#!/usr/bin/env bash

#
# Credits to github.com/webpro/dotfiles and github.com/orrsella/dotfiles
#

# Get current dir (so run this script from anywhere)

export DOTFILES_DIR EXTRA_DIR
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
EXTRA_DIR="$HOME/.extra"

OS="$(uname -s)"

# Don't automate updates; can use git easily enough
#[ -d "$DOTFILES_DIR/.git" ] && git --work-tree="$DOTFILES_DIR" --git-dir="$DOTFILES_DIR/.git" pull origin master

# Bunch of symlinks
ln -sfv "$DOTFILES_DIR/vim/.vimrc" ~
ln -sfv "$DOTFILES_DIR/runcom/.bash_profile" ~
ln -sfv "$DOTFILES_DIR/runcom/.inputrc" ~

if [ "$OS" = "Linux" ]; then
    printf "\nInstalling Linux dependencies...\n"
    $DOTFILES_DIR/bin/rhinstall.sh
fi

printf "\nInstall VIM plugins...\n"
$DOTFILES_DIR/bin/viminstall.sh

## Package managers & packages
#
#. "$DOTFILES_DIR/install/brew.sh"
#. "$DOTFILES_DIR/install/bash.sh"
#. "$DOTFILES_DIR/install/npm.sh"
#. "$DOTFILES_DIR/install/pip.sh"

#if [ "$(uname)" == "Darwin" ]; then
#  . "$DOTFILES_DIR/install/brew-cask.sh"
#  . "$DOTFILES_DIR/install/gem.sh"
#  ln -sfv "$DOTFILES_DIR/etc/mackup/.mackup.cfg" ~
#fi

## Install extra stuff
#
#if [ -d "$EXTRA_DIR" -a -f "$EXTRA_DIR/install.sh" ]; then
#  . "$EXTRA_DIR/install.sh"

