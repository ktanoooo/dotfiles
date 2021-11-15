alias g='git'
alias gac='git add -A :/ && git commit'
alias gaca='git add -A :/ && git commit --amend'
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
alias gwip='git add -A :/ && git commit -m "[WIP]"'
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
alias gconf='git config --local --list'

gu() {
  guserinfo(){
    echo "local name: `git config --local user.name || echo 'none'`"
    echo "local email: `git config --local user.email || echo 'none'`"
    echo "global name: `git config --global user.name || echo 'none'`"
    echo "global email: `git config --global user.email || echo 'none'`"
  }
  guserinfo
  read answer"?type set info [local/global/n]: ";
  if [ $answer = "local" ] || [ $answer = "global" ]; then
    read name"?type --${answer} user.name: ";
    read email"?type --${answer} user.email: ";
    git config --${answer} user.name ${name}
    git config --${answer} user.email ${email}
    echo "updated :"
    guserinfo
  else
    echo "no change"
  fi
}

alias cdgh='cd `ghq list -p | fzf`'
alias ghweb='gh repo view --web'
gcre() {
  [ -z "$(ls -A ./)" ] && echo "Fail: Directory is empty." && return 0;
  git init;
  git secrets --install && git secrets --register-aws;
  git add -A && git commit;
  read        name"?type repo name        : ";
  read description"?type repo description : ";
  gh repo create ${name} --description ${description} --private;
  git push --set-upstream origin main;
  ghweb;
}
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