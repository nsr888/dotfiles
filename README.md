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
## Useful links
* https://wiki.archlinux.org/index.php/Neovim
* https://guides.hexlet.io/vim/
* https://vimawesome.com/
* https://github.com/mcchrish/vim-no-color-collections
* https://github.com/mokevnin/dotfiles/blob/master/files/vimrc
# Ctags
## Replace ctag in mac
```bash
brew install ctag
```
```bash
alias ctags="`brew --prefix`/bin/ctags  -R --exclude=.git --exclude=log"
```
## Links
* https://medium.com/@galea/getting-started-with-ctags-vim-on-macos-87bcb07cf6d
