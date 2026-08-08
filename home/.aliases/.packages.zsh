brewfile() {
  local os=darwin
  [[ $OSTYPE == linux-gnu* ]] && os=linux
  echo "$(ghq list -p -e dotfiles)/packages/Brewfile.${os}"
}

# Export current installed packages to Brewfile
brewexport () {
  brew bundle dump --file=$(brewfile) --force --no-vscode
}

# Sync packages with Brewfile and upgrade to latest versions
brewimport() {
  brew bundle --file=$(brewfile)
}

vscodefile() {
  echo "$(ghq list -p -e dotfiles)/packages/VSCodefile"
}

# Export current installed VSCode extensions to VSCodefile
vscodeexport() {
  local extensions
  extensions=$(code --list-extensions) || return 1
  echo "${extensions}" > $(vscodefile)
}
