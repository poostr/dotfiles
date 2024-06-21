return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local tb = require("telescope.builtin")

		telescope.setup({
			extensions = {},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "-L", "--hidden", "--glob", "!**/.git/*", "--smart-case" },
					theme = "dropdown",
				},
				live_grep = {
					theme = "dropdown",
					find_command = { "rg", "--files", "-L", "--hidden", "--glob", "!**/.git/*", "--smart-case" },
				},
			},
			defaults = {
				path_display = { "smart" },
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
					},
				},
			},
		})

		-- set keymaps
		local keymap = vim.keymap

		keymap.set("n", "<leader>sq", tb.help_tags, { desc = "[S]earch [Q]uestions" })
		keymap.set("n", "<leader>sf", tb.find_files, { desc = "[S]earch [F]iles" })
		keymap.set("n", "<leader><leader>", tb.live_grep, { desc = "[S]earch by [G]rep" })
		-- keymap.set("n", "<leader>sg", tb.live_grep, { desc = "[S]earch by [G]rep" })
		keymap.set("n", "<leader>ss", tb.grep_string, { desc = "[S]earch current [W]orld" })
		keymap.set("n", "<leader>sk", tb.keymaps, { desc = "[S]earch [K]eymaps" })
		keymap.set("n", "<leader>sd", tb.diagnostics, { desc = "[S]earch [D]iagnostics" })
		keymap.set("n", "<leader>sb", tb.buffers, { desc = "[ ] Find existing buffers" })
		keymap.set("n", "<leader>si", tb.search_history, { desc = "[S]earch H[I]story" })
    keymap.set("n", "<leader>sz", tb.spell_suggest, { desc = "[S]pell suggest"})
		-- Slightly advanced example of overriding default behavior and theme
		keymap.set("n", "<leader>/", function()
			-- You can pass additional configuration to telescope to change theme, layout, etc.
			tb.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "[/] Fuzzily search in current buffer" })

		-- Also possible to pass additional configuration options.
		-- See `:help telescope.builtin.live_grep()` for information about particular keys
		keymap.set("n", "<leader>s/", function()
			tb.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "[S]earch [/] in Open Files" })

		-- Shortcut for searching your neovim configuration files
		keymap.set("n", "<leader>sn", function()
			tb.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "[S]earch [N]eovim files" })

		-- Search visual text
		function vim.getVisualSelection()
			vim.cmd('noau normal! "vy"')
			local text = vim.fn.getreg("v")
			vim.fn.setreg("v", {})

			text = string.gsub(text, "\n", "")
			if #text > 0 then
				return text
			else
				return ""
			end
		end

		local opts = { noremap = true, silent = true }

		keymap.set("v", "<leader><leader>", function()
			local text = vim.getVisualSelection()
			tb.live_grep({ default_text = text })
		end, opts)
	end,
}
