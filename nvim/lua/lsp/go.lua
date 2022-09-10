local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities()) --nvim-cmp
capabilities.textDocument.completion.completionItem.snippetSupport = true

local on_attach = function(client, bufnr)
	local function buf_set_keymap(...)
		vim.api.nvim_buf_set_keymap(bufnr, ...)
	end
	local function buf_set_option(...)
		vim.api.nvim_buf_set_option(bufnr, ...)
	end

	buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")
end

-- Setup lspconfig.
local nvim_lsp = require("lspconfig")

-- setup languages
-- GoLang
nvim_lsp["gopls"].setup({
	cmd = { "gopls" },
	on_attach = on_attach,
	capabilities = capabilities,
	settings = {
		gopls = {
			experimentalPostfixCompletions = true,
			analyses = {
				unusedparams = true,
				shadow = true,
			},
			staticcheck = true,
		},
	},
	init_options = {
		usePlaceholders = true,
	},
})

local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

if not configs.golangcilsp then
	configs.golangcilsp = {
		default_config = {
			cmd = { "golangci-lint-langserver" },
			root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
			init_options = {
				-- command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json" };
				command = { "golangci-lint", "run", "--out-format", "json" },
			},
		},
	}
end
lspconfig.golangcilsp.setup({
	filetypes = { "go" },
})
