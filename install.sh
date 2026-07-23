#!/usr/bin/env bash
set -euo pipefail

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"

# Optional overlay for private files from another repo
PRIVATE_DIR="${DOTFILES_PRIVATE_DIR:-$HOME/dotfiles-private}"
PRIVATE_URL="${DOTFILES_PRIVATE_URL:-git@github.com:timheath/dotfiles-private.git}"

# Clone or update private dotfiles when SSH auth to GitHub works
sync_private_dotfiles() {
  if [[ -d "$PRIVATE_DIR/.git" ]]; then
    printf "Updating private dotfiles in %s...\n" "$PRIVATE_DIR"
    if ! git -C "$PRIVATE_DIR" pull --ff-only; then
      echo "Warning: could not update $PRIVATE_DIR (continuing)." >&2
    fi
    return 0
  fi

  if [[ -e "$PRIVATE_DIR" ]]; then
    echo "Private path exists but is not a git repo: $PRIVATE_DIR (using as-is)."
    return 0
  fi

  if ! GIT_SSH_COMMAND="ssh -o BatchMode=yes -o ConnectTimeout=5" \
    git ls-remote "$PRIVATE_URL" &>/dev/null; then
    echo "Access denied for $PRIVATE_URL. Skipping..."
    echo "When git access is configued, re-run this script to setup private files"
    return 0
  fi

  printf "Cloning private dotfiles into %s...\n" "$PRIVATE_DIR"
  git clone "$PRIVATE_URL" "$PRIVATE_DIR"
}

# Link files from private overlay when present.
link_private_overlays() {
  local src dst
  src="$PRIVATE_DIR/ssh/config.local"
  dst="$HOME/.ssh/config.local"
  if [[ -f "$src" ]]; then
    ln -sfv "$src" "$dst"
  else
    echo "No private SSH hosts file at $src (skipped)."
  fi
}

# --- shell / ssh symlinks ---
# ln -sfv "$DOTFILES_DIR/vim/vimrc" ~/.vimrc  # No longer using vim; kept under vim/ for posterity
mkdir -p -m 700 "$HOME/.ssh"
ln -sfv "$DOTFILES_DIR/runcom/bash_profile" ~/.bash_profile
ln -sfv "$DOTFILES_DIR/runcom/inputrc" ~/.inputrc
ln -sfv "$DOTFILES_DIR/ssh/config" ~/.ssh/config

# --- private overlay (optional; host-specific SSH config, etc.) ---
printf "\nCloning private dotfiles...\n"
sync_private_dotfiles
link_private_overlays

# --- Neovim (LazyVim) config ---
# Important: if ~/.config/nvim is a real directory, plain `ln -s` creates
# ~/.config/nvim/nvim instead of replacing it. Back up, then link.
mkdir -p "$HOME/.config"
NVIM_SRC="$DOTFILES_DIR/config/nvim"
NVIM_DST="$HOME/.config/nvim"

if [[ ! -d "$NVIM_SRC" ]]; then
  echo "Missing LazyVim config at $NVIM_SRC" >&2
  exit 1
fi

if [[ -L "$NVIM_DST" ]]; then
  current="$(readlink "$NVIM_DST")"
  if [[ "$current" == "$NVIM_SRC" ]]; then
    echo "Neovim config already linked: $NVIM_DST -> $NVIM_SRC"
  else
    echo "Updating Neovim config symlink ($current -> $NVIM_SRC)"
    ln -sfnv "$NVIM_SRC" "$NVIM_DST"
  fi
elif [[ -e "$NVIM_DST" ]]; then
  backup="${NVIM_DST}.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up existing Neovim config to $backup"
  mv "$NVIM_DST" "$backup"
  ln -sfnv "$NVIM_SRC" "$NVIM_DST"
else
  ln -sfnv "$NVIM_SRC" "$NVIM_DST"
fi

# --- OS packages (Homebrew + neovim on Darwin) ---
if [[ "$OS" == "Linux" ]]; then
  printf "\nInstalling Linux dependencies...\n"
  "$DOTFILES_DIR/bin/rhinstall.sh"
elif [[ "$OS" == "Darwin" ]]; then
  printf "\nInstalling macOS dependencies...\n"
  "$DOTFILES_DIR/bin/darwin-install.sh"
  # Subshell install does not export brew into this process
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
fi

# --- LazyVim plugins (lockfile-driven) ---
if command -v nvim >/dev/null 2>&1; then
  printf "\nSyncing Neovim plugins (Lazy)...\n"
  nvim --headless "+Lazy! sync" +qa
  printf "Neovim plugin sync finished.\n"
else
  echo "nvim not on PATH; skipped Lazy sync. Install neovim, then open nvim once or re-run this script." >&2
fi

# --- default shell (bash); may prompt for password ---
printf "\nConfiguring default shell...\n"
"$DOTFILES_DIR/bin/shell"
