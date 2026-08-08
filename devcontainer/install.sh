#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)
DOTFILES_DIR=$(dirname "${SCRIPT_DIR}")

## ----------------------------------------
## Symbolic link dotfiles
## ----------------------------------------
symlink() {
  local src="${DOTFILES_DIR}/home/$1"
  local dst="${HOME}/$1"

  if [ -e "${src}" ]; then
    mkdir -p "$(dirname "${dst}")"
    [ -d "${dst}" ] && rm -rf "${dst}"
    ln -sfnv "${src}" "${dst}"
  fi
}

## ----------------------------------------
## Install apt packages
## ----------------------------------------
install_apt_packages() {
  if command -v apt-get &>/dev/null; then
    sudo apt-get update && sudo apt-get install -y eza sox
  fi
}

## ----------------------------------------
## Global gitignore
## Git never reads ~/.gitignore on its own; its default is
## ~/.config/git/ignore. On a normal machine core.excludesfile is set in the
## linked .gitconfig, but that file is not linked here, so the symlink alone
## would leave the ignores inert.
## ----------------------------------------
setup_gitignore() {
  symlink .gitignore
  # Git expands the tilde itself for pathname values, so store it unexpanded
  # and keep the value identical to the one in home/.gitconfig.
  # shellcheck disable=SC2088
  git config --global core.excludesfile "~/.gitignore"
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
  install_apt_packages
  symlink .claude
  symlink .aliases
  setup_gitignore
  setup_aliases
}

main
