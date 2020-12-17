# Vim (neovim) config for C/C++ projects in 42 school
## Requirements
* Mac or Linux
* [Neovim](https://neovim.io/)
* [Silver Searcher (ag)](https://github.com/ggreer/the_silver_searcher)
* [nodejs](https://nodejs.org/en/download/) >= 10.12 for coc.nvim plugin 

To install nodejs run:

```
curl -sL install-node.now.sh/lts | bash
```

## Step by step configuration
#### 1. Clone this repo to `~/dotfiles`
```bash
git clone https://github.com/sun604/dotfiles ~/dotfiles
```
#### 2. Symlinking init.vim to .vimrc
```bash
ln -s ~/dotfiles/.vimrc ~/.config/nvim/init.vim
```
And for cpp/hpp templates I use [vim-skeletons](https://github.com/noahfrederick/vim-skeleton) templates, so it needed to make apropriate linking:
```bash
ln -s ~/dotfiles/templates ~/.vim/templates
```

#### 3. Replacing `vi` and `vim` commands with neovim
Add this aliases in your `.profile`, for zsh this will be `.zshrc`
```bash
alias vim="nvim"
alias vi="nvim"
alias oldvim="/usr/bin/vim"
```
#### 4. Replace default ctags in macos with [universal ctags](https://github.com/universal-ctags/ctags)
Install universal ctags:
```bash
brew install ctags
```
Add this alias in your `.profile` (for zsh this will be `.zshrc`):
```bash
alias ctags="`brew --prefix`/bin/ctags  -R --exclude=.git"
```
To generate `tags` file for vim (neovim), run in project folder:
```bash
ctags .
```
#### 5. Install [cscope](http://cscope.sourceforge.net/)
```bash
brew install cscope
```
To generate `cscope.out` file for vim (neovim), run in project folder:
```bash
cscope -R -b .
```
#### 6. Install [Silver Searcher (Ag)](https://github.com/ggreer/the_silver_searcher)
```bash
brew install the_silver_searcher
```
Your can add bellow command to `~/.zshrc`
```bash
export FZF_DEFAULT_COMMAND='ag -g ""'
```
#### 7. Open vim and run `:PlugInstall` to install all plugins
#### 8. Install [coc.nvim](https://github.com/neoclide/coc.nvim) plugin dependencies
>	Coc.vim used for:
>	* language and project specific autocompletion and suggestions;
>	* error markups;
>	* functions and structures documentation.
##### 8.1 Install [clangd](https://github.com/clangd/clangd)
1. Download latest stable release https://github.com/clangd/clangd/releases/tag/10.0.0
2. Unpack it to ~/clangd/bin ~/clangd/lib
3. Add to `~/.zshrc`:
```bash
export PATH="/Users/<name>/clangd/bin:/Users/<name>/clangd/lib:$PATH"
```
4. Open vim, run `:CocConfig` and place this config:
```json
{
    "diagnostic.displayByAle": true,
    "languageserver": {
        "clangd": {
            "command": "clangd",
            "rootPatterns": ["compile_flags.txt", "compile_commands.json"],
            "filetypes": ["c", "cpp", "objc", "objcpp"]
        }
    }
}
```
##### 8.2 Install [Bear](https://github.com/rizsotto/Bear)
Bear can make project setup for clangd.
It can be installed via homebrew:
```bash
brew install bear
```
Below command in project folder will generate file `compile_commands.json` for clangd:
```bash
make clean; bear make
```
#### 9 Add `.clang-format` file
Add into project `.clang-format` with following content. 
This will disable autoformatting code with coc.nvim.
```
DisableFormat: true
```
#### 10 ALE (Asynchronous Lint Engine) configuration

The easiest way to get coc.nvim and ALE work together is to configure coc.nvim to send diagnostics to ALE, so ALE controls how all problems are presented to you, and to disable all LSP features in ALE, so ALE doesn't try to provide LSP features already provided by coc.nvim, such as auto-completion.

1. Open your coc.nvim configuration file with :CocConfig and add "diagnostic.displayByAle": true to your settings.
2. Add let g:ale_disable_lsp = 1 to your vimrc file, before plugins are loaded.

##### 10.1 Install cppcheck (static analysis of c/c++ code)

It will be used automaticly by ALE

```
brew install cppcheck
```

##### 10.2 Install clang-tidy (static analysis of c/c++ code)

It will be used automaticly by ALE

Easeast way to install by installing LLVM via brew: `brew install llvm`, but LLVM has size about 1Gb. So I recommend to download prebuild binaries from:

https://releases.llvm.org/download.html#11.0.0

Extract downloaded archive and copy only `clang-tidy` and `include` folder:

```
copy ~/Downloads/clang+llvm-11.0.0-x86_64-apple-darwin/bin/clang-tidy ~/clangd/bin/
copy -r ~/Downloads/clang+llvm-11.0.0-x86_64-apple-darwin/include/ ~/clangd/
```
#### 11. Fix vim-skeleton plugin for better hpp files support

In file `vim-skeleton/autoload/skeleton.vim`, after line:

```vimscript
call skeleton#Replace('BASENAME', basename)
```

I add add rule for uppercase basename, so it will become look like this:
```vimscript
call skeleton#Replace('BASENAME', basename)
call skeleton#Replace('BASENAME_UPPER', toupper(basename))
```


## Useful links
* https://wiki.archlinux.org/index.php/Neovim
* https://guides.hexlet.io/vim/
* https://www.youtube.com/watch?v=79OWQ1qJwto
* https://github.com/mokevnin/dotfiles/blob/master/files/vimrc
* https://vimawesome.com/
* https://github.com/mcchrish/vim-no-color-collections
* https://medium.com/@galea/getting-started-with-ctags-vim-on-macos-87bcb07cf6d
