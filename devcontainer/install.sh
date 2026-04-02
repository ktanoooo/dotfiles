#!/bin/bash
set -eu

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)
DOTFILES_DIR=$(dirname "${SCRIPT_DIR}")

## ----------------------------------------
## Symbolic link .claude
## ----------------------------------------
setup_claude() {
  CLAUDE_SRC="${DOTFILES_DIR}/dotfiles/.claude"
  CLAUDE_DST="${HOME}/.claude"

  if [ -d "${CLAUDE_SRC}" ]; then
    ln -sfnv "${CLAUDE_SRC}" "${CLAUDE_DST}"
  fi
}

main() {
  setup_claude
}

main
