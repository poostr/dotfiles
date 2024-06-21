return {
  "mbbill/undotree",
  event ={ "BufReadPre", "BufNewFile" },
  keys = {
    vim.keymap.set('n', '<leader><F5>', vim.cmd.UndotreeToggle)
  }
}
