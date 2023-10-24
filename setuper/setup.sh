#!/bin/bash

# https://github.com/palikar/dotfiles/blob/986155b4bcefbd8070b7b42b1239c560e30d19ec/setuper/setup.sh 

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..

install_deb_packages()
{
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

}

setup_neovim()
{
    cd $HOME/Downloads/
    git clone https://github.com/neovim/neovim
    cd neovim && git checkout v0.9.2
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
    cd $HOME
    echo 'alias vi="nvim"' >> ~/.bashrc
    ln -snf $DIR/nvim ~/.config/nvim
    git config --global core.editor "nvim"
}

setup_fonts(){
    cd $HOME/Downloads/
    wget -O "fira.zip" "https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/FiraCode.zip"
    unzip -o fira.zip -d $HOME/Downloads/fira
    mkdir -p ~/.fonts
    cp -f $HOME/Downloads/fira/FiraCodeNerdFont-Regular.ttf ~/.fonts/
    fc-cache -f -v
    cd $HOME
}

setup_go()
{
    GOVERSION='1.21.1'
    cd $HOME/Downloads/
    wget -O "go.tar.gz" "https://go.dev/dl/go${GOVERSION}.linux-$(dpkg --print-architecture).tar.gz"
    sudo rm -rf /usr/local/go 
    sudo tar -C /usr/local -xzf go.tar.gz
    mkdir -p $HOME/go/{bin,pkg,src}
    echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.profile
    echo 'export GOPATH=$HOME/go' >> ~/.profile
    echo 'export GOBIN=$GOPATH/bin' >> ~/.profile
    echo 'export PATH=$PATH:$GOBIN' >> ~/.profile
    source ${HOME}/.profile
    cd $HOME
}

install_go_packages()
{
    go install golang.org/x/tools/gopls@latest
    go install github.com/nametake/golangci-lint-langserver@latest
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
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/arm64/kubectl"
  sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  kubectl version --client
  echo 'source <(kubectl completion bash)' >>~/.bashrc
  echo 'alias k=kubectl' >>~/.bashrc
  echo 'complete -o default -F __start_kubectl k' >>~/.bashrc
  source "${HOME}/.bashrc"
  cd $HOME
}

# https://gist.github.com/matthew01lokiet/3775469acf8137621b42e9d059695c2c
setup_docker()
{
  sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install -y \
      ca-certificates \
      curl \
      gnupg \
      lsb-release
  sudo rm -rf /usr/share/keyrings/docker-archive-keyring.gpg
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release; echo "$UBUNTU_CODENAME") stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  sudo usermod -a -G docker $USER
  sudo curl -L "https://github.com/docker/compose/releases/download/v2.2.2/docker-compose-linux-$(uname -m)" -o /usr/local/bin/docker-compose
  sudo chmod +x /usr/local/bin/docker-compose
}

# TODO: replace to open lens setup
setup_lens()
{
  curl -fsSL https://downloads.k8slens.dev/keys/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/lens-archive-keyring.gpg > /dev/null
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/lens-archive-keyring.gpg] https://downloads.k8slens.dev/apt/debian stable main" | sudo tee /etc/apt/sources.list.d/lens.list > /dev/null
  sudo apt update
  sudo apt install lens
}

setup_discord()
{
    cd $HOME/Downloads/
    sudo apt-get install ninja-build gettext cmake unzip curl
    wget -O "discord.deb" "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo dpkg -i "discord.deb"
    sudo apt-get -f install -y
    cd $HOME
}

# setup_alacritty()
# {
#     cd $HOME/Downloads/
#     git clone https://github.com/jwilm/alacritty.git
#     cd alacritty
#     cargo build --release
#     sudo cp target/release/alacritty /usr/local/bin
#     sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
#     sudo desktop-file-install extra/linux/Alacritty.desktop
#     sudo update-desktop-database
#     cd $HOME
# }

setup_calibre()
{
  sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
}

setup_vscode()
{
  cd $HOME/Downloads/
  wget -O "vscode.deb" "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64"
  # sudo apt install ./vscode.deb
  # If you're on an older Linux distribution, you will need to run this instead:
  sudo dpkg -i "vscode.deb"
  sudo apt-get -f install -y
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

# Integrity checks
[ -f $SCRIPTDIR/apt_packages ] || (echo "The apt packages file is not there!" && exit 1)


# Setup basic system

###########################################
###### The installation begins # ##########
###########################################


# install_deb_packages

# Setup basic application

# setup_neovim
# setup_fonts
# setup_go
# install_go_packages
# setup_npm
# setup_lua_language_server
# install_cargo_packages
# setup_kubectl


# Setup essenital applications

# setup_docker
# setup_lens
# setup_discord
# setup_calibre
# setup_vscode
# setup_bashrc

# Sourcing the new dot files

source "${HOME}/.profile"

source "${HOME}/.bashrc"


###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
