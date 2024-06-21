return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
		"mfussenegger/nvim-dap-python",
		"nvim-lualine/lualine.nvim",
	},
	event = "VeryLazy",
	ft = "python",
	init = function()
		local venv_selector = require("venv-selector")

		venv_selector.setup({
			auto_refresh = true,
			dap_enabled = true,

			vim.api.nvim_create_autocmd("VimEnter", {
				desc = "Auto select virtualenv Nvim open",
				pattern = "*",
				callback = function()
					local venv = vim.fn.findfile("pyproject.toml", vim.fn.getcwd() .. ";")
					if venv ~= "" then
						venv_selector.retrieve_from_cache()
					end
				end,
			once = true,
			}),
		})
	end,

	keys = {
		-- Keymap to open VenvSelector to pick a venv.
		{ "<leader>vs", "<cmd>VenvSelect<cr>" },
		-- Keymap to retrieve the venv from a cache (the one previously used for the same project directory).
		{ "<leader>vc", "<cmd>VenvSelectCached<cr>" },
	},
}
