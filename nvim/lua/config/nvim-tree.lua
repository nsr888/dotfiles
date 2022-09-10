-- local remap = vim.api.nvim_set_keymap
--
-- remap('', '<leader>ee', "<Esc>:NvimTreeToggle<CR>",     { silent = true })
-- remap('', '<leader>ef',  "<Esc>:NvimTreeFindFile<CR>",   { silent = true })

vim.g.vim_tree_special_files = {
  "README.md",
  "LICENSE",
  "Makefile",
  "package.json",
  "package-lock.json"
}

-- vim.g.nvim_tree_show_icons = {
--   git = 1,
--   folders = 1,
--   files = 1,
--   folder_arrows = 1,
--   lsp = 1
-- }

-- Mostly default mappings
local tree_cb = require "nvim-tree.config".nvim_tree_callback

-- default will show icon by default if no icon is provided
-- default shows no icon by default
-- vim.g.nvim_tree_icons = {
--   default = "",
--   symlink = "",
--   git = {
--     -- unstaged    = "",
--     unstaged = "★",
--     -- staged      = "",
--     staged = "+",
--     unmerged = "",
--     -- renamed     = "",
--     renamed = "→",
--     -- untracked   = "",
--     -- deleted     = """,
--     untracked = "?",
--     deleted = "✗",
--     ignored = "◌"
--   },
--   folder = {
--     arrow_open = "",
--     arrow_closed = "",
--     default = "",
--     open = "",
--     empty = "",
--     empty_open = "",
--     symlink = "",
--     symlink_open = ""
--   },
--   lsp = {
--     -- hint    = "",
--     -- info    = "",
--     hint = "",
--     info = "",
--     warning = "",
--     error = ""
--   }
-- }

require "nvim-tree".setup {
  disable_netrw = true,
  hijack_netrw = false,
  open_on_setup = false,
  ignore_ft_on_setup = {},
  open_on_tab = false,
  hijack_cursor = false,
  update_cwd = false,
  diagnostics = {
    enable = false
  },
  update_focused_file = {
    enable = false,
    update_cwd = false,
    ignore_list = {}
  },
  view = {
    width = 30,
    side = "right",
    mappings = {
      custom_only = false,
      list = {
        {key = {"<CR>", "o", "<2-LeftMouse>"}, cb = tree_cb("edit")},
        {key = {"<2-RightMouse>", "<C-]>"}, cb = tree_cb("cd")},
        {key = "<C-v>", cb = tree_cb("vsplit")},
        {key = "<C-s>", cb = tree_cb("split")},
        {key = "<C-t>", cb = tree_cb("tabnew")},
        {key = "<", cb = tree_cb("prev_sibling")},
        {key = ">", cb = tree_cb("next_sibling")},
        {key = "P", cb = tree_cb("parent_node")},
        {key = "<BS>", cb = tree_cb("close_node")},
        {key = "<S-CR>", cb = tree_cb("close_node")},
        {key = "<Tab>", cb = tree_cb("preview")},
        {key = "K", cb = tree_cb("first_sibling")},
        {key = "J", cb = tree_cb("last_sibling")},
        {key = "I", cb = tree_cb("toggle_ignored")},
        {key = "H", cb = tree_cb("toggle_dotfiles")},
        {key = "R", cb = tree_cb("refresh")},
        {key = "a", cb = tree_cb("create")},
        {key = "d", cb = tree_cb("remove")},
        {key = "r", cb = tree_cb("rename")},
        {key = "<C-r>", cb = tree_cb("full_rename")},
        {key = "x", cb = tree_cb("cut")},
        {key = "c", cb = tree_cb("copy")},
        {key = "p", cb = tree_cb("paste")},
        {key = "y", cb = tree_cb("copy_name")},
        {key = "Y", cb = tree_cb("copy_path")},
        {key = "gy", cb = tree_cb("copy_absolute_path")},
        {key = "[c", cb = tree_cb("prev_git_item")},
        {key = "]c", cb = tree_cb("next_git_item")},
        {key = "-", cb = tree_cb("dir_up")},
        {key = "s", cb = tree_cb("system_open")},
        {key = "q", cb = tree_cb("close")}
      }
    }
  }
}
