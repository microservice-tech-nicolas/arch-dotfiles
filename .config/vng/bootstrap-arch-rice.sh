#!/usr/bin/env bash
# bootstrap-arch-rice.sh — one-time setup of an Arch rootfs for vng ricing
# Run this once from your Fedora host. After it completes, use rice.sh to launch.
#
# Requirements on host: vng (virtme-ng), curl, zstd, sudo, tar
set -euo pipefail

ROOTFS_BASE="${HOME}/rootfs"
ROOTFS="${ROOTFS_BASE}/arch-rice"
# Official Arch geo-mirror — picks fastest server automatically
MIRROR="https://geo.mirror.pkgbuild.com"
TARBALL="archlinux-bootstrap-x86_64.tar.zst"

# ── preflight ────────────────────────────────────────────────────────────────
if [ -d "${ROOTFS}" ]; then
  echo "==> ${ROOTFS} already exists. Delete it first to re-bootstrap:"
  echo "    sudo rm -rf ${ROOTFS}"
  exit 1
fi

for cmd in vng zstd curl sudo tar; do
  command -v "${cmd}" >/dev/null || {
    echo "ERROR: '${cmd}' not found."
    [ "${cmd}" = "zstd" ] && echo "  Run: sudo dnf install zstd"
    exit 1
  }
done

echo ""
echo "  arch-rice bootstrap"
echo "  ==================="
echo "  Rootfs: ${ROOTFS}"
echo "  Mirror: ${MIRROR}"
echo ""

# ── download & extract bootstrap tarball ─────────────────────────────────────
mkdir -p "${ROOTFS_BASE}"
cd "${ROOTFS_BASE}"

echo "==> Downloading Arch bootstrap tarball..."
curl -L# "${MIRROR}/iso/latest/${TARBALL}" -o "${TARBALL}"

echo "==> Extracting..."
sudo tar --zstd -xf "${TARBALL}"
sudo mv root.x86_64 arch-rice
rm -f "${TARBALL}"

# ── configure pacman mirror inside rootfs ────────────────────────────────────
echo "==> Configuring pacman mirror..."
# The bootstrap mirrorlist has all servers commented out — uncomment geo mirror
sudo sed -i "s|^#Server = ${MIRROR}|Server = ${MIRROR}|" \
  "${ROOTFS}/etc/pacman.d/mirrorlist" 2>/dev/null || true
# Fallback: if the geo mirror line isn't there, write it directly
if ! grep -q "^Server" "${ROOTFS}/etc/pacman.d/mirrorlist" 2>/dev/null; then
  echo "Server = ${MIRROR}/\$repo/os/\$arch" \
    | sudo tee "${ROOTFS}/etc/pacman.d/mirrorlist" > /dev/null
fi

# ── write guest setup script to a file inside the rootfs ─────────────────────
# (vng has no --addFile flag — we write directly into the rootfs on the host)
echo "==> Writing guest setup script..."
sudo tee "${ROOTFS}/arch-setup.sh" > /dev/null << 'SETUPEOF'
#!/bin/bash
set -euo pipefail

echo ""
echo "  === Inside arch-rice guest ==="
echo ""

# ── pacman keyring ────────────────────────────────────────────────────────────
echo "==> Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

# ── base system ───────────────────────────────────────────────────────────────
echo "==> Installing base packages..."
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
    base sudo git curl networkmanager \
    mesa vulkan-virtio seatd dbus-broker dbus-broker-units

# ── add nic-repo ──────────────────────────────────────────────────────────────
echo "==> Adding nic-repo to /etc/pacman.conf..."
cat >> /etc/pacman.conf << 'PACEOF'

[nic-repo]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/microservice-tech-nicolas/arch-packages/main/repo/stable/$arch
PACEOF

pacman -Sy --noconfirm

# ── full rice stack from nic-repo ─────────────────────────────────────────────
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

# ── create rice user ──────────────────────────────────────────────────────────
echo "==> Creating rice user..."
if ! id rice &>/dev/null; then
    useradd -m -G wheel,seat,video,audio,input -s /bin/zsh rice
fi
echo 'rice:rice' | chpasswd
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

# ── enable services ───────────────────────────────────────────────────────────
systemctl enable seatd
systemctl enable dbus-broker
systemctl enable NetworkManager

# NOTE: do NOT install linux / linux-firmware — vng uses the host kernel.

echo ""
echo "  === Setup complete! ==="
echo "  Exiting guest. Run: ~/.config/vng/rice.sh"
echo ""
SETUPEOF

sudo chmod +x "${ROOTFS}/arch-setup.sh"

# ── boot guest and run setup ──────────────────────────────────────────────────
echo ""
echo "==> Booting guest for initial setup (--rw — writes persist to rootfs)..."
echo ""

vng --root "${ROOTFS}" \
    --user root \
    --rw \
    --network user \
    --systemd \
    -- bash /arch-setup.sh

# Clean up the setup script from the rootfs
sudo rm -f "${ROOTFS}/arch-setup.sh"

echo ""
echo "==> Bootstrap complete!"
echo "==> Start your ricing session:"
echo "    ~/.config/vng/rice.sh"
echo ""
