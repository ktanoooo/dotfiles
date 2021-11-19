alias tm='tmux'
alias tmn='tmux attach -t 1 || tmux new -s 1'
alias tmkl='tmux list-sessions | fzf -m | cut -d: -f 1 | xargs -I{} tmux kill-session -t {}'
tmrn() {
  selected=`tmux list-sessions | fzf | cut -d : -f 1`
  read newname"?type new session name: ";
  tmux rename-session -t "${selected}" "${newname}"
}
tma() {
  selected=`tmux list-sessions | fzf | cut -d : -f 1`
  if [ -z "${TMUX}" ]; then
    tmux attach -t "${selected}"
  else
    tmux switch -t "${selected}"
  fi
}
tmuxkl() {
  tmux ls | fzf-tmux | cut -d':' -f1 | xargs tmux kill-session -t
}
