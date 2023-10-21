-- If we do not wish to wait for timeoutlen
vim.api.nvim_set_keymap("n", "<Leader>w", "<Esc>:WhichKey '' n<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<Leader>w", "<Esc>:WhichKey '' v<CR>", { noremap = true, silent = true })

-- https://github.com/folke/which-key.nvim#colors
vim.cmd([[highlight default link WhichKey          htmlH1]])
vim.cmd([[highlight default link WhichKeySeperator String]])
vim.cmd([[highlight default link WhichKeyGroup     Keyword]])
vim.cmd([[highlight default link WhichKeyDesc      Include]])
vim.cmd([[highlight default link WhichKeyFloat     CursorLine]])
vim.cmd([[highlight default link WhichKeyValue     Comment]])

require("which-key").setup({
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		-- the presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		spelling = {
			enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset / operators plugin above
	operators = { gc = "Comments" },
	key_labels = {
		-- override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		["<space>"] = "SPC",
		["<cr>"] = "RET",
		["<tab>"] = "TAB",
	},
	icons = {
		breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
		separator = "➜", -- symbol used between a key and it's label
		group = "+", -- symbol prepended to a group
	},
	window = {
		border = "none", -- none, single, double, shadow
		position = "bottom", -- bottom, top
		margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
		padding = { 1, 1, 1, 1 }, -- extra window padding [top, right, bottom, left]
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 50 }, -- min and max width of the columns
		spacing = 5, -- spacing between columns
	},
	hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	-- triggers = {"<leader>"} -- or specifiy a list manually
})

local wk = require("which-key")
wk.register({
	-- load
	["<leader>"] = {
		v = {
			name = "+vim",
			["<leader>vl"] = { ":vsp $MYVIMRC<cr>", "load neovim config" },
			["<leader>vk"] = { ":vsp $HOME/.config/nvim/lua/keymaps.lua<cr>", "load keymaps.lua" },
			["<leader>vp"] = { ":vsp $HOME/.config/nvim/lua/plugins.lua<cr>", "load plugins.lua" },
			["<leader>vs"] = { ":vsp $HOME/.config/nvim/lua/settings.lua<cr>", "load settings.lua" },
			["<leader>vr"] = { ":Reload<cr>", "reload neovim" },
		},
	},
	-- Telescope
	-- Ctrl + p fuzzy files
	-- ["<C-p>"] = {":Telescope find_files<cr>", "Find files"},
	-- ["<leader>ff"] = {":Telescope find_files<cr>", "Find files"},
	-- ["<leader>fb"] = {":Telescope buffers<cr>", "Show buffers"},
	-- ["<leader>fs"] = {":Telescope live_grep<cr>", "Find with grep"},
	-- ["<leader>b"] = {":Telescope buffers<cr>", "Show buffers"},
	-- ["<leader>s"] = {":Telescope live_grep<cr>", "Find with grep"},
	-- hop words
	["f"] = { ":HopWord<cr>", "Horizontal hop word" },
	["F"] = { ":HopLine<cr>", "vertical hop line" },
	["<leader>,"] = { ":HopChar1<cr>" },
	-- NvimTree
	["<C-n>"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
	["<leader>n"] = { ":NvimTreeFindFile<CR>", "Find file in NvimTree" },
	-- lsp
	["<leader>rn"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Lsp buf rename" },
	["<leader>gd"] = { ":lua vim.lsp.buf.definition()<CR>", "Go to definition" },
	["<leader>gi"] = { ":lua vim.lsp.buf.implementation()<CR>", "Go to implementation" },
	["gs"] = { ":lua vim.lsp.buf.signature_help()<CR>", "signature_help" },
	["K"] = { ":lua vim.lsp.buf.hover()<CR>", "buf hover" },
	["<leader>p"] = { "<cmd>lua vim.lsp.buf.formatting()<CR>", "buf format" },
	-- lspsaga
	["gh"] = { ":Lspsaga lsp_finder<cr>", "lsp finder" },
	["<leader>ca"] = { ":Lspsaga code_action<cr>", "code_action" },
	["<C-f>"] = { [[":lua require("lspsaga.action").smart_scroll_with_saga(1)<cr>]], "lspsaga action +" },
	["<C-b>"] = { [[":lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>]], "lspsaga action -" },
	["gr"] = { ":Lspsaga rename<cr>", "Lspsaga rename" },
	["gD"] = { ":Lspsaga preview_definition<cr>", "preview_definition" },
	["gl"] = { ":Lspsaga show_line_diagnostics<cr>", "show_line_diagnostics" },
	["C-f"] = { "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(1)<CR>", "action +" },
	["C-b"] = { "<cmd>lua require('lspsaga.action').smart_scroll_with_saga(-1)<CR>", "action -" },
	["]e"] = { ":Lspsaga diagnostic_jump_next<CR>", "diagnostics jump next" },
	["[e"] = { ":Lspsaga diagnostic_jump_prev<CR>", "diagnostics jump prev" },
	-- highlight search
	["//"] = { ":nohlsearch<CR>", "hide search highlight" },
	["<leader>hl"] = { ":set hlsearch! hlsearch?<CR>", "set search withot highlight" },
	-- Tab switch buffer
	["<TAB>"] = { ":bnext<CR>", "next buffer" },
	["<S-TAB>"] = { ":bprevious<CR>", "prev buffer" },
	-- Other
	["<leader>q"] = { ":bdelete<CR>", "delete current buffer" },
	-- f = {"<cmd>Telescope find_files<cr>", "Find File"},
	-- d = {
	--   name = "Diagnostics",
	--   t = {"<cmd>TroubleToggle<cr>", "trouble"},
	--   w = {"<cmd>TroubleToggle lsp_workspace_diagnostics<cr>", "workspace"},
	--   d = {"<cmd>TroubleToggle lsp_document_diagnostics<cr>", "document"},
	--   q = {"<cmd>TroubleToggle quickfix<cr>", "quickfix"},
	--   l = {"<cmd>TroubleToggle loclist<cr>", "loclist"},
	--   r = {"<cmd>TroubleToggle lsp_references<cr>", "references"}
	-- },
	-- g = {
	--   name = "Git",
	--   o = {"<cmd>Telescope git_status<cr>", "Open changed file"},
	--   b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
	--   c = {"<cmd>Telescope git_commits<cr>", "Checkout commit"},
	--   C = {"<cmd>Telescope git_bcommits<cr>", "Checkout commit(for current file)"}
	-- },
	-- l = {
	--   name = "LSP",
	--   a = {"<cmd>Lspsaga code_action<cr>", "Code Action"},
	--   A = {"<cmd>Lspsaga range_code_action<cr>", "Selected Action"},
	--   d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
	--   D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
	--   f = {"<cmd>LspFormatting<cr>", "Format"},
	--   h = {"<cmd>Lspsaga hover_doc<cr>", "Hover Doc"},
	--   i = {"<cmd>LspInfo<cr>", "Info"},
	--   L = {"<cmd>Lspsaga lsp_finder<cr>", "LSP Finder"},
	--   l = {"<cmd>Lspsaga show_line_diagnostics<cr>", "Line Diagnostics"},
	--   p = {"<cmd>Lspsaga preview_definition<cr>", "Preview Definition"},
	--   q = {"<cmd>Telescope quickfix<cr>", "Quickfix"},
	--   r = {"<cmd>Lspsaga rename<cr>", "Rename"},
	--   t = {"<cmd>LspTypeDefinition<cr>", "Type Definition"},
	--   x = {"<cmd>cclose<cr>", "Close Quickfix"},
	--   s = {"<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols"},
	--   S = {"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", "Workspace Symbols"}
	-- },
	-- r = {
	--   name = "Replace",
	--   f = {"<cmd>lua require('spectre').open_file_search()<cr>", "Current File"},
	--   p = {"<cmd>lua require('spectre').open()<cr>", "Project"}
	-- },
	-- t = {
	--   name = "Search",
	--   b = {"<cmd>Telescope git_branches<cr>", "Checkout branch"},
	--   c = {"<cmd>Telescope colorscheme<cr>", "Colorscheme"},
	--   d = {"<cmd>Telescope lsp_document_diagnostics<cr>", "Document Diagnostics"},
	--   D = {"<cmd>Telescope lsp_workspace_diagnostics<cr>", "Workspace Diagnostics"},
	--   f = {"<cmd>Telescope find_files<cr>", "Find File"},
	--   h = {"<cmd>Telescope help_tags<cr>", "Find Help"},
	--   m = {"<cmd>Telescope marks<cr>", "Marks"},
	--   M = {"<cmd>Telescope man_pages<cr>", "Man Pages"},
	--   r = {"<cmd>Telescope oldfiles<cr>", "Open Recent File"},
	--   R = {"<cmd>Telescope registers<cr>", "Registers"},
	--   t = {"<cmd>Telescope live_grep<cr>", "Text"}
	-- }
	--[[ f = {
    name = 'find',
    b = { '<cmd>lua require(\'telescope.builtin\').buffers()<cr>', 'buffers' },
    f = { '<cmd>lua require(\'telescope.builtin\').find_files({follow = true})<cr>', 'files' },
    g = { '<cmd>lua require(\'telescope.builtin\').live_grep()<cr>', 'whit live grep' },
    h = { '<cmd>lua require(\'telescope.builtin\').help_tags()<cr>', 'help tags' },
  }, ]]
}, {
	mode = "n", -- NORMAL mode
	prefix = "<leader>",
	buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
	silent = true, -- use `silent` when creating keymaps
	noremap = true, -- use `noremap` when creating keymaps
	nowait = false, -- use `nowait` when creating keymaps
})
