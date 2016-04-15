#!/bin/bash

#
# Redhat/CentOS installer for binary dependencies 
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

# Make bash default shell
_SH=`grep $USER /etc/passwd|awk 'BEGIN { FS = ":"}; {print $NF}'`
if [ $_SH != "/bin/bash" ]; then
    printf "Changing shell to bash...\n"
    chsh -s /bin/bash
fi

# Install git if not available
if ! $(is-executable git); then
    printf "Installing git...\n"
    sesu -c "yum install git"
fi

# Make sure we have curl
if ! $(is-executable curl); then
    printf "Installing curl...\n"
    sesu -c "yum install curl"
fi
