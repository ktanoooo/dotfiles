#!/bin/bash
set -eu

## ----------------------------------------
##  Run after bootstrap.sh, from the clone it creates.
##
##    ./setup.sh                     everything
##    ./setup.sh setup_gpg           only the named targets
##    ./setup.sh --list              show the targets
##
##  Every target is guarded, so a full run on a machine that is already set
##  up costs seconds and can be repeated safely. Nothing here calls exec:
##  replacing the process would silently drop every later target.
## ----------------------------------------

EXEPATH=$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && pwd)

# Targets run in this order no matter how they are ordered on the command
# line, so the dependencies hold: links before anything reading a linked
# file, rust before cargo, brew before the packages it installs.
TARGETS="
setup_locale
symboliclink_dotfiles
setup_gitconfig
install_databases
install_rust
install_packages
install_cargo_pkgs
install_vscode_extensions
install_gcloud
install_asdf_global
install_devbox
install_heroku
install_zinit
install_herdr
setup_tig
setup_gpg
setup_vscode
setup_vimplug
setup_local_aliases
"

## ----------------------------------------
##  Helpers
## ----------------------------------------
have() { command -v "$1" > /dev/null 2>&1; }
skip() { echo "    skip: $*"; }
is_linux() { [[ $OSTYPE == linux-gnu* ]]; }
is_wsl() { grep -qi microsoft /proc/version 2> /dev/null; }

## ----------------------------------------
##  Locale
## ----------------------------------------
setup_locale() {
  is_linux || { skip "linux only"; return; }
  if locale -a 2> /dev/null | grep -qix "en_US.utf8"; then
    skip "en_US.UTF-8 already generated"
    return
  fi
  sudo locale-gen en_US
  sudo locale-gen en_US.UTF-8
  sudo update-locale LC_ALL=en_US.UTF-8
}

## ----------------------------------------
##  Symbolic link dotfiles
##  Files are linked one by one rather than by directory, so a target
##  directory holding runtime state next to its config keeps that state.
## ----------------------------------------
symboliclink_dotfiles() {
  handle_symlink_from_path() {
    file=$1
    dirpath=$(dirname "${file}") && filename=$(basename "${file}")
    abspath=$(cd "${dirpath}" && pwd)"/${filename}"
    relpath=${file#./home/}
    target="${HOME}/${relpath}"
    mkdir -p "$(dirname "${target}")"
    ln -sfn "${abspath}" "${target}"
  }
  export -f handle_symlink_from_path

  bulk_symlink_target=(
    "./home/.aliases"
    "./home/.claude"
    "./home/.git_template"
  )
  is_linux || bulk_symlink_target+=("./home/.trashrc")

  cd "${EXEPATH}"
  find_exclude=""
  for i in "${bulk_symlink_target[@]}"; do
    handle_symlink_from_path "${i}"
    find_exclude="${find_exclude} -path \"${i}\" -prune -or "
  done
  find_command="find ./home ${find_exclude} \( -type l -or -type f \) -exec bash -c 'handle_symlink_from_path \"{}\"' \;"
  eval "${find_command}"
}

## ----------------------------------------
##  Git config
##  includeIf conditions on gitdir, onbranch and hasconfig, never on the
##  operating system, so .gitconfig includes a fixed path and the variant is
##  chosen here.
## ----------------------------------------
setup_gitconfig() {
  if is_linux; then
    ln -sfn "${EXEPATH}/home/.gitconfig.linux" "${HOME}/.gitconfig.os"
  else
    ln -sfn "${EXEPATH}/home/.gitconfig.darwin" "${HOME}/.gitconfig.os"
  fi
}

## ----------------------------------------
##  Databases on WSL (mac uses Homebrew)
## ----------------------------------------
install_databases() {
  is_linux || { skip "linux only"; return; }
  if have psql && have mysql && have sqlite3; then
    skip "already installed"
    return
  fi

  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt install -y \
    postgresql \
    libpq-dev \
    mysql-server \
    mysql-client \
    libmysqlclient-dev \
    sqlite3 \
    libsqlite3-dev
}

## ----------------------------------------
##  Rust
## ----------------------------------------
install_rust() {
  if have rustup; then
    skip "rustup already installed"
    return
  fi

  if is_linux; then
    sudo apt install -y \
      pkg-config \
      libssl-dev \
      libz-dev
  fi
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
  # shellcheck disable=SC1091
  source "${HOME}/.cargo/env"
  rustup component add rust-src --toolchain stable
  rustup component add rust-analysis --toolchain stable
  rustup update stable
}

## ----------------------------------------
##  Homebrew packages
##  `brew upgrade` is deliberately not run here: upgrading is a separate
##  concern from setting a machine up, and it was the reason a full run took
##  so long that steps got commented out instead.
## ----------------------------------------
install_packages() {
  have brew || { skip "brew not installed"; return; }
  if is_linux; then
    brew bundle --file "${EXEPATH}/packages/Brewfile.linux"
  else
    brew bundle --file "${EXEPATH}/packages/Brewfile.darwin"
  fi
}

## ----------------------------------------
##  Cargo packages
## ----------------------------------------
install_cargo_pkgs() {
  have cargo || { skip "cargo not installed"; return; }

  installed=$(cargo install --list | grep -E '^[a-zA-Z]' | cut -d' ' -f1)
  sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "${EXEPATH}/packages/Cargofile" |
    while read -r pkg; do
      pkg=$(echo "${pkg}" | tr -d '[:space:]')
      [ -n "${pkg}" ] || continue
      if echo "${installed}" | grep -qx "${pkg}"; then
        skip "cargo ${pkg}"
        continue
      fi
      cargo install "${pkg}"
    done
}

## ----------------------------------------
##  VSCode extensions
## ----------------------------------------
install_vscode_extensions() {
  have code || { skip "code CLI not found"; return; }

  installed=$(code --list-extensions 2> /dev/null || true)
  while read -r extension; do
    extension=$(echo "${extension}" | tr -d '[:space:]')
    [ -n "${extension}" ] || continue
    if echo "${installed}" | grep -qix "${extension}"; then
      skip "ext ${extension}"
      continue
    fi
    code --install-extension "${extension}"
  done < "${EXEPATH}/packages/VSCodefile"
}

## ----------------------------------------
##  Google Cloud SDK
## ----------------------------------------
install_gcloud() {
  if have gcloud; then
    skip "gcloud already installed"
    return
  fi
  if is_linux; then
    curl https://sdk.cloud.google.com | bash
  else
    skip "installed through the google-cloud-sdk cask"
  fi
}

## ----------------------------------------
##  Asdf
## ----------------------------------------
install_asdf_global() {
  # https://asdf-vm.com/guide/getting-started.html
  if [ -d "${HOME}/.asdf" ]; then
    skip "asdf already cloned"
  else
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0
  fi

  have asdf || { skip "asdf not on PATH yet, open a new shell and re-run"; return; }

  asdf plugin add bun || true
  asdf plugin-add php https://github.com/asdf-community/asdf-php.git || true
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git || true
  asdf plugin add deno https://github.com/asdf-community/asdf-deno.git || true
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git || true
  asdf plugin add golang https://github.com/kennyp/asdf-golang.git || true
  asdf plugin add terraform https://github.com/Banno/asdf-hashicorp.git || true
  asdf plugin add terragrunt https://github.com/ohmer/asdf-terragrunt.git || true

  if [ ! -f "${HOME}/.tool-versions" ]; then
    echo "Please create ${HOME}/.tool-versions"
    return
  fi

  # Read the whole file up front: ~/.tool-versions is a link into this repo and
  # `asdf global` rewrites it, so iterating over the open file would have it
  # changing underneath the loop.
  tool_versions=$(cat "${HOME}/.tool-versions")
  echo "${tool_versions}" | while read -r line; do
    [ -n "${line}" ] || continue
    lng=$(echo "${line}" | cut -d' ' -f1)
    ver=$(echo "${line}" | cut -d' ' -f2)
    asdf install "${lng}" "${ver}"
    asdf global "${lng}" "${ver}"
  done

  # Not an `a && b && c` one-liner: as the last statement of the function its
  # non-zero result becomes the return value and set -e ends the whole run.
  if have node && ! have yarn; then
    npm install -g yarn
  fi
}

## ----------------------------------------
##  Devbox
## ----------------------------------------
install_devbox() {
  if have devbox; then
    skip "devbox already installed"
    return
  fi
  curl -fsSL https://get.jetpack.io/devbox | bash
  if is_linux; then
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
  else
    sh <(curl -L https://nixos.org/nix/install)
  fi
}

## ----------------------------------------
##  heroku-cli
## ----------------------------------------
install_heroku() {
  if have heroku; then
    skip "heroku already installed"
    return
  fi
  if is_linux; then
    curl https://cli-assets.heroku.com/install-ubuntu.sh | sh
  else
    curl https://cli-assets.heroku.com/install.sh | sh
  fi
}

## ----------------------------------------
##  Zinit
## ----------------------------------------
install_zinit() {
  if [ -d "${HOME}/.zinit" ]; then
    skip "zinit already installed"
    return
  fi
  # No `source ~/.zshrc` here: this runs under bash and the file is zsh.
  sh -c "$(curl -fsSL https://git.io/zinit-install)"
}

## ----------------------------------------
##  Herdr
##  Installs to ~/.local/bin and self-updates through `herdr update`.
##  symboliclink_dotfiles runs first, so ~/.config/herdr/config.toml is
##  already linked here and Herdr skips onboarding instead of writing its
##  own config over it.
## ----------------------------------------
install_herdr() {
  if have herdr; then
    skip "herdr already installed"
    return
  fi
  curl -fsSL https://herdr.dev/install.sh | sh
}

## ----------------------------------------
##  Tig
## ----------------------------------------
setup_tig() {
  # Not yet supported delta in tig, comming soon.
  # https://github.com/jonas/tig/pull/1140
  # So, on MacOS, need to use diff-highlight in tig
  is_linux && { skip "mac only"; return; }
  have brew || { skip "brew not installed"; return; }
  ln -sfn "$(brew --prefix git)/share/git-core/contrib/diff-highlight/diff-highlight" "$(brew --prefix)/bin/diff-highlight"
}

## ----------------------------------------
##  GPG
##  A GUI pinentry lets non-interactive callers (IDE, Claude Code) still
##  prompt for the passphrase.
## ----------------------------------------
setup_gpg() {
  mkdir -p "${HOME}/.gnupg"
  chmod 700 "${HOME}/.gnupg"

  conf="${HOME}/.gnupg/gpg-agent.conf"
  before=$(readlink "${conf}" 2> /dev/null || true)

  if is_linux; then
    have pinentry-gnome3 || sudo apt install -y pinentry-gnome3
    ln -sfn "${EXEPATH}/home/.gnupg/gpg-agent.conf.linux" "${conf}"
  else
    have pinentry-mac || brew install pinentry-mac
    ln -sfn "${EXEPATH}/home/.gnupg/gpg-agent.conf.mac" "${conf}"
  fi

  # Restarting the agent drops the cached passphrase, so only do it when the
  # config actually moved. Otherwise every run would ask for it again.
  if [ "${before}" != "$(readlink "${conf}")" ]; then
    gpgconf --kill gpg-agent 2> /dev/null || true
  else
    skip "gpg-agent already pointed at this config"
  fi
}

## ----------------------------------------
##  VSCode settings
##  WSL is skipped: the editor runs on the Windows side and
##  windows/bootstrap.ps1 places the files there.
## ----------------------------------------
setup_vscode() {
  if is_linux; then
    is_wsl && { skip "WSL uses the Windows install"; return; }
    dir="${HOME}/.config/Code/User"
  else
    dir="${HOME}/Library/Application Support/Code/User"
  fi
  mkdir -p "${dir}"
  ln -sfn "${EXEPATH}/vscode/settings.json" "${dir}/settings.json"
  ln -sfn "${EXEPATH}/vscode/keybindings.json" "${dir}/keybindings.json"
}

## ----------------------------------------
##  vim-plug
##  init.vim calls plug#begin, so nvim errors on a machine without this.
## ----------------------------------------
setup_vimplug() {
  plugvim="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload/plug.vim"
  if [ -f "${plugvim}" ]; then
    skip "vim-plug already installed"
    return
  fi
  curl -fLo "${plugvim}" --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

## ----------------------------------------
##  Local aliases
## ----------------------------------------
setup_local_aliases() {
  # An `[ ! -f x ] && touch x` one-liner returns non-zero once the file
  # exists, which under set -e ends the run.
  if [ ! -f "${HOME}/.aliases-local.zsh" ]; then
    touch "${HOME}/.aliases-local.zsh"
  fi
}

## ----------------------------------------
##  Entry point
## ----------------------------------------
usage() {
  echo "Usage: ./setup.sh [target...]"
  echo
  echo "  no arguments   run every target"
  echo "  --list         print the targets"
  echo
  echo "Targets run in their declared order regardless of the order given."
}

main() {
  case "${1:-}" in
    --help | -h)
      usage
      return
      ;;
    --list)
      echo "${TARGETS}" | sed '/^$/d;s/^/  /'
      return
      ;;
  esac

  if [ "$#" -eq 0 ]; then
    # shellcheck disable=SC2086
    set -- ${TARGETS}
  fi

  for want in "$@"; do
    if ! echo "${TARGETS}" | grep -qx "${want}"; then
      echo "unknown target: ${want}" >&2
      echo >&2
      usage >&2
      return 1
    fi
  done

  for name in ${TARGETS}; do
    for want in "$@"; do
      if [ "${name}" = "${want}" ]; then
        echo "==> ${name}"
        "${name}"
        break
      fi
    done
  done

  echo
  echo "Done. Open a new shell to pick up any PATH change."
}

# Main
main "$@"
