require 'plugins'
require("options")
require("keymaps")
require("lsp")

-- run some vim script from lua
vim.cmd([[command! Hello lua print('Hello')]])
