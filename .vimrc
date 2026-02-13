" Sets UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
set encoding=UTF-8
set fileformat=unix
set textwidth=79
set noexpandtab      " Use actual tabs instead of spaces
set copyindent       " Copy indent structure from previous line
set preserveindent   " Preserve indent structure when reindenting
set softtabstop=0    " Disable soft tabs (matches tabstop when 0)
set shiftwidth=4     " Number of spaces for each indentation level
set tabstop=4        " Number of spaces that a tab character represents

set number " Show current line number

set nocompatible
set autoindent
set smartindent
set nocindent        " Disable C-style indenting
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

" Ultra-minimal grayscale color scheme for vim-tiny,
" which lacks +syntax and +termguicolors
set background=dark
highlight clear
hi Normal ctermfg=252 ctermbg=235
hi LineNr ctermfg=240

" vim-tiny skips this entire block because it lacks +eval
if 1
  set termguicolors
  colorscheme habamax
  syntax on
endif
