cnew() {
  cargo new --bin $1
}
cnewl() {
  cargo new --lib $1
}
alias cch='cargo check'
alias crn='cargo run'
alias crnl='cargo run --release'
alias cbl='cargo build'
