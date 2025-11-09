# ----------------------------------------
# Google Cloud
# ----------------------------------------
alias gclogin='gcloud auth login'
alias gclal='gcloud auth list'
alias gclconf='gcloud config list'
alias gclsetp='gcloud config set project $1'

# ----------------------------------------
# Terraform
# ----------------------------------------
alias tf='terraform'

alias tfinit='terraform init'
alias tfpln='terraform plan'
alias tfapy='terraform apply'
alias tfdl='terraform destroy'

# format
alias tffmt='terraform fmt -recursive' #  Also process files in subdirectories. By default, only the given directory (or current directory) is processed.
alias tffmtc='terraform fmt -check -recursive' # Check if the input is formatted. Exit status will be 0 if all input is properly formatted and non-zero otherwise.

alias tfvalid='terraform validate;'

alias tfshow='terraform show'
alias tfout='terraform output'

alias tfsl='terraform state list'
alias tfsrm='terraform state rm $1'
alias tfimp='terraform import $1'
