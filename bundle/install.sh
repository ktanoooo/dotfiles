#!/bin/bash
set -eux

EXEPATH=$(cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd)

## ----------------------------------------
##  Install Brewfile
## ----------------------------------------
install_brew() {
  brew upgrade
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

## ----------------------------------------
##  Install cargo packages
## ----------------------------------------
install_cargo_pkgs() {
  plugins=$(cat "${EXEPATH}"/Cargofile | sed -e 's/#.*$//' -e '/^$/d')
  for plugin in $plugins; do
    if [ -n $plugin ]; then
      cargo install "${plugin}"
    fi
  done
}

# ----------------------------------------
# Install Google Cloud SDK
# ----------------------------------------
install_gcloud() {
  if [[ $OSTYPE == "linux-gnu" ]]; then
    sudo curl https://sdk.cloud.google.com | bash
    exec $SHELL -l
  else
    echo "installed with homebrew cask: google-cloud-sdk"
  fi
}

main() {
  install_brew
  install_vsplug
  install_cargo_pkgs
  install_gcloud
}

main
