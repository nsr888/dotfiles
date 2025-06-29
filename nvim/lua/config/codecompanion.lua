local constants = {
	LLM_ROLE = "llm",
	USER_ROLE = "user",
	SYSTEM_ROLE = "system",
}

require("codecompanion").setup({
	extensions = {
		mcphub = {
			callback = "mcphub.extensions.codecompanion",
			opts = {
				show_result_in_chat = true, -- Show mcp tool results in chat
				make_vars = true, -- Convert resources to #variables
				make_slash_commands = true, -- Add prompts as /slash commands
			},
		},
	},
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
			enabled = true,
			close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
			layout = "vertical", -- vertical|horizontal split for default provider
			opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
			provider = "default", -- default|mini_diff
		},
	},
	strategies = {
		chat = {
			adapter = "copilot",
			-- adapter = "openrouter",
			-- tools = {
			-- 	opts = {
			-- 		default_tools = {
			-- 			"read_file",
			-- 			"mcp",
			-- 			"file_search",
			-- 			"grep_search",
			-- 		},
			-- 	},
			-- },
		},
		inline = {
			adapter = "copilot",
		},
	},
	adapters = {
		copilot = function()
			return require("codecompanion.adapters").extend("copilot", {
				name = "copilot",
				schema = {
					model = {
						default = "gpt-4.1",
						-- default = "claude-3.7-sonnet",
						-- default = "gpt-4o",
					},
					temperature = {
						default = 0.0,
					},
				},
			})
		end,
		openrouter = function()
			return require("codecompanion.adapters").extend("openai_compatible", {
				env = {
					url = "https://openrouter.ai/api",
					api_key = "OPENROUTER_API_KEY",
					chat_url = "/v1/chat/completions",
				},
				schema = {
					model = {
						-- default = "anthropic/claude-3.7-sonnet",
						-- default = "anthropic/claude-sonnet-4",
						default = "deepseek/deepseek-r1-0528",
					},
				},
			})
		end,
		llama3 = function()
			return require("codecompanion.adapters").extend("ollama", {
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
	},
	prompt_library = {
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
					content = [[I want you to act as a senior golang developer.
I will give you specific go code and you must write unit tests for it.
When generating unit tests, follow these steps:
1. Identify the purpose of the function or module to be tested.
2. List the edge cases and typical use cases that should be covered in the tests and share the plan with the user.
3. Write table tests for each test case.
4. Use `github.com/stretchr/testify/mock` package to mock dependencies only when it's necessary.
5. Use `github.com/stretchr/testify/assert` package to validate results.
6. Use following structure for table tests:
```go
  typr args struct { // inputs to test cases
    value1 Type
    ...
  }
  mocks sturct {
    svc Type
    ...
  }
  results struct { // expected result
    error   error // must be validated throught errors.Is()
    result  Type
    wantErr bool // used only in case when error type can't be determine
  },
	tests := []struct {
		name   string
		args   args
		result result
	}{
    ...
  }

	for _, tt := range tests {
		tt := tt
		t.Run(tt.name, func(t *testing.T) {
			t.Parallel()
      ...
		})
	}
```
5. Ensure the tests cover:
      - Success cases
      - Edge cases
      - Error handling (if applicable)
6. Provide the generated unit tests in a clear and organized manner without additional explanations or chat.]],
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
	},
})
