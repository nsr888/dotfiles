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

set number
"set mouse=a
"map <ScrollWheelDown> j
"map <ScrollWheelUp> k
"set cc=80
"highlight ColorColumn ctermbg=8
set comments=sl:/*,mb:**,elx:*/
imap jk <Esc>

" set background=dark
set t_Co=256
syntax on
" syntax off

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins will be downloaded under the specified directory.
call plug#begin('~/.vim/plugged')

" Declare the list of plugins.
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdtree'
" Plug 'itchyny/lightline.vim'
Plug 'robertmeta/nofrils'
Plug 'huyvohcmc/atlas.vim'
" Plug 'pbrisbin/vim-colors-off'
" Plug 'danishprakash/vim-yami'
" Plug 'ewilazarus/preto'
" Plug 'lokaltog/vim-monotone'
" Plug 'fxn/vim-monochrome'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

" colorscheme yami
" colorscheme off
" colorscheme monochrome
" colo atlas
" colo monotone
" colo preto
colo nofrils-dark
"let g:lightline = { 'colorscheme': 'atlas' }

" Unified color scheme (default: dark)
" colo seoul256

" Light color scheme
" colo seoul256-light

" Switch
" set background=dark

let mapleader = "\<Space>"

""" Plugins Keymaps

nmap <C-m> :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

"nnoremap <leader>b :buffers<CR>
nnoremap <Leader>b :ls<CR>:b<Space>

" ================ Persistent Undo ==================
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir /tmp/.vim/backups > /dev/null 2>&1
  set undodir=/tmp/.vim/backups
  set undofile
endif
"nnoremap <leader>b :buffers<CR>
