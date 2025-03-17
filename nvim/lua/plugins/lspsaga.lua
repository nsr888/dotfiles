return {
	"nvimdev/lspsaga.nvim",
	config = function()
		require("lspsaga").setup({})
	end,
	opts = {
		debug = true,
	},
	dependencies = {
		"nvim-treesitter/nvim-treesitter", -- optional
		"nvim-tree/nvim-web-devicons", -- optional
	},
}
