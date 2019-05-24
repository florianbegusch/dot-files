# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

alias hex_little_endian='nvim -c ":%!xxd -e" $@'

export RED='\033[1;31m'
export YELLOW='\033[1;33m'
export GREEN='\033[1;32m'
export NC='\033[0m'

# minikube config
export KUBECONFIG=$HOME/.kube/minikube

# kubernetes autocompletion
source <(kubectl completion bash)

# kubernetes aliases
alias kb=kubectl
alias kbg="kubectl get"
alias kc=kubectl
alias kcg="kubectl get"
alias kn="kubens"

# make bash history saving immediate and shared between sessions
# taken from https://askubuntu.com/a/115625
# 
# history -c clears the history of the running session. This will reduce the history counter by the amount of $HISTSIZE. 
# history -r read the contents of $HISTFILE and insert them in to the current running session history.
# This will raise the history counter by the amount of lines in $HISTFILE
shopt -s histappend                      # append to history, don't overwrite it
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

