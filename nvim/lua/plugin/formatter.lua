-- Examples: https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md
-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0))},
    stdin = true
  }
end

local clangd = function()
  return {
    exe = "clang-format",
    args = {"--assume-filename", vim.api.nvim_buf_get_name(0)},
    stdin = true,
    cwd = vim.fn.expand("%:p:h") -- Run clang-format in cwd of the file.
  }
end

local function black()
  return {exe = "black", args = {"--quiet", "-"}, stdin = true}
end

local function gofmt()
  return {exe = "gofumpt", args = {"-s"}, stdin = true}
end

local function gogci()
  return {exe = "gci", args = {"print"}, stdin = true}
end

require("formatter").setup(
  {
    logging = false,
    filetype = {
      typescriptreact = {prettier},
      javacriptreact = {prettier},
      javascript = {prettier},
      typescript = {prettier},
      json = {prettier},
      html = {prettier},
      css = {prettier},
      scss = {prettier},
      markdown = {prettier},
      vue = {prettier},
      -- htmldjango = {prettier},
      lua = {
        -- luafmt
        function()
          return {
            exe = "luafmt",
            args = {"--indent-count", 2, "--stdin"},
            stdin = true
          }
        end
      },
      cpp = {clangd},
      c = {clangd},
      rust = {
        -- Rustfmt
        function()
          return {
            exe = "rustfmt",
            args = {"--emit=stdout"},
            stdin = true
          }
        end
      },
      python = {black},
      go = {gofmt, gogci},
      perl = {
        -- perltidy
        function()
          return {
            exe = "perltidy",
            args = {"--standard-output"},
            stdin = true
          }
        end
      }
    }
  }
)

-- Runs Prettier on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.tsx,*.css,*.scss,*.md,*.lua,.*json,*.vue : FormatWrite
augroup END
]],
  true
)
