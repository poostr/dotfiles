return {
	"Pocco81/auto-save.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local auto_save = require("auto-save")
		auto_save.setup({
			trigger_events = { "InsertLeave", "TextChanged" },
			condition = function(buf)
				if vim.bo[buf].filetype == "harpoon" then
					return false
				end
			end,
			enabled = true,
			execution_message = {
				message = function()
					return ""
				end,
			},
		})
	end,
}
