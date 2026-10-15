# Notes for Claude Code

- This file and `~/.claude/settings.json` are symlinks into the dotfiles repo (usually `~/dotfiles`, under `claude/`), so editing them changes files that get committed there. That repo isn't private: never put API keys, tokens or other secrets in either file, including the `env` block of settings.json.
- Secrets belong in the private repo instead: add `export NAME=value` to `~/dotfiles-private/runcom/env`, which the shell sources (`runcom/bashrc`), so Claude Code inherits them from the environment.
