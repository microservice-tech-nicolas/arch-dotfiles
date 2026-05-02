#!/usr/bin/env bash
# rice.sh — daily ricing loop for arch-rice vng VM
# Boots the Arch rootfs with dotfiles overlaid from the host.
# No --rw: each boot is a clean snapshot — exit and rerun to reset.
#
# Usage:
#   rice.sh            — boot into sway (full GUI)
#   rice.sh shell      — boot into a zsh shell (no GUI, for testing)
#   rice.sh rw         — boot with persistent writes (use sparingly)
#   rice.sh update     — boot with --rw and run pacman -Syu inside

ROOTFS="${HOME}/rootfs/arch-rice"
DOTFILES="${HOME}/.dotfiles"   # bare clone managed by nic-dotfiles / dot alias

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
  --root "${ROOTFS}"
  --user rice
  --systemd
  -g                          # enable graphical output (virtio-gpu)
)

# Overlay host dotfiles into guest home — edits on host appear instantly
# The bare repo has the work-tree checked out; we mount the real dirs
if [ -d "${HOME}/.config" ]; then
  VNG_ARGS+=(--overlay-rwdir "/home/rice/.config=${HOME}/.config")
fi
if [ -f "${HOME}/.zshrc" ]; then
  VNG_ARGS+=(--addFile "${HOME}/.zshrc":/home/rice/.zshrc)
fi
if [ -f "${HOME}/.zprofile" ]; then
  VNG_ARGS+=(--addFile "${HOME}/.zprofile":/home/rice/.zprofile)
fi

case "${MODE}" in
  gui)
    echo "==> Booting arch-rice into sway (snapshot mode — changes lost on exit)..."
    echo "    Mod+b to pick wallpaper, Mod+Enter for terminal."
    echo ""
    vng "${VNG_ARGS[@]}" -- sway
    ;;

  shell)
    echo "==> Booting arch-rice into zsh shell (snapshot mode)..."
    vng "${VNG_ARGS[@]}" -- zsh
    ;;

  rw)
    echo "==> Booting arch-rice with PERSISTENT writes..."
    echo "    WARNING: changes survive across reboots."
    vng "${VNG_ARGS[@]}" --rw -- zsh
    ;;

  update)
    echo "==> Updating arch-rice packages (persistent write)..."
    vng "${VNG_ARGS[@]}" --rw -- bash -c '
      pacman -Syu --noconfirm
      pacman -S --noconfirm arch-core arch-dev arch-gui-sway arch-eyecandy \
        arch-debug arch-ops arch-ai nic-nvim nic-dotfiles
      echo "Update complete."
    '
    ;;

  *)
    echo "Usage: rice.sh [gui|shell|rw|update]"
    exit 1
    ;;
esac
