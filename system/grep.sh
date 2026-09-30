# Tell grep to highlight matches

if is-supported "grep --color a <<< a"; then
  GREP_OPTIONS+=" --color=auto"
fi

# Avoid VCS folders

if is-supported "echo | grep --exclude-dir=.cvs ''"; then
  for PATTERN in .cvs .git .hg .svn; do
    GREP_OPTIONS+=" --exclude-dir=$PATTERN"
  done
elif is-supported "echo | grep --exclude=.cvs ''"; then
  for PATTERN in .cvs .git .hg .svn; do
    GREP_OPTIONS+=" --exclude=$PATTERN"
  done
fi

alias grep="grep $GREP_OPTIONS"
# GREP_COLOR for BSD grep; GNU grep 3.8+ warns about it unless GREP_COLORS sets mt
export GREP_COLOR='1;32'
export GREP_COLORS='mt=1;32'
