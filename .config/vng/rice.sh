#!/usr/bin/env bash
# rice.sh — daily ricing loop for arch-rice vng VM
# Snapshot mode by default — exit and rerun for a clean slate.
#
# Usage:
#   rice.sh            — sway GUI (snapshot, dotfiles overlaid from host)
#   rice.sh shell      — zsh shell (snapshot)
#   rice.sh rw         — persistent writes (for installs)
#   rice.sh update     — upgrade all nic packages (persistent)

ROOTFS="${HOME}/rootfs/arch-rice"
DOTFILES_CONFIG="${HOME}/.config"

if [ ! -d "${ROOTFS}" ]; then
  echo "ERROR: rootfs not found. Run: ~/.config/vng/bootstrap-arch-rice.sh"
  exit 1
fi
command -v vng >/dev/null || { echo "ERROR: vng not found."; exit 1; }

MODE="${1:-gui}"

case "${MODE}" in
  gui)
    echo "==> Booting arch-rice into sway (snapshot mode)..."
    echo "    Mod+b = wallpaper picker  |  Mod+Enter = terminal"
    echo ""
    # Exactly as per the instructions: --systemd -g --overlay-rwdir for dotfiles
    vng -r \
      --root "${ROOTFS}" \
      --user rice \
      --systemd \
      -g \
      --network user \
      --overlay-rwdir "/home/rice/.config=${DOTFILES_CONFIG}" \
      -- sway
    ;;

  shell)
    echo "==> Booting arch-rice into zsh (snapshot mode)..."
    vng -r \
      --root "${ROOTFS}" \
      --user rice \
      --systemd \
      --network user \
      --overlay-rwdir "/home/rice/.config=${DOTFILES_CONFIG}" \
      -- zsh
    ;;

  rw)
    echo "==> Booting with PERSISTENT writes..."
    vng -r \
      --root "${ROOTFS}" \
      --user rice \
      --rw \
      --systemd \
      --network user \
      -- zsh
    ;;

  update)
    echo "==> Updating nic packages (persistent)..."
    vng -r \
      --root "${ROOTFS}" \
      --user root \
      --rw \
      --network user \
      --systemd \
      -- bash -c 'pacman -Syu --noconfirm && pacman -S --noconfirm arch-core arch-dev arch-gui-sway arch-eyecandy arch-debug arch-ops arch-ai nic-nvim nic-dotfiles && echo done'
    ;;

  *)
    echo "Usage: rice.sh [gui|shell|rw|update]"
    exit 1
    ;;
esac
