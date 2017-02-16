BUNDLE=~/.vim/bundle
AUTOLOAD=~/.vim/autoload
OS="$(uname -s)"

mkdir -p $BUNDLE
mkdir -p $AUTOLOAD

# Get pathogen in place (special setup)
curl -LSso $AUTOLOAD/pathogen.vim https://tpo.pe/pathogen.vim

cd $BUNDLE

# Colors and utils

git clone https://github.com/scrooloose/nerdtree.git $BUNDLE/nerdtree
git clone https://github.com/kien/ctrlp.vim.git $BUNDLE/ctrlp.vim
git clone https://github.com/altercation/vim-colors-solarized.git $BUNDLE/vim-colors-solarized
git clone https://github.com/edkolev/promptline.vim.git $BUNDLE/promptline.vim

# Git

git clone https://github.com/tpope/vim-fugitive.git
git clone https://github.com/vim-airline/vim-airline.git

# Syntax, hightlighting, and format
git clone https://github.com/vim-scripts/loremipsum.git $BUNDLE/loremipsum
git clone https://github.com/scrooloose/syntastic.git $BUNDLE/syntastic
git clone https://github.com/Raimondi/delimitMate.git $BUNDLE/delimitMate
git clone https://github.com/fatih/vim-go.git $BUNDLE/vim-go
git clone https://github.com/AndrewRadev/splitjoin.vim.git $BUNDLE/splitjoin.vim
git clone https://github.com/SirVer/ultisnips.git $BUNDLE/ultisnips

[ "$OS" = "Darwin" ] &&  git clone https://github.com/axiaoxin/vim-json-line-format.git

# Completion & snippets

git clone https://github.com/ervandew/supertab.git
[ "$OS" = "Darwin" ] &&  git clone https://github.com/davidhalter/jedi-vim.git
