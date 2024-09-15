-- Indent Blankline
return {
	"lukas-reineke/indent-blankline.nvim",
	event = "BufRead",
	config = function()
		require("config.indent-blankline")
	end,
}
