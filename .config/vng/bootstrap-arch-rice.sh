#!/usr/bin/env bash
# bootstrap-arch-rice.sh — one-time Arch rootfs setup for vng ricing
#
# Step 1: download & extract the Arch bootstrap tarball
# Step 2: boot it with vng --rw --systemd (pacman works properly from inside)
# Step 3: run pacman setup inside the VM, then exit
# After this, use rice.sh for daily sessions.
set -euo pipefail

ROOTFS_BASE="${HOME}/rootfs"
ROOTFS="${ROOTFS_BASE}/arch-rice"
MIRROR="https://archlinux.cu.be"
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

# ── Step 1: download & extract ───────────────────────────────────────────────
mkdir -p "${ROOTFS_BASE}"
cd "${ROOTFS_BASE}"

echo "==> Downloading Arch bootstrap tarball..."
curl -LO "${MIRROR}/iso/latest/${TARBALL}"

echo "==> Extracting..."
sudo tar --zstd -xf "${TARBALL}"
sudo mv root.x86_64 arch-rice
rm -f "${TARBALL}"

# ── Step 2: write setup script into rootfs, boot with vng, run it inside ─────
# vng boots the rootfs with --rw so pacman writes persist.
# pacman works correctly inside the VM (real /proc /sys /dev, real kernel).
sudo tee "${ROOTFS}/arch-setup.sh" > /dev/null << 'SETUPEOF'
#!/bin/bash
set -euo pipefail

# Uncomment Belgian mirror
sed -i 's|^#Server = https://archlinux.cu.be|Server = https://archlinux.cu.be|' \
    /etc/pacman.d/mirrorlist

echo "==> Initializing pacman keyring..."
pacman-key --init
pacman-key --populate archlinux

echo "==> Syncing packages..."
pacman -Syu --noconfirm

echo "==> Installing base..."
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

echo "==> Installing full rice stack from nic-repo..."
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

echo ""
echo "==> Setup complete! Type 'exit' or poweroff to return to host."
SETUPEOF

sudo chmod +x "${ROOTFS}/arch-setup.sh"

echo ""
echo "==> Booting Arch rootfs in vng (--rw so changes persist)..."
echo "    Running setup automatically inside the VM..."
echo ""

# Boot the rootfs with vng, run setup script inside, exit when done
vng -r \
    --root "${ROOTFS}" \
    --user root \
    --rw \
    --network user \
    --systemd \
    -- bash /arch-setup.sh

sudo rm -f "${ROOTFS}/arch-setup.sh"

echo ""
echo "=============================="
echo " Bootstrap complete!"
echo " Run: ~/.config/vng/rice.sh"
echo "=============================="
echo ""
