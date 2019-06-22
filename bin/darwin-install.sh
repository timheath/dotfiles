#!/bin/bash

#
# Darwin customization and base package install
#

# debug mode
#set -x

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
READLINK=$(command -v greadlink || command -v readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
    SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
    DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
    printf "we are defaulting"
    DOTFILES_DIR="$HOME/dotfiles"
else
    echo "Unable to find dotfiles, exiting."
    return # `exit 1` would quit the shell itself
fi

source $DOTFILES_DIR/system/functions.sh

# Setup links to Docker for bash completions
if [ -d /Applications/Docker.app/Contents/Resources/etc ]; then
    ln -s /Applications/Docker.app/Contents/Resources/etc/docker.bash-completion $DOTFILES_DIR/completions/docker.bash
    ln -s /Applications/Docker.app/Contents/Resources/etc/docker-machine.bash-completion $DOTFILES_DIR/completions/docker-machine.bash
    ln -s /Applications/Docker.app/Contents/Resources/etc/docker-compose.bash-completion $DOTFILES_DIR/completions/docker-compose.bash
fi

echo "Please check bin/darwin-install.sh for homebrew installs that need to be run"
# brew install tmux
