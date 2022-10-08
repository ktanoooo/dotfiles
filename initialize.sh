#!/bin/bash
set -eux

## ----------------------------------------
##  Preparation
##  Step1. Please Install Ubuntu-20.04 at Microsoft Store
##  Step2. Open Ubuntu-20.04 by Windows Terminal
## ----------------------------------------

## ----------------------------------------
## Install brew
## ----------------------------------------
install_brew() {
  # Install brew dependent packages
  sudo apt install build-essential curl file git -y

  # Install brew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.profile
  # https://brew.sh/index_ja
  # https://docs.brew.sh/Homebrew-on-Linux
}

## ----------------------------------------
##  Git Configuration
## ----------------------------------------
setup_github() {
  mkdir -p ${HOME}/.ssh
  cd ${HOME}/.ssh
  ssh-keygen -t ed25519 -f id_ed25519_github -C "ktanoooo1112@gmail.com"
  ssh-keyscan -t ed25519 github.com >> "${HOME}"/.ssh/known_hosts
  cd ${HOME}
# Keep the following indententions.
cat >> ${HOME}/.ssh/config << EOF
HOST github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_github
EOF
  brew install gh ghq
  gh auth login

  clone_git_repositories() {
    ghq get -p git@github.com:ktanoooo/dotfiles.git
  }

  clone_git_repositories
}

## ----------------------------------------
## Install zsh
## ----------------------------------------
install_zsh() {
  brew install zsh
  if [[ $OSTYPE == "linux-gnu" ]]; then
    ZSH_PATH="$(brew --prefix)/bin/zsh"
    ZSH_SHARE_PATH="$(brew --prefix)/share/zsh"
    echo `which zsh` | sudo tee -a /etc/shells
  else
    ZSH_PATH="/usr/local/bin/zsh"
    ZSH_SHARE_PATH="/usr/local/share/zsh"
    sudo sh -c "$(echo $ZSH_PATH)" >> /etc/shells
  fi
  chmod 755 $ZSH_SHARE_PATH
  chmod 755 "${ZSH_SHARE_PATH}/site-functions"
  sudo chsh -s $ZSH_PATH
  sudo chsh $USER -s $ZSH_PATH
}

main() {
  sudo apt update -y
  sudo apt upgrade -y

  install_brew
  setup_github
  install_zsh
  exec $SHELL -l
}

# Main
main
