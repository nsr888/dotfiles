-- --- Document highlights
-- local function document_highlight()
--   vim.api.nvim_exec(
--     [[
-- 		hi LspReferenceRead  guibg=#121111 guifg=#FFFF00
-- 		hi LspReferenceText  guibg=#121111 guifg=#FFFF00
-- 		hi LspReferenceWrite guibg=#121111 guifg=#FFFF00
-- 		augroup lsp_document_highlight
-- 			autocmd!
-- 			autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
-- 			autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
-- 			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
-- 		augroup END
-- 	]],
--     false
--   )
-- end
--
-- local on_attach_vim = function()
--   document_highlight()
-- end
--
-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.preselectSupport = true
-- capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
-- capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
-- capabilities.textDocument.completion.completionItem.deprecatedSupport = true
-- capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
-- capabilities.textDocument.completion.completionItem.tagSupport = {valueSet = {1}}
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     "documentation",
--     "detail",
--     "additionalTextEdits"
--   }
-- }

require "lspconfig".gopls.setup {
  -- on_attach = on_attach_vim,
  -- capabilities = capabilities,
  cmd = {"gopls", "serve"},
  settings = {
    gopls = {
      analyses = {
        unusedparams = true
      },
      staticcheck = true
      -- linksInHover = false,
      -- codelens = {
      --   generate = true,
      --   gc_details = true,
      --   regenerate_cgo = true,
      --   tidy = true,
      --   upgrade_depdendency = true,
      --   vendor = true
      -- },
      -- usePlaceholders = true
    }
  }
}

local lspconfig = require "lspconfig"
local configs = require "lspconfig.configs"

if not configs.golangcilsp then
  configs.golangcilsp = {
    default_config = {
      cmd = {"golangci-lint-langserver"},
      root_dir = lspconfig.util.root_pattern(".git", "go.mod"),
      init_options = {
        -- command = { "golangci-lint", "run", "--enable-all", "--disable", "lll", "--out-format", "json" };
        command = {"golangci-lint", "run", "--out-format", "json"}
      }
    }
  }
end
lspconfig.golangcilsp.setup {
  filetypes = {"go"}
}
