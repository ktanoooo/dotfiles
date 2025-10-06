# Export current installed packages to Brewfile
brewexport () {
  brew bundle dump --file=$(ghq list -p -e dotfiles)/bundle/Brewfile.mac --force --no-vscode
}

# Sync packages with Brewfile and upgrade to latest versions
brewimport() {
  brew bundle --file=$(ghq list -p -e dotfiles)/bundle/Brewfile.mac
}
