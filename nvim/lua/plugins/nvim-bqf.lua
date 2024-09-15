-- Quickfix enhancements
return {
	"kevinhwang91/nvim-bqf",
	dependencies = {
		{ "junegunn/fzf", lazy = true },
		{ "junegunn/fzf.vim", lazy = true },
	},
	ft = { "qf" },
	config = function()
		require("bqf").setup({
			auto_enable = true,
		})
	end,
}
