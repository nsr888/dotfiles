#!/bin/bash

# https://github.com/palikar/dotfiles/blob/986155b4bcefbd8070b7b42b1239c560e30d19ec/setuper/setup.sh 

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

install_deb_packages()
{
    sudo apt purge neovim
    sudo apt-get update

    for pack in $(cat "$SCRIPTDIR/apt_packages"); do

        echo "Installing '$pack'"

        [ dpkg -s "$pack" ] && continue
        sudo apt-get install -y $pack
        
        sleep 1

    done

    echo "Updating and upgrading packages"
    sudo apt-get update -y
    sudo apt-get upgrade -y

    echo "Removing unnecessary packages"
    sudo apt autoremove -y
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

setup_neovim()
{
    cd $HOME/Downloads/
    git clone https://github.com/neovim/neovim
    cd neovim && git checkout v0.9.4
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && cpack -G DEB && sudo dpkg -i --force-overwrite nvim-linux64.deb
    cd $HOME
    echo 'alias vi="nvim"' >> ~/.bashrc
    ln -snf $DIR/nvim ~/.config/nvim
    git config --global core.editor "nvim"
}

setup_flatpak()
{
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for pack in $(cat "$SCRIPTDIR/flatpak_packages"); do
        echo "Installing '$pack'"
        [ dpkg -s "$pack" ] && continue
        flatpak install -y --noninteractive flathub $pack
        sleep 1
    done
}

setup_fonts(){
    cd $HOME/Downloads/
    wget -O "fira.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
    unzip -o fira.zip -d $HOME/Downloads/fira
    mkdir -p ~/.fonts
    cp -f $HOME/Downloads/fira/FiraCodeNerdFontMono-Regular.ttf ~/.fonts/
    cp -f $HOME/Downloads/fira/FiraCodeNerdFontMono-Bold.ttf ~/.fonts/
    fc-cache -f -v
    cd $HOME
}

setup_go()
{
    GOVERSION='1.21.3'
    cd $HOME/Downloads/
    wget -O "go.tar.gz" "https://go.dev/dl/go${GOVERSION}.linux-$(dpkg --print-architecture).tar.gz"
    sudo rm -rf /usr/local/go 
    sudo rm -rf $HOME/go 
    mkdir -p $HOME/src/go/{bin,pkg,src}
    tar -C $HOME -xzf go.tar.gz
    echo 'export PATH=$HOME/src/go/bin:$HOME/go/bin:$PATH' >> ~/.profile
    echo 'export GOROOT=$HOME/go' >> ~/.profile
    echo 'export GOPATH=$HOME/src/go' >> ~/.profile
    echo 'export PATH=$HOME/src/go/bin:$HOME/go/bin:$PATH' >> ~/.bash_profile
    echo 'export GOROOT=$HOME/go' >> ~/.bash_profile
    echo 'export GOPATH=$HOME/src/go' >> ~/.bash_profile
    source ${HOME}/.profile
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

setup_lua_language_server()
{
    LUALANGSERVERVERSION='3.7.0'
    cd $HOME/Downloads/
    wget -O "lua-language-server.tar.gz" "https://github.com/LuaLS/lua-language-server/releases/download/${LUALANGSERVERVERSION}/lua-language-server-${LUALANGSERVERVERSION}-linux-x64.tar.gz"
    mkdir -p $HOME/lua-language-server
    tar -C $HOME/lua-language-server -xzf lua-language-server.tar.gz
    echo 'export PATH=$PATH:$HOME/lua-language-server/bin' >> ~/.profile
    echo 'export PATH=$PATH:$HOME/lua-language-server/bin' >> ~/.bashrc
    source ${HOME}/.profile
    source ${HOME}/.bashrc
    cd $HOME
}

setup_fzf()
{
    echo "Cloning 'https://github.com/junegunn/fzf'"
    [-d "$HOME/.fzf" ] || rm -rf "$HOME/.fzf"
    git clone --depth 1 "https://github.com/junegunn/fzf.git" "$HOME/.fzf"
    $HOME/.fzf/install --key-bindings --no-completion --update-rc
    source "${HOME}/.bashrc"
}

setup_npm()
{
	# update node
	sudo wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.5/install.sh | bash
	source "${HOME}/.bashrc"
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
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

install_rustc()
{
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs  | sh -s -- -y
}

install_cargo_packages()
{
  echo 'export PATH=$PATH:$HOME/.cargo/bin' >> ~/.bashrc
  # echo 'export PKG_CONFIG_PATH=/usr/lib/x86_64-linux-gnu/pkgconfig' >> ~/.bashrc
  source "${HOME}/.bashrc"
  cargo install stylua
}

setup_kubectl()
{
  cd $HOME/Downloads/
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$(dpkg --print-architecture)/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  kubectl version --client
  echo 'source <(kubectl completion bash)' >>~/.bashrc
  echo 'alias k=kubectl' >>~/.bashrc
  echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
  source "${HOME}/.bashrc"
  cd $HOME
}

setup_bashrc()
{
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
  echo 'if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then' >> ~/.bashrc
  echo '    GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
  echo '    source $HOME/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
}

install_sublime()
{
  wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null
  echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
  sudo apt-get update
  sudo apt-get install sublime-text
}

# Integrity checks
[ -f $SCRIPTDIR/apt_packages ] || (echo "The apt packages file is not there!" && exit 1)

# Setup basic system

###########################################
###### The installation begins # ##########
###########################################


install_deb_packages
setup_fzf
setup_flatpak

# Setup basic application

setup_neovim
setup_fonts
setup_go
install_go_packages
setup_npm
setup_lua_language_server
install_rustc
install_cargo_packages
setup_kubectl
install_sublime

# Finish setup

setup_bashrc

# Sourcing the new dot files

source "${HOME}/.profile"

source "${HOME}/.bashrc"


###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
