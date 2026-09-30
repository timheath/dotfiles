# Use at your own risk
Bootstrap a new machine with my preferred settings for working from the command line. This includes installation of a minimal set of dependencies, like LazyVim or Coreutils on Darwin.

My config borrows heavily from the setups done by [Lars Kappert](https://github.com/webpro/dotfiles) and [Orr Sella](https://github.com/orrsella/dotfiles).


## Install
Clone into your home dir and run install.sh. Re-run it after pulling changes (it's safe to run repeatedly).

On Linux, install.sh appends a small block to `~/.bashrc` (terminals start non-login shells), so distro defaults stay in place. On [Omarchy](https://omarchy.org), Omarchy's bash defaults (Starship prompt, eza, zoxide, fzf, ...) are kept, with vi mode, 100k history, `lt` (eza by modification time) and `ltt` (tree) layered on top, and Neovim follows the active Omarchy theme.

Claude Code gets the status line in `claude/context-bar.sh` (linked into `~/.claude/scripts/`). Shared settings go in `claude/settings.json`, which install.sh merges into `~/.claude/settings.json`. That file isn't linked, because Claude Code rewrites it and it keeps per-machine settings like plugins.
