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

" set tab as tab for 42 school norminette requirements
au BufNewFile,BufRead *.c,*.h set noexpandtab

" set 2 space tabs for specific files with long lines
au BufNewFile,BufRead *.js,*.tsx,*.ts,*.jsx,*.css,*.html
    \ set tabstop=2 |
    \ set softtabstop=2 |
    \ set shiftwidth=2 |
    \ set expandtab

" turn off double indentation in vim
" https://stackoverflow.com/questions/3538785/how-to-turn-off-double-indentation-in-vim

" Skeleton template for cpp files
" au BufNewFile *.cpp 0r ~/.vim/templates/skeleton.cpp
" au BufNewFile *.hpp 0r ~/.vim/templates/skeleton.hpp



set termguicolors
augroup SyntaxSettings
    autocmd!
    autocmd BufNewFile,BufRead *.tsx set filetype=typescript.tsx
augroup END

" Don't redraw while executing macros (good performance config)
set ttyfast
set lazyredraw

set cursorline

" jk | Escaping!
imap jk <Esc>

" Disable entering Ex mode
nnoremap Q <Nop>

" Comments autocomletion
au Bufenter *.c,*.h set comments=sl:/*,mbl:**,elx:*/

" Disable ALE LSP features allready provided by coc.nvim
let g:ale_disable_lsp = 1

"====[ Set up smarter search behaviour ]=======================

set incsearch       "Lookahead as search pattern is specified
set ignorecase      "Ignore case in all searches...
set smartcase       "...unless uppercase letters used

set hlsearch        "Highlight all matches
nmap <silent> // :nohlsearch<CR>
noremap <leader>hl :set hlsearch! hlsearch?<CR>

"====[ Protodef ]=======================
" au! BufEnter *.cpp let b:fswitchdst = 'hpp,h' | let b:fswitchlocs = '.'
" au! BufEnter *.cpp let b:fswitchdst = 'hpp'
let g:protodefctagsexe = '/usr/local/bin/ctags'
let g:protodefprotogetter = '~/.vim/plugged/vim-protodef/pullproto.pl'

"====[ Plugins ]=======================
" Install vim-plug if not found
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
Plug 'huyvohcmc/atlas.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'brookhong/cscope.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'dense-analysis/ale'
Plug 'noahfrederick/vim-skeleton'
Plug 'vim-scripts/BufOnly.vim'
Plug 'derekwyatt/vim-fswitch'
Plug 'derekwyatt/vim-protodef'
Plug 'michaeljsmith/vim-indent-object'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'herringtondarkholme/yats.vim'
Plug 'othree/html5.vim'
Plug 'alvan/vim-closetag'

" get machine specific hostname
let HOSTNAME=substitute(system('hostname'), "\n", "", "")
if (HOSTNAME == "aimac.local")
    " set plugins for home pc
    let g:coc_global_extensions = [
          \ 'coc-tabnine',
          \ 'coc-vimlsp',
          \ 'coc-go',
          \ 'coc-json',
          \ 'coc-pyright',
          \ 'coc-html',
          \ 'coc-lists',
          \ 'coc-phpls',
          \ 'coc-sh',
          \ 'coc-css',
          \ 'coc-sql',
          \ 'coc-eslint',
          \ 'coc-tsserver',
          \ 'coc-stylelint',
          \]
          " \ 'coc-prettier',
    Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
    Plug 'dhruvasagar/vim-table-mode', { 'for': 'markdown' }
    Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
else
    " set plugins for school pc
    let g:coc_global_extensions = [
          \ 'coc-json',
          \ 'coc-pyright',
          \ 'coc-tabnine',
          \ 'coc-eslint',
          \ 'coc-tsserver',
          \ 'coc-stylelint',
          \]
endif

Plug 'ryanoasis/vim-devicons'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

" List ends here. Plugins become visible to Vim after this call.
call plug#end()


let mapleader = "\<Space>"

" ================ theme config 
" colo atlas
" let g:lightline = { 'colorscheme': 'atlas' }
" Fix atlas theme documentation menu font color
" hi Pmenu term=reverse cterm=reverse ctermfg=NONE ctermbg=NONE gui=reverse guifg=NONE guibg=NONE

colo dracula
let g:lightline = { 'colorscheme': 'dracula' }


" Unified color scheme (default: dark)
" let g:seoul256_background = 236
" colo seoul256

" ================ Plugins Keymaps

nnoremap <leader>b :Buffers<CR>

" ================ Persistent Undo 
" Keep undo history across sessions, by storing in file.
" Only works all the time.
if has('persistent_undo')
  silent !mkdir /tmp/.vim/backups > /dev/null 2>&1
  set undodir=/tmp/.vim/backups
  set undofile
endif
"nnoremap <leader>b :buffers<CR>


" ================ FZF
" Mapping
map <C-f> :Files<CR>
nnoremap <silent> <leader>t :Tags<CR>
let g:fzf_tags_command = 'ctags -R'
nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>

" map <C-g> :Ag
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

map <leader>vl :vsp $MYVIMRC<CR>
map <leader>vr :source $MYVIMRC<CR>

" ================ Cscope
nnoremap <leader>fa :call CscopeFindInteractive(expand('<cword>'))<CR>
nnoremap <leader>l :call ToggleLocationList()<CR>
let g:cscope_silent = 1


" ================ Coc
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

" Use <TAB> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <TAB> <Plug>(coc-range-select)
xmap <silent> <TAB> <Plug>(coc-range-select)

inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Coc Navigating
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gr <Plug>(coc-references)

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" ================ NERD

nmap <leader>v :NERDTreeFind<CR>
nmap <silent> <leader><leader> :NERDTreeToggle<CR>

set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,tags

"" Nerdtree config for wildignore
let NERDTreeRespectWildIgnore=1

" ================ Buffer Copy & Paste

vmap <leader>y :w! /tmp/.vim/.vbuf<CR>
nmap <leader>y :.w! /tmp/.vim/.vbuf<CR>
nmap <leader>p :r /tmp/.vim/.vbuf<CR>

" ================ ALE
" let g:ale_linters = {
" \   'cpp': ['clangd'],
" \   'c': ['clangd'],
" \}
" let g:ale_fixers={
" \   'cpp': ['clang-format'],
" \   '*': ['remove_trailing_lines', 'trim_whitespace'],
" \}
" let g:ale_cpp_clangtidy_checks = []
" let g:ale_cpp_clangtidy_executable = 'clang-tidy'
" let g:ale_c_parse_compile_commands=1
" let g:ale_cpp_clangtidy_extra_options = ''
" let g:ale_cpp_clangtidy_options = ''
" let g:ale_set_balloons=1

" ================ Skeleton
" function! g:skeleton_replacements.BASENAME_UPPER()
"     return toupper(fnamemodify(a:filename, ':t:r'))
" endfunction

set tags+=tags;$HOME
" autocmd FileType css,html set iskeyword+=-
augroup css
    autocmd!
    autocmd FileType css,html setlocal iskeyword+=-
augroup END
let g:closetag_filenames = '*.html,*.xhtml,*.phtml'
