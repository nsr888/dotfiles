return {
	"CopilotC-Nvim/CopilotChat.nvim",
	branch = "canary",
	lazy = false,
	dependencies = {
		"github/copilot.vim",
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("CopilotChat").setup({
			debug = true, -- Enable debugging
		})
		vim.api.nvim_create_user_command("CopilotChatQuick", function()
			local input = vim.fn.input("Quick Chat: ")
			if input ~= "" then
				require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
			end
		end, {})
	end,
	keys = {
		{
			"<leader>cc",
			function()
				vim.cmd("CopilotChatQuick")
			end,
			desc = "Quick Chat",
		},
	},
}
