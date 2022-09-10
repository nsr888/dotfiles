-- Inspired https://gist.github.com/horseinthesky/26d813d2974b27b5d142bb8a412d2ba3
-- Config
local cmp = require("cmp")

require("cmp_nvim_lsp")
require("cmp_buffer")
require("cmp_nvim_lsp")
require("cmp_nvim_lua")
require("cmp_calc")
require("cmp_emoji")
require("cmp_luasnip")

local tabnine = require("cmp_tabnine")
tabnine:setup({
	max_lines = 100,
	max_num_results = 5,
	sort = true,
})

local kind_icons = {
	Text = "",
	Method = "",
	Function = "",
	Constructor = "",
	Field = "ﰠ",
	Variable = "",
	Class = "",
	Interface = "",
	Module = "",
	Property = "ﰠ",
	Unit = "塞",
	Value = "",
	Enum = "",
	Keyword = "",
	Snippet = "",
	Color = "",
	File = "",
	Reference = "",
	Folder = "",
	EnumMember = "",
	Constant = "",
	Struct = "פּ",
	Event = "",
	Operator = "",
	TypeParameter = "",
}

local t = function(str)
	return vim.api.nvim_replace_termcodes(str, true, true, true)
end

cmp.setup({
	preselect = cmp.PreselectMode.None,
	snippet = {
		-- REQUIRED - you must specify a snippet engine
		expand = function(args)
			-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
			require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		-- documentation = cmp.config.window.bordered(),
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			vim_item.kind = kind_icons[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				path = "[Path]",
				nvim_lsp = "[LSP]",
				nvim_lua = "[Lua]",
				calc = "[Calc]",
				emoji = "[Emoji]",
				luasnip = "[LuaSnip]",
				cmp_tabnine = "[TabNine]",
			})[entry.source.name]

			return vim_item
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-n>"), "n")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if vim.fn.pumvisible() == 1 then
				vim.fn.feedkeys(t("<C-p>"), "n")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "cmp_tabnine" },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "calc" },
		{ name = "emoji" },
	},
})
