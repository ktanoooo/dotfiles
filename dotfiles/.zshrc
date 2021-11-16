## ----------------------------------------
##  Prompt
##  - Must be the top of .zshrc.
## ----------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## ----------------------------------------
##  Env
## ----------------------------------------
export ENHANCD_FILTER=fzf
export ENHANCD_DOT_ARG="-up"
export ENHANCD_HYPHEN_ARG="-ls"
export TERM=xterm-256color
export HOMEBREW_NO_AUTO_UPDATE=1
export PATH="$PATH:${HOME}/.local/bin"
export PATH="$PATH:/usr/local/opt/openjdk/bin"
export CPPFLAGS="-I/usr/local/opt/openjdk/include"
command -v gdircolors > /dev/null 2>&1 && eval $(gdircolors)

## ----------------------------------------
##  Editor
## ----------------------------------------
export EDITOR=nvim
export CVSEDITOR="${EDITOR}"
export GIT_EDITOR="${EDITOR}"
export SVN_EDITOR="${EDITOR}"

## ----------------------------------------
##  Language
## ----------------------------------------
export LANGUAGE="en_US.UTF-8"
export LANG="${LANGUAGE}"
export LC_ALL="${LANGUAGE}"
export LC_CTYPE="${LANGUAGE}"

## ----------------------------------------
##  GPG
## ----------------------------------------
# https://unix.stackexchange.com/questions/608842/zshrc-export-gpg-tty-tty-says-not-a-tty
export GPG_TTY="${TTY}"

## ----------------------------------------
##  Option & Function
## ----------------------------------------
setopt no_beep
setopt globdots
setopt mark_dirs
setopt list_packed
setopt no_flow_control
setopt auto_param_keys
autoload -Uz colors && colors

## ----------------------------------------
##  Completion
## ----------------------------------------
setopt auto_list
setopt auto_menu  # Go to next line, when bpress tab key
setopt share_history
setopt auto_param_slash  # add '/'
setopt magic_equal_subst
export HISTSIZE=1000
export SAVEHIST=10000
export HISTFILE=${HOME}/.zsh_history
export FPATH="${HOME}/.zinit/completions:${FPATH}"
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
autoload -Uz compinit && compinit -i && compinit
autoload -Uz up-line-or-beginning-search && zle -N up-line-or-beginning-search
autoload -Uz down-line-or-beginning-search && zle -N down-line-or-beginning-search
zstyle ':completion:*:default' menu select=2  # select highlight
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' '+m:{[:upper:]}={[:lower:]}'

## ----------------------------------------
##  Keymap
## ----------------------------------------
bindkey '^F' forward-word
bindkey '^B' backward-word
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line
bindkey "^W" backward-kill-word
bindkey "^U" kill-whole-line
bindkey "^L" clear-screen
bindkey "^R" history-incremental-search-backward
bindkey "^[[1;2A" up-line-or-beginning-search
bindkey "^[[1;2B" down-line-or-beginning-search

## ----------------------------------------
##  Load
## ----------------------------------------
# brew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# aliases
ALIASES_PATH="${HOME}/.aliases"
if [ -d $ALIASES_PATH -a -r $ALIASES_PATH -a -x $ALIASES_PATH ]; then
  for i in $ALIASES_PATH/*; do
    [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi

## ----------------------------------------
##  Disable defualt alias
## ----------------------------------------
## because of same as "!!" ( Repeat previous command )
disable r

## ----------------------------------------
##  Alias & Function
##  - ~/.aliases/**.zsh has more aliases.
## ----------------------------------------
alias vi='nvim'
alias cdh='cd ~'
alias op='open ./'
alias cdwk='cd ~/work'
alias weather='curl -Acurl wttr.in/Tokyo'
alias bat='bat --color=always --theme=ansi'
alias virc='vi ~/.zshrc' sorc='source ~/.zshrc'
alias dus='dust -pr -d 2 -X ".git" -X "node_modules"'
alias python='python3' py='python' pip='pip3'
alias ll='exa -alhF --group-directories-first --time-style=long-iso'
alias psa='ps aux' pskl='psa | fzf | awk "{ print \$2 }" | xargs kill -9'
alias fd='fd -iH --no-ignore-vcs -E ".git" -E "node_modules"' rmds='fd .DS_Store -X rm'
alias llx='ll --git-ignore --ignore-glob=".git|node_modules"' tr2='llx -T -L=2' tr3='llx -T -L=3'
mkcd() { mkdir "$1" && cd "$1"; }
absp() { echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1"); }
lnsv() {
  [ -z "$2" ] && echo "Specify Target" && return 0;
  abspath=$(absp $1);
  ln -sfnv "${abspath}" "$2";
}
vv() {
  [ -z "$1" ] && code -r ./ && return 0;
  code -r "$1";
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
hst() {
  cmd=`history 1 | awk '{$1="";print $0;}' | fzf`
  [ -z "${cmd}" ] && echo "fzf Canceled." && return 0;
  echo "${cmd}" && eval "${cmd}"
}

if [[ $OSTYPE != "linux-gnu" ]]; then
  # MacOS
  alias grep='ggrep'
  alias pp='pbpaste >'
  catp() { cat "$1" | pbcopy }
fi

## ========== Global Alias ==========
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g X='| xargs'
alias -g C='| wc -l'
alias -g CP='| pbcopy'

## ========== Neovim ==========
alias vivi='vi ~/.config/nvim/init.vim'
vink() {
  FORMAT=`nkf -g $@`;
  nvim -c ":e ++enc=${FORMAT}" $@;
}
vigo() {
  nvim -c "call append(0, v:oldfiles)" -c "write! ~/.config/nvim/viminfo.log" -c exit;
  nvim `cat ~/.config/nvim/viminfo.log | fzf --preview 'bat --color=always --theme=ansi {}'`;
}

## ========== Aliases && Snippets ==========
[ -f ~/.secret_alias ] && source ~/.secret_alias

## ----------------------------------------
##  FZF
## ----------------------------------------
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--reverse --height 80%'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

## ----------------------------------------
##  iTerm2
## ----------------------------------------

## ----------------------------------------
##  asdf
## ----------------------------------------
if [[ $OSTYPE == "linux-gnu" ]]; then
  . /home/linuxbrew/.linuxbrew/opt/asdf/asdf.sh
fi

## ----------------------------------------
##  Zinit
## ----------------------------------------
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "${HOME}/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

zinit ice wait'0'
zinit lucid for \
  ulwlu/enhancd \
  zsh-users/zsh-completions \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-syntax-highlighting \
  # as'completion' is-snippet 'https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker' \
  # as'completion' is-snippet 'https://github.com/docker/machine/blob/master/contrib/completion/zsh/_docker-machine' \
  # as'completion' is-snippet 'https://github.com/docker/compose/blob/master/contrib/completion/zsh/_docker-compose' \
  # as'completion' is-snippet 'https://github.com/lukechilds/zsh-better-npm-completion/blob/master/zsh-better-npm-completion.plugin.zsh'

## ----------------------------------------
##  Prompt
##  - Must be the end of .zshrc.
##  - `p10k configure` to restart setting.
## ----------------------------------------
zinit ice depth=1; zinit light romkatv/powerlevel10k
[ -f ~/.p10k.zsh ] && source ~/.p10k.zsh
### End of Zinit's installer chunk
