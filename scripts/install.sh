#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

# run cmd via sudo unless we’re already root
sudo_if_needed() {
  if [[ $EUID -eq 0 ]]; then "$@"; else sudo -n "$@"; fi
}
detect_pm() {
  for pm in brew apt dnf yum pacman; do command -v "$pm" &>/dev/null && {
    echo "$pm"
    return
  }; done
  err "No supported package manager found"
  exit 1
}

BREW_DEPS=(neovim ripgrep lazygit fzf fd node git)
APT_DEPS=(neovim ripgrep lazygit fzf fd-find nodejs npm git build-essential)
DNF_DEPS=(neovim ripgrep lazygit fzf fd-find nodejs git)
PACMAN_DEPS=(neovim ripgrep lazygit fzf fd nodejs git)

install_brew() { brew update && brew install "${BREW_DEPS[@]}"; }
install_apt() {
  sudo_if_needed
  apt-get update -qq && apt-get install -y "${APT_DEPS[@]}"
}
install_dnf() {
  sudo_if_needed
  dnf install -y "${DNF_DEPS[@]}"
}
install_yum() {
  sudo_if_needed
  yum install -y "${DNF_DEPS[@]}"
}
install_pacman() {
  sudo_if_needed
  pacman -Sy --noconfirm "${PACMAN_DEPS[@]}"
}

main() {
  PM=$(detect_pm)
  log "using $PM"
  "install_${PM}"
  log "System packages installed"
}

main "$@"
