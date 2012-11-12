set nocompatible

filetype indent plugin on

syntax on

set hidden

" set xterm title
set title

" text formatting
set completeopt=
set expandtab
set ignorecase
set infercase
set nowrap
set smartcase
set shiftround
set shiftwidth=4
set softtabstop=4
set tabstop=4

" UI
set cursorcolumn
set cursorline
set laststatus=2
set incsearch
set lazyredraw
"set list
"set listchars=tab:>-,trail:-
set ruler
set scrolloff=5
set showcmd
set showmatch
set sidescrolloff=10
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set number
set numberwidth=5
set mouse=a
set pastetoggle=<F12>

" general
set backspace=indent,eol,start
set autoindent

noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0'  : '^')
"noremap  <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$'  : 'g_')
"vnoremap <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$h' : 'g_')
imap <Home> <C-o><Home>
"imap <End>  <C-o><End>

