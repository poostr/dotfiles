return {
	"OXY2DEV/markview.nvim",
	ft = "markdown",

	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		require("markview").setup({
			buf_ignore = { "nofile" },
			modes = { "n", "no" },

			options = {
				on_enable = {},
				on_disable = {},
			},

			block_quotes = {},
			checkboxes = {},
			code_blocks = {
					enable = true,
					style = "language",
					hl = "CursorLine",
			},
			headings = {},
			horizontal_rules = {},
			inline_codes = {
        enable = false,
        hl = nil,
      },
			links = {},
			list_items = {},
			tables = {},
		})
	end,
}
