nvim-install:
	mkdir -p ~/.config/nvim
	ln -sf $(PWD)/neovim-lua-config/.config/nvim/init.lua ~/.config/nvim/init.lua
	ln -snf $(PWD)/neovim-lua-config/.config/nvim/colors ~/.config/nvim/colors
	ln -snf $(PWD)/neovim-lua-config/.config/nvim/lua ~/.config/nvim/lua

deps-typescript:
