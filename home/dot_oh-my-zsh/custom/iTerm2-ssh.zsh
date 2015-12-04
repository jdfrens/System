# inspired by
# https://coderwall.com/p/t7a-tq/change-terminal-color-when-ssh-from-os-x
# https://github.com/erangaeb/dev-notes/blob/master/oh-my-zsh/iTrem2-ssh.zsh
#

# If your default profile in iTerm 2 is not called "Default", change
# "Default" in these functions.

# Sets the profile in the current iTerm.
# The "Default" profile is used by default.
function tabc() {
    NAME=$1
    if [ -z "$NAME" ]; then NAME="Default"; fi
    echo -e "\033]50;SetProfile=$NAME\a"
}

# Tweak the regexes for your own servers.  Change the argument to
# `tabc` based on your iTerm 2 profiles.
function colorssh() {
    if [[ -n "$ITERM_SESSION_ID" ]]; then
        # reset to default color preset when done
        trap "tabc" INT EXIT
        if [[ "$*" =~ "^web[[:digit:]]{2}\." ]]; then
            tabc Production
        elif [[ "$*" =~ "staging[[:digit:]]{2}" ]]; then
            tabc Staging
        elif [[ "$*" =~ "\.dev\." ]]; then
            tabc Staging
        else
            tabc Default
        fi
    fi
    ssh $*
}

# make sure autocomplete still works for `ssh`
compdef _ssh colorssh=ssh

alias ssh="colorssh"
