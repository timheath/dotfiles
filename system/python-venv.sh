# Simplify venv management with some simple commands

function venv() {
  case "$1" in
  create)
    if [ -z "$2" ]; then
      echo "Usage: venv create <env-name>"
      return 1
    fi
    python3 -m venv ~/.venvs/"$2"
    echo "Created venv at ~/.venvs/$2"
    ;;
  activate)
    if [ -z "$2" ]; then
      echo "Usage: venv activate <env-name>"
      return 1
    fi
    source ~/.venvs/"$2"/bin/activate
    ;;
  list) ls -1 ~/.venvs ;;
  remove)
    if [ -z "$2" ]; then
      echo "Usage: venv remove <env-name>"
      return 1
    fi
    read -p "Delete ~/.venvs/$2? (y/n) " confirm
    if [ "$confirm" = "y" ]; then
      rm -rf ~/.venvs/"$2"
      echo "Deleted"
    fi
    ;;
  *) echo "Usage: venv {create|activate|list|remove} <env-name>" ;;
  esac
}
