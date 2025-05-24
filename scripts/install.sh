#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

log() { printf "\033[1;34m[INFO]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[ERR ]\033[0m %s\n" "$*" >&2; }

sudo_if_needed() {
  if (( EUID == 0 )); then "$@"; else sudo "$@"; fi
}

detect_pm() {
  for pm in brew apt dnf yum pacman; do
    command -v "$pm" &>/dev/null && { echo "$pm"; return; }
  done
  err "No supported package manager found"; exit 1
}

BREW_DEPS=(neovim ripgrep lazygit fzf fd node git)
APT_DEPS=(neovim ripgrep fzf fd-find nodejs npm git build-essential)
DNF_DEPS=(neovim ripgrep lazygit fzf fd-find nodejs git)
PACMAN_DEPS=(neovim ripgrep lazygit fzf fd nodejs git)

install_brew() {
  brew update --quiet || true
  brew install "${BREW_DEPS[@]}"
}

install_apt() {
  sudo_if_needed apt-get update -qq
  # everything except lazygit
  sudo_if_needed apt-get install -y "${APT_DEPS[@]}"

  # create fd → fdfind symlink if it doesn’t exist
  command -v fd >/dev/null 2>&1 || sudo_if_needed ln -s "$(command -v fdfind)" /usr/local/bin/fd

  # ---- lazygit (download binary) ----
  log "Installing lazygit"
  arch=$(dpkg --print-architecture)            # amd64, arm64, etc.
  ver=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazygit/releases/latest \
        | grep -Po '"tag_name":\s*"\K.*?(?=")')
  tmp=$(mktemp -d)
  curl -fsSL \
    "https://github.com/jesseduffield/lazygit/releases/download/${ver}/lazygit_${ver#v}_Linux_${arch}.tar.gz" \
    | tar -xz -C "$tmp" lazygit
  sudo_if_needed mv "$tmp/lazygit" /usr/local/bin/
  rm -rf "$tmp"
}


install_dnf()  { sudo_if_needed dnf    install -y "${DNF_DEPS[@]}"; }
install_yum()  { sudo_if_needed yum    install -y "${DNF_DEPS[@]}"; }
install_pacman(){
  sudo_if_needed pacman -Sy --noconfirm "${PACMAN_DEPS[@]}"
}

fetch_and_exec() {
  local url=$1
  if command -v curl >/dev/null 2>&1;   then curl -fsSL "$url" | sh
  elif command -v wget >/dev/null 2>&1; then wget -qO- "$url" | sh
  else
    err "curl/wget missing; installing curl"
    case $PM in
      apt) sudo_if_needed apt-get update -qq && sudo_if_needed apt-get install -y curl ;;
      dnf|yum) sudo_if_needed $PM install -y curl ;;
      pacman) sudo_if_needed pacman -Sy --noconfirm curl ;;
      brew) brew install curl ;;
      *) err "Cannot install curl automatically"; exit 1 ;;
    esac
    curl -fsSL "$url" | sh
  fi
}

main() {
  PM=$(detect_pm)
  log "Using package manager: $PM"
  "install_$PM"
  fetch_and_exec "https://astral.sh/uv/install.sh"
  log "System packages installed"
}

main "$@"
