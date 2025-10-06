# Before, Create local .tool-versions
# ex. echo "nodejs 17.0.0"  >> .tool-versions
asdf_install() {
  if [ -f ./.tool-versions ]; then
    while read line; do
      lng=`$line | cut -d' ' -f1`
      ver=`$line | cut -d' ' -f2`
      asdf install $lng $ver
      asdf local $lng $ver
    done < ./.tool-versions
    echo ".tool-versions" >> .gitignore
  else
    echo "Please create ./.tool-versions"
  fi
}

# https://github.com/asdf-vm/asdf/issues/1115#issuecomment-1018009184
asdf_clean() {
  rm -f ~/.asdf/shims/*
  asdf reshim
}

alias asdfc='asdf current'
alias asdfpl="asdf plugin list"
alias asdfpu='asdf plugin update --all'
alias asdfpr='asdf plugin remove'
alias asdfpad='asdf plugin add'
alias asdfi='asdf install'
alias asdfu='asdf uninstall'
alias asdfl='asdf list'
alias asdflg='asdf list global'
alias asdfg='asdf global'
alias asdflo='asdf local'
