#Aliases
alias pc="sudo port clean --all installed"
alias pi="sudo port install $@"
alias psu="sudo port selfupdate"
alias pun="sudo port uninstall $@"
alias puni="sudo port uninstall inactive"
alias puo="sudo port upgrade outdated"
alias pup="psu && puo"

