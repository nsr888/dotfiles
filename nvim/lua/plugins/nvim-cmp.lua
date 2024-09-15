return {
	"hrsh7th/nvim-cmp",
	dependencies = {
		{ "onsails/lspkind-nvim" },
		{ "hrsh7th/cmp-buffer" },
		{ "hrsh7th/cmp-path" },
		{ "hrsh7th/cmp-nvim-lsp" },
		{ "hrsh7th/cmp-nvim-lua" },
		{ "hrsh7th/cmp-calc" },
		{ "hrsh7th/cmp-emoji" },
		{ "saadparwaiz1/cmp_luasnip" },
		-- {
		-- 	"tzachar/cmp-tabnine",
		-- 	build = "./install.sh",
		-- },
		{
			"rafamadriz/friendly-snippets",
			dependencies = {
				{
					"L3MON4D3/LuaSnip",
					config = function()
						require("config.snippets")
					end,
				},
			},
		},
	},
	event = "InsertEnter",
	config = function()
		require("config.cmp")
	end,
}
