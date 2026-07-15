#!/usr/bin/env bash

# Get current dir (so run this script from anywhere)

# TODO
# Add precheck for primary deps like python3, brew, nvim, nvim python3 module, vim, coreutils?

export DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"

# Bunch of symlinks
# ln -sfv "$DOTFILES_DIR/vim/vimrc" ~/.vimrc  # No longer using vim, keeping for posterity
ln -sfv "$DOTFILES_DIR/runcom/bash_profile" ~/.bash_profile
ln -sfv "$DOTFILES_DIR/runcom/inputrc" ~/.inputrc
ln -sfv "$DOTFILES_DIR/ssh/config" ~/.ssh/config

# Lazyvim has this in ~/.config/nvim
# ln -sfv "$DOTFILES_DIR/config/nvim" ~/conifg/nvim

if [ "$OS" == "Linux" ]; then
  printf "\nInstalling Linux dependencies...\n"
  $DOTFILES_DIR/bin/rhinstall.sh
elif [ "$OS" == "Darwin" ]; then
  printf "\nInstalling OS X dependencies...\n"
  $DOTFILES_DIR/bin/darwin-install.sh
fi

# python3 -m pip install --user --upgrade pynvim
