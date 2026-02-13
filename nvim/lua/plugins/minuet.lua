return {
	"milanglacier/minuet-ai.nvim",
	lazy = false,
	enabled = vim.env.AI_COMPLETION_PROVIDER == "minuet",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("config.minuet")
	end,
}
