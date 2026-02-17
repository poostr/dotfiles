return {
	"github/copilot.vim",
	opts = {
		no_tab_map = true,
		suggestion = { auto_trigger = false },
	},

	config = function()
		vim.keymap.set("i", "<C-y>", 'copilot#Accept("")<CR>', {
			expr = true,
			silent = true,
			replace_keycodes = false,
		})
		vim.keymap.set("i", "<C-p>", "<Cmd>call copilot#Next()<CR>", { silent = true })
		vim.keymap.set("i", "<C-n>", "<Cmd>call copilot#Previous()<CR>", { silent = true })
		vim.keymap.set("i", "<C-\\>", "<Cmd>call copilot#Dismiss()<CR>", { silent = true })
		vim.g.copilot_proxy = os.getenv("COPILOT_PROXY")
	end,
}
