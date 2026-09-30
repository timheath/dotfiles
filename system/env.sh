#
# EXPORTS
#

# Keep showing man page after exit (Omarchy colors man pages with bat)
if ! is-omarchy; then
  export MANPAGER='less -X';
fi

# Increase Bash history size, omit duplicates and commands that begin with a space
export HISTCONTROL=ignoreboth;
export HISTSIZE=100000;
export HISTFILESIZE="${HISTSIZE}";
export HISTCONTROL='ignoreboth';

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Prefer US English and use UTF-8 (Omarchy sets the locale from /etc/locale.conf)
if ! is-omarchy; then
  export LC_ALL="en_US.UTF-8"
  export LANG="en_US"
fi

# Highlight section titles in man pages
export LESS_TERMCAP_md="${yellow}";

# set vi as CLI editor
set -o vi


# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Do not autocomplete when accidentally pressing Tab on an empty line.
shopt -s no_empty_cmd_completion

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
