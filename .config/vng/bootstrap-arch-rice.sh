#!/usr/bin/env bash
# bootstrap-arch-rice.sh — one-time setup of an Arch rootfs for vng ricing
# Run this once from your Fedora host. After it completes use rice.sh to launch.
#
# Requirements on host: vng (virtme-ng), curl, zstd, sudo, tar
set -euo pipefail

ROOTFS_BASE="${HOME}/rootfs"
ROOTFS="${ROOTFS_BASE}/arch-rice"
MIRROR="https://archlinux.cu.be"  # Belgian mirror

# ── preflight ────────────────────────────────────────────────────────────────
if [ -d "${ROOTFS}" ]; then
  echo "==> ${ROOTFS} already exists. Delete it first to re-bootstrap:"
  echo "    sudo rm -rf ${ROOTFS}"
  exit 1
fi

command -v vng   >/dev/null || { echo "ERROR: vng not found. Install virtme-ng first."; exit 1; }
command -v zstd  >/dev/null || { echo "ERROR: zstd not found. Run: sudo dnf install zstd"; exit 1; }
command -v curl  >/dev/null || { echo "ERROR: curl not found."; exit 1; }

echo ""
echo "  arch-rice bootstrap"
echo "  ==================="
echo "  Rootfs: ${ROOTFS}"
echo "  Mirror: ${MIRROR}"
echo ""

# ── download bootstrap tarball ───────────────────────────────────────────────
mkdir -p "${ROOTFS_BASE}"
cd "${ROOTFS_BASE}"

TARBALL="archlinux-bootstrap-x86_64.tar.zst"

echo "==> Downloading Arch bootstrap tarball..."
curl -L# "${MIRROR}/iso/latest/${TARBALL}" -o "${TARBALL}"
curl -L# "${MIRROR}/iso/latest/${TARBALL}.sig" -o "${TARBALL}.sig"

echo "==> Extracting..."
sudo tar --zstd -xf "${TARBALL}"
sudo mv root.x86_64 arch-rice
rm -f "${TARBALL}" "${TARBALL}.sig"

# Set up pacman mirrorlist inside rootfs
echo "==> Configuring pacman mirror..."
sudo sed -i "s|^#Server = ${MIRROR}|Server = ${MIRROR}|" \
  "${ROOTFS}/etc/pacman.d/mirrorlist" 2>/dev/null || \
  echo "Server = ${MIRROR}/\$repo/os/\$arch" | sudo tee "${ROOTFS}/etc/pacman.d/mirrorlist" > /dev/null

echo ""
echo "==> Rootfs ready at ${ROOTFS}"
echo ""
echo "==> Booting for initial setup (--rw so changes persist)..."
echo "    This will drop you into the guest as root."
echo "    Run the setup inside the guest, then type 'exit'."
echo ""

# ── boot into guest for interactive setup ────────────────────────────────────
# We pass a setup script via a temp file mounted into the guest
SETUP_SCRIPT=$(mktemp /tmp/arch-setup-XXXX.sh)
cat > "${SETUP_SCRIPT}" << 'GUESTEOF'
#!/bin/bash
set -euo pipefail

echo ""
echo "  === Inside arch-rice guest ==="
echo ""

# Pacman keyring init
echo "==> Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

# Base system
echo "==> Installing base packages..."
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
    base \
    sudo \
    git \
    curl \
    networkmanager \
    mesa \
    vulkan-virtio

# ── Add nic-repo ──────────────────────────────────────────────────────────────
echo "==> Adding nic-repo to pacman..."
cat >> /etc/pacman.conf << 'PACMANEOF'

[nic-repo]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/microservice-tech-nicolas/arch-packages/main/repo/stable/$arch
PACMANEOF

pacman -Sy --noconfirm

# ── Install the full rice stack via our custom packages ──────────────────────
echo "==> Installing arch-full from nic-repo..."
pacman -S --noconfirm \
    arch-core \
    arch-dev \
    arch-pass \
    arch-gui-sway \
    arch-eyecandy \
    arch-debug \
    arch-ops \
    arch-ai \
    nic-nvim \
    nic-dotfiles

# ── Graphics for vng (virtio-gpu, no need for actual GPU drivers) ─────────────
pacman -S --noconfirm --needed \
    mesa \
    vulkan-virtio \
    seatd \
    dbus-broker

# ── Kernel not needed — vng uses host kernel ─────────────────────────────────
# (do NOT install linux/linux-firmware — wastes space and causes confusion)

# ── Create rice user ─────────────────────────────────────────────────────────
echo "==> Creating rice user..."
if ! id rice &>/dev/null; then
    useradd -m -G wheel,seat,video,audio,input -s /bin/zsh rice
fi
echo 'rice:rice' | chpasswd
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# ── Enable services ───────────────────────────────────────────────────────────
systemctl enable seatd
systemctl enable dbus-broker
systemctl enable NetworkManager

echo ""
echo "  === Setup complete! ==="
echo "  Type 'exit' to return to your Fedora host."
echo "  Then run: ~/.config/vng/rice.sh"
echo ""
GUESTEOF

chmod +x "${SETUP_SCRIPT}"

vng --root "${ROOTFS}" \
    --user root \
    --rw \
    --systemd \
    --addFile "${SETUP_SCRIPT}":/arch-setup.sh \
    -- bash /arch-setup.sh

rm -f "${SETUP_SCRIPT}"

echo ""
echo "==> Bootstrap complete!"
echo "==> Start your ricing session:"
echo "    ~/.config/vng/rice.sh"
echo ""
