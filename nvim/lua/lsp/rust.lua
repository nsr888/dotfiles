local nvim_lsp = require "lspconfig"

nvim_lsp.rust_analyzer.setup(
  {
    settings = {
      ["rust-analyzer"] = {
        assist = {
          importGranularity = "module",
          importPrefix = "by_self"
        },
        cargo = {
          loadOutDirsFromCheck = true
        },
        procMacro = {
          enable = true
        }
      }
    }
  }
)

--
-- require("lspconfig").rust_analyzer.setup(
--   {
--     flags = {
--       debounce_text_changes = 150
--     },
--     settings = {
--       ["rust-analyzer"] = {
--         checkOnSave = {
--           command = "clippy"
--         }
--       }
--     }
--   }
-- )
