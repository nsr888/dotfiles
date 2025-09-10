local providers = require("codecompanion.providers")
---@module "vectorcode"

local constants = {
	LLM_ROLE = "llm",
	USER_ROLE = "user",
	SYSTEM_ROLE = "system",
}

require("codecompanion").setup({
	opts = {
		log_level = "DEBUG",
	},
	display = {
		chat = {
			show_settings = true,
		},
		action_palette = {
			width = 95,
			height = 10,
			prompt = "Prompt ", -- Prompt used for interactive LLM calls
			provider = "default", -- Can be "default", "telescope", "fzf_lua", "mini_pick" or "snacks". If not specified, the plugin will autodetect installed providers.
			opts = {
				show_default_actions = true, -- Show the default actions in the action palette?
				show_default_prompt_library = true, -- Show the default prompt library in the action palette?
			},
		},
		diff = {
			-- Default provider: Commands: do/dp (obtain/put), Exit: :diffoff, :q
			-- Mini-diff: Inline changes with colors, Nav: Commands: =a/=A (apply hunk/all)
			-- Use gda to accept, gdr to reject changes (auto-exits when all changes handled)
			enabled = true,
			close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
			layout = "vertical", -- vertical|horizontal split for default provider
			opts = {
				"internal",
				"filler",
				"closeoff",
				"algorithm:histogram",
				"indent-heuristic",
				"followwrap",
				"linematch:120",
			},
			provider = providers.diff,
			-- provider = "mini_diff", -- default|mini_diff
			diff_signs = {
				signs = {
					text = "▌", -- Sign text for normal changes
					reject = "✗", -- Sign text for rejected changes in super_diff
					highlight_groups = {
						addition = "DiagnosticOk",
						deletion = "DiagnosticError",
						modification = "DiagnosticWarn",
					},
				},
				-- Super Diff options
				icons = {
					accepted = " ",
					rejected = " ",
				},
				colors = {
					accepted = "DiagnosticOk",
					rejected = "DiagnosticError",
				},
			},
		},
	},
	strategies = {
		chat = {
			-- adapter = "anthropic",
			-- adapter = "copilot",
			-- adapter = "openrouter",
			adapter = "copilot",
			-- adapter = "chutes",
		},
		inline = {
			-- adapter = "anthropic",
			adapter = "copilot",
			keymaps = {
				accept_change = {
					modes = { n = "gda" }, -- Remember this as DiffAccept
				},
				reject_change = {
					modes = { n = "gdr" }, -- Remember this as DiffReject
				},
				always_accept = {
					modes = { n = "gdy" }, -- Remember this as DiffYolo
				},
			},
		},
	},
	adapters = {
		http = {
			copilot = function()
				return require("codecompanion.adapters.http").extend("copilot", {
					name = "copilot",
					schema = {
						model = {
							-- default = "gpt-5-mini",
							-- default = "gpt-4.1",
							-- default = "grok-code-fast-1",
							-- default = "claude-3.7-sonnet",
							default = "gemini-2.5-pro",
						},
						-- temperature = {
						-- 	default = 0.0,
						-- },
					},
				})
			end,
			openrouter = function()
				return require("codecompanion.adapters.http").extend("openai_compatible", {
					env = {
						url = "https://openrouter.ai/api",
						api_key = "OPENROUTER_API_KEY",
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							-- default = "deepseek/deepseek-r1-0528",
							-- default = "moonshotai/kimi-k2",
							default = "google/gemini-2.5-pro",
						},
						-- temperature = {
						-- 	default = 0.6, -- default temperature for kimi-k2
						-- },
					},
				})
			end,
			gemini = function()
				return require("codecompanion.adapters.http").extend("gemini", {
					name = "gemini",
					schema = {
						model = {
							default = "gemini-2.5-pro",
						},
						num_ctx = {
							default = 8192,
						},
						num_predict = {
							default = -1,
						},
					},
					env = {
						api_key = "GEMINI_API_KEY",
					},
				})
			end,
			llama3 = function()
				return require("codecompanion.adapters.http").extend("ollama", {
					name = "llama3",
					schema = {
						model = {
							default = "llama3.2:3b",
							choices = {
								"mistral:7b",
								"starcoder2:7b",
								"codellama:7b",
								"qwen2.5-coder:7b",
								"deepseek-r1:7b",
								"llama3.2:3b",
							},
						},
						num_ctx = {
							default = 16384,
						},
						num_predict = {
							default = -1,
						},
					},
				})
			end,
			anthropic = function()
				return require("codecompanion.adapters.http").extend("anthropic", {
					env = {
						api_key = "ANTHROPIC_API_KEY",
					},
					schema = {
						model = {
							default = "claude-sonnet-4-20250514",
						},
					},
				})
			end,
			chutes = function()
				return require("codecompanion.adapters.http").extend("openai_compatible", {
					env = {
						api_key = "CHUTES_CODECOMPANION_API_KEY",
						url = "https://llm.chutes.ai",
						chat_url = "/v1/chat/completions",
					},
					schema = {
						model = {
							default = "Qwen/Qwen3-Coder-480B-A35B-Instruct-FP8",
						},
					},
				})
			end,
		},
	},
	prompt_library = {
		["Buffer Chat"] = {
			strategy = "chat",
			description = "Chat with current buffer auto-attached (pinned)",
			opts = {
				mapping = "<Leader>ce",
				modes = { "n" },
				short_name = "buf", -- use :CodeCompanion /buf
				-- user_prompt = true, -- ask for your message each time
				auto_submit = false,
			},
			prompts = {
				{
					role = "user",
					content = "#{buffer}{watch} ",
					opts = { contains_code = true },
				},
			},
		},
		["Code Expert"] = {
			strategy = "chat",
			description = "Get some special advice from an LLM",
			opts = {
				mapping = "<LocalLeader>ce",
				modes = { "v" },
				short_name = "expert",
				auto_submit = true,
				stop_context_insertion = true,
				user_prompt = true,
			},
			prompts = {
				{
					role = "system",
					content = function(context)
						return "I want you to act as a senior "
							.. context.filetype
							.. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
							.. "Don't reply on this message, just wait for the questions."
					end,
				},
				{
					role = "user",
					content = function(context)
						local text =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return "I have the following code:\n\n```" .. context.filetype .. "\n" .. text .. "\n```\n\n"
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
		["Golang unit tests"] = {
			strategy = "chat",
			description = "Write unit tests for selected code",
			opts = {
				mapping = "<LocalLeader>ct",
				modes = { "v" },
				short_name = "gotest",
				auto_submit = true,
				stop_context_insertion = true,
				user_prompt = false,
			},
			prompts = {
				{
					role = constants.SYSTEM_ROLE,
					content = function(context)
						return "I want you to act as a senior Go "
							.. " developer. I will ask you specific questions and I want you to return concise explanations and codeblock examples."
							.. "@mcp Use from memory bank programming/go-test-guidelines.md if available."
							.. "Don't reply on this message, just wait for the questions."
					end,
				},
				{
					role = "user",
					content = function(context)
						local text =
							require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

						return "@mcp Use go test guidelines from memory bank, try to find go-test-guidelines in memory bank.\n\n"
							.. "I have the following code:\n\n```"
							.. context.filetype
							.. "\n"
							.. text
							.. "\n```\n\n"
					end,
					opts = {
						contains_code = true,
					},
				},
			},
		},
	},
	extensions = {
		vectorcode = {
			---@type VectorCode.CodeCompanion.ExtensionOpts
			opts = {
				tool_group = {
					-- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
					enabled = true,
					-- a list of extra tools that you want to include in `@vectorcode_toolbox`.
					-- if you use @vectorcode_vectorise, it'll be very handy to include
					-- `file_search` here.
					extras = {},
					collapse = false, -- whether the individual tools should be shown in the chat
				},
				tool_opts = {
					---@type VectorCode.CodeCompanion.ToolOpts
					["*"] = {},
					---@type VectorCode.CodeCompanion.LsToolOpts
					ls = {},
					---@type VectorCode.CodeCompanion.VectoriseToolOpts
					vectorise = {},
					---@type VectorCode.CodeCompanion.QueryToolOpts
					query = {
						max_num = { chunk = -1, document = -1 },
						default_num = { chunk = 50, document = 10 },
						include_stderr = false,
						use_lsp = true,
						no_duplicate = true,
						chunk_mode = false,
						---@type VectorCode.CodeCompanion.SummariseOpts
						summarise = {
							---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
							enabled = false,
							adapter = nil,
							query_augmented = true,
						},
					},
					files_ls = {},
					files_rm = {},
				},
			},
		},
	},
})
