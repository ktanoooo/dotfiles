# vim: filetype=zsh

alias grep='grep --color=auto'
alias a='grep alias $HOME/.aliases'
alias aa='grep alias $HOME/.aliases-local'

alias ls='ls -aG'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

alias date-yymmddhhmmss='date +%Y%m%d%H%M%S'
alias df='df -Th'

# editer
alias vi='nvim'
alias vim='nvim'
alias view='nvim -R'
alias viewhex="view -b -c '%!xxd'"

## ========== Neovim ==========
alias vivi='vi ~/.config/nvim/init.vim'
vink() {
  FORMAT=`nkf -g $@`;
  nvim -c ":e ++enc=${FORMAT}" $@;
}
vigo() {
  nvim -c "call append(0, v:oldfiles)" -c "write! ~/.config/nvim/viminfo.log" -c exit;
  nvim `cat ~/.config/nvim/viminfo.log | fzf --preview 'bat --color=always {}'`;
}

# (--interactive)オプションで上書き時に対話形式で返すようにする
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# alias   ssh
alias skg='ssh-keygen -t rsa -f $1'

# alias   pbcopy
# alias   copyはこの後にファイルを指定する
alias copy='pbcopy < '

# alias   docker
alias di='docker images'
alias dps='docker ps'
alias drmi='docker rmi -f'
alias dip='docker inspect'
alias dpsa='docker ps -a'

# alias   docker-compose
alias dcb='docker-compose build'
alias dcup='docker-compose up'
alias dcd='docker-compose down'
alias dcps='docker-compose ps'
alias dcpsa='docker-compose ps -a'

# Ruby
alias bclpvb='bundle config --local path vendor/bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bi-pvb='echo deprecated! Use "bclpvb" for "bundle config --local path vendor/bundle"'
alias bi-bbb='bundle install --binstubs .bundle/bin'

# Ruby
alias bclpvb='bundle config --local path vendor/bundle'
alias be='bundle exec'
alias bi='bundle install'
alias bi-pvb='echo deprecated! Use "bclpvb" for "bundle config --local path vendor/bundle"'
alias bi-bbb='bundle install --binstubs .bundle/bin'

# Git
alias g=git
alias gac='git add -A :/ && git commit'
alias gaca='git add -A :/ && git commit --amend'
alias gad='git add'
alias gadd='git add'
alias gb='git branch'
alias gca='git commit --amend'
alias gci='git commit'
alias gco='git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias gfop='git fetch origin --prune'
alias gfup='git fetch upstream --prune'
alias gic='git init && git add -A :/ && git commit'
alias glg="git log --stat --pretty=format:'%Cblue%h %Cgreen%ai %Cred%an %d
%Creset%s'"
alias glggo='git log --graph --oneline'
alias gnow='git add -A :/ && git commit -m "[WIP]"'
alias gp='git push'
alias gpo='git push origin'
alias gpl='git pull'
alias grm='git remote -v'
alias grma='git remote add'
alias grms='git remote set-url origin'
alias grbh1id='git rebase HEAD^ --ignore-date'
alias grfh='git reset FETCH_HEAD --hard'
alias grfhh=grfh
alias grhh='git reset HEAD --hard'
alias grh1h='git reset HEAD^ --hard'
alias gs='git status -sb'
alias gst='git status'
alias gshow='git show'
alias gsw='git switch'
alias gacarbh1cdiad='git add -A :/ && git commit --amend && git rebase HEAD^ --committer-date-is-author-date'
alias gconf='git config --local --list'
alias gconfn='git config --local user.name'
alias gconfe='git config --local user.email'

gacm() {
  git add -A :/
  git commit -m "$(echo $@)"
}
gcim() {
  git commit -m "$(echo $@)"
}

gpom() {
  if git branch | grep '[ \*] master$' > /dev/null; then
    git push origin master $@
  else
    git push origin main $@
  fi
}

alias ta='tig --all'

# ref. http://vim.wikia.com/wiki/256_colors_setup_for_console_Vim
alias tmux='tmux -2'
alias tmux-n='tmux -2 new-session -n ""'

alias unzipsjis='unzip -O cp932'
alias shs='echo Use "pyhs"; python3 -m http.server'
alias pyhs='python3 -m http.server'

