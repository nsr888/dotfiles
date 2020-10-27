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
## Replace default ctag in macos
```bash
brew install ctags
```
```bash
alias ctags="`brew --prefix`/bin/ctags  -R --exclude=.git --exclude=log"
```
In project folder
```bash
ctags .
```
## Links
* https://medium.com/@galea/getting-started-with-ctags-vim-on-macos-87bcb07cf6d
# Cscope
```bash
brew install cscope
```
In project folder
```bash
cscope -R -b .
```
# Ag
```bash
brew install the_silver_searcher
```
May be add to ~/.zshrc
```bash
export FZF_DEFAULT_COMMAND='ag -g ""'
```
# Coc.vim
## Clangd
1. Download latest stable release https://github.com/clangd/clangd/releases/tag/10.0.0
2. Place in ~/clangd/bin ~/clangd/lib
3. Add to ~/.zshrc
```bash
export PATH="/Users/<name>/clangd/bin:/Users/<name>/clangd/lib:$PATH"
```
4. CocConfig
```json
{
    "languageserver": {
        "clangd": {
            "command": "clangd",
            "rootPatterns": ["compile_flags.txt", "compile_commands.json"],
            "filetypes": ["c", "cpp", "objc", "objcpp"]
        }
    }
}
```
## Bear
It needed to make compile_commands.json for clangd
```bash
brew install bear
```
In project folder
```bash
bear make
```
