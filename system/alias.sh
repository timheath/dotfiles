# dev shortcuts

alias sshkey='cat ~/.ssh/id_rsa.pub | pbcopy'
alias vi='nvim'
alias path='echo $PATH | tr ":" "\n" | sort'

# `command ls` so these keep GNU ls flags/output even when ls is aliased (eza on Omarchy)
alias ll='command ls -l --time-style=+"%Y-%m-%d %H:%M:%S" --color -h -a'
alias lsz='command ls -l | sort -k5'
alias la="command ls -R |grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

if is-omarchy; then
  # Keep Omarchy's ls (eza); lt lists by modification time, oldest first like ls -ltr
  alias lt='eza -lh --icons=auto --sort=modified'
  # Omarchy's original lt/lta (tree view)
  alias ltt='eza --tree --level=2 --long --icons --git'
  alias ltta='ltt -a'
else
  alias ls='ls --color'
  alias lt='ls -ltrh'
fi

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cpwd='pwd|tr -d "\n"|pbcopy'
alias line='printf "%100s\n" | tr " " ='

# Quick-Look preview files from the command line
alias ql="qlmanage -p &>/dev/null"

# Intuitive map function
# For example, to list all directories that contain a certain file:
# find . -name .gitattributes | map dirname
alias map="xargs -n1"

# Reload the shell (i.e. invoke as a login shell)
alias reload="exec $SHELL -l"

alias notes='vi ~/Notes'
alias toto='vi ~/Notes/todo.md' # easier to type than todo
alias todo='vi ~/Notes/todo.md' # easier to type than todo

# Simplify python venv management
# alias venv-create='python -m venv ~/.venvs/$1'        # Usage: venv-create myproject-env
# alias venv-activate='source ~/.venvs/$1/bin/activate' # Usage: venv-activate myproject-env (Unix/macOS)
# alias venv-list='ls ~/.venvs'                         # List all envs
# alias venv-remove='rm -rf ~/.venvs/$1'                # Usage: venv-remove myproject-env (be careful!)

alias golang='cd $GOPATH/src/github.com/timheath'
