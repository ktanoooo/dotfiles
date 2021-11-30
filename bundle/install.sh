#!/bin/bash
set -eux

EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)


## ----------------------------------------
##  Install Brewfile
## ----------------------------------------
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

## ----------------------------------------
##  Install vscode plugins
## ----------------------------------------
install_vsplug() {
  for plugin in $(cat "${EXEPATH}"/Vsplug); do
    if [ -n $plugin ]; then
      code --install-extension "${plugin}"
    fi
  done
}

main() {
  install_vsplug
}

main