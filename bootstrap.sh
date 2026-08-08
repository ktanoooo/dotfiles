#!/bin/bash
set -eux

## ----------------------------------------
##  Preparation
##  Step1. Please Install Ubuntu at Microsoft Store
##  Step2. Open Ubuntu by Windows Terminal
##
##  Run this once on a new machine, then run setup.sh from the clone it
##  creates. Every step is guarded, so re-running after a failure resumes
##  instead of starting over.
## ----------------------------------------

# ghq takes its root from ghq.root in ~/.gitconfig, which is a link into this
# repository and so does not exist yet at this point. Without this the clone
# lands in ghq's default ~/ghq, while every later `ghq list` and `ghq root`
# reads ~/.ghq and never finds it. Keep in sync with [ghq] root in
# home/.gitconfig.
export GHQ_ROOT="${HOME}/.ghq"

## ----------------------------------------
##  Helpers
## ----------------------------------------
# Append a line only if the file does not already carry it, so re-running
# does not stack duplicates in the shell rc files.
append_once() {
  local line=$1 file=$2
  [ -f "${file}" ] || return 0
  grep -qxF "${line}" "${file}" || echo "${line}" >> "${file}"
}

## ----------------------------------------
## Install brew
## ----------------------------------------
install_brew() {
  if ! command -v brew > /dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  test -d ~/.linuxbrew && eval "$(~/.linuxbrew/bin/brew shellenv)"
  test -d /home/linuxbrew/.linuxbrew && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

  # https://docs.brew.sh/Homebrew-on-Linux
  local shellenv
  shellenv="eval \"\$($(brew --prefix)/bin/brew shellenv)\""
  if [[ $OSTYPE == "linux-gnu" ]]; then
    append_once "${shellenv}" ~/.bash_profile
    append_once "${shellenv}" ~/.bashrc
  else
    append_once "${shellenv}" ~/.zshrc
  fi
}

## ----------------------------------------
##  Git Configuration
## ----------------------------------------
setup_github() {
  FILENAME=id_ed25519_github
  SSH_DIR=~/.ssh
  SSH_KEY_PATH=${SSH_DIR}/${FILENAME}
  SSH_KEY_PUB_PATH=${SSH_KEY_PATH}.pub

  mkdir -p "${SSH_DIR}"
  chmod 700 "${SSH_DIR}"

  if [ ! -f "${SSH_KEY_PATH}" ]; then
    ssh-keygen -t ed25519 -f "${SSH_KEY_PATH}" -C "ktanoooo1112@gmail.com"
  fi

  touch "${SSH_DIR}/known_hosts"
  if ! ssh-keygen -F github.com -f "${SSH_DIR}/known_hosts" > /dev/null 2>&1; then
    ssh-keyscan -t ed25519 github.com >> "${SSH_DIR}/known_hosts"
  fi

  touch "${SSH_DIR}/config"
  if ! grep -q "^HOST github.com" "${SSH_DIR}/config"; then
# Keep the following indententions.
cat >> "${SSH_DIR}/config" << EOF
HOST github.com
  HostName github.com
  User git
  IdentityFile ${SSH_KEY_PATH}
EOF
  fi

  command -v gh > /dev/null 2>&1 || brew install gh
  command -v ghq > /dev/null 2>&1 || brew install ghq

  # gh auth login opens a browser, so only ask when not already authenticated.
  if ! gh auth status > /dev/null 2>&1; then
    yes | gh auth login -p ssh -h github.com -s admin:public_key --web
    gh ssh-key add "${SSH_KEY_PUB_PATH}" --title "main_pc"
  fi

  git config --global user.name ktanoooo
  git config --global user.email "ktanoooo1112@gmail.com"

  ghq get -p git@github.com:ktanoooo/dotfiles.git
}

## ----------------------------------------
## Install zsh
## ----------------------------------------
install_zsh() {
  command -v zsh > /dev/null 2>&1 || brew install zsh

  # Resolve through brew so this works on both Intel and Apple Silicon; the
  # prefix differs (/usr/local vs /opt/homebrew) and hardcoding it left the
  # login shell pointing at a path that does not exist.
  ZSH_PATH="$(brew --prefix)/bin/zsh"
  ZSH_SHARE_PATH="$(brew --prefix)/share/zsh"

  # /etc/shells needs root, so tee rather than a plain redirect: with `sudo cmd
  # >> file` the redirect still runs as the calling user and is denied.
  if ! grep -qxF "${ZSH_PATH}" /etc/shells; then
    echo "${ZSH_PATH}" | sudo tee -a /etc/shells > /dev/null
  fi

  chmod 755 "${ZSH_SHARE_PATH}"
  chmod 755 "${ZSH_SHARE_PATH}/site-functions"

  # Only the invoking user's shell. A bare `sudo chsh -s` targets root, which
  # is how root ended up on a brew-managed zsh.
  if [ "$(getent passwd "${USER}" | cut -d: -f7)" != "${ZSH_PATH}" ]; then
    sudo chsh "${USER}" -s "${ZSH_PATH}"
  fi
}

main() {
  if [[ $OSTYPE == "linux-gnu" ]]; then
    sudo apt update -y
    sudo apt upgrade -y
    sudo apt install -y build-essential curl file git
  fi

  install_brew
  setup_github
  install_zsh

  set +x
  echo
  echo "Done. Open a new terminal to pick up the new login shell and brew's"
  echo "PATH, then run:"
  echo "  cd ${GHQ_ROOT}/github.com/ktanoooo/dotfiles"
  echo "  ./setup.sh"
  echo
}

# Main
main
