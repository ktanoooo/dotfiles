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
alias dus='dust -pr -d 2 -X ".git" -X "node_modules"'
alias psa='ps aux' pskl='psa | fzf | awk "{ print \$2 }" | xargs kill -9'
alias fd='fd -iH --no-ignore-vcs -E ".git" -E "node_modules"' rmds='fd .DS_Store -X rm'
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

alias df='df -Th'
alias makedummy='dd if=/dev/zero of=/home/user/100MB.file bs=1M count=100'

# (--interactive)オプションで上書き時に対話形式で返すようにする
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# alias   ssh
alias skg='ssh-keygen -t rsa -f $1'

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
