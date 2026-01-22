return {
	"robitx/gp.nvim",
	config = function()
		local conf = {
			openai_api_key = os.getenv("OPENAI_API_KEY"),
			providers = {
				openai = { disable = true },
				openrouter = {
					endpoint = "https://openrouter.ai/api/v1/chat/completions",
					secret = os.getenv("OPENROUTER_API_KEY"),
				},
			},
			agents = {
				{
					name = "Deepseek chat V3",
					provider = "openrouter",
					chat = true,
					command = true,
					model = { model = "deepseek/deepseek-chat" },
					system_prompt = "You are a helpful AI assistant.",
				},
				{
					name = "qwen3",
					provider = "openrouter",
					chat = true,
					command = true,
					model = { model = "qwen/qwen3-235b-a22b" },
					system_prompt = "You are a helpful AI assistant.",
				},
			},
			default_command_agent = nil,
			default_chat_agent = "Deepseek chat V3",
		}
		require("gp").setup(conf)

		-- Setup shortcuts here (see Usage > Shortcuts in the Documentation/Readme)
		local function keymapOptions(desc)
			return {
				noremap = true,
				silent = true,
				nowait = true,
				desc = "GPT prompt " .. desc,
			}
		end
		-- Chat commands
		vim.keymap.set({ "n", "i" }, "<C-g>c", "<cmd>GpChatNew<cr>", keymapOptions("New Chat"))
		vim.keymap.set({ "n", "i" }, "<C-g>t", "<cmd>GpChatToggle<cr>", keymapOptions("Toggle Chat"))
		vim.keymap.set({ "n", "i" }, "<C-g>f", "<cmd>GpChatFinder<cr>", keymapOptions("Chat Finder"))

		vim.keymap.set("v", "<C-g>c", ":<C-u>'<,'>GpChatNew<cr>", keymapOptions("Visual Chat New"))
		vim.keymap.set("v", "<C-g>p", ":<C-u>'<,'>GpChatPaste<cr>", keymapOptions("Visual Chat Paste"))
		vim.keymap.set("v", "<C-g>t", ":<C-u>'<,'>GpChatToggle<cr>", keymapOptions("Visual Toggle Chat"))
	end,
}
