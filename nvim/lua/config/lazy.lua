-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Color scheme, requires nvim-treesitter
vim.opt.termguicolors = true
vim.g.nvcode_termcolors = 256

-- Setup lazy.nvim
require("lazy").setup({

	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- Write the lockfile to a writable location (not $XDG_CONFIG_HOME).
	lockfile = vim.fn.stdpath("data") .. "/lazy-lock.json",
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "tokyonight" } },
	-- automatically check for plugin updates
	-- checker = { enabled = true },
})
