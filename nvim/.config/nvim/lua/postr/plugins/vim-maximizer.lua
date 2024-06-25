return {
  "szw/vim-maximizer",
  event = "VeryLazy",
  init = function()
    vim.g.maximizer_set_default_mapping = 0
  end,
  keys = {
    { "<leader>sm", "<cmd>MaximizerToggle<CR>", desc = "Maximize/minimize a split" },
  }
}
