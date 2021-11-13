#!/bin/bash
set -eux

EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ========== Brew Bundle ==========
install_brew() {
  brew upgrade
  brew tap "homebrew/bundle"
  brew bundle --file "${EXEPATH}/Brewfile.common"
  if [[ $OSTYPE == "linux-gnu" ]]; then
    brew bundle --file "${EXEPATH}/Brewfile.win"
  else
    brew bundle --file "${EXEPATH}/Brewfile.mac"
  fi
}

main() {
  install_brew
}

main