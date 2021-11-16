#!/bin/bash

## ----------------------------------------
##  Preparation
##  Please open zsh by Ubuntu-20.04 on Windows Terminal
##  Powershell > wsl -l -v
##  If VERSTION equals 1, please commands '> wsl --set-version Ubuntu-20.04 2'.
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
##  Install Asdf
## ----------------------------------------
install_asdf_global() {
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  if [ -f "${HOME}/.tool-versions" ]; then
    while read line; do
      lng=`$line | cut -d' ' -f1`
      ver=`$line | cut -d' ' -f2`
      asdf install $lng $ver
      asdf global $lng $ver
    done < "${HOME}/.tool-versions"
  else
    echo "Please create `${HOME}/.tool-versions`"
  fi
}

## ----------------------------------------
##  Install Yarn
## ----------------------------------------
install_yarn() {
  npm install -g yarn
  yarn -v
}


## ----------------------------------------
##  Install Zinit
## ----------------------------------------
install_zinit() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"
  source ~/.zshrc
  zinit self-update
}

## ----------------------------------------
##  Tmux
## ----------------------------------------
install_tmux_plugin_manager() {
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  /bin/bash ${HOME}/.tmux/plugins/tpm/scripts/install_plugins.sh
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
      "./dotfiles/.git_template"
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
##  Myself
## ----------------------------------------
setup_for_myself() {
  mkdir -p "${HOME}"/work
  [ ! -f "${HOME}/.secret_aliass" ] && touch "${HOME}/.secret_aliass"
}

main() {
  # install_bundle
  # install_asdf_gltall
  # install_yarn
  # install_zinit
  # install_tmux_plugin_manager
  # git_configuration
  # clone_git_repositories
  symboliclink_dotfiles
  # setup_for_myself
}

main
exec $SHELL -l
