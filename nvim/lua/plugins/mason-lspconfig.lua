-- https://github.com/williamboman/mason-lspconfig.nvim/blob/main/doc/server-mapping.md
return {
	"williamboman/mason-lspconfig.nvim",
	dependencies = {
		{ "williamboman/mason.nvim" },
		{ "neovim/nvim-lspconfig" },
	},
	config = function()
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				-- npm install -g typescript typescript-language-server
				-- npm install -g vscode-langservers-extracted
				"ts_ls",
				-- npm install -g bash-language-server
				"bashls",
				-- npm install -g dockerfile-language-server-nodejs
				"dockerls",
				-- npm install -g eslint_d eslint prettier
				"eslint",
				"graphql",
				"html",
				"htmx",
				"jqls",
				"jsonls",
				"ltex",
				"markdown_oxide",
				"phpactor",
				-- npm install -g yaml-language-server
				"yamlls",
				"ruff",
			},
		})
	end,
}
