return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<leader>ps", "<cmd>lua require('kulala').run()<cr>", desc = "Send request" },
		{ "<leader>pa", "<cmd>lua require('kulala').run_all()<cr>", desc = "Send all requests" },
		{ "<leader>pb", "<cmd>lua require('kulala').scratchpad()<cr>", desc = "Open scratchpad" },
		{ "<leader>pc", "<cmd>lua require('kulala').copy()<cr>", desc = "Copy request as cURL" },
		{ "<leader>pe", "<cmd>lua require('kulala').set_selected_env()<cr>", desc = "Select environment" },
		{ "<leader>pr", "<cmd>lua require('kulala').replay()<cr>", desc = "Replay last request" },
		{
			"<leader>po",
			function()
				local collection_path = "/Users/kuznetsov.p/Desktop/Autotests/requests_collection"
				-- Check if a window with a buffer from this path is already open
				for _, win in ipairs(vim.api.nvim_list_wins()) do
					local buf = vim.api.nvim_win_get_buf(win)
					local bufname = vim.api.nvim_buf_get_name(buf)
					if bufname:find(collection_path, 1, true) then
						vim.api.nvim_win_close(win, false)
						return
					end
				end
				-- Open split and use oil or netrw to browse the directory
				vim.cmd("vsplit " .. collection_path)
			end,
			desc = "Toggle requests collection",
		},
	},
	ft = { "http", "rest" },
	opts = {
		default_view = "body",
		-- default_env = "dev",
		debug = false,
		ui = {
			win_opts = {
				wo = { foldmethod = "manual" }, -- window options
			},
		},
		lsp = {
			enable = true,
			keymaps = false, -- disabled by default, as Kulala relies on default Neovim LSP keymaps
			formatter = {
				sort = { -- enable/disable alphabetical sorting in request body
					metadata = true,
					variables = true,
					commands = true,
					json = false,
				},
			},
		},
	},
}
