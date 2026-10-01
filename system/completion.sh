# Homebrew's bash-completion (macOS); Linux/Omarchy load bash-completion themselves
[[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"

# Source local bash completion files
for COMPLETION in "$DOTFILES_DIR"/completions/*.bash; do
  # Prefer the system's git completion when available / loaded
  if [[ $COMPLETION == */git-completion.bash ]]; then
    # macOS: Homebrew's bash-completion has already loaded git's completion
    # Linux: bash-completion will load the system one on first <tab>
    declare -F __git_main >/dev/null || [[ -f /usr/share/bash-completion/completions/git ]] && continue
  fi
  [ -f "$COMPLETION" ] && . "$COMPLETION"
done
unset COMPLETION

# Grok completions
[[ -r "$HOME/.grok/completions/bash/grok.bash" ]] && source "$HOME/.grok/completions/bash/grok.bash"
