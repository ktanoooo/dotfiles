anyenv_setup() {
  brew install anyenv
  export PATH="$HOME/.anyenv/bin:$PATH"
  echo 'eval "$(anyenv init -)"' >> "${HOME}/.zshrc"
}

anyenv_ruby_install() {
  anyenv install rbenv
  rbenv install 2.7.0
}

anyenv_nodejs_install() {
  anyenv install nodenv
  git clone https://github.com/pine/nodenv-yarn-install.git "$(nodenv root)/plugins/nodenv-yarn-install"
  nodenv install 13.6.0
}

anyenv_python_install() {
  anyenv install pynev
  pyenv install 3.9.6
}