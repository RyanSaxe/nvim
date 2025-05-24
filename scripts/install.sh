#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

require_root() { [[ $EUID -eq 0 ]] || {
  err "re-run with sudo"
  exit 1
}; }

detect_pm() {
  for pm in brew apt dnf yum pacman; do command -v "$pm" &>/dev/null && {
    echo "$pm"
    return
  }; done
  err "No supported package manager found"
  exit 1
}

BREW_DEPS=(neovim ripgrep lazygit fzf fd node git python3)
APT_DEPS=(neovim ripgrep lazygit fzf fd-find nodejs npm git python3 python3-pip build-essential)
DNF_DEPS=(neovim ripgrep lazygit fzf fd-find nodejs git python3 python3-pip)
PACMAN_DEPS=(neovim ripgrep lazygit fzf fd nodejs git python python-pip)

install_brew() { brew update && brew install "${BREW_DEPS[@]}"; }
install_apt() {
  require_root
  apt-get update -qq && apt-get install -y "${APT_DEPS[@]}"
}
install_dnf() {
  require_root
  dnf install -y "${DNF_DEPS[@]}"
}
install_yum() {
  require_root
  yum install -y "${DNF_DEPS[@]}"
}
install_pacman() {
  require_root
  pacman -Sy --noconfirm "${PACMAN_DEPS[@]}"
}

bootstrap_neovim() {
  python3 -m pip install --user --upgrade pynvim
  # headless plugin sync (waits for completion)
  nvim --headless "+Lazy! sync" +qa # docs example :contentReference[oaicite:0]{index=0}
}

main() {
  PM=$(detect_pm)
  log "using $PM"
  "install_${PM}"
  log "System packages installed"
  bootstrap_neovim
  log "Neovim plugins installed"
}

main "$@"
