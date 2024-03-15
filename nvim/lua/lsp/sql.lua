-- go install github.com/sqls-server/sqls@latest
local lspconfig = require("lspconfig")
lspconfig.sqls.setup({
	on_attach = function(client, bufnr)
		require("sqls").on_attach(client, bufnr) -- require sqls.nvim
	end,
})
