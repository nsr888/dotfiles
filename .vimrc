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

" jk | Escaping!
inoremap jk <Esc>
xnoremap jk <Esc>
cnoremap jk <C-c>
"imap jk <Esc>

nnoremap Q <Nop>

" set background=dark
" set t_Co=256
" syntax on
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
Plug 'brookhong/cscope.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh' }

" List ends here. Plugins become visible to Vim after this call.
call plug#end()

colo atlas
"colo nofrils-dark
let g:lightline = { 'colorscheme': 'atlas' }

let mapleader = "\<Space>"

""" Plugins Keymaps

nmap <leader>v :NERDTreeFind<CR>
"nmap <C-m> :NERDTreeFind<CR>
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


""""" FZF
" Mapping
map <C-f> :Files<CR>
nnoremap <silent> <leader>t :Tags<CR>
let g:fzf_tags_command = 'ctags -R'
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
"nmap <leader><tab> :FZF<CR>
" Mapping selecting mappings
" nmap <leader><tab> :Tags<CR>
" command! -bang -nargs=* Ag
"   \ call fzf#vim#grep(
"   \   'ag --column --numbers --noheading --color --smart-case '.shellescape(<q-args>), 1,
"   \   fzf#vim#with_preview(), <bang>0)

" map <C-g> :Ag
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

" Cscope
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
let g:cscope_silent = 1


"""" COC
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

"" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

"" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

"" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
