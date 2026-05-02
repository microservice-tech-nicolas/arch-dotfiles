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

# Keyring
pacman-key --init
pacman-key --populate archlinux

# Mirror
echo "Server = https://geo.mirror.pkgbuild.com/\$repo/os/\$arch" \
    >> /etc/pacman.d/mirrorlist

# Add nic-repo
cat >> /etc/pacman.conf << 'EOF'

[nic-repo]
SigLevel = Optional TrustAll
Server = https://raw.githubusercontent.com/microservice-tech-nicolas/arch-packages/main/repo/stable/$arch
EOF

# Install
pacman -Syu --noconfirm
pacman -S --noconfirm arch-full
SETUPEOF

sudo chmod +x "${ROOTFS}/arch-setup.sh"

echo ""
echo "==> Booting Arch rootfs with vng --rw --systemd..."
echo "    Setup script will run automatically inside."
echo ""

# Boot with --systemd so /etc is writable (CoW overlay), run setup script as a
# systemd transient service via the virtme-ng exec mechanism
vng -r \
    --root "${ROOTFS}" \
    --user root \
    --rw \
    --network user \
    --systemd \
    --exec "bash /arch-setup.sh"

sudo rm -f "${ROOTFS}/arch-setup.sh"

echo ""
echo "=============================="
echo " Done! Run: ~/.config/vng/rice.sh"
echo "=============================="
echo ""
