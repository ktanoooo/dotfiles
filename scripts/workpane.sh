#!/bin/bash
# NOTE: 実行
# cdコマンドを効かせるためには sourceを使う必要がある
# ref. https://qiita.com/mattak/items/bd159863be10b0ae81d8

# How to use
# source sh/workpane.sh

if [ "$#" -eq 0 ]; then
  # 引数なしの時
  # source sh/workpane.sh
else
  case $1 in
    "ana")
      tmux split-window -v
      tmux split-window -v
      tmux split-window -v
      tmux select-layout even-vertical

      tmux send-keys -t 0 "cda" C-m  # C-m は enter
      tmux send-keys -t 0 "bs" C-m  # C-m は enter

      tmux send-keys -t 1 "cda" C-m  # C-m は enter
      tmux send-keys -t 1 "bes" C-m  # C-m は enter

      tmux send-keys -t 2 "cda" C-m  # C-m は enter
      tmux send-keys -t 2 "bw" C-m # C-m は enter

      tmux send-keys -t 3 "cda" C-m  # C-m は enter
      tmux send-keys -t 3 "clear" C-m  # C-m は enter
      tmux send-keys -t 3 "code ." C-m  # C-m は enter
      clear
      ;;
    *)
      echo [ERROR] "$1" は設定されていない引数です。
      ;;
  esac
fi

# https://dev.classmethod.jp/articles/tmux_create_devenv_display/
# https://qiita.com/blp1526/items/390020ca9e1e56be3028
# https://www.lisz-works.com/entry/tmux-pane-setup