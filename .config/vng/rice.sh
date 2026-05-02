#!/usr/bin/env bash
# rice.sh — daily ricing loop for arch-rice vng VM
# Boots the Arch rootfs with host dotfiles visible read-only inside the guest.
# Default (no --rw): snapshot mode — exit and rerun to get a clean slate.
#
# Usage:
#   rice.sh            — boot into sway (full GUI, snapshot)
#   rice.sh shell      — drop into zsh (no GUI, snapshot)
#   rice.sh rw         — persistent writes (use for installs/config changes)
#   rice.sh update     — upgrade all nic packages inside the VM (persistent)

ROOTFS="${HOME}/rootfs/arch-rice"

# ── preflight ────────────────────────────────────────────────────────────────
if [ ! -d "${ROOTFS}" ]; then
  echo "ERROR: rootfs not found at ${ROOTFS}"
  echo "Run bootstrap first: ~/.config/vng/bootstrap-arch-rice.sh"
  exit 1
fi
command -v vng >/dev/null || { echo "ERROR: vng not found."; exit 1; }

MODE="${1:-gui}"

# ── base vng flags ───────────────────────────────────────────────────────────
VNG_ARGS=(
  --root    "${ROOTFS}"
  --user    rice
  --network user          # NAT networking so pacman/git work inside guest
  --graphics              # virtio-gpu output
)

# ── mount host dotfiles read-only inside the guest ───────────────────────────
# --rodir=guestpath=hostpath makes the host dir visible at guestpath in the VM
# Changes made in the guest to these dirs do NOT touch the host.
if [ -d "${HOME}/.config" ]; then
  VNG_ARGS+=(--rodir="/home/rice/.config=${HOME}/.config")
fi
if [ -f "${HOME}/.zshrc" ]; then
  # Individual files: mount parent dir read-only and symlink, or use rwdir
  # Simplest: mount home dotfiles dir read-only
  VNG_ARGS+=(--rodir="/home/rice/.zshrc=${HOME}/.zshrc")
fi
if [ -f "${HOME}/.zprofile" ]; then
  VNG_ARGS+=(--rodir="/home/rice/.zprofile=${HOME}/.zprofile")
fi

# ── dispatch ─────────────────────────────────────────────────────────────────
case "${MODE}" in
  gui)
    echo "==> Booting arch-rice into sway (snapshot — changes lost on exit)..."
    echo "    Mod+b  wallpaper picker"
    echo "    Mod+Enter  terminal"
    echo ""
    # --exec runs a command as the user after login, without --systemd
    vng "${VNG_ARGS[@]}" --exec sway
    ;;

  shell)
    echo "==> Booting arch-rice into zsh (snapshot mode)..."
    vng "${VNG_ARGS[@]}" --exec zsh
    ;;

  rw)
    echo "==> Booting arch-rice with PERSISTENT writes..."
    echo "    WARNING: changes survive across reboots."
    vng "${VNG_ARGS[@]}" --rw --exec zsh
    ;;

  update)
    echo "==> Updating arch-rice packages (persistent write)..."
    vng "${VNG_ARGS[@]}" --rw --exec bash -c '
      pacman -Syu --noconfirm && \
      pacman -S --noconfirm \
        arch-core arch-dev arch-gui-sway arch-eyecandy \
        arch-debug arch-ops arch-ai nic-nvim nic-dotfiles && \
      echo "==> Update complete."
    '
    ;;

  *)
    echo "Usage: rice.sh [gui|shell|rw|update]"
    exit 1
    ;;
esac
