alias dus='dust -pr -d 2 -X ".git" -X "node_modules"'
alias psa='ps aux'
alias pskl='psa | fzf | awk "{ print \$2 }" | xargs kill -9'

alias loi='[ !-z $1 ] && lsof -i $1'
alias loikl='lsof -i | fzf | awk "{print \$2 }" | xargs kill -9'

alias fd='fd -iH --no-ignore-vcs -E ".git" -E "node_modules"' rmds='fd .DS_Store -X rm'

alias dfh='df -Th'
duh() {
  if [ -z "$1" ]; then
    du -h -d 1 | sort -h -r
  else
    du -h -d $1 | sort -h -r
  fi
}
alias makedummy='dd if=/dev/zero of=/home/user/100MB.file bs=1M count=100'

alias skg='ssh-keygen -t rsa -f $1'