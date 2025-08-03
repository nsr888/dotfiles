#!/bin/bash

# https://github.com/palikar/dotfiles/blob/986155b4bcefbd8070b7b42b1239c560e30d19ec/setuper/setup.sh 

SCRIPTDIR=$(dirname "$(readlink -f "$0")")
DIR=$SCRIPTDIR/..
NEOVIM_VERSION=0.11.2

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
    sudo apt remove neovim
    cd "$HOME"/Downloads/ || exit
    rm -rf "$HOME"/Downloads/neovim
    git clone https://github.com/neovim/neovim
    cd neovim && git checkout v$NEOVIM_VERSION
    make CMAKE_BUILD_TYPE=RelWithDebInfo
    sudo make install
    cd "$HOME" || exit
    echo 'alias vim="/usr/bin/vi"' >> ~/.bashrc
    echo 'alias vi="/usr/local/bin/nvim"' >> ~/.bashrc
    ln -snf "$DIR"/nvim ~/.config/nvim
    git config --global core.editor "nvim"
    rm -rf "$HOME"/Downloads/neovim
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

setup_goenv()
{
  echo 'export GOPATH="$HOME/go"' >> ~/.bashrc
  echo 'export GOMODCACHE="$GOPATH/pkg/mod"' >> ~/.bashrc
  # Installing Go
  cd $HOME/Downloads/
  git clone https://github.com/go-nv/goenv.git ~/.goenv
  echo 'export GOENV_ROOT="$HOME/.goenv"' >> ~/.bashrc
  echo 'export PATH="$GOENV_ROOT/bin:$PATH"' >> ~/.bashrc
  source "${HOME}/.bashrc"
  cd $HOME
}

setup_go()
{
  goenv install 1.23.6
  goenv global 1.23.6
}

setup_gopackages()
{
  # Installing additional Go tools
  curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/HEAD/install.sh | sh -s -- -b $(go env GOPATH)/bin v1.63.4
  go install github.com/nametake/golangci-lint-langserver@latest
  go install golang.org/x/tools/gopls@latest
  go install github.com/daixiang0/gci@latest
  go install mvdan.cc/gofumpt@latest
  go install github.com/segmentio/golines@latest
  go install github.com/google/yamlfmt/cmd/yamlfmt@latest
  source "${HOME}/.bashrc"
}

setup_nvm()
{
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
	source "${HOME}/.bashrc"
}

setup_node()
{
  echo 'export NVM_DIR="$HOME/.nvm"' >> ~/.bashrc
  echo '[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"' >> ~/.bashrc
  echo '[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"' >> ~/.bashrc
	source "${HOME}/.bashrc"
	nvm install --lts
	nvm install v16.20.0
	nvm use --lts
	source "${HOME}/.bashrc"
}

setup_node_packages()
{
	npm install -g typescript typescript-language-server
	npm install -g eslint_d eslint prettier
	npm install -g vscode-langservers-extracted
	npm install -g dockerfile-language-server-nodejs
	npm install -g sql-cli
	npm install -g bash-language-server
  npm install -g yarn
  npm install -g yaml-language-server
}

setup_bashhistory()
{
  # Use a heredoc for cleaner multi-line appends
  cat <<'EOF' >> ~/.bashrc

# --- Enhanced Bash History ---
# Don't store duplicates or commands starting with a space.
# Erase all previous duplicate lines from history.
export HISTCONTROL=ignoreboth:erasedups
# Set a very large history size.
export HISTSIZE=1000000
export HISTFILESIZE=1000000
# Add timestamps to history entries.
export HISTTIMEFORMAT="%F %T "
# Append to the history file, don't overwrite it.
shopt -s histappend
# After each command, append to the history file and reread it,
# which shares history across all open terminals.
export PROMPT_COMMAND="history -a; history -c; history -r; ${PROMPT_COMMAND}"
# --- End Enhanced Bash History ---
EOF
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

# install_deb_packages
# setup_fzf
# setup_flatpak

# Setup basic application

# setup_fonts
# setup_lua_language_server
# install_rustc
# install_cargo_packages
# setup_kubectl
# install_sublime
# setup_bashrc
# setup_neovim
# setup_bashhistory
# setup_goenv
# setup_go
# setup_gopackages
# setup_nvm
# setup_node
# setup_node_packages

# Sourcing the new dot files

source "${HOME}/.profile"

source "${HOME}/.bashrc"


###########################################
###### The installation is ready ##########
###########################################

echo "Let the games begin!"
