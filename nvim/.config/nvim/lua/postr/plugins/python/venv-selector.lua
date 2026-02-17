return {
	"linux-cultist/venv-selector.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } }, -- optional: you can also use fzf-lua, snacks, mini-pick instead.
	},
	ft = "python", -- Load when opening Python files
	keys = {
		{ ",v", "<cmd>VenvSelect<cr>" }, -- Open picker on keymap
	},
	opts = { -- this can be an empty lua table - just showing below for clarity.
		search = {}, -- if you add your own searches, they go here.
		options = {
			activate_venv_in_terminal = true,
			set_environment_variables = true,
			require_lsp_activation = true,
			enable_cached_venvs = true,
			cached_venv_automatic_activation = true,
			debug = false,
			on_venv_activate_callback = function(venv_path, venv_python)
				-- Custom logic after activation
				print("Activated: " .. vim.fn.fnamemodify(venv_path, ":t"))
			end,
			statusline_func = {
				lualine = function()
					local venv_path = require("venv-selector").venv()
					if not venv_path or venv_path == "" then
						return ""
					end
					local venv_name = vim.fn.fnamemodify(venv_path, ":t")
					return "🐍 " .. (venv_name or "") .. " "
				end,
			},
		},
	},
}
