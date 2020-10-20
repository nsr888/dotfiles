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

" syntax on
set number
set mouse=a
map <ScrollWheelDown> j
map <ScrollWheelUp> k
set cc=80
highlight ColorColumn ctermbg=8
set comments=sl:/*,mb:**,elx:*/
" colorscheme zellner
imap jk <Esc>

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'junegunn/seoul256.vim'
Plug 'tpope/vim-sensible'
Plug 'scrooloose/nerdtree'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" Unified color scheme (default: dark)
colo seoul256

" Light color scheme
colo seoul256-light

" Switch
set background=dark

let mapleader = "\<Space>"

""" Plugins Keymaps

nmap <C-m> :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

nnoremap <leader>b :buffers<CR>
