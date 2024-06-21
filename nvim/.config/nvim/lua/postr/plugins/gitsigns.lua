return {
	"lewis6991/gitsigns.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local gs = require("gitsigns")

		gs.setup({
			signs = {
				add = { text = "┃" },
				change = { text = "┃" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
			auto_attach = true,

			vim.keymap.set("n", "<leader>gB", gs.toggle_current_line_blame, { desc = "[G]it [B]lame" }),
			vim.keymap.set("n", "<leader>gp", gs.preview_hunk, { desc = "[G]it [P]review" }),
			vim.keymap.set("n", "<leader>gd", gs.diffthis, { desc = "[G]it [D]iff" }),
      vim.keymap.set('n', '<leader>hD', function() gs.diffthis('~') end, { desc = "[G]it [D]iff this"}),
		})
	end,
}
