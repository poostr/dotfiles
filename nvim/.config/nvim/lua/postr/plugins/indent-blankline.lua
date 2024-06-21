return {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
        scope = {
            enabled = false,
        },
    },
    config = function(_, opts)
        require("ibl").setup(opts)
    end
}

