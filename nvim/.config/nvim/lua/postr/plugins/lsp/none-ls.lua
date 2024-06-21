return {
	"nvimtools/none-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local null_ls = require("null-ls")

		null_ls.setup({
			sources = {
				null_ls.builtins.formatting.stylua,
				null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.ruff,
				null_ls.builtins.completion.spell,
				null_ls.builtins.diagnostics.write_good,
			},
		})

		local keymap = vim.keymap
		keymap.set("n", "<leader>gf", vim.lsp.buf.format, {})
	end,
}
