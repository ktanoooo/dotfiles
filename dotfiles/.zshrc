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
export HISTSIZE=20000
export SAVEHIST=20000
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
# GPG
# https://unix.stackexchange.com/questions/608842/zshrc-export-gpg-tty-tty-says-not-a-tty
export GPG_TTY="${TTY}"

# brew
if [ $OSTYPE = "linux-gnu" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
else
  eval "$(/usr/local/bin/brew shellenv)"
fi

# fzf
export FZF_DEFAULT_COMMAND="rg --files"
export FZF_DEFAULT_OPTS='--reverse --height 80%'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# asdf
. "`brew --prefix`/opt/asdf/asdf.sh"

# terraform
autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /usr/local/bin/terraform terraform

## ----------------------------------------
##  Aliases
## ----------------------------------------
ALIASES_PATH="${HOME}/.aliases"
if [ -d $ALIASES_PATH -a -r $ALIASES_PATH -a -x $ALIASES_PATH ]; then
  for i in $ALIASES_PATH/*; do
    [[ ${i##*/} = *.zsh ]] && [ \( -f $i -o -h $i \) -a -r $i ] && . $i
  done
fi
[ -f ~/.aliases-local ] && source ~/.aliases-local

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
