-- C, C++ -->  clangd
--- https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#clangd
require("lspconfig").clangd.setup({
	filetypes = { "c", "cpp" },
})
