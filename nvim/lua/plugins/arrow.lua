return {
	"otavioschwanck/arrow.nvim",
	dependencies = {
		-- { "nvim-tree/nvim-web-devicons" },
		-- or if using `mini.icons`
		{ "echasnovski/mini.icons" },
	},
	keys = {
		{
			"<leader>;",
			"<Cmd>Arrow open<CR>",
			mode = { "n" },
			desc = "[arrow] file anchor",
		},
	},
	opts = {
		show_icons = true,
		-- leader_key = ";", -- Recommended to be a single key
		-- buffer_leader_key = "m", -- Per Buffer Mappings
	},
}
