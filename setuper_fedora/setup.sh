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

setup_docker()
{
	sudo dnf install -y dnf-plugins-core
	sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
	sudo dnf install -y docker-ce docker-ce-cli containerd.io
	sudo systemctl start docker
	sudo gpasswd -a ${USER} docker && sudo systemctl restart docker
	newgrp docker
}

setup_bashrc()
{
  echo 'eval "$(fzf --bash)"' >> ~/.bashrc
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
  echo "export PROMPT_COMMAND='history -a'" >> ~/.bashrc
}

setup_vimrc()
{
  cp ../.vimrc ~/
}

setup_cargo_packages()
{
  echo 'export PATH=$PATH:$HOME/.cargo/bin' >> ~/.bashrc
  source "${HOME}/.bashrc"
  cargo install stylua
  cargo install sleek
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

setup_asdf()
{
  git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.1
  echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
  echo '. "$HOME/.asdf/completions/asdf.bash"' >> ~/.bashrc
  source "${HOME}/.bashrc"
  asdf plugin add asdf-plugin-manager https://github.com/asdf-community/asdf-plugin-manager.git
  asdf plugin update asdf-plugin-manager v1.3.1
  asdf install asdf-plugin-manager 1.3.1
  # Install specific version
  asdf install asdf-plugin-manager 1.3.1
  # Set a version globally (on your ~/.tool-versions file)
  asdf global asdf-plugin-manager 1.3.1
  # Now asdf-plugin-manager command is available
  asdf-plugin-manager version
  source "${HOME}/.bashrc"
}

setup_asdf_plugins()
{
  # Copy plugins-versions
  cp .plugin-versions ~/
  # Add all plugins according to .plugin-versions file
  asdf-plugin-manager add-all
  source "${HOME}/.bashrc"
}

setup_asdf_golang()
{
  cp .default-golang-pkgs ~/
  asdf install golang 1.22.5
  asdf global golang 1.22.5
  source "${HOME}/.bashrc"
}

setup_asdf_golangci()
{
  asdf install golangci-lint 1.61.0
  asdf global golangci-lint 1.61.0
  source "${HOME}/.bashrc"
}

setup_asdf_nodejs()
{
  asdf install nodejs 16.20.0
  asdf install nodejs 18.17.1
  asdf global nodejs 18.17.1
}

setup_gitprompt()
{
  git clone https://github.com/magicmonty/bash-git-prompt.git ~/.bash-git-prompt --depth=1
  echo 'if [ -f "$HOME/.bash-git-prompt/gitprompt.sh" ]; then' >> ~/.bashrc
  echo '    GIT_PROMPT_ONLY_IN_REPO=1' >> ~/.bashrc
  echo '    source $HOME/.bash-git-prompt/gitprompt.sh' >> ~/.bashrc
  echo 'fi' >> ~/.bashrc
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

# Integrity checks
[ -f $SCRIPTDIR/dnf_packages ] || (echo "The dnf packages file is not there!" && exit 1)

# Setup basic system

###########################################
###### The installation begins # ##########
###########################################

# install_packages
# setup_neovim
# setup_flatpak
# setup_docker
# setup_bashrc
# setup_vimrc
# setup_asdf
# setup_asdf_plugins
# setup_asdf_golang
# setup_asdf_golangci
# setup_asdf_nodejs
# setup_gitprompt
# setup_kubectl
# setup_cargo_packages
setup_fonts

# Sourcing the new dot files

source "${HOME}/.bash_profile"
source "${HOME}/.bashrc"

###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
