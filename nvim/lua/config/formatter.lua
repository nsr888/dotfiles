-- Examples: https://github.com/mhartington/formatter.nvim/blob/master/CONFIG.md
-- Prettier function for formatter
local prettier = function()
	return {
		exe = "prettier",
		args = { "--stdin-filepath", vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)) },
		stdin = true,
	}
end

local clangd = function()
	return {
		exe = "clang-format",
		args = { "--assume-filename", vim.api.nvim_buf_get_name(0) },
		stdin = true,
		cwd = vim.fn.expand("%:p:h"), -- Run clang-format in cwd of the file.
	}
end

local function black()
	return { exe = "black", args = { "--quiet", "-" }, stdin = true }
end

local function isort()
	return { exe = "isort", args = { "--quiet", "-" }, stdin = true }
end

local function golines()
	return { exe = "golines", args = { "--max-len=125" }, stdin = true }
end

local function gofmt()
	return { exe = "gofumpt", args = { "-s" }, stdin = true }
end

local function gogci()
	return { exe = "gci", args = { "print" }, stdin = true }
end

local util = require("formatter.util")

require("formatter").setup({
	logging = false,
	filetype = {
		typescriptreact = { prettier },
		javacriptreact = { prettier },
		javascript = { prettier },
		typescript = { prettier },
		json = { prettier },
		html = { prettier },
		css = { prettier },
		scss = { prettier },
		markdown = { prettier },
		vue = { prettier },
		-- htmldjango = {prettier},
		lua = {
			-- "formatter.filetypes.lua" defines default configurations for the
			-- "lua" filetype
			require("formatter.filetypes.lua").stylua,

			-- You can also define your own configuration
			function()
				-- Supports conditional formatting
				if util.get_current_buffer_file_name() == "special.lua" then
					return nil
				end

				-- Full specification of configurations is down below and in Vim help
				-- files
				return {
					exe = "stylua",
					args = {
						"--search-parent-directories",
						"--stdin-filepath",
						util.escape_path(util.get_current_buffer_file_path()),
						"--",
						"-",
					},
					stdin = true,
				}
			end,
		},
		cpp = { clangd },
		c = { clangd },
		rust = {
			-- Rustfmt
			function()
				return {
					exe = "rustfmt",
					args = { "--emit=stdout" },
					stdin = true,
				}
			end,
		},
		python = { black, isort },
		go = { gofmt, gogci, golines },
		perl = {
			-- perltidy
			function()
				return {
					exe = "perltidy",
					args = { "--standard-output" },
					stdin = true,
				}
			end,
		},
	},
})

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
