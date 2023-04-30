#!/bin/bash
set -eux

# ----------------------------------------
#  Preparation
#  Please open zsh by Ubuntu-20.04 on Windows Terminal
#  Powershell > wsl -l -v
#  If VERSTION equals 1, please commands '> wsl --set-version Ubuntu-20.04 2'.
# ----------------------------------------

EXEPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

## ----------------------------------------
## Locale
## ----------------------------------------
setup_locale() {
  sudo locale-gen en_US
  sudo locale-gen en_US.UTF-8
  sudo update-locale LC_ALL=en_US.UTF-8
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
      "./scripts"
    )
  else
    bulk_symlink_target=(
      "./dotfiles/.aliases"
      "./dotfiles/.git_template"
      "./dotfiles/.trashrc"
      "./scripts"
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
##  Install Databases on WSL (mac use Homebrew)
## ----------------------------------------
install_databases() {
  if [[ $OSTYPE == "linux-gnu" ]]; then
    # postgresql
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt install -y \
      postgresql \
      libpq-dev

    # mysql
    sudo apt install -y \
      mysql-server \
      mysql-client \
      libpq-dev \
      libmysqlclient-dev

    # sqlite
    sudo apt install -y \
      sqlite3 \
      libpq-dev \
      libmysqlclient-dev \
      libsqlite3-dev
  fi
}

## ----------------------------------------
## Install Rust
## ----------------------------------------
install_rust() {
  sudo apt install -y \
    pkg-config \
    libssl-dev \
    libz-dev
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  source ${HOME}/.cargo/env
  rustup component add rls --toolchain stable
  rustup component add rust-src --toolchain stable
  rustup component add rls-preview --toolchain stable
  rustup component add rust-analysis --toolchain stable
  rustup update stable
}

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
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git || true
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git || true
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
  asdf plugin add golang https://github.com/kennyp/asdf-golang.git || true
  asdf plugin add python https://github.com/danhper/asdf-python.git || true
  asdf plugin add terraform https://github.com/Banno/asdf-hashicorp.git || true
  asdf plugin add terragrunt https://github.com/ohmer/asdf-terragrunt.git || true
  if [ -f "${HOME}/.tool-versions" ]; then
    while read line; do
      lng=`echo $line | cut -d' ' -f1`
      ver=`echo $line | cut -d' ' -f2`
      asdf install $lng $ver
      asdf global $lng $ver
    done < "${HOME}/.tool-versions"
    type node > /dev/null 2>&1 && npm install -g yarn
  else
    echo "Please create `${HOME}/.tool-versions`"
  fi
}

## ----------------------------------------
##  Install Zinit
## ----------------------------------------
install_zinit() {
  sh -c "$(curl -fsSL https://git.io/zinit-install)"
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
##  Tig
## ----------------------------------------
setup_tig() {
  # Not yet supported delta in tig, comming soon.
  # https://github.com/jonas/tig/pull/1140
  # So, on MacOS, need to use diff-highlight in tig
  if [[ $OSTYPE != "linux-gnu" ]]; then
    ln -s `brew --prefix git`/share/git-core/contrib/diff-highlight/diff-highlight `brew --prefix`/bin
  fi
}

## ----------------------------------------
##  Setup VimPlug
## ----------------------------------------
vimplug_setup() {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}

## ----------------------------------------
##  Myself
## ----------------------------------------
setup_for_myself() {
  [ ! -f "${HOME}/.aliases-local.zsh" ] && touch "${HOME}/.aliases-local.zsh"
}

main() {
  setup_locale
  
  symboliclink_dotfiles
  install_databases
  install_rust
  install_bundle
  install_asdf_global
  install_zinit
  install_tmux_plugin_manager
  setup_tig
  setup_for_myself

  exec $SHELL -l
}

# Main
main
