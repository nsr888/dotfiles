# Inspiration: https://github.com/mokevnin/dotfiles/blob/master/Makefile
vim:
	ln -sf $(PWD)/.vimrc ~/.vimrc
	ln -sf $(PWD)/.vimrc ~/.ideavimrc

alacritty:
	mkdir -p ~/.config/alacritty
	ln -sf $(PWD)/alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
	ln -sf $(PWD)/alacritty/alacritty.yml ~/.config/alacritty/alacritty.yml

goinfre:
	# Make link ~/.docker -> /goinfre/ksinistr/docker
	# Make link ~/Library/Containers/com.docker.docker -> /goinfre/ksinistr/agent
	mkdir -p ~/goinfre/docker
	mkdir -p ~/goinfre/agent
	npm config set prefix '~/goinfre/.npm-global'

nvim-install:
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/nvim/init.lua ~/.config/nvim/init.lua
	ln -snf $(PWD)/nvim/colors ~/.config/nvim/colors
	ln -snf $(PWD)/nvim/lua ~/.config/nvim/lua

prepare:
	brew upgrade neovim git ripgrep fd bat exa
	brew install --HEAD universal-ctags/universal-ctags/universal-ctags

deps-npm:
	npm install -g typescript typescript-language-server
	npm install -g eslint_d eslint prettier
	# Install html, css, json and eslint language servers.
	npm install -g vscode-langservers-extracted
	npm install -g dockerfile-language-server-nodejs

deps-go:
	GO111MODULE=on go install golang.org/x/tools/gopls@latest
	# https://github.com/nametake/golangci-lint-langserver
	go get github.com/nametake/golangci-lint-langserver

deps-lua:
	npm install -g lua-fmt

deps-pip:
	pip3 install --upgrade pynvim
	pip3 install --upgrade python-lsp-server
	pip3 install --upgrade black flake8 pycodestyle pyflakes pylint autopep8

deps-sql:
	npm install -g sql-cli

deps-vue:
	npm install -g vls

deps-nvim:
	pip3 install pynvim

deps-bash:
	bash-language-server

.PHONY: vim alacritty goinfre nvim-install prepare deps-npm deps-go deps-lua deps-pip deps-sql deps-vue deps-nvim deps-bash
