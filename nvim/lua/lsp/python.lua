-- pip install python-lsp-server
-- pip install mypy-ls

require "lspconfig".pylsp.setup(
  {
    enable = true,
    cmd = {"pylsp"},
    -- cmd_env = {VIRTUAL_ENV = "/Users/anasyrov/Documents/21/social-network-parser"},
    -- cmd = { 'pylsp', '-vvv', '--log-file', 'pylsp.log' },
    settings = {
      pylsp = {
        configurationSources = {"flake8"},
        plugins = {
          flake8 = {
            enabled = true,
            maxLineLength = 100,
            ignore = {
              "D100", -- Missing docstring in public module
              "D101", -- Missing docstring in public class
              "D105", -- Missing docstring in magic method
              "D107", -- Missing docstring in __init__
              "D200", -- One-line docstring should fit on one line with quotes
              "D205", -- 1 blank line required between summary line and description
              "D400", -- First line should end with a period
              "D402", -- First line should not be the function's "signature"
              "D401", -- First line should be in imperative mood
              "N812", -- Lowercase imported as non lowercase (prevents `import torch.functionnal as F`)
              "W503" -- line break before binary operator
            }
          },
          pylint = {
            enabled = false,
            -- https://vald-phoenix.github.io/pylint-errors/
            executable = "pylint",
            ignore = {},
            args = {
              "-d " ..
                "C0115," .. -- missing-class-docstring
                  "C0116," .. -- missing-function-docstring
                    "R0903," .. -- too-few-public-methods
                      "C0114" -- missing-module-docstring
            }
          },
          pylsp_mypy = {
            -- enabled = true,
            enabled = false,
            live_mode = false
          },
          jedi_completion = {
            enabled = true,
            fuzzy = true
          },
          jedi_hover = {
            enabled = true
          },
          jedi_references = {
            enabled = true
          },
          jedi_signature_help = {
            enabled = true
          },
          jedi_symbols = {
            enabled = true,
            all_scopes = true
          },
          pycodestyle = {
            enabled = false
          },
          yapf = {
            enabled = false
          },
          pyflakes = {
            enabled = false
          },
          pydocstyle = {
            enabled = false
          },
          mccabe = {
            enabled = false
          },
          preload = {
            enabled = false
          },
          rope_completion = {
            enabled = false
          }
        }
      }
    }
    -- on_attach = require "lspconfig".common_on_attach
    -- on_attach = on_attach
  }
)

-- require "lspconfig".pyright.setup {}
