require("postr.core.remap")
require("postr.core.options")

local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- -- Проверка маппингов
-- vim.keymap.set('n', '<leader>km', function()
--   local modes = {'n', 'i', 'v', 'x', 's', 'o', 't', 'c'}
--   for _, mode in ipairs(modes) do
--     local maps = vim.api.nvim_get_keymap(mode)
--     for _, map in ipairs(maps) do
--       if map.lhs:match('<C%-i>') or map.lhs:match('<Tab>') then
--         print(string.format("Mode: %s, LHS: %s, RHS: %s, Desc: %s", 
--           mode, map.lhs, map.rhs or 'function', map.desc or ''))
--       end
--     end
--   end
-- end, { desc = 'Show Tab/C-i keymaps' })
--
