return {
	"akinsho/bufferline.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	version = "*",
  keys = {
    {"<leader>]", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer"}},
    {"<leader>[", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer"}},
  },
	config = function()
		local bufferline = require("bufferline")
		bufferline.setup({
			options = {
				separator_style =  "thin",
				style_preset = bufferline.style_preset.default,
				themable = true,
				show_buffer_icons = false,
			},
			highlights = {
				buffer_selected = {
					bg = "#c4a7e7",
					bold = true,
          italic = false,
				},
			},
		})
	end,
}
