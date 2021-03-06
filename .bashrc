# shellcheck disable=SC1090,SC1091

# If not running interactively, don't do anything
[[ $- != *i* ]] && [[ -z "$BASH_SOURCE_IT" ]] && return
[ "$(uname)" = Darwin ] && export TERM=screen-256color
# ----
# bash history START
#

export HISTSIZE='blub'
export HISTFILESIZE='blub'
export HISTCONTROL='ignorespace:erasedups'  # man bash

# TODO add additional?
# based on https://github.com/justinmk/config/blob/9332827a1cbcc2fc144364459d7f65c736b11938/.bashrc#L28
HISTIGNORE='exit:cd:ls:bg:fg:history:f:fd'

# Non-default history file, to avoid accidental truncation.
# -> copy default file if non-default does not exist <-
# snatched from https://github.com/justinmk/config/blob/9332827a1cbcc2fc144364459d7f65c736b11938/.bashrc#L22
[ -f "$HOME/.bash_history_x" ] || { [ -f "$HOME/.bash_history" ] && cp "$HOME/.bash_history" "$HOME/.bash_history_x" ; }
HISTFILE="$HOME/.bash_history_x"

# ----


# ----
# keybindings | bind settings | binding settings

# undefine previous assignment!
stty werase undef

# set '/' as word delmiter
#bind '\C-w:unix-filename-rubout'

# set '-', '/' etc. as word delmiters
bind '"\C-w":backward-kill-word'

# do not execute multiline pastes immediately
bind 'set enable-bracketed-paste'
#
# ----


# TODO if you want to DEBUG this bashrc
# return
# ..................................................



# stupid workaround for $SHELL set to whatever you did with `chsh -s`
# on Mac OS
export ZSH=''


source ~/Documents/scripts/source-me/bash-nnn.sh


source ~/.password-store/.extensions/pass-tail.bash.completion
export PASSWORD_STORE_ENABLE_EXTENSIONS=true

source ~/Documents/scripts/source-me/common-functions.sh
source ~/Documents/scripts/source-me/posix-compliant-shells.sh

for name in ~/Documents/scripts/source-me/completions_*; do
  source "$name"
done

  source ~/Documents/scripts/private/source-me/posix-compliant-shells.sh

system="$(uname)"
if [ "$system" = Darwin ]; then

  source /usr/local/share/bash-completion/bash_completion


  source ~/Documents/scripts/source-me/darwin/posix-compliant-shells.sh

  if [[ -x /usr/local/bin/kubectl ]]; then
    filename="/tmp/_kubectl-completions"
    _patched_kubectl_completions="$filename-patched"

    if [ ! -e "$_patched_kubectl_completions" ]; then
      kubectl completion bash > "$filename"
      ~/Documents/python/tools/kubectl-client/completion_script_patcher.py "$filename" > "$_patched_kubectl_completions"
    fi

    source "$_patched_kubectl_completions"
    unset filename _patched_kubectl_completions
  fi

  if [[ -x /usr/local/bin/oc ]]; then
    filename="/tmp/_oc-completions"
    _patched_oc_completions="$filename-patched"

    if [ ! -e "$_patched_oc_completions" ]; then
      oc completion bash > "$filename"
      ~/Documents/python/tools/oc-client/completion_script_patcher.py "$filename" > "$_patched_oc_completions"
    fi

    source "$_patched_oc_completions"
    unset filename _patched_oc_completions
  fi

  # [[ -x /usr/local/bin/openstack ]] && source <(openstack complete --shell bash)


  for name in ~/Documents/scripts/source-me/darwin/completions_*; do
    source "$name"
  done
  for name in ~/Documents/scripts/kubernetes/source-me/completions_*; do
    source "$name"
  done


  # mostly kubernetes - cc only
  source ~/Documents/scripts/cc/source-me/posix-compliant-shells.sh
  source ~/Documents/scripts/cc/source-me/completions_* || true

  # bb only
  source ~/Documents/scripts/bb/source-me/posix-compliant-shells.sh
  source ~/Documents/scripts/bb/source-me/completions_* || true


  # helper functions such as 'get_pod' for kubernetes
  source ~/Documents/scripts/kubernetes/source-me/common-functions.sh

elif [ "$system" = Linux ]; then
  # Arch Linux

  for name in ~/Documents/scripts/source-me/linux/*; do
    source "$name"
  done

  source ~/Documents/scripts/private/source-me/linux/posix-compliant-shells.sh
fi


#------------

# --------------------------
shopt -s autocd   # assume one wants to cd given a directory
shopt -s cdspell  # autocorrect spelling errors for cd
shopt -s nocaseglob  # case-insensitive-globbing in pathname expansion
# --------------------------

#
# fzf reverse search
#
__fzf_history ()
{
    builtin history -a;
    builtin history -c;
    builtin history -r;
    builtin typeset \
        READLINE_LINE_NEW="$(
            HISTTIMEFORMAT= builtin history |
            command fzf +s --tac +m -n2..,.. --tiebreak=index --toggle-sort=ctrl-r |
            command sed '
                /^ *[0-9]/ {
                    s/ *\([0-9]*\) .*/!\1/;
                    b end;
                };
                d;
                : end
            '
        )";

        if
                [[ -n $READLINE_LINE_NEW ]]
        then
                builtin bind '"\er": redraw-current-line'
                builtin bind '"\e^": magic-space'
                READLINE_LINE=${READLINE_LINE:+${READLINE_LINE:0:READLINE_POINT}}${READLINE_LINE_NEW}${READLINE_LINE:+${READLINE_LINE:READLINE_POINT}}
                READLINE_POINT=$(( READLINE_POINT + ${#READLINE_LINE_NEW} ))
        else
                builtin bind '"\er":'
                builtin bind '"\e^":'
        fi
}

#
# enable fzf reverse search
#
builtin set -o histexpand;
builtin bind -x '"\C-x1": __fzf_history';
builtin bind '"\C-r": "\C-x1\e^\er"'

# --------------------------

