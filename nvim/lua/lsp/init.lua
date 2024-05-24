-- require all language server modules
-- null-ls for tsutils plugin
require("lsp/typescript")
-- require("lsp/vue")
-- require("lsp/frontend")
require("lsp/luals")
require("lsp/python")
-- require("lsp/cpp")
require("lsp/go")
require("lsp/yamlls")
require("lsp/php")
require("lsp/kotlin")
-- require("lsp/sql")
-- require("lsp/rust")
-- require("lsp/ocaml")
-- require("lsp/haskell")
-- require("lsp/bufls")
-- require("lsp/flutter")
-- require("lspconfig").dockerls.setup {}
-- require "lspconfig".bashls.setup {
--   filetypes = {"sh", "zsh"} -- Added support to "zsh" files
-- }

-- Customization and appearance -----------------------------------------
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization
--

-- borders --------------------------------

vim.cmd([[autocmd! ColorScheme * highlight NormalFloat guibg=#1f2335]])
vim.cmd([[autocmd! ColorScheme * highlight FloatBorder guifg=white guibg=#1f2335]])

local border = {
	{ "▔", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "▔", "FloatBorder" },
	{ "▕", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "▁", "FloatBorder" },
	{ "▏", "FloatBorder" },
}

-- LSP settings (for overriding per client)
local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
	["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = border }),
}

-- Do not forget to use the on_attach function
-- require("lspconfig").myserver.setup({ handlers = handlers })

-- To instead override globally
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
	opts = opts or {}
	opts.border = opts.border or border
	return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

-- require("lspconfig").myservertwo.setup({})

------------------
-- Customizing how diagnostics are displayed
------------------

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = false,
})

------------------
-- Change diagnostic symbols in the sign column (gutter)
------------------

local signs = { Error = "󰅚", Warn = "󰀪", Hint = "", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

------------------
-- Go-to definition in a split window
------------------

local function goto_definition(split_cmd)
	local util = vim.lsp.util
	local log = require("vim.lsp.log")
	local api = vim.api

	-- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
	local handler = function(_, result, ctx)
		if result == nil or vim.tbl_isempty(result) then
			local _ = log.info() and log.info(ctx.method, "No location found")
			return nil
		end

		if split_cmd then
			vim.cmd(split_cmd)
		end

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1])

			if #result > 1 then
				util.set_qflist(util.locations_to_items(result))
				api.nvim_command("copen")
				api.nvim_command("wincmd p")
			end
		else
			util.jump_to_location(result)
		end
	end

	return handler
end

vim.lsp.handlers["textDocument/definition"] = goto_definition("split")
