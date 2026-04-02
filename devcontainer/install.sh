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
    ln -sfnv "${src}" "${dst}"
  fi
}

## ----------------------------------------
## Load aliases in shell rc
## ----------------------------------------
setup_aliases() {
  local snippet='for f in ~/.aliases/*.zsh; do [ -f "$f" ] && source "$f"; done'
  for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
    if [ -f "${rc}" ] && ! grep -qF '.aliases' "${rc}"; then
      echo "${snippet}" >> "${rc}"
    fi
  done
}

main() {
  symlink .claude
  symlink .aliases
  setup_aliases
}

main
