return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },

			session_lens = {
				buftypes_to_ignore = {},
				load_on_setup = true,
				theme_conf = { border = true },
				previewer = false,
			},
		})

		vim.keymap.set("n", "<leader>sl", require("auto-session.session-lens").search_session, { desc = '[S]ession [L]ist'}, { noremap = true, })
    vim.keymap.set('n', "<leader>sw", "<cmd>Autosession delete<CR>", {desc= '[S]ession delete'})
	end,
}
