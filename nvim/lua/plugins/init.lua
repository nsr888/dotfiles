return {
	-- { "echasnovski/mini.nvim", version = false },
	{ "github/copilot.vim", lazy = false },
	{ "tami5/lspsaga.nvim", branch = "main" },

	{ "christianchiarulli/nvcode-color-schemes.vim", lazy = true },

	-- "airblade/vim-gitgutter",

	-- bufonly, close all buffers except current one
	{ "numtostr/BufOnly.nvim", cmd = "BufOnly" },

	-- "tpope/vim-fugitive",
	-- "tpope/vim-surround",

	-- Fzf
	{
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
		event = { "BufReadPost" },
	},
	{ "junegunn/fzf.vim", dependencies = "junegunn/fzf" },

	{ "jremmen/vim-ripgrep", cmd = { "Rg" } },
	{ "aklt/plantuml-syntax" },
	{ "tyru/open-browser.vim" },
	{ "weirongxu/plantuml-previewer.vim" },
	{ "rhysd/git-messenger.vim" },

	-- react native
	-- use("dimaportenko/telescope-simulators.nvim")

}
