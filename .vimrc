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
