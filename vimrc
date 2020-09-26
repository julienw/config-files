set nocompatible


" change the leader for some commands
let mapleader = ","

filetype off                  " required!

" Vundle configuration
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle
" required! 
Plugin 'VundleVim/Vundle.vim'

" My Plugins
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'rust-lang/rust.vim'
Plugin 'w0rp/ale'
Plugin 'tpope/vim-repeat'
Plugin 'Raimondi/delimitMate'
Plugin 'mattn/emmet-vim'
"Plugin 'jelera/vim-javascript-syntax'
"Plugin 'pangloss/vim-javascript'
Plugin 'yuezk/vim-js'
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'leafgarland/typescript-vim'
Plugin 'ervandew/supertab'
Plugin 'Lokaltog/vim-distinguished'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'sickill/vim-pasta.git'
Plugin 'kien/ctrlp.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'wincent/command-t'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'
Plugin 'honza/vim-snippets'
Plugin 'elzr/vim-json'
Plugin 'sjl/gundo.vim'
Plugin 'cespare/vim-toml'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'svermeulen/vim-easyclip'
Plugin 'digitaltoad/vim-jade'
Plugin 'bogado/file-line'
"Plugin 'Rip-Rip/clang_complete'
Plugin 'burner/vim-svelte'

" All of your Plugins must be added before the following line
call vundle#end()            " required

runtime macros/matchit.vim

syntax on
autocmd BufEnter * :syntax sync fromstart

"colorscheme desert
colorscheme distinguished

filetype indent plugin on
" don't try to highlight super long lines
set synmaxcol=1000


autocmd BufNewFile,BufRead *.jsm set filetype=javascript

set hidden

" set xterm title
set title

" text formatting
"set completeopt=menu,menuone,longest
set completeopt=
set pumheight=15
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
set list listchars=nbsp:¤,tab:··,trail:¤,extends:▶,precedes:◀
set ruler
set scrolloff=5
set showcmd

" show the matching bracket/parenthesis/etc
set showmatch
set sidescrolloff=5
"set statusline=%F%m%r%h%w[%L][%{&ff}]%y[%p%%][%04l,%04v]
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
"set smartindent

noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0'  : '^')
"noremap  <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$'  : 'g_')
"vnoremap <expr> <End>  (col('.') == match(getline('.'),    '\s*$')   ? '$h' : 'g_')
imap <Home> <C-o><Home>
"imap <End>  <C-o><End>

"easier escape
inoremap jk <Esc>
inoremap kj <Esc>
vnoremap jk <Esc>
vnoremap kj <Esc>

" write with sudo
command! W w !sudo tee % > /dev/null

" highlight bad whitespaces
" see http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen
"match ExtraWhitespace /\s\+$/
"autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
"autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
"autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"autocmd BufWinLeave * call clearmatches()

" Show trailing whitepace and spaces before a tab:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

" "
" auto clear trailing space
" see http://vim.wikia.com/wiki/Remove_unwanted_spaces
"autocmd BufWritePre *.pl,*.js,*.jsm,*.css :%s/\s\+$//e

" show long lines
set textwidth=80
set colorcolumn=+1

set updatetime=750

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

" use ctrl + space in supertab
" in terminal windows, ctrl + space inserts null characters
let g:SuperTabMappingForward = '<nul>'
let g:SuperTabMappingBackward = '<s-nul>'
" context completion
"let g:SuperTabDefaultCompletionType = "context"

" vim-javascript plugin
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_flow = 1

"for the indent guides plugin
let g:indent_guides_start_level = 2
let g:indent_guides_guides_size = 1

" useful with the delitMate plugin
imap <C-c> <CR><Esc>O

" indent guides stuff
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#121212 ctermbg=233

"super undo
nnoremap <leader>u :GundoToggle<CR>

"Command T
let g:CommandTFileScanner = "git"
let g:CommandTMaxHeight = 30
let g:CommandTMaxFiles = 500000
let g:CommandTSCMDirectories='.git,.hg,.svn,.bzr,_darcs,manifest.webapp'
"let g:CommandTInputDebounce = 50

" tab handling
noremap <C-Down> :tabn<CR>
noremap <C-Up> :tabp<CR>
noremap! <C-Down> <Esc>:tabn<CR>
noremap! <C-Up> <Esc>:tabp<CR>

" moving between changes
noremap <C-j> g,
noremap <C-k> g;

"ale
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
let g:ale_fixers = {
\   'javascript': [
\       'eslint',
\   ],
\   'rust': [
\       'rustfmt',
\   ],
\   'css': [
\       'stylelint',
\   ],
\   'svelte': [
\       'eslint', 'prettier',
\   ],
\}
let g:ale_fix_on_save = 1

"airline
let g:airline_theme='distinguished'
"let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
let g:airline_powerline_fonts = 1

"macros: execute macros on selected lines only
"from https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
"via https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

"easyclip
"Always move cursor at the end of paste
let g:EasyClipAlwaysMoveCursorToEndOfPaste = 1
"auto format when pasting
let g:EasyClipAutoFormat = 1
"do not change the cursor position when yanking
let g:EasyClipPreserveCursorPositionAfterYank = 1
"substitute commands
let g:EasyClipUseSubstituteDefaults = 1
"intuitive pasting in insert mode
imap <c-v> <plug>EasyClipInsertModePaste

"open firefox for current file
map <F8> :!xdg-open %<CR>

"this isn't very useful now and prone to security issues
"see https://github.com/numirias/security/blob/master/doc/2019-06-04_ace-vim-neovim.md
set nomodeline
