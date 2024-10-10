return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local oil = require("oil")
		local detail = false

		vim.keymap.set("n", "<leader>e", function()
			oil.open()
			-- Wait until oil has opened, for a maximum of 1 second.
			vim.wait(1000, function()
				return oil.get_cursor_entry() ~= nil
			end)
			if oil.get_cursor_entry() then
				oil.open_preview()
			end
		end, { desc = "open dir" })

		oil.setup({
			prompt_save_on_select_new_entry = true,
			default_file_explorer = true,
			constrain_cursor = "editable",
			delete_to_trash = true,
			skip_confirm_for_simple_edits = true,
			view_options = {
				is_hidden_file = function(name, _)
					if vim.startswith(name, "__p") then
						return true
					elseif vim.startswith(name, ".idea") then
						return true
					elseif vim.startswith(name, ".DS") then
						return true
					elseif vim.startswith(name, ".ruff") then
						return true
					elseif vim.startswith(name, ".pytest") then
						return true
					elseif vim.startswith(name, ".venv") then
						return true
					elseif vim.startswith(name, ".gitlab-ci.yml") then
						return false
					elseif vim.startswith(name, ".g") then
						return true
					end
				end,
			},
			float = {
				preview_split = "left",
				override = function(conf)
					return conf
				end,
			},
			preview = {
				update_on_cursor_moved = true,
			},
			keymaps = {
				["gd"] = {
					desc = "Toggle file detail view",
					callback = function()
						detail = not detail
						if detail then
							require("oil").set_columns({ "icon", "permissions", "size", "mtime" })
						else
							require("oil").set_columns({ "icon" })
						end
					end,
				},
			},
		})
	end,
}
