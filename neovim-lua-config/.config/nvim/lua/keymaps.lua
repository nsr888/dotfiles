local function register_mappings(mappings, default_options)
  for mode, mode_mappings in pairs(mappings) do
    for _, mapping in pairs(mode_mappings) do
      local options = #mapping == 3 and table.remove(mapping) or default_options
      local prefix, cmd = unpack(mapping)
      pcall(vim.api.nvim_set_keymap, mode, prefix, cmd, options)
    end
  end
end

local mappings = {
  i = {
    -- Insert mode
    {"jk", "<ESC>"},
    -- Terminal window navigation
    {"<C-h>", "<C-\\><C-N><C-w>h"},
    {"<C-j>", "<C-\\><C-N><C-w>j"},
    {"<C-k>", "<C-\\><C-N><C-w>k"},
    {"<C-l>", "<C-\\><C-N><C-w>l"}
  },
  n = {
    -- Normal mode
    -- remap ; to C-w
    {";", "<C-w>"},
    {";;", "<C-w>w"},
    -- Better window movement
    {"<C-h>", "<C-w>h", {silent = true}},
    {"<C-j>", "<C-w>j", {silent = true}},
    {"<C-k>", "<C-w>k", {silent = true}},
    {"<C-l>", "<C-w>l", {silent = true}},
    -- tab navigation
    {"<leader>nt", ":tabnew<cr>"},
    {"<leader>pp", ":tabprevious<cr>"},
    {"<leader>nn", ":tabnext<cr>"},
    -- {"<C-j>", "<C-w>j", {silent = true}},
    -- {"<C-k>", "<C-w>k", {silent = true}},

    -- Resize with arrows
    {"<C-Up>", ":resize -2<CR>", {silent = true}},
    {"<C-Down>", ":resize +2<CR>", {silent = true}},
    {"<C-Left>", ":vertical resize -2<CR>", {silent = true}},
    {"<C-Right>", ":vertical resize +2<CR>", {silent = true}},
    -- Telescope
    -- Ctrl + p fuzzy files
    {"<C-p>", [[<cmd> lua require"telescope.builtin".find_files({ hidden = true })<CR>]]},
    {"<leader>ff", ":Telescope find_files<cr>"},
    {"<leader>fb", ":Telescope buffers<cr>"},
    {"<leader>b", ":Telescope buffers<cr>"},
    {"<leader>fs", ":Telescope live_grep<cr>"},
    {"<leader>s", ":Telescope live_grep<cr>"},
    -- Escape clears highlight after search
    {"<esc>", ":noh<cr><esc>"},
    -- hop words
    {"f", ":HopWord<cr>"},
    {"F", ":HopLine<cr>"},
    {"<leader><leader>", ":HopChar1<cr>"},
    -- NvimTree
    {"<C-n>", ":NvimTreeToggle<CR>"},
    {"<leader>n", ":NvimTreeFindFile<CR>"},
    -- lsp
    {"<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>"},
    -- lspsaga
    {"gh", ":Lspsaga lsp_finder<cr>", {silent = true}},
    {"<leader>ca", ":Lspsaga code_action<cr>", {silent = true}},
    {"K", ":Lspsaga hover_doc<cr>", {silent = true}},
    {"<C-f>", ':lua require("lspsaga.action").smart_scroll_with_saga(1)<cr>', {silent = true}},
    {"<C-b>", ':lua require("lspsaga.action").smart_scroll_with_saga(-1)<cr>', {silent = true}},
    {"gs", ":Lspsaga signature_help<cr>", {silent = true}},
    {"gr", ":Lspsaga rename<cr>", {silent = true}},
    {"gd", ":Lspsaga preview_definition<cr>", {silent = true}},
    {"gl", ":Lspsaga show_line_diagnostics<cr>", {silent = true}},
    -- reload
    {"<leader>vl", ":vsp $MYVIMRC<cr>"},
    {"<leader>vk", ":vsp $HOME/.config/nvim/lua/keymaps.lua<cr>"},
    {"<leader>vp", ":vsp $HOME/.config/nvim/lua/plugins.lua<cr>"},
    {"<leader>vs", ":vsp $HOME/.config/nvim/lua/settings.lua<cr>"},
    {"<leader>vr", ":Reload<cr>"},
    -- Disable entering Ex mode
    {"Q", "<Nop>"},
    -- highlight search
    {"//", ":nohlsearch<CR>"},
    {"<leader>hl", ":set hlsearch! hlsearch?<CR>"},
    -- trouble
    {"<leader>xx", "<cmd>Trouble<cr>"},
    {"<leader>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>"},
    {"<leader>xd", "<cmd>Trouble lsp_document_diagnostics<cr>"},
    {"<leader>xl", "<cmd>Trouble loclist<cr>"},
    {"<leader>xq", "<cmd>Trouble quickfix<cr>"},
    {"gR", "<cmd>Trouble lsp_references<cr>"}
  },
  t = {
    -- Terminal mode
    -- Tejrminal window navigation
    {"<C-h>", "<C-\\><C-N><C-w>h"},
    {"<C-j>", "<C-\\><C-N><C-w>j"},
    {"<C-k>", "<C-\\><C-N><C-w>k"},
    {"<C-l>", "<C-\\><C-N><C-w>l"},
    -- map escape to normal mode in terminal
    {"<Esc>", [[ <C-\><C-n> ]]},
    {"jk", [[ <C-\><C-n> ]]}
  },
  v = {
    -- Visual/Select mode
    -- Better indenting
    {"<", "<gv"},
    {">", ">gv"},
    -- hop words
    {"f", "<cmd>lua require'hop'.hint_words()<cr>"},
    -- lspsago
    {"<leader>ca", "<C-U>Lspsaga range_code_action<cr>", {silent = true}},
    -- hop
    {"<leader><leader>", ":HopChar1Visual<cr>"}
  },
  x = {}
}

register_mappings(mappings, {silent = true, noremap = true})

-- S for search and replace in buffer
vim.cmd "nnoremap S :%s//gi<Left><Left><Left>"
