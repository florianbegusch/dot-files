set is_ubuntu (uname -a | grep Ubuntu)
if [ "$is_ubuntu" != "" ]
  set -x LANG en_GB.UTF-8
  set -x LANGUAGE en_GB:en
end

set -x EDITOR nvim
set -x VISUAL nvim

set -x user_dir (eval echo ~$USER)
set -x PYTHONSTARTUP "$user_dir/.python_startup"

set -x FZF_DEFAULT_COMMAND 'find ~'
set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border'

if [ -x direnv ]
  eval (direnv hook fish)
end


# colorize man pages using 'bat'
set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"

set -x GIT_PAGER 'less'


#
# set colors
# refer to https://fishshell.com/docs/current/index.html#variables-color
#
#The following variables are available to change the highlighting colors in fish:
    #fish_color_normal, the default color
    #fish_color_command, the color for commands
    #fish_color_quote, the color for quoted blocks of text
    #fish_color_redirection, the color for IO redirections
    #fish_color_end, the color for process separators like ';' and '&'
    #fish_color_error, the color used to highlight potential errors
    #fish_color_param, the color for regular command parameters
    #fish_color_comment, the color used for code comments
    #fish_color_match, the color used to highlight matching parenthesis
    #fish_color_selection, the color used when selecting text (in vi visual mode)
    #fish_color_search_match, used to highlight history search matches and the selected pager item (must be a background)
    #fish_color_operator, the color for parameter expansion operators like '*' and '~'
    #fish_color_escape, the color used to highlight character escapes like '\n' and '\x70'
    #fish_color_cwd, the color used for the current working directory in the default prompt
    #fish_color_autosuggestion, the color used for autosuggestions
    #fish_color_user, the color used to print the current username in some of fish default prompts
    #fish_color_host, the color used to print the current host system in some of fish default prompts
    #fish_color_cancel, the color for the '^C' indicator on a canceled command

#Additionally, the following variables are available to change the highlighting in the completion pager:

    #fish_pager_color_prefix, the color of the prefix string, i.e. the string that is to be completed
    #fish_pager_color_completion, the color of the completion itself
    #fish_pager_color_description, the color of the completion description
    #fish_pager_color_progress, the color of the progress bar at the bottom left corner
    #fish_pager_color_secondary, the background color of the every second completion
#
#set custom_green 13d400
#set custom_yellow fcbd0f
#set -x fish_color_command c399f8
#set -x fish_color_param "$custom_green"
#set -x fish_color_end normal
#set -x fish_color_escape "$custom_green"
#set -x fish_pager_color_description "$custom_yellow"
#set -x fish_color_quote "$custom_yellow"
#set -x fish_color_autosuggestion 848484
set -x fish_color_operator fa5bd0

# due to https://phoenhex.re/2018-03-25/not-a-vagrant-bug
set -x VAGRANT_DISABLE_VBOXSYMLINKCREATE 1

xrdb -merge ~/.Xdefaults

# source self-written completions
source ~/.config/fish/completions


if status is-interactive
and not set -q TMUX
  #exec tmux
  #
  if ! tmux list-sessions 2>/dev/null
    tmux -2 -u new 'sleep 4; tmux detach'
  else
    tmux -2 -u new  # -u -> utf-8; -2 -> force 256 colors
  end
end
#
#
# on ubuntu - old fish versions
#test $TERM != "screen"; and tmux

