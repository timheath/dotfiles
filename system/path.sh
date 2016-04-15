# Start with system path
# Retrieve it from getconf, otherwise it's just current $PATH

is-executable getconf && PATH=$(command -v getconf PATH)

# Prepend new items to path (if directory exists)

#/usr/local/opt/coreutils/libexec/gnubin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/opt/coreutils/libexec/gnubin:/Users/xbbl4bt/dev/golang/bin:/Users/xbbl4bt/dev/golang/bin

# redhat specific path elements
if [ -f /etc/redhat-release ]; then
    prepend-path "/usr/seos/bin"
    prepend-path "/usr/lib64/qt-3.3/bin"
fi

#export PATH=$PATH:$GOPATH/bin
#export GOPATH=$HOME/dev/golang

prepend-path "/bin"
prepend-path "/usr/bin"
prepend-path "$HOME/dev/golang/bin"
prepend-path "/usr/local/bin"
is-executable brew && prepend-path "$(brew --prefix coreutils)/libexec/gnubin"
prepend-path "$DOTFILES_DIR/bin"
prepend-path "$HOME/bin"
prepend-path "/sbin"
prepend-path "/usr/sbin"
prepend-path "/usr/local/sbin"

# Remove duplicates (preserving prepended items)
# Source: http://unix.stackexchange.com/a/40755

PATH=`echo -n $PATH | awk -v RS=: '{ if (!arr[$0]++) {printf("%s%s",!ln++?"":":",$0)}}'`

# Wrap up

export PATH
