#!/bin/bash

# https://github.com/palikar/dotfiles/blob/986155b4bcefbd8070b7b42b1239c560e30d19ec/setuper/setup.sh 

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

install_packages()
{
    sudo dnf check-update

    for pack in $(cat "$SCRIPTDIR/dnf_packages"); do
        echo "Installing '$pack'"
        sudo dnf install -y $pack
        
        sleep 1
    done

    echo "Updating and upgrading packages"
    sudo dnf check-update -y
    sudo dnf upgrade -y

    echo "Removing unnecessary packages"
    sudo dnf autoremove -y
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
}

setup_docker()
{
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install -y docker-ce docker-ce-cli containerd.io
	sudo systemctl start docker
	sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
	newgrp docker
}

setup_neovim()
{
    sudo dnf remove neovim
    cd $HOME/Downloads/
    git clone https://github.com/neovim/neovim
    cd neovim && git checkout v0.9.4
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd $HOME
    echo 'alias vim="/usr/bin/vi"' >> ~/.bashrc
    echo 'alias vi="/usr/local/bin/nvim"' >> ~/.bashrc
    ln -snf $DIR/nvim ~/.config/nvim
    git config --global core.editor "nvim"
}

setup_flatpak()
{
    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    for pack in $(cat "$SCRIPTDIR/flatpak_packages"); do
        echo "Installing '$pack'"
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
    local GOVERSION=$1
    cd $HOME/Downloads/
    wget -O "go.tar.gz" "https://go.dev/dl/go${GOVERSION}.linux-arm64.tar.gz"
    sudo rm -rf /usr/local/go 
    mkdir -p $HOME/go${GOVERSION}
    mkdir -p $HOME/src/go/{bin,pkg,src}
    tar -C $HOME/go${GOVERSION} -xzf go.tar.gz
    echo "export PATH=$HOME/src/go/bin:$HOME/go${GOVERSION}/go/bin:$PATH" >> ~/.profile_go${GOVERSION}
    echo "export GOPATH=$HOME/src/go" >> ~/.profile_go${GOVERSION}
    echo "export GOROOT=$HOME/go${GOVERSION}/go" >> ~/.profile_go${GOVERSION}
    echo "source ~/.profile_go${GOVERSION}" >> ~/.bashrc
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
    wget -O "lua-language-server.tar.gz" "https://github.com/LuaLS/lua-language-server/releases/download/${LUALANGSERVERVERSION}/lua-language-server-${LUALANGSERVERVERSION}-linux-arm64.tar.gz"
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
    rm -rf "$HOME/.fzf"
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
  # node 16 too old for copilot, but 16.20 used on my work
	# nvm install v16.20.0
	# nvm use v16.20.0
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
  source "${HOME}/.bashrc"
  cargo install stylua
  cargo install sleek
}

setup_kubectl()
{
  cd $HOME/Downloads/
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
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
  # git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
  # echo 'if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then' >> ~/.bashrc
  # echo '    GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
  # echo '    source $HOME/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
  # echo 'fi' >> ~/.bashrc
  echo "export PROMPT_COMMAND='history -a'" >> ~/.bashrc
}

setup_vimrc()
{
  cp ../.vimrc ~/
}

# Integrity checks
[ -f $SCRIPTDIR/dnf_packages ] || (echo "The dnf packages file is not there!" && exit 1)

# Setup basic system

###########################################
###### The installation begins # ##########
###########################################


# install_packages
# setup_docker
# setup_fzf
# setup_flatpak

# Setup basic application

# setup_neovim
# setup_fonts
# setup_go "1.19"
# setup_go "1.20.13"
# setup_go "1.21.3"
# setup_go "1.21.10"
# setup_go "1.22.1"
# setup_go "1.22.3"
setup_go "1.22.6"
# install_go_packages
# setup_npm
# setup_lua_language_server
# install_rustc
# install_cargo_packages
# setup_kubectl
# setup_vimrc

# Finish setup

setup_bashrc

# Sourcing the new dot files

source "${HOME}/.bash_profile"
source "${HOME}/.bashrc"

###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
