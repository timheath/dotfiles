#!/usr/bin/env bash
set -euo pipefail

#
# Darwin: ensure Homebrew, then install base packages
#

# --- ensure Homebrew ---
if ! command -v brew >/dev/null 2>&1; then
  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  else
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi
fi

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is not available on PATH; cannot install packages." >&2
  exit 1
fi

# --- packages your shell / editor expect ---
formulae=(
  coreutils # path.sh: brew --prefix coreutils .../gnubin
  neovim    # alias vi='nvim'; LazyVim
  git
)

for f in "${formulae[@]}"; do
  if brew list --formula "$f" &>/dev/null; then
    echo "Already installed: $f"
  else
    echo "Installing: $f"
    brew install "$f"
  fi
done
