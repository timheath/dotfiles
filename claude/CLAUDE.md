# Notes for Claude Code

- This file and `~/.claude/settings.json` are symlinks into the dotfiles repo (usually `~/dotfiles`, under `claude/`), so editing them changes files that get committed there. That repo isn't private: never put API keys, tokens or other secrets in either file, including the `env` block of settings.json.
- Secrets and host-specific config belong in the private repo (`~/dotfiles-private`). Nothing there is loaded into the shell environment yet, so ask how a secret should be wired up rather than putting it in settings.json.
