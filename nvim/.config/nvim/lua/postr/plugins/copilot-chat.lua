return {
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim", branch = "master" },
			{
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "copilot-chat" },
					anti_conceal = { enabled = true },
				},
				ft = { "markdown", "copilot-chat" },
			},
			{ "github/copilot.vim" },
		},
		build = "make tiktoken", -- Only on MacOS or Linux
		lazy = false,
		opts = {
			model = "claude-opus-4.5",
			proxy = os.getenv("COPILOT_PROXY"),
      allow_insecure = false,
			clear_chat_on_new_prompt = false,
			highlight_selection = false,
			highlight_headers = false,
			auto_insert_mode = false,
			context = "#buffer",
			auto_follow_cursor = false,
			separator = "━━",
			auto_fold = true,
			mappings = {
				-- Use tab for completion
				complete = {
					detail = "Use @<Tab> or /<Tab> for options.",
					insert = "<C-t>",
				},
			},
			window = {
				layout = "vertical",
				width = 0.4,
				height = 1.0,
				relative = "editor",
				border = "single",
			},
			headers = {
				user = "👤 You",
				assistant = "🤖 Copilot",
				tool = "🔧 Tool",
			},

			prompts = {
				ExplainCode = {
					prompt = "Объясни как работает этот код и что он делает, максимально коротко, но чтобы это было понятно",
					system_prompt = "You are very good at explaining stuff",
					mapping = "<leader>ae",
					description = "My custom prompt description",
				},
			},
		},
		keys = {
			{ "<leader>ac", "<cmd>CopilotChat<cr>", mode = { "n", "v" }, desc = "CopilotChat: Toggle Chat" },
			{ "<leader>aa", "<cmd>CopilotChatToggle<cr>", desc = "CopilotChat: Toggle Chat" },
			-- { "<leader>ae", "<cmd>CopilotChatExplain<cr>", mode = { "n", "v" }, desc = "CopilotChat: Explain" },
			{ "<leader>af", "<cmd>CopilotChatFix<cr>", mode = { "n", "v" }, desc = "CopilotChat: Fix" },
			{ "<leader>at", "<cmd>CopilotChatTests<cr>", mode = { "n", "v" }, desc = "CopilotChat: Generate Tests" },
			{ "<leader>as", "<cmd>CopilotChatSave<cr>", desc = "CopilotChat: Save Session" },
			{ "<leader>ap", "<cmd>CopilotChatPrompt<cr>", desc = "CopilotChat: Prompt" },
			{ "<leader>ar", "<cmd>CopilotChatReset<cr>", desc = "CopilotChat: Reset chat" },
			{ "<leader>ao", "<cmd>CopilotChatOptimize<cr>", mode = { "n", "v" }, desc = "CopilotChat: Optimize Code" },
		},
	},
}
