return {
	"Davidyz/VectorCode",
	version = "*", -- optional, depending on whether you're on nightly or release
	build = "uv tool upgrade vectorcode", -- This helps keeping the CLI up-to-date
	dependencies = { "nvim-lua/plenary.nvim" },
	cmd = "VectorCode", -- if you're lazy-loading VectorCode
	config = function()
		require("config.vectorcode")
	end,
}
