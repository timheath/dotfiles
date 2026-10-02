# MacOS: point homebrew's completion loader at custom list of completions to load
if [[ -r /opt/homebrew/etc/profile.d/bash_completion.sh &&
  -z ${BASH_COMPLETION:-} ]]; then
  # Load our dispatcher first so it can skip incompatible Homebrew completions.
  BASH_COMPLETION_DIR="$DOTFILES_DIR/completions/homebrew"
  BASH_COMPLETION_COMPAT_DIR="$BASH_COMPLETION_DIR"
  . /opt/homebrew/etc/profile.d/bash_completion.sh
fi

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
