-- Prettier function for formatter
local prettier = function()
  return {
    exe = "prettier",
    args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)},
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
      c = {clangd}
    }
  }
)

-- Runs Prettier on save
vim.api.nvim_exec(
  [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.ts,*.tsx,*.css,*.scss,*.md,*.html,*.lua,.*json,*.vue : FormatWrite
augroup END
]],
  true
)
