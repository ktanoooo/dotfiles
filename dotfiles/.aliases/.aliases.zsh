## ========== Global Alias ==========
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g X='| xargs'
alias -g C='| wc -l'
alias -g CP='| pbcopy'

alias cdh='cd ~'
alias ls='exa -h'
alias ll='exa -alhF --group-directories-first --time-style=long-iso'
alias llx='ll --git-ignore --ignore-glob=".git|node_modules"'
alias tr2='llx -T -L=2' tr3='llx -T -L=3'

alias weather='curl -Acurl wttr.in/Tokyo'
alias weathert='curl -Acurl wttr.in/Tokushima'
alias bat='bat --color=always --theme=ansi'
alias virc='vi ~/.zshrc' sorc='source ~/.zshrc'

alias ydlmp3='youtube-dl -x --audio-format mp3'

mkcd() { mkdir "$1" && cd "$1"; }
absp() { echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1"); }
lnsv() {
  [ -z "$2" ] && echo "Specify Target" && return 0;
  abspath=$(absp $1);
  ln -sfnv "${abspath}" "$2";
}
vv() {
  [ -z "$1" ] && code ./ && return 0;
  code "$1";
}
rgvi() {
  [ -z "$2" ] && matches=`rg "$1" -l`;
  [ -z "${matches}" ] && echo "no matches\n" && return 0;
  selected=`echo "${matches}" | fzf --preview "rg -pn '$1' {}"`;
  [ -z "${selected}" ] && echo "fzf Canceled." && return 0;
  vi "${selected}";
}
fdvi() {
  [ -z "$2" ] && matches=`fd "$1"`;
  [ -z "${matches}" ] && echo "no matches\n" && return 0;
  selected=`echo "${matches}" | fzf --preview "bat --color=always {}"`;
  [ -z "${selected}" ] && echo "fzf Canceled." && return 0;
  vi "${selected}";
}
h() {
  cmd=`history 1 | awk '{$1="";print $0;}' | fzf`
  [ -z "${cmd}" ] && echo "fzf Canceled." && return 0;
  echo "${cmd}" && eval "${cmd}"
}
alias vvh='code -n ~/.zsh_history'

if [[ $OSTYPE != "linux-gnu" ]]; then
  # MacOS
  alias grep='ggrep'
  alias pp='pbpaste >'
  catp() { cat "$1" | pbcopy }
fi

# (--interactive)オプションで上書き時に対話形式で返すようにする
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

zipd() {
  [ -z $1 ] && echo "no arg" && return 0;
  zip -r $1.zip $1 -x "*.DS_Store"
}
zipdp() {
  [ -z $1 ] && echo "no arg" && return 0;
  zip -e -r $1.zip $1 -x "*.DS_Store"
}
alias unzipsjis='unzip -O cp932'

## ----------------------------------------
##  Zinit
## ----------------------------------------
zinit-plug-install() {
  source ~/.zshrc
}
zinit-plug-update() {
  zinit self-update
  zinit update
}
zinit-plug-clean() {
  zinit delete --clean
}
