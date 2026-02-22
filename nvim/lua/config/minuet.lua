local mc = require("minuet.config")

require("minuet").setup({
	notify = "debug",
	provider = "codestral",
	n_completions = 1,
	add_single_line_entry = false,
	provider_options = {
		-- Requires $GEMINI_API_KEY
		gemini = {
			model = "gemini-2.5-flash",
			stream = true,
		},
		openai_compatible = {
			api_key = "OPENROUTER_API_KEY",
			end_point = "https://openrouter.ai/api/v1/chat/completions",
			model = "google/gemini-2.5-flash-lite-preview-09-2025",
			name = "Openrouter",
			-- for gemini
			system = mc.default_system_prefix_first,
			chat_input = mc.default_chat_input_prefix_first,
			few_shots = mc.default_few_shots_prefix_first,
			optional = {
				-- for chinese
				-- max_tokens = 256,
				-- top_p = 0.9,
				provider = {
					-- Prioritize throughput for faster completion
					sort = "throughput",
				},
			},
		},
		codestral = {
			optional = {
				max_tokens = 256,
				stop = { "\n\n" },
			},
		},
	},
	virtualtext = {
		auto_trigger_ft = { "lua", "go", "python" },
		keymap = {
			accept = "<Tab>",
			accept_line = "<C-l>",
			next = "<C-]>",
			dismiss = "<C-e>",
		},
	},
	throttle = 150, -- Request only after paused typing for 150ms
})
