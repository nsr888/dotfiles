# Dotfiles

This is my collection of neovim and vim configurations:

- [basic-vim-config] - basic classic vim setup
- [cpp-neovim-config] - cpp projects setup with CoC.nvim
- [neovim-lua-config] - latest (neovim >= 0.5) js typescript setup (leaving the CoC behind)

## Usage

Pull the repository, and then create the symbolic links [using GNU
stow](https://alexpearce.me/2016/02/managing-dotfiles-with-stow/).

```bash
$ git clone git@github.com:nsr888/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ stow neovim-lua-config # will create soft link to ~/.config/nvim/
```
