#!/bin/bash

## ----------------------------------------
##  Preparation
##  Please open zsh by Ubuntu-20.04 on Windows Terminal
## ----------------------------------------

EXEPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

## ----------------------------------------
##  Install Bundle
## ----------------------------------------
install_bundle() {
  CWD=${EXEPATH}/bundle
  /bin/bash "${CWD}"/install.sh
}

## ----------------------------------------
##  Git Configuration
## ----------------------------------------
git_configuration() {
  mkdir -p "${HOME}"/.ssh
  ssh-keygen -t rsa -b 4096 -C $USER_EMAIL
  ssh-keyscan -t rsa github.com >> "${HOME}"/.ssh/known_hosts
  brew install gh
  gh auth login
}

## ----------------------------------------
##  Clone Git Repositories
## ----------------------------------------
clone_git_repositories() {
  mkdir -p "${HOME}"/.ghq/github.com/ktanoooo/dotfiles && cd "$_" || exit 1
  git clone --recursive https://github.com/ktanoooo/dotfiles .

  # ... other repos
}

## ----------------------------------------
## Symbolic link dotfiles
## ----------------------------------------
symboliclink_dotfiles() {
  handle_symlink_from_path() {
    file=$1
    dirpath=$(dirname "${file}") && filename=$(basename "${file}")
    abspath=$(cd "${dirpath}" && pwd)"/${filename}"
    relpath=$(echo "${file}" | sed "s|^\./dotfiles/||")
    target="${HOME}/${relpath}"
    mkdir -p "$(dirname "${target}")"
    ln -sfnv "${abspath}" "${target}"
  }
  export -f handle_symlink_from_path

  if [[ $OSTYPE == "linux-gnu" ]]; then
    bulk_symlink_target=(
      "./dotfiles/.aliases"
    )
  else
    bulk_symlink_target=(
      "./dotfiles/Library/Application Support/Alfred/Alfred.alfredpreferences"
      "./dotfiles/.aliases"
      "./dotfiles/.git_template"
      "./dotfiles/.snippets"
      "./dotfiles/.trashrc"
    )
  fi

  find_exclude=""
  for i in "${bulk_symlink_target[@]}"; do
    handle_symlink_from_path "${i}"
    find_exclude="${find_exclude} -path \"${i}\" -prune -or "
  done
  find_command="find ./dotfiles ${find_exclude} \( -type l -or -type f \) -exec bash -c 'handle_symlink_from_path \"{}\"' \;"
  eval "${find_command}"
}

## ----------------------------------------
##  Install asdf
## ----------------------------------------


## ----------------------------------------
##  Myself
## ----------------------------------------
setup_for_myself() {
  mkdir -p "${HOME}"/work
}

main() {
  # install_bundle
  # git_configuration
  # clone_git_repositories
  symboliclink_dotfiles
}

main
exec $SHELL -l
