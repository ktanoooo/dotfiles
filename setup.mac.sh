#!/bin/bash
set -eux


# ----------------------------------------
#  VSCODE settings
# ----------------------------------------
setup_vscode() {
  EXEPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)
  VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"
  mkdir -p "${VSCODE_USER_DIR}"
  ln -sfnv "${EXEPATH}/.vscode/settings.json" "${VSCODE_USER_DIR}/settings.json"
  ln -sfnv "${EXEPATH}/.vscode/keybindings.json" "${VSCODE_USER_DIR}/keybindings.json"
}

main() {
  setup_vscode
  exec $SHELL -l
}

# Main
main
