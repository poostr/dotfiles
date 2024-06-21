return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	init = function()
		local ok, wf = pcall(require, "vim.lsp._watchfiles")
		if ok then
			-- disable lsp watcher. Too slow on linux
			wf._watchfunc = function()
				return function() end
			end
		end
	end,
	config = function()
		-- import lspconfig plugin
		local lspconfig = require("lspconfig")

		-- import cmp-nvim-lsp plugin
		local cmp_nvim_lsp = require("cmp_nvim_lsp")

		local keymap = vim.keymap -- for conciseness

		local opts = { noremap = true, silent = true }
		local on_attach = function(client, bufnr)
			opts.buffer = bufnr

			-- set keybinds
			opts.desc = "Show LSP references"
			keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

			opts.desc = "Go to declaration"
			keymap.set("n", "gb", vim.lsp.buf.declaration, opts) -- go to declaration

			opts.desc = "Show LSP definitions"
			keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

			opts.desc = "Show LSP implementations"
			keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

			opts.desc = "Show LSP type definitions"
			keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

			opts.desc = "See available code actions"
			keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

			opts.desc = "Smart rename"
			keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename

			opts.desc = "Show buffer diagnostics"
			keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

			opts.desc = "Show line diagnostics"
			keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts) -- show diagnostics for line

			opts.desc = "Go to previous diagnostic"
			keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

			opts.desc = "Go to next diagnostic"
			keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

			opts.desc = "Show documentation for what is under cursor"
			keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

			opts.desc = "Restart LSP"
			keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary

			opts.desc = "Hide diagnostic"
			keymap.set("n", "<leader>lh", vim.diagnostic.hide, opts)

			opts.desc = "Show diagnostic"
			keymap.set("n", "<leader>lr", vim.diagnostic.reset, opts)
		end

		-- used to enable autocompletion (assign to every lsp server config)
		local capabilities = cmp_nvim_lsp.default_capabilities()

		vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
			underline = false,
			update_in_insert = false,
		})

		-- Change the Diagnostic symbols in the sign column (gutter)
		-- (not in youtube nvim video)
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- configure python server
		lspconfig["pyright"].setup({
			filetypes = { "python" },
			settings = {
				python = {
					-- executionEnvironments = {
					--   {
					--     root = "~/Desktop/Autotests/project_api_tests/",
					--     extraPaths = "~/Desktop/Autotests/project_api_tests/api_sync_lib",
					--   },
					--   {
					--     root = "~/Desktop/Autotests/checker_test_users/",
					--     extraPaths = "~/Desktop/Autotests/ati_api_async ",
					--   },
					-- },
					analysis = {
						autoImportCompletions = true,
						diagnosticMode = "workspace",
						autoSearchPaths = false,
					},
				},
			},
			capabilities = capabilities,
			on_attach = on_attach,
		})

		-- Configure `ruff-lsp`.
		-- See: https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#ruff_lsp
		-- For the default config, along with instructions on how to customize the settings
		lspconfig["ruff_lsp"].setup({
			settings = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						-- Ignore all files for analysis to exclusively use Ruff for linting
						ignore = { "*" },
					},
				},
			},
		})

		-- configure lua server (with special settings)
		lspconfig["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = { -- custom settings for lua
				Lua = {
					-- make the language server recognize "vim" global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})

		-- configure yamls
		lspconfig["yamlls"].setup({
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas({
						-- select subset from the JSON schema catalog
						select = {
							"kustomization.yaml",
							"docker-compose.yml",
						},

						-- additional schemas (not in the catalog)
						extra = {
							url = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
							name = "Argo CD Application",
							fileMatch = "argocd-application.yaml",
						},
					}),
				},
			},
		})

		-- configure json server
		lspconfig["jsonls"].setup({
			settings = {
				json = {
					schemas = require("schemastore").json.schemas({
						select = {
							"Renovate",
							"GitHub Workflow Template Properties",
						},
					}),
					validate = { enable = true },
				},
			},
		})

		-- configure toml server
		lspconfig["taplo"].setup({
			settings = {
				evenBetterToml = {
					schema = {
						-- add additional schemas
						associations = {
							["example\\.toml$"] = "https://json.schemastore.org/example.json",
						},
					},
				},
			},
		})

		lspconfig["ltex"].setup({
			settings = {
				ltex = {
					language = "ru-RU",
					enabled = true,
					--  dictionary = {
					--     ["en-US"] = spell_words,
					-- },
				},
			},
		})
	end,
}
