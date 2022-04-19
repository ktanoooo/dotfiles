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
##  Show github ktanoooo info
## ----------------------------------------
alias gpgkey='gpg --list-secret-key --keyid-format LONG ktanoooo'
alias gpgsec='gpgkey | sed -n -e1p -e4p | cut -d " " -f4 | cut -d "/" -f2 | sed -n 1p'
alias gpgpub='gpgkey | sed -n -e1p -e4p | cut -d " " -f4 | cut -d "/" -f2 | sed -n 2p'

## ----------------------------------------
##  Export public key
## ----------------------------------------
alias gpgexp='gpgkey | sed -n -e1p -e4p | cut -d " " -f4 | cut -d "/" -f2 | sed -n 2p | xargs gpg --armor --export'

## ----------------------------------------
## Delete
## ----------------------------------------
gpgdl() {
  # Delete secret key
  gpgkey | sed -n -e1p -e4p | cut -d " " -f4 | cut -d "/" -f2 | sed -n 2p | xargs gpg --delete-secret-keys
  # Delete public key
  gpg --delete-key ktanoooo1112@gmail.com
}

## ----------------------------------------
## Delete
## ----------------------------------------
alias gpgchpass='gpg --change-passphrase ktanoooo'
