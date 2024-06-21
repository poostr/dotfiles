return {
	"Pocco81/auto-save.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local auto_save = require("auto-save")
		auto_save.setup({
			enabled = true,
			execution_message = {
				message = function()
					return ""
				end,
			},
		})
	end,
}
