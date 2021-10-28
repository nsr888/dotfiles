" Sets UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set encoding=UTF-8
set fileformat=unix
set textwidth=79
" set default tabs
set shiftwidth=4
set softtabstop=4
set tabstop=4
set expandtab

" use relative numbers for all lines except the current line
set number                     " Show current line number
set relativenumber             " Show relative line numbers

set nocompatible
set autoindent
set smartindent
set cindent
filetype indent off
set colorcolumn=80

" set 2 space tabs for specific files with long lines
au BufNewFile,BufRead *.js,*.tsx,*.ts,*.jsx,*.css,*.html
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

" Don't redraw while executing macros (good performance config)
set ttyfast
set lazyredraw
set cursorline

" jk | Escaping!
imap jk <Esc>

" Disable entering Ex mode
nnoremap Q <Nop>

"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
nmap <silent> // :nohlsearch<CR>
noremap <leader>hl :set hlsearch! hlsearch?<CR>

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'preservim/nerdtree'
Plug 'vim-scripts/BufOnly.vim'
Plug 'michaeljsmith/vim-indent-object'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'herringtondarkholme/yats.vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

let mapleader = "\<Space>"

" ================ theme config

colo dracula
let g:lightline = { 'colorscheme': 'dracula' }

nnoremap <leader>b :buffers<CR>

" ================ NERD

nmap <leader>v :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,tags

"" Nerdtree config for wildignore
let NERDTreeRespectWildIgnore=1
