## ----------------------------------------
##  Generate new key
##    Please select what kind of key you want: => (1) RSA and RSA
##    What keysize do you want? (3072) => 4096
##    Key is valid for? (0) => 0
##    Is this correct? (y/N) => y
##    Real name: ktanoooo
##    Email address: ktanoooo1112@gmail.com
##    Comment: (Enter)
##    Change (N)ame, (C)omment, (E)mail or (O)kay/(Q)uit? => O
## ----------------------------------------
alias gpggen='gpg --full-gen-key'

## ----------------------------------------
##  Export public key
## ----------------------------------------
alias gpgpub="gpg -k G uid | awk '{print \$3\" \"\$4}' | fzf | awk '{print \$1}' | xargs gpg -k --keyid-format=long {} G sub | cut -d '/' -f2 | cut -d ' ' -f1"
alias gpgexp='gpgpub | xargs gpg --armor --export'

## ----------------------------------------
## Delete
## ----------------------------------------
gpgdl() {
  # Delete secret key
  gpgpub | xargs -I{} sh -c 'gpg --delete-secret-keys {} && gpg --delete-key {}'
}

## ----------------------------------------
## Delete
## ----------------------------------------
alias gpgchpass='gpg --change-passphrase ktanoooo'
