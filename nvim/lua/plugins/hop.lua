-- fast move around code
return {
	"smoka7/hop.nvim",
	version = "*",
	opts = {
		keys = "etovxqpdygfblzhckisuran",
	},
	keys = {
		{ "f", ":HopWord<cr>" },
		{ "F", ":HopLine<cr>" },
		{ "<leader>,", ":HopChar1<cr>" },
	},
}
