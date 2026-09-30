#!/usr/bin/env bash
set -euo pipefail

#
# Arch (incl. Omarchy): install base packages with pacman
#

# --- packages your shell / editor expect ---
packages=(
  git
  curl
  neovim # alias vi='nvim'; LazyVim
)

missing=()
for p in "${packages[@]}"; do
  if pacman -Qi "$p" &>/dev/null; then
    echo "Already installed: $p"
  else
    missing+=("$p")
  fi
done

if ((${#missing[@]})); then
  echo "Installing: ${missing[*]}"
  sudo pacman -S --needed --noconfirm "${missing[@]}"
fi
