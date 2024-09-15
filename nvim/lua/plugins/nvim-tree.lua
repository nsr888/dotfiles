return {
	"kyazdani42/nvim-tree.lua",
	dependencies = { "kyazdani42/nvim-web-devicons" },
	config = function()
		require("config.nvim-tree")
	end,
	keys = {
		{ "<C-n>", ":NvimTreeToggle<CR>" },
		{ "<leader>n", ":NvimTreeFindFile<CR>" },
	},
}
