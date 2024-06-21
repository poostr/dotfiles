return {
	"sidebar-nvim/sidebar.nvim",
	config = function()
		local sidebar = require("sidebar-nvim")

		vim.keymap.set("n", "<leader>q", function() sidebar.toggle() end, { desc = "Toggle sidebar" })

		require("sidebar-nvim").setup({
			bindings = nil,
			open = true,
			side = "left",
			initial_width = 30,
			hide_statusline = true,
			update_interval = 1000,
			sections = { "files", "containers", "git" },
			section_separator = { "", "-----", "" },
			section_title_separator = { "" },
			containers = {
        icon = "",
				attach_shell = "/bin/sh",
				show_all = true,
				interval = 5000,
			},
			todos = { ignored_paths = { "~" } },
		})
	end,
}
