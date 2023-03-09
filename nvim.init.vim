" change the leader key
let mapleader = ","

" Specify a directory for plugins
call plug#begin(stdpath('data') . '/plugged')
" Make sure you use single quotes

" Make it possible to repeat stuff coming from plugins
Plug 'tpope/vim-repeat'

" Color scheme
Plug 'Lokaltog/vim-distinguished'

" airline shows a nicer status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" ale auto-lint and auto-fix
Plug 'dense-analysis/ale'

" Indentation columns
Plug 'nathanaelkane/vim-indent-guides'

" Git plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

" easily change quotes and similar things
Plug 'tpope/vim-surround'

" easily comment a block of code
Plug 'tpope/vim-commentary'

" Working with clipboard
" - when deleting, to not copy to the register
Plug 'svermeulen/vim-cutlass'
" - easily replace things
Plug 'svermeulen/vim-subversive'
" - better yank (do not move the cursor)and paste (autoindent)
Plug 'svermeulen/vim-yoink'

" easily open a file at a given line (with file.name:<line>)
Plug 'bogado/file-line'

" Fuzzy finder
Plug 'wincent/command-t', {
    \   'do': 'cd ruby/command-t/ext/command-t && { make clean; ruby extconf.rb && make }'
    \ }

" Search in all files with :Ack :Lack :Back
Plug 'wincent/ferret'

" Tap into the vim undo capabilities
Plug 'sjl/gundo.vim'

" Trying out auto-pairs for managing the quotes, etc
"Plug 'jiangmiao/auto-pairs'

" support for snippets
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'

" better json support
Plug 'elzr/vim-json'

" syntax highlighting
"svelte
Plug 'evanleck/vim-svelte'
"javascript
Plug 'pangloss/vim-javascript'
"another option for JS
"Plug 'yuezk/vim-js'
"typescript
Plug 'HerringtonDarkholme/yats.vim'
"jsx
Plug 'maxmellon/vim-jsx-pretty'

" LSP capabilities
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-flow.vim'

" Initialize plugin system
call plug#end()

" turn on more colors
set termguicolors

" set up the color scheme
colorscheme distinguished

" configure jsm files to use the javascript syntax
autocmd BufNewFile,BufRead *.jsm set filetype=javascript

" highlight bad whitespaces
" see http://vim.wikia.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace ctermbg=darkred guibg=darkred

" Show trailing whitepace and spaces before a tab:
autocmd Syntax * syn match ExtraWhitespace /\s\+$\| \+\ze\t/ containedin=ALL

"macros: execute macros on selected lines only
"from https://github.com/stoeffel/.dotfiles/blob/master/vim/visual-at.vim
"via https://medium.com/@schtoeffel/you-don-t-need-more-than-one-cursor-in-vim-2c44117d51db
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" --- configuration for vim-cutlass ---
" m is for "move" => delete and move
nnoremap m d
xnoremap m d

nnoremap mm dd
nnoremap M D

" --- configuration for vim-subversive ---
" s for substitute (substitute the current "thing" with the clipboard)
nmap s <plug>(SubversiveSubstitute)
nmap ss <plug>(SubversiveSubstituteLine)
nmap S <plug>(SubversiveSubstituteToEndOfLine)

" working with ranges
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)

nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" --- configuration for vim-yoink ---
let g:yoinkAutoFormatPaste = 1
let g:yoinkIncludeDeleteOperations = 1
nmap p <plug>(YoinkPaste_p)
nmap P <plug>(YoinkPaste_P)
nmap gp <plug>(YoinkPaste_gp)
nmap gP <plug>(YoinkPaste_gP)
nmap <c-n> <plug>(YoinkPostPasteSwapBack)
nmap <c-p> <plug>(YoinkPostPasteSwapForward)
nmap y <plug>(YoinkYankPreserveCursorPosition)
xmap y <plug>(YoinkYankPreserveCursorPosition)

" --- configuration for command-t ---
" ruby implementation
let g:CommandTPreferredImplementation='ruby'
let g:CommandTFileScanner = "git"
let g:CommandTMaxHeight = 30
let g:CommandTMaxFiles = 500000
let g:CommandTSCMDirectories='.git,.hg,.svn,.bzr,_darcs,manifest.webapp'
"let g:CommandTInputDebounce = 50

" --- configuration for ale ---
let g:ale_c_build_dir_names = ['obj-x86_64-pc-linux-gnu-opt']
let g:ale_linter_aliases = {'svelte': ['css', 'javascript']}
" disable prettier and typescript for JS
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'typescript': ['eslint', 'tsserver'],
\}
let g:ale_fixers = {
\   'javascript': [
\       'eslint', 'prettier',
\   ],
\   'javascriptreact': [
  \       'eslint', 'prettier',
  \   ],
\   'typescript': ['prettier'],
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

" use the quickfix rather than the loclist
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 1

" -------

" security issue
set nomodeline

" Add numbers to each line on the left-hand side.
set number

" the normal vim copy/paste operations use the system clipboard
set clipboard=unnamedplus

" use the mouse in all modes
set mouse=a

" searches ignore case by default, but you can use \C to force it
set ignorecase

" see the result of a :%s operation while you're typing it (neovim only)
set inccommand=nosplit

" show long lines
set textwidth=80
set colorcolumn=+1

" one tab = 2 characters for everything
set shiftwidth=2
set shiftround "indent to multiples of shiftwidth
set expandtab "uses spaces instead of tabs
set softtabstop=2
set tabstop=2

" this helps gitgutter displays update more quickly
set updatetime=750

" toggle between paste mode and nopaste mode
set pastetoggle=<F12>

" set xterm title
set title

" make sure there's this numbero f lines around the line where the cursor
" currently is
set scrolloff=5

" Better show the cursor location (only the line is enough)
set cursorline
"set cursorcolumn

" <home> goes to the start of the code, not the start of the line
noremap  <expr> <Home> (col('.') == matchend(getline('.'), '^\s*')+1 ? '0'  : '^')
imap <Home> <C-o><Home>

" tab handling
noremap <C-Down> :tabn<CR>
noremap <C-Up> :tabp<CR>
noremap! <C-Down> <Esc>:tabn<CR>
noremap! <C-Up> <Esc>:tabp<CR>

" keep the selection when reindenting
vmap > >gv
vmap < <gv

" configure airline
let g:airline_theme='distinguished'
"let g:airline_section_z = airline#section#create(['windowswap', '%3p%% ', 'linenr', ':%3v'])
let g:airline_powerline_fonts = 1
"let g:airline#extensions#ale#enabled = 1

"super undo
nnoremap <leader>u :GundoToggle<CR>

" display a warning when the file exernally changed (not really good)
au FileChangedShell * echo "Warning: File changed on disk"

" search for the symbol under the cursor
au CursorMoved * exe printf('match CursorColumn /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" remember where we were last time (note: viminfo is good by default)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" use ctrl + space for completion
imap <C-space> <c-p>
" note that this doesn't work in terminal as ctrl-shift-space is sent as
" ctrl-space by the terminal emulator.
imap <C-S-space> <c-n>

"---- asynccomplete ----
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#flow#get_source_options({
\ 'name': 'flow',
\ 'allowlist': ['javascript'],
\ 'completor': function('asyncomplete#sources#flow#completor'),
\ 'config': {
\    'prefer_local': 1,
\    'show_typeinfo': 1
\  },
\ }))

"opt-in to the new version of snipmate's snippet parser
let g:snipMate = { 'snippet_version' : 1 }

"--- indent guides ---
let g:indent_guides_start_level = 2
let g:indent_guides_guides_size = 1
let g:indent_guides_auto_colors = 0
let g:indent_guides_enable_on_vim_startup = 1
autocmd VimEnter,Colorscheme * :hi IndentGuidesOdd  guibg=black ctermbg=black
autocmd VimEnter,Colorscheme * :hi IndentGuidesEven guibg=#121212 ctermbg=233
"---

" support flow with the javascript plugin
let g:javascript_plugin_flow = 1

"--- quickfix window
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cc :cclose<CR>
" open in a new tab
set switchbuf+=usetab,newtab
