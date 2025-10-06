#!/bin/bash
set -eux


# ----------------------------------------
#  VSCODE settings
# ----------------------------------------
setup_vscode() {
  curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/settings.json -o $HOME/Library/Application\ Support/Code/User/settings.json
  curl https://raw.githubusercontent.com/ktanoooo/dotfiles/main/.vscode/keybindings.json -o $HOME/Library/Application\ Support/Code/User/keybindings.json
}

main() {
  setup_vscode
  exec $SHELL -l
}

# Main
main
