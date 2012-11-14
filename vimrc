set nocompatible

filetype indent plugin on

syntax on
set bg=dark

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
set sidescrolloff=10
set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
set number
set numberwidth=5

" use the mouse in all mode
set mouse=a

" toggle between paste mode and nopaste mode
set pastetoggle=<F12>

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
command W w !sudo tee % > /dev/null

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
autocmd BufWritePre *.pl,*.js,*.jsm :%s/\s\+$//e

" show long lines
set textwidth=76
set colorcolumn=+1

" remember where we were last time (note: viminfo is good by default)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" for gaia
map <F8> :!gf<CR>

