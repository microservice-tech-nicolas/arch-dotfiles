#!/usr/bin/env bash
# bootstrap-arch-rice.sh — one-time Arch rootfs setup for vng ricing
# Uses arch-chroot (bundled in bootstrap tarball) — no manual bind mounts.
# After this completes, use rice.sh for daily sessions.
set -euo pipefail

ROOTFS_BASE="${HOME}/rootfs"
ROOTFS="${ROOTFS_BASE}/arch-rice"
MIRROR="https://geo.mirror.pkgbuild.com"
TARBALL="archlinux-bootstrap-x86_64.tar.zst"

# ── preflight ────────────────────────────────────────────────────────────────
if [ -d "${ROOTFS}" ]; then
  echo "==> ${ROOTFS} already exists. Delete it first:"
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
echo ""

# ── download & extract ───────────────────────────────────────────────────────
mkdir -p "${ROOTFS_BASE}"
cd "${ROOTFS_BASE}"

echo "==> Downloading Arch bootstrap tarball..."
curl -L# "${MIRROR}/iso/latest/${TARBALL}" -o "${TARBALL}"

echo "==> Extracting..."
sudo tar --zstd -xf "${TARBALL}"
sudo mv root.x86_64 arch-rice
rm -f "${TARBALL}"

# ── configure mirror ─────────────────────────────────────────────────────────
echo "==> Configuring pacman mirror..."
echo "Server = ${MIRROR}/\$repo/os/\$arch" \
  | sudo tee -a "${ROOTFS}/etc/pacman.d/mirrorlist" > /dev/null

# ── write setup script directly into rootfs ──────────────────────────────────
sudo tee "${ROOTFS}/arch-setup.sh" > /dev/null << 'SETUPEOF'
#!/bin/bash
set -euo pipefail

echo "==> Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

echo "==> Syncing and installing base..."
pacman -Syu --noconfirm
pacman -S --noconfirm --needed \
    base sudo git curl networkmanager \
    mesa vulkan-virtio seatd dbus-broker dbus-broker-units

echo "==> Adding nic-repo..."
cat >> /etc/pacman.conf << 'EOF'

[nic-repo]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/microservice-tech-nicolas/arch-packages/main/repo/stable/$arch
EOF
pacman -Sy --noconfirm

echo "==> Installing full rice stack..."
pacman -S --noconfirm \
    arch-core arch-dev arch-pass arch-gui-sway arch-eyecandy \
    arch-debug arch-ops arch-ai nic-nvim nic-dotfiles

echo "==> Creating rice user..."
if ! id rice &>/dev/null; then
    useradd -m -G wheel,seat,video,audio,input -s /bin/zsh rice
fi
echo 'rice:rice' | chpasswd
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel
chmod 440 /etc/sudoers.d/wheel

systemctl enable seatd dbus-broker NetworkManager
systemd-machine-id-setup 2>/dev/null || true

echo ""
echo "==> Setup complete!"
SETUPEOF

sudo chmod +x "${ROOTFS}/arch-setup.sh"

# ── arch-chroot handles all bind mounts itself — no manual mounting needed ────
echo ""
echo "==> Running setup inside arch-chroot (10-20 min)..."
echo ""
sudo "${ROOTFS}/bin/arch-chroot" "${ROOTFS}" /arch-setup.sh

sudo rm -f "${ROOTFS}/arch-setup.sh"

echo ""
echo "=============================="
echo " Bootstrap complete!"
echo " Run: ~/.config/vng/rice.sh"
echo "=============================="
echo ""
