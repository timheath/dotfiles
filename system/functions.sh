#
# Credits
# github.com/orrsella/dotfiles
# github.com/mathiasbynens
# github.com/webpro

# Executable
is-executable() {
  local BIN=$(command -v "$1" 2>/dev/null)
  if [[ ! $BIN == "" && -x $BIN ]]; then true; else false; fi
}

is-supported() {
  if [ $# -eq 1 ]; then
    if eval "$1" > /dev/null 2>&1; then true; else false; fi
  else
    if eval "$1" > /dev/null 2>&1; then
      echo -n "$2"
    else
      echo -n "$3"
    fi
  fi
}

# Add to path
prepend-path() {
  [ -d $1 ] && PATH="$1:$PATH"
}

# Fuzzy find file/dir
ff() {  find . -type f -iname "$1";}
fff() { find . -type f -iname "*$1*";}
fd() {  find . -type d -iname "$1";}
fdf() { find . -type d -iname "*$1*";}

# show weather forcast
weather() {
  local CITY=${1:-Palo Alto}
  curl -4 "wttr.in/$CITY"
}
# show moon phase
moon() {
  curl -4 "wttr.in/Moon"
}

# show 256 TERM colors
colors() {
  local X=$(tput op)
  local Y=$(printf %$((COLUMNS-6))s)
  for i in {0..256}; do
  o=00$i;
  echo -e ${o:${#o}-3:3} $(tput setaf $i;tput setab $i)${Y// /=}$X;
  done
}

# change terminal title
title() {
  echo -en "\033]2;$1\007";
}

# server up current dir via http
servethis() {
  open "http://localhost:8000";
  python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()';
}

# extract any archive format
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)        tar xjf $1        ;;
      *.tar.gz)         tar xzf $1        ;;
      *.bz2)            bunzip2 $1        ;;
      *.rar)            unrar x $1        ;;
      *.gz)             gunzip $1         ;;
      *.tar)            tar xf $1         ;;
      *.tbz2)           tar xjf $1        ;;
      *.tgz)            tar xzf $1        ;;
      *.zip)            unzip $1          ;;
      *.jar)            unzip $1          ;;
      *.war)            unzip $1          ;;
      *.Z)              uncompress $1     ;;
      *)                echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Determine size of a file or total size of a directory
function fs() {
	if du -b /dev/null > /dev/null 2>&1; then
		local arg=-sbh;
	else
		local arg=-sh;
	fi
	if [[ -n "$@" ]]; then
		du $arg -- "$@";
	else
		du $arg .[^.]* ./*;
	fi;
}

# A recursive, case-insensitive grep that excludes binary files
rgrep() {
  grep -iR "$@" * | grep -v "Binary"
}

# A recursive, case-insensitive grep that excludes binary files and returns only unique filenames
dfgrep() {
  grep -iR "$@" * | grep -v "Binary" | sed 's/:/ /g' | awk '{ print $1 }' | sort | uniq
}

# TODO have Darwin only functions
# Render markdown file and copy into system buffer (OSX only)
mdcopy() {
    if [ -f $1 ] && [ $(uname) == "Darwin" ]; then
        cat $1 | pandoc --from markdown_github --to html | textutil -convert rtf -stdin -stdout -format html| pbcopy -Prefer rtf
    fi
}

# TODO create a quick function to convert to html which doesn't lose formatting like rtf
# md2html() {
#     if [ -f $1 ] && [ $(uname) == "Darwin" ]; then
#         cat $1 | pandoc --from markdown_github --to html | textutil -convert rtf -stdin -stdout -format html| pbcopy -Prefer rtf
#     fi
# }
