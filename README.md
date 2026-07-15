# DO NOT USE THIS
This is a simple set of scripts for managing my dotfiles.  It's not tested
and may overwrite your configuration files!  

Feel free to take anything useful but you should look at much better examples 
from [Lars Kappert](https://github.com/webpro/dotfiles) and 
[Orr Sella](https://github.com/orrsella/dotfiles).  This repo steals heavily from what [Lars](https://github.com/webpro/dotfiles) put together.


## Installion
- Clone this repo into your home dir 
- Open a spare terminal window in case anything goes wrong that you need to fix
- Run the `install.sh` script
- Run `bin/rhinstall.sh` if you're on a Redhat/CentOS 
- Log in from a new terminal to make sure you can get into your machine

## Dependencies
The instsall script assumes the following are installed:
* `brew install nvim`
* `brew install coreutils`

The script also assumes:
* Brew is installed in `/opt/homebrew`
* That the `coreutils` path from brew should be prepended to the normal path
* Your terminal emulator is setup for the Solarized color palette 
* Python3 installed with nvim support (`python3 -m pip install --user --upgrade pynvim`)
