# Query/use custom command for `git`.
zstyle -s ":vcs_info:git:*:-all-" "command" _omz_git_git_cmd
: ${_omz_git_git_cmd:=git}

#
# Functions
#

# The name of the current branch
# Back-compatibility wrapper for when this function was defined here in
# the plugin, before being pulled in to core lib/git.zsh as git_current_branch()
# to fix the core -> git plugin dependency.
function current_branch() {
  git_current_branch
}
# The list of remotes
function current_repository() {
  if ! $_omz_git_git_cmd rev-parse --is-inside-work-tree &> /dev/null; then
    return
  fi
  echo $($_omz_git_git_cmd remote -v | cut -d':' -f 2)
}
# Pretty log messages
function _git_log_prettily(){
  if ! [ -z $1 ]; then
    git log --pretty=$1
  fi
}
# Warn if the current branch is a WIP
function work_in_progress() {
  if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
    echo "WIP!!"
  fi
}

#
# Aliases
# (sorted alphabetically)
#

alias g='git'

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'

alias gam='git am'
alias gap='git apply -v'

alias gb='git branch -vv'
compdef _git gb=git-branch
alias gba='git branch -vva'
alias gbl='git blame -b -w'
alias gbnm='git branch --no-merged'
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcb='git checkout -b'
alias gcf='git config'
alias gcn='git clone --recursive'
alias gcns='git clone --recursive --depth 1 --shallow-submodules'
alias gclean='git clean -id'
alias gpristine='git reset --hard && git clean -dfx'
alias gcm='git checkout master'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcount='git shortlog -sn'
compdef gcount=git
alias gcp='git cherry-pick'
alias gcs='git commit -S'

alias gd='git diff --patch-with-stat'
alias gdca='git diff --patch-with-stat --cached'
alias gdct='git describe --tags --dirty --always'
# alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdt='git difftool'
gdv() { git diff -w "$@" | view - }
compdef _git gdv=git-diff
alias gdw='git diff --word-diff'
alias gic='git-icdiff'

alias gf='git fetch'
alias gfa='git fetch --all --prune'
function gfg() { git ls-files | grep $@ }
compdef _grep gfg
alias gfo='git fetch origin'

alias gfp='git format-patch'

compdef _git ggf=git-checkout
ggl() {
if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
git pull origin "${*}"
else
[[ "$#" == 0 ]] && local b="$(git_current_branch)"
git pull origin "${b:=$1}"
fi
}
compdef _git ggl=git-checkout
alias ggpull='git pull origin $(git_current_branch)'
compdef _git ggpull=git-checkout
ggp() {
if [[ "$#" != 0 ]] && [[ "$#" != 1 ]]; then
git push origin "${*}"
else
[[ "$#" == 0 ]] && local b="$(git_current_branch)"
git push origin "${b:=$1}"
fi
}
compdef _git ggp=git-checkout
alias ggpush='git push origin $(git_current_branch)'
compdef _git ggpush=git-checkout
ggpnp() {
if [[ "$#" == 0 ]]; then
ggl && ggp
else
ggl "${*}" && ggp "${*}"
fi
}
compdef _git ggpnp=git-checkout
alias gbsu='git branch --set-upstream-to'
ggu() {
[[ "$#" != 1 ]] && local b="$(git_current_branch)"
git pull --rebase origin "${b:=$1}"
}
compdef _git ggu=git-checkout
alias ggpur='ggu'
compdef _git ggpur=git-checkout

alias gignore='git update-index --assume-unchanged'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-svn-dcommit-push='git svn dcommit && git push github master:svntrunk'
compdef git-svn-dcommit-push=git

alias gi='git init'

alias gk='\gitk --all --branches'
compdef _git gk='gitk'
alias gke='\gitk --all $(git log -g --pretty=format:%h)'
compdef _git gke='gitk'

alias gfl='git log -C --stat --decorate'
alias gfla='git log -C --stat --decorate --all --graph'
alias gcl='git log -C --pretty=format:"%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gcla='git log -C --all --graph --pretty=format:"%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'

alias gm='git merge'
alias gmnff='git merge --no-ff'
alias gmnc='git merge --no-ff --no-commit'
alias gmsq='git merge --squash'

alias gmv='git mv'

alias gpl='git pull --stat'
alias gpd='git push --dry-run'
alias gpoat='git push origin --all && git push origin --tags'
compdef _git gpoat=git-push
alias gps='git push'
alias gpsr='git push origin HEAD:refs/for/$(git rev-parse --abbrev-ref HEAD)'
gpsrb() { git push origin HEAD:refs/for/$1 }

alias gr='git remote -v'
alias gra='git remote add'
alias grb='git rebase'
alias grbi='git rebase -i'
alias gre='git reset'
alias greha='git reset --hard'
alias grem='git reset --merge'
alias gremp='git reset --merge @~'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grt='cd $(git rev-parse --show-toplevel || echo ".")'
alias grup='git remote update'

alias grm='git rm'

alias gs='git status -sb'
alias gso='git status -sb -uno'
alias gst='git status'
alias gsto='git status -uno'

alias gsp='git show -C --decorate -p --stat'

alias gsta='git stash push'
alias gstaa='git stash apply'
alias gstad='git stash drop'
alias gstal='git stash list --format="%n%C(yellow)%gd %Cgreen(%cr) %Creset%C(bold)%gs" --stat'
alias gstap='git stash pop'
alias gstas='git stash show --text'

alias gsb='git submodule'
alias gsu='git submodule update --init --recursive'

alias gta='git tag'
alias gtl='git log --all --graph --simplify-by-decoration --pretty=format:"%C(auto)%h -%d %s %Cgreen(%cr) %C(bold blue)<%an>%Creset"'
alias gts='git tag -s'

alias gunignore='git update-index --no-assume-unchanged'
alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias glum='git pull upstream master'

alias gvt='git verify-tag'

alias gmbfp='git merge-base --fork-point'
