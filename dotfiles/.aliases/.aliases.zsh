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

# tig
alias ta='tig --all'

# ref. http://vim.wikia.com/wiki/256_colors_setup_for_console_Vim
alias tmux='tmux -2'
alias tmux-n='tmux -2 new-session -n ""'

alias unzipsjis='unzip -O cp932'
alias shs='echo Use "pyhs"; python3 -m http.server'
alias pyhs='python3 -m http.server'


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
