#!/bin/sh

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

install_homebrew_bundle()
{
  echo 'export GOPATH=$HOME/golang' >> ~/.zshrc
  echo 'export GOROOT=/usr/local/opt/go/libexec' >> ~/.zshrc
  echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.zshrc
  echo 'export PATH=$PATH:$GOROOT/bin' >> ~/.zshrc
  source "$HOME/.zshrc"
	echo "Installing Homebrew…"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$($(brew --prefix)/bin/brew shellenv)"
	brew bundle --file ./brewfile
  echo "export PATH=\"$(brew --prefix)/opt/python/libexec/bin:\$PATH\"" >> ~/.profile
	echo "Homebrew Bundle Done."
}

setup_neovim()
{
	cd $HOME/Downloads/
	git clone https://github.com/neovim/neovim
	cd neovim && git checkout v0.9.2
	make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim"
	make install
	echo 'export PATH="$HOME/neovim/bin:$PATH"' >> ~/.zshrc
	cd $HOME
	echo 'alias vi="nvim"' >> ~/.zshrc
	ln -snf $DIR/nvim ~/.config/nvim
	git config --global core.editor "nvim"
}

setup_alacritty()
{
	cd $HOME/Downloads/
	git clone https://github.com/alacritty/alacritty
	cd alacritty
	make app
  cp -r target/release/osx/Alacritty.app /Applications/
	cd $HOME
}

install_go_packages()
{
    go install golang.org/x/tools/gopls@latest
    go install github.com/nametake/golangci-lint-langserver@latest
    go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
    go install github.com/daixiang0/gci@latest
    go install mvdan.cc/gofumpt@latest
    go install github.com/segmentio/golines@latest
    go install github.com/google/yamlfmt/cmd/yamlfmt@latest
}

setup_fzf()
{
    echo "Cloning 'https://github.com/junegunn/fzf'"
    [-d "$HOME/.fzf" ] || rm -rf "$HOME/.fzf"
    git clone --depth 1 "https://github.com/junegunn/fzf.git" "$HOME/.fzf"
    $HOME/.fzf/install --key-bindings --no-completion --update-rc
    source "${HOME}/.zshrc"
}

setup_npm()
{
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
  source "$HOME/.zshrc"
	nvm install v18.17.1
	nvm use v18.17.1
	npm install -g typescript typescript-language-server
	npm install -g eslint_d eslint prettier
	npm install -g vscode-langservers-extracted
	npm install -g dockerfile-language-server-nodejs
	npm install -g sql-cli
	npm install -g vls #vue
	npm install -g bash-language-server
  npm install -g yarn
  npm install -g yaml-language-server
}


install_python_packages()
{
    
    for pack in $(cat "$SCRIPTDIR/python_packages"); do
        sleep 1
        echo "Installing $pack"
        pip install $pack --user > /dev/null 2>&1
        sleep 1
    done
    
}

setup_zshrc()
{
	cd $HOME
  git clone https://github.com/olivierverdier/zsh-git-prompt
  echo 'source $HOME/zsh-git-prompt/zshrc.sh' >> ~/.zshrc
  echo 'PROMPT=''%B%m%~%b$(git_super_status) ''' >> ~/.zshrc
}

# Integrity checks
[ -f $SCRIPTDIR/Brewfile ] || (echo "The Brewfile is not there!" && exit 1)
[ -f $SCRIPTDIR/python_packages ] || (echo "The python packages file is not there!" && exit 1)

# Setup basic system

###########################################
###### The installation begins # ##########
###########################################

# install_homebrew_bundle
# install_go_packages
# setup_neovim
# setup_alacritty
# setup_fzf
# setup_npm
# install_python_packages
setup_zshrc

source "$HOME/.profile"
source "$HOME/.zshrc"

###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
