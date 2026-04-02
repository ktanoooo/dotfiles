#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)
DOTFILES_DIR=$(dirname "${SCRIPT_DIR}")

## ----------------------------------------
## Symbolic link dotfiles
## ----------------------------------------
symlink() {
  local src="${DOTFILES_DIR}/dotfiles/$1"
  local dst="${HOME}/$1"

  if [ -e "${src}" ]; then
    mkdir -p "$(dirname "${dst}")"
    [ -d "${dst}" ] && rm -rf "${dst}"
    ln -sfnv "${src}" "${dst}"
  fi
}

## ----------------------------------------
## Install eza
## ----------------------------------------
install_eza() {
  if command -v eza &>/dev/null; then
    return
  fi

  if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y eza
  fi
}

## ----------------------------------------
## Load aliases in shell rc
## ----------------------------------------
setup_aliases() {
  local snippet='for f in ~/.aliases/.*.zsh ~/.aliases/*.zsh; do [ -f "$f" ] && source "$f"; done'
  for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
    # Skip if rc file doesn't exist or already contains the exact snippet line
    if [ -f "${rc}" ] && ! grep -qxF "${snippet}" "${rc}"; then
      echo "${snippet}" >> "${rc}"
    fi
  done
}

main() {
  install_eza
  symlink .claude
  symlink .aliases
  setup_aliases
}

main
