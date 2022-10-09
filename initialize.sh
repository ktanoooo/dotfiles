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
  FILENAME=id_ed25519_github
  SSH_DIR=~/.ssh
  SSH_KEY_PATH=${SSH_DIR}/${FILENAME}
  SSH_KEY_PUB_PATH=${SSH_KEY_PATH}.pub

  mkdir -p ${SSH_DIR}
  cd ${SSH_DIR}
  ssh-keygen -t ed25519 -f FILENAME -C "ktanoooo1112@gmail.com"
  ssh-keyscan -t ed25519 github.com >> "${SSH_DIR}"/known_hosts
  cd ${HOME}
# Keep the following indententions.
cat >> ${SSH_DIR}/config << EOF
HOST github.com
  HostName github.com
  User git
  IdentityFile ${SSH_KEY_PATH}
EOF
  brew install gh ghq
  yes | gh auth login -p ssh -h GitHub.com --web
  gh ssh-key add ${SSH_KEY_PUB_PATH} --title "main_pc"
  git config --global user.name ktanoooo
  git config --global user.email "ktanoooo1112@gmail.com"

  ghq get -p git@github.com:ktanoooo/dotfiles.git
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
