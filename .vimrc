" Sets UTF-8 encoding
set enc=utf-8
set fenc=utf-8
set termencoding=utf-8
" set tabs for 42 school norminette requirements
set shiftwidth=4
set softtabstop=4
set tabstop=4
set nocompatible
set autoindent
set smartindent

set ttyfast
set lazyredraw
set number
set cursorline
set hlsearch
"set mouse=a
"map <ScrollWheelDown> j
"map <ScrollWheelUp> k
set colorcolumn=80
"highlight ColorColumn ctermbg=8
imap jk <Esc>
nnoremap Q <Nop>

" set background=dark
set t_Co=256
syntax on
" syntax off

" Comments autocomletion
au Bufenter *.c,*.h set comments=sl:/*,mbl:**,elx:*/

if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'pbondoer/vim-42header'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
Plug 'itchyny/lightline.vim'
"Plug 'robertmeta/nofrils'
Plug 'huyvohcmc/atlas.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colo atlas
"colo nofrils-dark
let g:lightline = { 'colorscheme': 'atlas' }

let mapleader = "\<Space>"

""" Plugins Keymaps

"nmap <leader>v :NERDTreeFind<CR>
nmap <C-m> :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

nnoremap <leader>b :Buffers<CR>

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir /tmp/.vim/backups > /dev/null 2>&1
  set undodir=/tmp/.vim/backups
  set undofile
endif
"nnoremap <leader>b :buffers<CR>

" Mapping
nmap <leader><tab> :FZF<CR>

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Edit .vimrc
map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

