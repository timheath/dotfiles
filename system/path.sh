# Start with system path
# Retrieve it from getconf, otherwise it's just current $PATH

is-executable getconf && PATH=$(command -v getconf PATH)

# Prepend new items to path (if directory exists)

# User prepend-path function to insert paths at the front of the PATH variable
prepend-path "$HOME/.local/bin"
# Grok is special
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
append-path "$(brew --prefix coreutils)/libexec/gnubin"

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755

PATH=$(echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}')

# Wrap up

export PATH
export GOPATH=$HOME/dev/golang
