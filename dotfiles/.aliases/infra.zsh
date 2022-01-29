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
alias makedummy='dd if=/dev/zero of=./100MB.file bs=1M count=100'

sshkg() {
  read filename"?type set filename [id_ed25519_*]: "
  [ -z $filename ] && echo "type error" && return
  read hostname"?type set hostname [github.com]: "
  [ -z $hostname ] && echo "type error" && return
  read user"?type set User [git/ubuntu/root]: "
  [ -z $user ] && echo "type error" && return
  if [ $hostname = "github.com" ]; then
    sshalias=$hostname
  else 
    read sshalias"?type set ssh alias [projectprd]: "
    [ -z $sshalias ] && echo "type error" && return
  fi
  fullpath=${HOME}/.ssh/id_ed25519_${filename}
  mkdir -p ${HOME}/.ssh
  ssh-keygen -t ed25519 -f $fullpath -N "" -C "ktanoooo1112@gmail.com"
  ssh-keyscan -t ed25519 $hostname >> ${HOME}/.ssh/known_hosts
# インデント大事
cat >> ${HOME}/.ssh/config << EOF
HOST $sshalias
  HostName $hostname
  User $user
  IdentityFile ~/.ssh/id_ed25519_${filename}

EOF
  cat ${fullpath}.pub
}
