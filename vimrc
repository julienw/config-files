set nocompatible

" this need the pathogen vim plugin
call pathogen#infect()

filetype indent plugin on

syntax on
autocmd BufNewFile,BufRead *.jsm set filetype=javascript

set bg=dark
"colorscheme desert

set hidden

" set xterm title
set title

" text formatting
set completeopt=
set expandtab
set ignorecase
"set infercase
set nowrap
"set smartcase
set shiftround
set shiftwidth=2
set softtabstop=2
set tabstop=2
set smarttab

" UI
set cursorcolumn
set cursorline
set laststatus=2
set incsearch
set hlsearch
set lazyredraw
"set list
"set listchars=tab:>-,trail:-
set ruler
set scrolloff=5
set showcmd

" show the matching bracket/parenthesis/etc
set showmatch
set sidescrolloff=5
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set number
set numberwidth=5

" use the mouse in all mode
set mouse=a

" toggle between paste mode and nopaste mode
set pastetoggle=<F12>

" the normal vim copy/paste operations use the system clipboard
set clipboard=unnamedplus

" general
set backspace=indent,eol,start
set autoindent
set smartindent

noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0'  : '^')
"noremap  <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$'  : 'g_')
"vnoremap <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$h' : 'g_')
imap <Home> <C-o><Home>
"imap <End>  <C-o><End>

" write with sudo
command! W w !sudo tee % > /dev/null

" highlight bad whitespaces
" see http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
match ExtraWhitespace /\s\+$/
match ExtraWhitespace /^\s*\t/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" auto clear trailing space
" see http://vim.wikia.com/wiki/Remove_unwanted_spaces
"autocmd BufWritePre *.pl,*.js,*.jsm,*.css :%s/\s\+$//e

" show long lines
set textwidth=80
set colorcolumn=+1

" remember where we were last time (note: viminfo is good by default)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" keep the selection
vmap > >gv
vmap < <gv

" define Y like D
nmap Y y$

" display a warning when the file exernally changed (not really good)
au FileChangedShell * echo "Warning: File changed on disk"

" search for the symbol under the cursor
au CursorMoved * exe printf('match CursorColumn /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" for gaia
map <F8> :!gf<CR>
map <F9> :!gf -o<CR>

" use ctrl + space in supertab
" in terminal windows, ctrl + space inserts null characters
let g:SuperTabMappingForward = '<nul>'
let g:SuperTabMappingBackward = '<s-nul>'

" use jshint for syntastic
let g:syntastic_javascript_checkers = ['jshint', 'gjslint']
