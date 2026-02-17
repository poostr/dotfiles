return {
	"saghen/blink.cmp",
	dependencies = { "rafamadriz/friendly-snippets" },
	version = "1.*",
	opts = {
		cmdline = {
			keymap = { preset = "inherit" },
			completion = { menu = { auto_show = true } },
		},
		keymap = {
			preset = "default",
			["<C-o>"] = { "select_and_accept" },
			["<C-j>"] = { "snippet_forward" },
			["<C-k>"] = { "snippet_backward" },
			["<Tab>"] = {},
			["<S-Tab>"] = {},
		},
		appearance = {
			nerd_font_variant = "mono",
		},
		completion = { documentation = { auto_show = false } },

		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
}
