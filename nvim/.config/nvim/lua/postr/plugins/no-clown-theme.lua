return {
	"aktersnurra/no-clown-fiesta.nvim",
	config = function()
		require("no-clown-fiesta").setup({
			transparent = true, -- Enable this to disable the bg color
			styles = {
				-- You can set any of the style values specified for `:h nvim_set_hl`
				comments = { italic = true },
				functions = {},
				keywords = {},
				lsp = { underline = true },
				match_paren = {},
				type = { bold = true },
				variables = {},
				bufferline = {
					current = {},
					modified = { italic = true },
				},
			},
		})
		vim.cmd.colorscheme("no-clown-fiesta")
	end,
}
