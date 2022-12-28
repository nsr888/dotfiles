local fn = vim.fn
local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- settings for lua-language-server can be found on https://github.com/sumneko/lua-language-server/wiki/Settings .
lspconfig.sumneko_lua.setup({
	settings = {
		Lua = {
			runtime = {
				-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { "vim" },
			},
			workspace = {
				-- Make the server aware of Neovim runtime files,
				-- see also https://github.com/sumneko/lua-language-server/wiki/Libraries#link-to-workspace .
				-- Lua-dev.nvim also has similar settings for sumneko lua, https://github.com/folke/lua-dev.nvim/blob/main/lua/lua-dev/sumneko.lua .
				library = {
					fn.stdpath("data") .. "/site/pack/packer/opt/emmylua-nvim",
					fn.stdpath("config"),
				},
				maxPreload = 2000,
				preloadFileSize = 50000,
			},
		},
	},
	capabilities = capabilities,
})
