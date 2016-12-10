set nocompatible    " use vim settings rather than vi

" setup pathogen
execute pathogen#infect()
syntax on
filetype plugin indent on

" setup solarized color scheme
syntax enable
set background=dark
colorscheme solarized

" airline/powerline enabled
set laststatus=2     " Airline status bar always visible
let g:airline_powerline_fonts = 1    " Enable powerline symbols

" File specific actions
"au BufNewFile,BufFilePre,BufRead *.md set filetype=markdown   " markdown highlighting for .md files
if has("autocmd")
	" Enable file type detection
	filetype on
	" Treat .json files as .js
	autocmd BufNewFile,BufRead *.json setfiletype json syntax=javascript
	" Treat .md files as Markdown
	autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
endif

" Change mapleader from \ to ,
let mapleader=","
let maplocalleader="\\"

"
" General look and feel
"
set ttyfast          " optimze for fast terminals
set title            " show filename in window titlebar
set number           " enable line numbers
set cul              " highlight cursor line
set scrolloff=3      " start scrolling 3 lines before border
"set colorcolumn=90   " highlight end of line
"set nowrap           " don't wrap lines
set tabstop=4        " tab is 4 spaces
set shiftwidth=4     " shift (<, >) inserts 4 spaces
set expandtab        " convert tab key to spaces
set softtabstop=4    " when hitting <BS>, pretend like a tab is removed, even if spaces
set smarttab         " insert tabs at start of line according to shiftwidth, not tabstop
set showmatch        " show matching parens
"set showmode         " always show what mode we're editing in
set autoindent       " not sure

set hlsearch         " highlight search terms
set incsearch        " show search matches as you type
set ignorecase       " ignore case when searching
set smartcase        " ignore case if search is all lowercase, case sesnitive othewise
"set gsearch          " replace all occurences on current line, by default
set scrolloff=4      " keep 4 lines on edge of screen while scrolling

set wildmenu         " when using tab to autocomplete filenames, will show horizontal list of prev/next matches
set clipboard=unnamed
" set mouse=v
set backspace=indent,eol,start  " backspace over everything

"
" supertab / jedi-vim integration
"
"let g:SuperTabDefaultCompletionType = "context"
"let g:jedi#popup_on_dot = 0

" vertical line indentation
"let g:indentLine_color_term = 239
"let g:indentLine_color_gui = '#09AA08'
"let g:indentLine_char = '|'

"
" files (nerdtree, ctrlp, etc...)
"

" NerdTree open nerdtree automatically
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" NerdTree close vim if nothing else open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" <leader>t to open ctrlp
let g:ctrlp_map = '<leader>t'
let g:ctrlp_use_caching=0

" ignore certain file types with wild menu and ctrlp
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,*.pyc
"let g:ctrlp_custom_ignore = '\v[\/]\.(get|hg|svn)$'
let g:ctrlp_custom_ignore = {
            \ 'dir': '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(so|pyc|class|swp)$',
            \ }


"
" Key mappings / productivity
"

" toggle search highlights
nnoremap <ENTER> :set hlsearch!<CR>

" no need to press shift to enter command mode
nnoremap ; :
" move up/down into wrapped lines (instead of to starting line)
nnoremap j gj
nnoremap k gk
" jj instead of <ESC> to exist insert mode
inoremap jj <ESC>

" easily move between splits
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" create vertical split
nnoremap <leader>w <C-w>v<C-w>l
nnoremap <leader>s <C-w>s<C-w>j


"
" Macros
"

" create a line of "===" below current line
nnoremap <leader>1 yypVr=
" strip all trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction
noremap <leader>ss :call StripWhitespace()<CR>

" lorem ipsum abbreviations
iab lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit
iab llorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi
iab lllorem Lorem ipsum dolor sit amet, consectetur adipiscing elit.  Etiam lacus ligula, accumsan id imperdiet rhoncus, dapibus vitae arcu.  Nulla non quam erat, luctus consequat nisi.  Integer hendrerit lacus sagittis erat fermentum tincidunt.  Cras vel dui neque.  In sagittis commodo luctus.  Mauris non metus dolor, ut suscipit dui.  Aliquam mauris lacus, laoreet et consequat quis, bibendum id ipsum.  Donec gravida, diam id imperdiet cursus, nunc nisl bibendum sapien, eget tempor neque elit in tortor

