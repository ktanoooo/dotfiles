alias vivi='vi ~/.config/nvim/init.vim'
vink() {
  FORMAT=`nkf -g $@`;
  nvim -c ":e ++enc=${FORMAT}" $@;
}
vigo() {
  nvim -c "call append(0, v:oldfiles)" -c "write! ~/.config/nvim/viminfo.log" -c exit;
  nvim `cat ~/.config/nvim/viminfo.log | fzf --preview 'bat --color=always --theme=ansi {}'`;
}
vimplug_setup() {
  sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
}
