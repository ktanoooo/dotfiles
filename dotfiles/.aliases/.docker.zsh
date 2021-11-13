alias d='docker'
compdef _docker d
alias dcc='docker-compose'
compdef _docker-compose dcc
alias k='kubectl'
compdef _kubectl k

## ----------------------------------------
##  Base
## ----------------------------------------
alias drma='docker system prune --volumes'
alias drmf='docker system prune --force --all --volumes'

## ----------------------------------------
##  Container
## ----------------------------------------
alias dc='docker container'
alias dcls='docker container ls --all'
alias dcrm='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf -m | cut -f1 | xargs docker container rm --volumes'
alias dclog='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf -m | cut -f1 | xargs docker container log'
alias dcstop='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf -m | cut -f1 | xargs docker container stop'
alias dcstart='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf | cut -f1 | xargs docker container start -ai'
alias dcinspect='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf | cut -f1 | xargs docker container inspect'
alias dcip='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf | cut -f1 | xargs docker container inspect --format "{{ .NetworkSettings.IPAddress }}"'
alias dcexec='docker container ls --all --format "{{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}" | fzf | cut -f1 | xargs -I{} docker container exec -it {} sh'
alias dcrma='docker container rm --force --volumes $(docker ps -all --quiet --filter status=exited)'
alias dcrmf='docker container rm --force --volumes $(docker ps -all -quiet)'

## ----------------------------------------
##  Image
## ----------------------------------------
alias di='docker image'
alias dils='docker image ls --all'
alias dirm='docker image ls --all --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}" | fzf -m | cut -f1 | xargs docker image rm --force'
alias diinspect='docker image ls --all --format "{{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.CreatedAt}}" | fzf | cut -f1 | xargs docker image inspect'
alias dirma='docker image prune'
alias dirmf='docker image prune --all --force'

## ----------------------------------------
##  Network
## ----------------------------------------
alias dn='docker network'
alias dnls='docker network ls --all --latest'
alias dnconnect='docker network connect'
alias dndisconn='docker network disconnect'
alias dninspect='docker network ls --format "{{.ID}}\t{{.Name}}\t{{.Driver}}" | fzf | cut -f1 | xargs docker network inspect'

## ----------------------------------------
##  Process
## ----------------------------------------
alias dp='docker ps --latest'

## ----------------------------------------
##  Docker Compose
## ----------------------------------------
alias dccup='docker-compose up -d'
alias dccdown='docker-compose down -v'
alias dccb='docker-compose ps --services | fzf -m | cut -f1 | xargs docker-compose build'

## ----------------------------------------
##  Swarm
## ----------------------------------------
# alias dlsn='docker node ls'
# alias dlss='docker service ls'
# alias drms='docker service rm'
# alias dscales='docker service scale'
# alias dupdates='docker service update'
# alias dcreates='docker service create'
# alias dupdatei='docker service update --image'
# alias dupdatee='docker service update --env-add'
# alias dupdatesc='docker service update --secret-rm'
# alias dupdatep='docker service update --publish-add'
# alias drmsa='docker service rm $(docker service ls -q)'
# alias dipm='docker-machine ip'
# alias dssh='docker-machine ssh'
# alias denv='docker-machine env'
# alias dscp='docker-machine scp'
# alias dleave='docker swarm leave --force'
# alias dinit='docker swarm init --advertise-addr'
# alias dcreatesw='docker network create --driver overlay'
# alias dpss='docker stack ps'
# alias ddeploy='docker stack deploy -c'
# alias dservices='docker stack services'
# alias dlssc='docker secret ls'
# alias dcreatesc='docker secret create'
# alias dinspectsc='docker secret inspect'

## ----------------------------------------
##  Kubernetes
## ----------------------------------------
alias kcls='kubectl config get-contexts'
kcset() {
  context=$(kubectl config get-contexts --output=name | fzf);
  kubectl config use-context "$context"
}
alias kgn='kubectl get namespace'
knset() {
  namespace=$(kubectl get namespace --output=name --context=$(kubectl config current-context) | fzf);
  kubectl config set-context --current --namespace="$namespace"
}
alias kpls='kubectl get pods -o wide'
alias kprestart='kubectl get pods -o wide | fzf | awk "{ print \$1 }" | xargs kubectl rollout restart'
alias kpdelete='kubectl get pods -o wide | fzf | awk "{ print \$1 }" | xargs kubectl delete pod'
alias kpexp='kubectl get pods -o wide | fzf | awk "{ print \$1 }" | xargs kubectl explain'
alias kplog='kubectl get pods -o wide | fzf | awk "{ print \$1 }" | xargs kubectl logs'
alias kpyml='kubectl get pods -o wide | fzf | awk "{ print \$1 }" | xargs kubectl get pod -o yaml'
alias ksls='kubectl get service -o wide'
alias ksyml='kubectl get service -o wide | fzf | awk "{ print \$1 }" | xargs kubectl get service -o yaml'
alias ksdes='kubectl get service -o wide | fzf | awk "{ print \$1 }" | xargs kubectl describe service'
alias kdls='kubectl get deployment -o wide'
alias kdyml='kubectl get deployment -o wide | fzf | awk "{ print \$1 }" | xargs kubectl get deployment -o yaml'
alias kjls='kubectl get jobs -o wide'
alias kjlog='kubectl get jobs -o wide | fzf | awk "{ print \$1 }" | xargs kubectl logs'
alias kjrm='kubectl get jobs -o wide | fzf | awk "{ print \$1 }" | xargs kubectl delete job'
alias kjyml='kubectl get jobs -o wide | fzf | awk "{ print \$1 }" | xargs kubectl get job -o yaml'
alias kjdes='kubectl get jobs -o wide | fzf | awk "{ print \$1 }" | xargs kubectl describe job'
alias kapi='kubectl api-resources'
alias krun='kubectl run'
alias kexpose='kubectl expose'
alias kcreate='kubectl create'
alias kapply='kubectl apply -f'

