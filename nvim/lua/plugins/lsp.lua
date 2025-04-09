local M = {}

function M.setup()
    local lspconfig = require("lspconfig")
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    local on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    end

    -- Python LSP
    lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "basic",
                    autoImportCompletions = true,
                    useLibraryCodeForTypes = true,
                },
                formatting = {
                    provider = "black",
                    indentSize = 4,
                },
            },
        },
    })

    -- YAML LSP
    lspconfig.yamlls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
            yaml = {
                format = {
                    enable = true,
                    singleQuote = false,
                    bracketSpacing = true,
                    proseWrap = "preserve",
                    printWidth = 80,
                    tabWidth = 2,
                    useTabs = false,
                    bracketSameLine = false,
                    arrowParens = "avoid",
                    endOfLine = "lf",
                },
                validate = true,
                hover = true,
                completion = true,
                schemaStore = {
                    enable = true,
                    url = "https://json.schemastore.org/schema-catalog.json",
                },
                schemas = {
                    ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
                },
            },
        },
    })

    -- Mason setup
    require("mason").setup()
    require("mason-lspconfig").setup({
        ensure_installed = { "pyright", "yamlls" },
        automatic_installation = true,
    })
end

return M 