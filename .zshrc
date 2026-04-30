# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
export ZSH="$HOME/.oh-my-zsh"

# Default editor - used by crontab, git, etc.
export EDITOR=nvim
export VISUAL=nvim
export new_line_before_prompt="1"
ZSH_THEME="gnzh"

plugins=( 
    git
    dnf
    zsh-autosuggestions
    zsh-syntax-highlighting
    direnv
)

source $ZSH/oh-my-zsh.sh

# Empty line before and after each command output
precmd() { print "" }

# Path variable
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# fastfetch. Will be disabled if above colorscript was chosen to install
# fastfetch -c $HOME/.config/fastfetch/config-compact.jsonc
fastfetch -c $HOME/.config/fastfetch/config-v2.jsonc

# Set-up FZF key bindings (CTRL R for fuzzy history finder)
source <(fzf --zsh)

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Set-up icons for files/directories in terminal using lsd
alias ls='lsd'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'
alias ccy='claude --dangerously-skip-permissions'
alias cc='claude'
alias lzg='lazygit'
alias lzd='lazydocker'
alias ls='eza -l'
alias dnf='sudo dnf install'
alias dnfs='sudo dnf search'
alias cfg='nvim ~/.config/'
alias k='kubectl'
alias oc='opencode'
alias ghd='gh dash'

eval "$(zoxide init zsh)"

# Make dir and change into it
mkdircd() { 
    mkdir -p "$1" && cd "$1";
}


# opencode
# API keys — load from pass or ~/.secrets (never commit keys here)
export PATH=$HOME/.opencode/bin:$PATH
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/go/bin:$PATH
export PATH=$HOME/.config/fzfmenu:$PATH

# tmux a 
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Doom Emacs
export PATH="$HOME/.config/emacs/bin:$PATH"

# Source modular shell configurations from .d directory
# These are managed via literate org-mode files in ~/Org/atoms/shell/
if [[ -d "$HOME/.config/shell.d" ]]; then
  for file in "$HOME/.config/shell.d"/*.sh; do
    [[ -r "$file" ]] && source "$file"
  done
fi
eval "$(atuin init zsh)"

# Android SDK
export ANDROID_HOME=$HOME/Android/Sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin

# Sesh cli
function sesh-sessions() {
  {
    exec </dev/tty
    exec <&1
    local session
    session=$(sesh list -t -c | fzf --height 40% --reverse --border-label ' sesh ' --border --prompt '⚡  ')
    zle reset-prompt > /dev/null 2>&1 || true
    [[ -z "$session" ]] && return
    sesh connect $session
  }
}

zle     -N             sesh-sessions
bindkey -M emacs '\es' sesh-sessions
bindkey -M vicmd '\es' sesh-sessions
bindkey -M viins '\es' sesh-sessions
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

# ctrl+f: fuzzy-find any directory and open/attach a tmux project session
function fzf-project() {
  local dir home="$HOME"
  dir=$(fd --type d --hidden --max-depth 4 \
          --exclude .git --exclude node_modules --exclude .cache \
          --exclude target --exclude __pycache__ --exclude .cargo \
          . "$home" 2>/dev/null \
        | sed "s|^$home/||" \
        | awk '{ print gsub(/\//,"/")" "$0 }' \
        | sort -n \
        | sed 's/^[0-9]* //' \
        | fzf-tmux -p 80%,60% \
            --border-label ' project ' \
            --prompt '  ' \
            --no-sort \
            --preview "ls -lA --color=always $home/{} 2>/dev/null | head -30")
  zle reset-prompt
  [[ -z "$dir" ]] && return
  # Run as a real shell command so it has a proper tty for tmux attach
  BUFFER="tmux-project $home/$dir"
  zle accept-line
}

zle     -N             fzf-project
bindkey -M emacs '^f'  fzf-project
bindkey -M vicmd '^f'  fzf-project
bindkey -M viins '^f'  fzf-project

# Direnv
# Load KEY=VALUE pairs from a pass entry into the environment
export DIRENV_LOG_FORMAT=$'\033[2mdirenv: %s\033[0m'
# eval "$(direnv hook zsh)"

# Pull GPG private key from microservice-dt over SSH
gpg-pull() {
  local host="${1:-nic@microservice-dt.local}"
  local key="${2:-6BE764C6C37DEB87}"
  local tmp="/tmp/gpg-pull-$$.asc"
  local remote_tmp="/tmp/gpg-export-$$.asc"
  echo "Pulling GPG key $key from $host..."
  # Export on remote with loopback pinentry (allow-loopback-pinentry must be in gpg-agent.conf)
  # Use ssh -tt for TTY so pinentry-curses can prompt for passphrase
  ssh -tt "$host" "GPG_TTY=\$(tty) gpg --export-secret-keys --armor --pinentry-mode loopback $key > $remote_tmp 2>/dev/tty; echo DONE" 2>/dev/null
  scp "$host:$remote_tmp" "$tmp" 2>/dev/null
  ssh "$host" "rm -f $remote_tmp" 2>/dev/null
  gpg --import "$tmp"
  rm -f "$tmp"
  gpg --list-secret-keys "$key"
}

# Clone or pull the pass password store from its private GitHub remote
pass-pull() {
  local store="${PASSWORD_STORE_DIR:-$HOME/.password-store}"
  if [[ -d "$store/.git" ]]; then
    echo "Updating existing password store..."
    pass git pull
  else
    echo "Cloning password store..."
    git clone git@github.com:microservice-tech/password-store.git "$store"
    echo "Done. Run gpg-pull first if GPG key is not yet imported."
  fi
}


# WM logout
alias logout='
  if [[ -n "$NIRI_SOCKET" ]]; then
    niri msg action quit
  elif [[ -n "$SWAYSOCK" ]]; then
    swaymsg exit
  else
    echo "Not in niri or sway"
  fi
'

# Starship prompt — replaces oh-my-zsh theme
# Installed by arch-eyecandy; comment out ZSH_THEME above when using this
command -v starship &>/dev/null && eval "$(starship init zsh)"
