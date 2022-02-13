alias g='git'
alias gci='git commit'
alias gca='git commit --amend'
alias gac='git add -A :/ && git commit'
alias gaca='git add -A :/ && git commit --amend'
alias gwip='git add -A :/ && git commit -m "[WIP]"'
alias gb='git branch'
alias gco='git checkout'
alias gcof='git branch | fzf | xargs git checkout'
alias gdf='git diff'
alias gdfc='git diff --cached'
alias gfop='git fetch origin --prune'
alias gfup='git fetch upstream --prune'
alias glggo='git log --graph --oneline'
alias gp='git push'
alias gpo='git push origin'
gpom() {
  if git branch | grep '[ \*] master$' > /dev/null; then
    git push origin master $@
  else
    git push origin main $@
  fi
}
alias gpl='git pull'
alias grm='git remote -v'
alias grma='git remote add'
alias grmaup='git remote add upstream'
alias grms='git remote set-url origin'
alias grso='git reset --soft'
alias grsoh='git reset --soft HEAD^'
alias grmi='git reset --mixed'
alias grmih='git reset --mixed HEAD^'
alias grha='git reset --hard'
alias grhah='git reset --hard HEAD^'
alias grbom='git rebase origin/main'
alias gconf='git config --local --list'
alias gsta='git stash'
alias gstaa='git stash apply'
alias gstad='git stash list | cut -d':' -f1 | xargs -I {} git stash drop {}'

# gh 
alias ghweb='gh repo view --web'

# ghq
alias cdgh='cd `ghq list -p | fzf`'

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

gclo() {
  [ $# = 1 ] && ghq get -p $1
}

gcre() {
  read        name"?type repo name        : ";
  read description"?type repo description : ";
  repoPath="`ghq root`/github.com/ktanoooo/${name}"
  [ -d $repoPath  ] && echo "This name Repo is already exists." && return 0;
  ghq create ${name};
  cd $repoPath
  git secrets --install && git secrets --register-aws;
  printf "# ${name}\n\n${description}" >> README.md
  git add -A && git commit -m "first commit";
  gh repo create ${name} --description ${description} --private;
  git push --set-upstream origin main;
  ghweb;
}
