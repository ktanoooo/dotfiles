#!/bin/bash

## ----------------------------------------
##  Preparation
##  Step1. Please Install Ubuntu-20.04 at Microsoft Store
##  Step2. Open Ubuntu-20.04 by Windows Terminal
## ----------------------------------------

# Update and Upgrade apt
initial() {
  sudo apt update -y
  sudo apt upgrade -y
}

# Install brew
install_brew() {
  # Install brew dependent packages
  sudo apt install build-essential curl file git -y
  # Install brew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  test -r ~/.bash_profile && echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >> ~/.bash_profile
  echo "eval \"\$($(brew --prefix)/bin/brew shellenv)\"" >>~/.profile
  # references: 
  # https://brew.sh/index_ja
  # https://docs.brew.sh/Homebrew-on-Linux
}

# Install zsh
install_zsh() {
  brew install zsh
  if [[ $OSTYPE == "linux-gnu" ]]; then
    ZSH_PATH=`$(brew --prefix)/bin/zsh`
    ZSH_SHARE_PATH=`$(brew --prefix)/share/zsh`
    echo `which zsh` | sudo tee -a /etc/shells
    chsh -s `which zsh`
    echo "eval \$($(brew --prefix)/bin/brew shellenv)" >> ~/.zshrc
  else
    ZSHPATH="/usr/local/bin/zsh"
    ZSH_SHARE_PATH="/usr/local/share/zsh"
    sudo sh -c "$(echo $ZSH_PATH)" >> /etc/shells
    sudo chsh -s $ZSH_PATH
  fi
  chmod 755 $ZSH_SHARE_PATH
  chmod 755 "${ZSH_SHARE_PATH}/site-functions"
}

main() {
  initial
  install_brew
  install_zsh
}

# Main
USER_NAME="ktanoooo"
USER_EMAIL="ktanoooo1112@gmail.com"
main

# If it is finished, reopen Windows Terminal. Maybe it will be opened on zsh.