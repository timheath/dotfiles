BUNDLE=~/.vim/bundle
AUTOLOAD=~/.vim/autoload
OS="$(uname -s)"

mkdir -p $BUNDLE
mkdir -p $AUTOLOAD

# Get pathogen in place (special setup)
curl -LSso $AUTOLOAD/pathogen.vim https://tpo.pe/pathogen.vim

cd $BUNDLE

# Colors and utils

git clone https://github.com/scrooloose/nerdtree.git 
git clone https://github.com/kien/ctrlp.vim.git 
git clone https://github.com/altercation/vim-colors-solarized.git 
git clone https://github.com/edkolev/promptline.vim.git 
git clone https://github.com/mikelue/vim-maven-plugin.git

# Git

git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/vim-airline/vim-airline.git
git clone https://github.com/airblade/vim-gitgutter.git

# Syntax, hightlighting, and format

git clone https://github.com/scrooloose/syntastic.git 
git clone https://github.com/altercation/vim-colors-solarized.git
git clone https://github.com/Raimondi/delimitMate.git 
[ "$OS" = "Darwin" ] &&  git clone https://github.com/axiaoxin/vim-json-line-format.git

# Completion & snippets

git clone https://github.com/ervandew/supertab.git
[ "$OS" = "Darwin" ] &&  git clone https://github.com/davidhalter/jedi-vim.git
