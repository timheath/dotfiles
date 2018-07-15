alias sshkey='cat ~/.ssh/id_rsa.pub | pbcopy'
alias vi='vim'   
alias path='echo $PATH | tr ":" "\n" | sort'

alias ll='ls -l --time-style=+"%Y-%m-%d %H:%M:%S" --color -h -a'
alias lsz='ls -l | sort -k5'
alias ls='ls --color'
alias lt='ls -ltrh'
alias la="ls -R |grep \":$\" | sed -e 's/:$//' -e 's/[^-][^\/]*\//--/g' -e 's/^/ /' -e 's/-/|/'"

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
alias toto='vi ~/Notes/todo.md'  # easier to type than todo
alias todo='vi ~/Notes/todo.md'  # easier to type than todo

alias golang='cd $GOPATH/src/github.com/timheath'
