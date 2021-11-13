#!/bin/bash
# NOTE: 実行
# cdコマンドを効かせるためには sourceを使う必要がある
# ref. https://qiita.com/mattak/items/bd159863be10b0ae81d8

# 引数関係なく共通の処理
# source sh/workpane.sh
tmux split-window -v
tmux split-window -v
tmux split-window -v
tmux select-layout even-vertical

if [ "$#" -eq 0 ]; then
  # 引数なしの時
  # source sh/workpane.sh
else
  case $1 in
    "viztech")
    # 引数が viztechの時
    # source sh/workpane.sh viztech
      tmux send-keys -t 0 "cd ~/myself/viztech" C-m  # C-m は enter
      tmux send-keys -t 0 "yarn dev" C-m  # C-m は enter

      tmux send-keys -t 1 "cd ~/myself/viztech" C-m  # C-m は enter
      tmux send-keys -t 1 "code ." C-m  # C-m は enter
      tmux send-keys -t 1 "clear" C-m  # C-m は enter

      tmux send-keys -t 2 "cd ~/myself/viztech_backend" C-m  # C-m は enter
      tmux send-keys -t 2 "yarn start:dev" C-m # C-m は enter

      tmux send-keys -t 3 "cd ~/myself/webgl_school_lesson_sample" C-m  # C-m は enter
      tmux send-keys -t 3 "clear" C-m  # C-m は enter
      tmux send-keys -t 3 "code ." C-m  # C-m は enter
      ;;
    "ana")
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