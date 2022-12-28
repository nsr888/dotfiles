local nvim_lsp = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true

nvim_lsp.rust_analyzer.setup({
	capabilities = capabilities,
	settings = {
		["rust-analyzer"] = {
			imports = {
				granularity = {
					group = "module",
				},
				prefix = "self",
			},
			cargo = {
				buildScripts = {
					enable = true,
				},
			},
			procMacro = {
				enable = true,
			},
		},
	},
})
