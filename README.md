## Symlinking init.vim to .vimrc
```bash
ln -s ~/dotfiles/.vimrc ~/.config/nvim/init.vim
```
## Replacing vi and vim with neovim
```bash
alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
```
## Ctags for mac
```bash
alias ctags="`brew --prefix`/bin/ctags  -R --exclude=.git --exclude=log"
```
https://wiki.archlinux.org/index.php/Neovim
