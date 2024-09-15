-- Treesitter
return {
	"nvim-treesitter/nvim-treesitter",
	config = function()
		require("config.treesitter")
	end,
	build = ":TSUpdate",
}
