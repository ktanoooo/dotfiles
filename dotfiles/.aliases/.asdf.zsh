asdf_setup() {
  echo -e "\n. $(brew --prefix asdf)/asdf.sh" >> ~/.zshrc
}

asdf_install() {
  for plugin in $(cat ./.tool-versions | cut -d' ' -f1); do
    asdf plugin-add "${plugin}"
  done
  asdf install
  while read local_version; do
    asdf local $local_version
  done < ./.tool-versions
}

asdf_ruby_install() {
  asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
  asdf install ruby 3.0.2
  asdf global ruby 3.0.2
}

asdf_nodejs_install() {
  asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
  asdf install nodejs 17.0.1
  asdf global nodejs 17.0.1
}

source $(brew --prefix asdf)/asdf.sh
bash $(brew --prefix asdf)/etc/bash_completion.d/asdf.bash
