-- Do not use plugins when running as root or neovim < 0.5
if require "utils".is_root() or not require "utils".has_neovim_v05() then
  return {
    sync_if_not_compiled = function()
      return
    end
  }
end

local execute = vim.api.nvim_command

-- check if packer is installed (~/.local/share/nvim/site/pack)
local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local is_installed = vim.fn.empty(vim.fn.glob(install_path)) == 0
local is_compiled = vim.fn.empty(vim.fn.glob(compile_path)) == 0

if not is_installed then
  if vim.fn.input("Install packer.nvim? (y for yes) ") == "y" then
    execute("!git clone https://github.com/wbthomason/packer.nvim " .. install_path)
    execute("packadd packer.nvim")
    print("Installed packer.nvim.")
    is_installed = 1
  end
end

-- Packer commands
vim.cmd [[command! PackerInstall packadd packer.nvim | lua require('plugins').install()]]
vim.cmd [[command! PackerUpdate packadd packer.nvim | lua require('plugins').update()]]
vim.cmd [[command! PackerSync packadd packer.nvim | lua require('plugins').sync()]]
vim.cmd [[command! PackerClean packadd packer.nvim | lua require('plugins').clean()]]
vim.cmd [[command! PackerCompile packadd packer.nvim | lua require('plugins').compile()]]
vim.cmd [[command! PC PackerCompile]]
vim.cmd [[command! PS PackerStatus]]
vim.cmd [[command! PU PackerSync]]

local packer = nil
local function init()
  if not is_installed then
    return
  end
  if packer == nil then
    packer = require("packer")
    packer.init(
      {
        -- we don't want the compilation file in '~/.config/nvim'
        compile_path = compile_path
      }
    )
  end

  local use = packer.use

  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- lsp
  use "neovim/nvim-lspconfig"

  -- file tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = "require('plugin.nvim-tree')"
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
    config = "require('plugin.telescope')"
  }

  -- TS utils
  use {
    "jose-elias-alvarez/nvim-lsp-ts-utils",
    requires = {{"jose-elias-alvarez/null-ls.nvim"}, {"nvim-lua/plenary.nvim"}}
  }

  -- Theme
  use "folke/tokyonight.nvim"
  -- use {"dracula/vim", as = "dracula"}

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = "require('plugin.treesitter')",
    run = ":TSUpdate"
  }

  -- LuaLine
  use {
    "hoob3rt/lualine.nvim",
    requires = {"kyazdani42/nvim-web-devicons", opt = true},
    config = "require('plugin.lualine')"
  }

  -- Autocomplete
  use {"hrsh7th/nvim-compe", config = "require('plugin.compe')"}

  -- tpope
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  use "tpope/vim-commentary"

  use "knubie/vim-kitty-navigator"
  use "alvan/vim-closetag"
  use "jiangmiao/auto-pairs"
  use {"mhartington/formatter.nvim", config = "require('plugin.formatter')"}
  use "airblade/vim-gitgutter"

  use {
    "phaazon/hop.nvim",
    as = "hop",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require "hop".setup {keys = "etovxqpdygfblzhckisuran"}
    end
  }

  -- snippets
  use {
    "SirVer/ultisnips",
    requires = {{"honza/vim-snippets"}}
  }
end

-- called from 'lua/autocmd.lua' at `VimEnter`
local function sync_if_not_compiled()
  if packer == nil then
    return
  end
  if not is_compiled then
    packer.sync()
  --execute("luafile $MYVIMRC")
  end
end

local plugins =
  setmetatable(
  {},
  {
    __index = function(_, key)
      init()
      -- workaround for error when packer not installed
      if packer == nil then
        return function()
        end
      end
      if key == "sync_if_not_compiled" then
        return sync_if_not_compiled
      else
        return packer[key]
      end
    end
  }
)

return plugins
