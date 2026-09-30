#!/usr/bin/env bash
set -euo pipefail

# Get current dir (so run this script from anywhere)
export DOTFILES_DIR
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

OS="$(uname -s)"

# Symlink src to dst. A real file/dir at dst is backed up first (plain `ln -s`
# onto a real directory would create dst/<name> inside it instead).
link() {
  local src="$1" dst="$2" backup
  if [[ -L "$dst" && "$(readlink "$dst")" == "$src" ]]; then
    echo "Already linked: $dst -> $src"
    return 0
  fi
  if [[ -e "$dst" && ! -L "$dst" ]]; then
    backup="${dst}.bak.$(date +%Y%m%d%H%M%S)"
    echo "Backing up $dst to $backup"
    mv "$dst" "$backup"
  fi
  ln -sfnv "$src" "$dst"
}

# Source runcom/bashrc from ~/.bashrc: terminals (e.g. on Omarchy) start
# non-login shells, which never read ~/.bash_profile. Appending (rather than
# linking ~/.bashrc) keeps the distro/Omarchy defaults and installer additions.
BASHRC_BEGIN="# >>> dotfiles >>>"
BASHRC_END="# <<< dotfiles <<<"
install_bashrc_hook() {
  local rc="$HOME/.bashrc" line tmp
  line="[[ -r \"$DOTFILES_DIR/runcom/bashrc\" ]] && . \"$DOTFILES_DIR/runcom/bashrc\""
  touch "$rc"
  if grep -qxF "$line" "$rc"; then
    echo "Dotfiles already sourced from $rc"
    return 0
  fi
  # Drop a stale block (e.g. repo moved) before appending the current one
  if grep -qxF "$BASHRC_BEGIN" "$rc"; then
    tmp="$(mktemp)"
    awk -v b="$BASHRC_BEGIN" -v e="$BASHRC_END" '$0 == b { skip = 1 } !skip { print } $0 == e { skip = 0 }' "$rc" >"$tmp"
    cat "$tmp" >"$rc"
    rm -f "$tmp"
  fi
  echo "Adding dotfiles block to $rc"
  printf '\n%s\n%s\n%s\n' "$BASHRC_BEGIN" "$line" "$BASHRC_END" >>"$rc"
}

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
    link "$src" "$dst"
  else
    echo "No private SSH hosts file at $src (skipped)."
  fi
}

# --- shell / ssh symlinks ---
mkdir -p -m 700 "$HOME/.ssh"
link "$DOTFILES_DIR/runcom/bash_profile" ~/.bash_profile
link "$DOTFILES_DIR/runcom/inputrc" ~/.inputrc
link "$DOTFILES_DIR/ssh/config" ~/.ssh/config
install_bashrc_hook

# --- private overlay (optional; host-specific SSH config, etc.) ---
printf "\nCloning private dotfiles...\n"
sync_private_dotfiles
link_private_overlays

# --- Neovim (LazyVim) config ---
mkdir -p "$HOME/.config"
NVIM_SRC="$DOTFILES_DIR/config/nvim"
link "$NVIM_SRC" "$HOME/.config/nvim"

# Omarchy theme sync: link plugins/theme.lua (gitignored) to the active
# Omarchy theme, like omarchy-nvim-setup does. Its presence also enables the
# theme hot-reload and transparency in the nvim config.
if [[ -n "${OMARCHY_PATH:-}" || -d /usr/share/omarchy ]]; then
  # Omarchy 4 keeps the current theme under ~/.local/state, 3.x under ~/.config
  theme_dir="$HOME/.local/state/omarchy/current/theme"
  if [[ ! -d "$HOME/.local/state/omarchy/current" && -d "$HOME/.config/omarchy/current" ]]; then
    theme_dir="$HOME/.config/omarchy/current/theme"
  fi
  ln -sfnv "$theme_dir/neovim.lua" "$NVIM_SRC/lua/plugins/theme.lua"
fi

# --- OS packages (pacman on Arch, Homebrew + neovim on Darwin) ---
if [[ "$OS" == "Linux" ]] && command -v pacman >/dev/null 2>&1; then
  printf "\nInstalling Arch dependencies...\n"
  "$DOTFILES_DIR/bin/arch-install.sh"
elif [[ "$OS" == "Linux" ]]; then
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

# --- LazyVim plugins: install, clean and update to latest (lazy-lock.json is per machine) ---
if command -v nvim >/dev/null 2>&1; then
  printf "\nSyncing Neovim plugins (Lazy)...\n"
  # ts-build.lua waits for the treesitter parser rebuild, which +qa would cut off
  nvim --headless "+Lazy! sync" "+luafile $NVIM_SRC/scripts/ts-build.lua" +qa
  printf "Neovim plugin sync finished.\n"
else
  echo "nvim not on PATH; skipped Lazy sync. Install neovim, then open nvim once or re-run this script." >&2
fi

# --- Claude Code: status line script + shared settings ---
# settings.json isn't linked: Claude Code rewrites it and it holds per-machine
# state (plugins, effort), so claude/settings.json is merged in over it instead.
printf "\nConfiguring Claude Code...\n"
mkdir -p "$HOME/.claude/scripts"
link "$DOTFILES_DIR/claude/context-bar.sh" "$HOME/.claude/scripts/context-bar.sh"
if command -v jq >/dev/null 2>&1; then
  settings="$HOME/.claude/settings.json"
  [[ -s "$settings" ]] || echo '{}' >"$settings"
  tmp="$(mktemp)"
  jq -s '.[0] * .[1]' "$settings" "$DOTFILES_DIR/claude/settings.json" >"$tmp"
  if cmp -s "$tmp" "$settings"; then
    echo "Claude settings already up to date: $settings"
  else
    echo "Merging shared Claude settings into $settings"
    cat "$tmp" >"$settings"
  fi
  rm -f "$tmp"
else
  echo "jq not on PATH; skipped Claude settings merge (the status line needs jq too)." >&2
fi

# --- default shell (bash); may prompt for password ---
printf "\nConfiguring default shell...\n"
"$DOTFILES_DIR/bin/shell"
