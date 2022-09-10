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
  use {
    "wbthomason/packer.nvim",
    config = {
      profile = {
        enable = true,
        threshold = 1
      }
    }
  }

  -- plugin reload
  use "famiu/nvim-reload"

  -- Comment
  use {
    "terrortylor/nvim-comment",
    event = "BufRead",
    config = function()
      local status_ok, nvim_comment = pcall(require, "nvim_comment")
      if not status_ok then
        return
      end
      nvim_comment.setup()
    end
  }

  -- plenary is required by gitsigns, telescope and nvim-reload
  -- lazy load so gitsigns doesn't abuse our startup time
  use {"nvim-lua/plenary.nvim"}

  -- Add git related info in the signs columns and popups
  use {
    "lewis6991/gitsigns.nvim",
    requires = {"nvim-lua/plenary.nvim"},
    config = function()
      require("plugin.gitsigns")
    end
  }

  -- lsp
  use {"neovim/nvim-lspconfig"}
  use {"ray-x/lsp_signature.nvim", event = "BufRead"}
  -- use {
  --   "kabouzeid/nvim-lspinstall",
  --   config = function()
  --     require("lsp")
  --     -- ':command LspStart'
  --     require "lspconfig"._root.commands.LspStart[1]()
  --   end,
  --   after = {"nvim-lspconfig", "lsp_signature.nvim"}
  -- }
  -- use {
  --   "glepnir/lspsaga.nvim",
  --   requires = {"neovim/nvim-lspconfig"}
  -- }

  use {"tami5/lspsaga.nvim", branch = "nvim6.0"}

  -- file tree
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {"kyazdani42/nvim-web-devicons"},
    config = "require('plugin.nvim-tree')"
  }

  -- Telescope
  use {
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    requires = {{"nvim-lua/popup.nvim"}, {"nvim-lua/plenary.nvim"}},
    config = "require('plugin.telescope')"
  }

  use {
    "jose-elias-alvarez/null-ls.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
      require("null-ls").setup(
        {
          sources = {
            require("null-ls").builtins.formatting.stylua,
            require("null-ls").builtins.diagnostics.eslint,
            require("null-ls").builtins.completion.spell
          }
        }
      )
    end
  }

  --
  --   -- TS utils
  --   use {
  --     "jose-elias-alvarez/nvim-lsp-ts-utils",
  --     event = "BufRead",
  --     requires = {{"jose-elias-alvarez/null-ls.nvim"}, {"nvim-lua/plenary.nvim"}}
  --   }

  -- Theme
  use "folke/tokyonight.nvim"
  -- use "marko-cerovac/material.nvim"
  -- use {"dracula/vim", as = "dracula"}

  -- Shows RGB colors
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require "colorizer".setup()
    end
  }

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    config = "require('plugin.treesitter')",
    run = ":TSUpdate"
  }

  -- key bindings cheatsheet
  use {
    "folke/which-key.nvim",
    config = "require('plugin.which_key')",
    event = "VimEnter"
  }

  -- Color scheme, requires nvim-treesitter
  vim.g.nvcode_termcolors = 256
  use {"christianchiarulli/nvcode-color-schemes.vim", opt = true}

  -- LuaLine
  -- use {
  --   "hoob3rt/lualine.nvim",
  --   requires = {"kyazdani42/nvim-web-devicons", opt = true},
  --   config = "require('plugin.lualine')"
  -- }

  -- fancy statusline
  -- TODO: causes splash screen to flash
  -- use {
  --   "famiu/feline.nvim",
  --   tag = "v0.3.3",
  --   requires = {"kyazdani42/nvim-web-devicons"},
  --   config = "require'plugin.feline'",
  --   event = "VimEnter"
  -- }

  -- Autocomplete
  use {"hrsh7th/nvim-compe", config = "require('plugin.compe')"}

  use "knubie/vim-kitty-navigator"
  use "alvan/vim-closetag"
  use {"mhartington/formatter.nvim", config = "require('plugin.formatter')"}
  -- use "airblade/vim-gitgutter"

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

  -- Indent Blankline
  use {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufRead",
    config = function()
      require("plugin.indent-blankline")
    end
  }

  -- bufonly, close all buffers except current one
  use {"numtostr/BufOnly.nvim", cmd = "BufOnly"}

  use {"simrat39/symbols-outline.nvim"}

  -- :TZMinimalist :TZFocus :TZAtaraxis
  -- use "Pocco81/TrueZen.nvim"

  -- Lua
  -- use {
  --   "folke/twilight.nvim",
  --   config = function()
  --     require("twilight").setup {}
  --   end
  -- }

  -- Search
  -- use {"windwp/nvim-spectre"}

  -- tpope
  use "tpope/vim-fugitive"
  use "tpope/vim-surround"
  -- use "tpope/vim-commentary"

  -- pairs
  -- use "jiangmiao/auto-pairs"
  -- use {
  --   "steelsojka/pears.nvim",
  --   -- event = 'InsertEnter',
  --   config = function()
  --     require("pears").setup()
  --   end
  -- }

  -- Fzf
  use {
    "junegunn/fzf",
    run = function()
      vim.fn["fzf#install"]()
    end,
    event = {"BufReadPost"}
  }
  use {
    "junegunn/fzf.vim",
    requires = "junegunn/fzf",
    after = {"nvim-bqf"}
  }

  -- Quickfix enhancements
  use {
    "kevinhwang91/nvim-bqf",
    requires = {{"junegunn/fzf", opt = true}, {"junegunn/fzf.vim", opt = true}},
    ft = {"qf"},
    config = function()
      require("bqf").setup {
        auto_enable = true
      }
    end
  }

  -- Grepping
  use {
    "jremmen/vim-ripgrep",
    cmd = {"Rg"}
  }
  use {
    "mhinz/vim-grepper",
    config = function()
      vim.cmd [[
        nmap gs <Plug>(GrepperOperator)
        xmap gs <Plug>(GrepperOperator)
      ]]
    end,
    cmd = {"Grepper", "<Plug>(GrepperOperator)"},
    keys = {
      {"n", "gs"},
      {"x", "gs"}
    }
  }
  use {"chr4/nginx.vim", opt = true, ft = "nginx"}
  -- Grepping
  use {
    "dbsr/vimpy",
    cmd = {"VimpyCheckLine"}
  }
  use {
    "glench/vim-jinja2-syntax"
  }
  use {"ellisonleao/glow.nvim"}
  use {"aklt/plantuml-syntax"}
  use {"tyru/open-browser.vim"}
  use {"weirongxu/plantuml-previewer.vim"}
  use {"rhysd/git-messenger.vim"}
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
