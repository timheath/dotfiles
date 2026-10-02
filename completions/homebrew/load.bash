# Homebrew's bash-completion framework sources this dispatcher during startup.
# Keep scripts in their original locations, but skip known incompatibilities.
for completion_file in /opt/homebrew/etc/bash_completion.d/*; do
  [[ -f $completion_file && -r $completion_file ]] || continue

  case ${completion_file##*/} in
    # Match the framework's usual backup-file exclusions.
    *~|*.bak|*.swp|\#*\#|*.dpkg*|*.rpmorig|*.rpmnew|*.rpmsave|Makefile*)
      continue
      ;;

    hf)
      # Click's completion requires Bash 4.4 or newer.
      (( BASH_VERSINFO[0] > 4 ||
         (BASH_VERSINFO[0] == 4 && BASH_VERSINFO[1] >= 4) )) ||
        continue
      ;;
  esac

  . "$completion_file"
done
unset completion_file
