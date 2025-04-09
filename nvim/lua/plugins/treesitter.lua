local M = {}

function M.setup()
    require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "python",
            "lua",
            "vim",
            "vimdoc",
            "query",
            "yaml",
        },
        highlight = {
            enable = true,
            use_languagetree = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
        },
        autotag = {
            enable = true,
        },
    })
end

return M 