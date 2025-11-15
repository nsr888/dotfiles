return {
	"huynle/ogpt.nvim",
	dev = true,
	event = "VeryLazy",
	keys = {
		{
			"<leader>]]",
			"<cmd>OGPTFocus<CR>",
			desc = "GPT",
		},
		{
			"<leader>]",
			":'<,'>OGPTRun<CR>",
			desc = "GPT",
			mode = { "n", "v" },
		},
	},
	opts = {
		default_provider = "openrouter",
		providers = {
			openrouter = {
				api_host = os.getenv("OPENAI_BASE_URL") or "http://localhost:11434",
				api_key = os.getenv("OPENAI_API_KEY") or "",
			},
		},
		edgy = false,
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
	},
}
