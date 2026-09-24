alias hd='herdr'
alias hdd="herdr session list | fzf --header-lines=1 | awk '{print \$1}' | xargs -I {} herdr session stop {}"
