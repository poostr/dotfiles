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
			model = "claude-sonnet-4.6",
			proxy = os.getenv("COPILOT_PROXY"),
			allow_insecure = false,

			providers = {
				lm_studio = (function()
					local lm_token = os.getenv("LM_API_TOKEN") or ""
					return {
					get_headers = function()
						return {
							["Content-Type"] = "application/json",
							["Authorization"] = "Bearer " .. lm_token,
						}
					end,

					get_url = function()
						return "http://localhost:1234/v1/chat/completions"
					end,

					get_models = function()
						local ok, res = pcall(function()
							local response =
								vim.fn.system(
								'curl -s --connect-timeout 2 -H "Authorization: Bearer '
									.. lm_token
									.. '" http://localhost:1234/v1/models'
							)
							return vim.fn.json_decode(response)
						end)

						if ok and res and res.data then
							local models = {}
							for _, m in ipairs(res.data) do
								table.insert(models, {
									id = m.id,
									name = m.id,
									tokenizer = "cl100k_base",
									max_input_tokens = m.max_model_len or 8192,
									max_output_tokens = 4096,
									streaming = true,
								})
							end
							return models
						end

						return {
							{
								id = "local-model",
								name = "LM Studio (fallback)",
								tokenizer = "cl100k_base",
								max_input_tokens = 8192,
								max_output_tokens = 4096,
								streaming = true,
							},
						}
					end,

					prepare_input = function(inputs, opts)
						local messages = vim.tbl_map(function(input)
							return {
								role = input.role,
								content = input.content,
							}
						end, inputs)

						return {
							messages = messages,
							model = opts.model.id,
							stream = opts.model.streaming or false,
							temperature = opts.temperature or 0.7,
							max_tokens = opts.model.max_output_tokens or 4096,
						}
					end,

					prepare_output = function(...)
						return require("CopilotChat.config.providers").copilot.prepare_output(...)
					end,
				}
				end)(),
			},
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
