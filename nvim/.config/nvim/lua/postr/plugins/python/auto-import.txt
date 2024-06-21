return {
  "stevanmilic/nvim-lspimport",
  event = "VeryLazy",
  config = function()
      vim.keymap.set("n", "<leader>ai", require("lspimport").import, { desc = "[a]uto [i]mport" }, { noremap = true })
  end,
}

-- Not working
