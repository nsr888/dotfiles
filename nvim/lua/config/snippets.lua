local map = require("utils").map

-- Load VS Code snippets
require("luasnip.loaders.from_vscode").lazy_load()

local ls = require("luasnip")
local s = ls.snippet
local f = ls.function_node

-- Config
ls.config.setup({
	-- This tells LuaSnip to remember to keep around the last snippet.
	-- You can jump back into it even if you move outside of the selection
	history = true,

	-- Updates as you type
	updateevents = "TextChanged,TextChangedI",
})

-- Keymaps
-- Expand or jump to next item
map({ "i", "s" }, "<C-j>", function()
	if ls.expand_or_jumpable() then
		ls.expand_or_jump()
	end
end)

-- Jump to previous item
map({ "i", "s" }, "<C-k>", function()
	if ls.jumpable(-1) then
		ls.jump(-1)
	end
end)

-- Selecting within a list of options.
map("i", "<c-l>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end)

local function comment(notation)
	local entry = vim.split(vim.opt.commentstring:get(), "%", true)[1]:gsub(" ", "")

	return string.format("%s %s: (%s) ", entry, notation, os.getenv("USER"))
end

-- General snippets
ls.add_snippets("all", {
	s(
		"todo",
		f(function()
			return comment("TODO")
		end)
	),
	s(
		"note",
		f(function()
			return comment("NOTE")
		end)
	),
	s(
		"fix",
		f(function()
			return comment("FIX")
		end)
	),
	s(
		"warn",
		f(function()
			return comment("WARNING")
		end)
	),
	s(
		"hack",
		f(function()
			return comment("HACK")
		end)
	),
})
