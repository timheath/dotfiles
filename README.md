# Use at your own risk
Bootstrap a new machine with my preferred settings for working from the command line. This includes installation of a minimal set of dependencies, like LazyVim or Coreutils on Darwin.

My config borrows heavily from the setups done by [Lars Kappert](https://github.com/webpro/dotfiles) and [Orr Sella](https://github.com/orrsella/dotfiles).


## Install
Clone into your home dir and run install.sh. Re-run it after pulling changes (it's safe to run repeatedly).

On Linux, install.sh appends a small block to `~/.bashrc` (terminals start non-login shells), so distro defaults stay in place. On [Omarchy](https://omarchy.org), Omarchy's bash defaults (Starship prompt, eza, zoxide, fzf, ...) are kept, with vi mode, 100k history, `lt` (eza by modification time) and `ltt` (tree) layered on top, and Neovim follows the active Omarchy theme.

The Neovim config replaces Omarchy's (the `omarchy-nvim` package), so its updates aren't applied automatically. `vendor/omarchy-nvim` holds the last reviewed version; when the package changes, new shells say so. `omarchy-nvim-diff` shows what changed upstream, and `omarchy-nvim-diff --accept` marks it reviewed after picking what you want into `config/nvim`.

Claude Code gets the status line in `claude/context-bar.sh` (linked into `~/.claude/scripts/`). `~/.claude/settings.json` is linked to `claude/settings.json`, so changes Claude Code makes on any machine (`/config`, `/model`, plugins) show up as a git diff to commit or `git restore`. On first install, an existing settings file is merged into the repo copy and backed up. Keep tokens out of its `env` block, since it's committed here; machine-specific plugins fit better at project scope (`claude plugin enable <name> --scope project`). `claude/CLAUDE.md` is linked to `~/.claude/CLAUDE.md`, so instructions for every session (like keeping secrets out of the settings file) follow you too.
