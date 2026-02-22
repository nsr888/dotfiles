-- Treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	config = function()
		require("config.treesitter")
	end,
	build = ":TSUpdate",
}
