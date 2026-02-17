return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

			session_lens = {
				buftypes_to_ignore = {},
				load_on_setup = false,
				theme_conf = { border = true },
				previewer = false,
			},
		})

		vim.keymap.set("n", "<leader>sl", "<cmd>AutoSession search<CR>", { desc = "[S]ession [L]ist" })
		vim.keymap.set("n", "<leader>sw", "<cmd>AutoSession delete<CR>", { desc = "[S]ession delete" })
	end,
}
