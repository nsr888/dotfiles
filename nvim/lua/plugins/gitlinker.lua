return {
	"ruifm/gitlinker.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("config.gitlinker")
	end,
}
