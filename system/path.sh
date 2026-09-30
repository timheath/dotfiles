export GOPATH=$HOME/dev/golang

if [ "$(uname -s)" = "Darwin" ]; then
  # Prepend new items to path (if directory exists)

  # User prepend-path function to insert paths at the front of the PATH variable
  prepend-path "$HOME/.local/bin"
  prepend-path "$HOME/.grok/bin"
  prepend-path "/bin"
  prepend-path "/usr/bin"
  prepend-path "$GOPATH/bin"
  prepend-path "/usr/local/bin"
  prepend-path "/usr/local/go/bin"
  prepend-path "$DOTFILES_DIR/bin"
  prepend-path "$HOME/bin"
  prepend-path "/sbin"
  prepend-path "/usr/sbin"
  prepend-path "/usr/local/sbin"
  prepend-path "/opt/homebrew/sbin"
  prepend-path "/opt/homebrew/bin"
  is-executable brew && append-path "$(brew --prefix coreutils)/libexec/gnubin"
else
  # Keep the system (and Omarchy/mise) PATH; append user dirs so system
  # binaries keep precedence, same order as on Darwin
  append-path "$HOME/bin"
  append-path "$DOTFILES_DIR/bin"
  append-path "/usr/local/go/bin"
  append-path "$GOPATH/bin"
  append-path "$HOME/.grok/bin"
  append-path "$HOME/.local/bin"
fi

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755

PATH=$(echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

# Wrap up

export PATH
