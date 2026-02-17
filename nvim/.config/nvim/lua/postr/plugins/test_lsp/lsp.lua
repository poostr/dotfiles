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
		-- import cmp-nvim-lsp plugin for capabilities
		local cmp_nvim_lsp = require("cmp_nvim_lsp")
		local capabilities = cmp_nvim_lsp.default_capabilities()

		local keymap = vim.keymap

		-- Configure diagnostics globally
		vim.diagnostic.config({
			virtual_text = {
				enabled = true,
				source = "if_many",
				prefix = "●",
				spacing = 4,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
					[vim.diagnostic.severity.INFO] = " ",
				},
			},
			underline = false,
			update_in_insert = false,
			severity_sort = true,
			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = "always",
				header = "",
				prefix = "",
			},
		})

		-- Setup LSP keymaps on LspAttach
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, noremap = true, silent = true }
				local client = vim.lsp.get_client_by_id(ev.data.client_id)

				-- Set keybinds
				opts.desc = "Show LSP references"
        keymap.set("n", "gR", function() require("telescope.builtin").lsp_references() end, opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gb", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", vim.lsp.buf.definition, opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>ld", vim.diagnostic.open_float, opts)

				opts.desc = "Go to previous diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Go to next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Show documentation for what is under cursor"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Hide diagnostic"
				keymap.set("n", "<leader>lh", vim.diagnostic.hide, opts)

				opts.desc = "Show diagnostic"
				keymap.set("n", "<leader>lr", vim.diagnostic.reset, opts)
			end,
		})

		-- ============================================
		-- NEOVIM 0.11+ CONFIG API
		-- ============================================

		-- Configure gopls
		vim.lsp.config.gopls = {
			cmd = { "gopls" },
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_markers = { "go.mod", "go.work", ".git" },
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				-- Fix position_encoding warning
				offsetEncoding = { "utf-16" },
			}),
		}

		-- Configure pyright
		vim.lsp.config.pyright = {
			cmd = { "pyright-langserver", "--stdio" },
			filetypes = { "python" },
			root_markers = {
				"pyproject.toml",
				"setup.py",
				"setup.cfg",
				"requirements.txt",
				"Pipfile",
				".git",
			},
			settings = {
				python = {
					analysis = {
						autoImportCompletions = true,
						autoSearchPaths = false,
					},
					capabilities = capabilities,
				},
			},
		}

		-- Configure lua_ls
		vim.lsp.config.lua_ls = {
			cmd = { "lua-language-server" },
			filetypes = { "lua" },
			root_markers = { ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", ".git" },
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},
						checkThirdParty = false,
					},
					telemetry = {
						enable = false,
					},
				},
			},
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-8" }, -- lua_ls uses utf-8
			}),
		}

		-- Configure yamlls
		vim.lsp.config.yamlls = {
			cmd = { "yaml-language-server", "--stdio" },
			filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
			root_markers = { ".git" },
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
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-16" },
			}),
		}

		-- Configure jsonls
		vim.lsp.config.jsonls = {
			cmd = { "vscode-json-language-server", "--stdio" },
			filetypes = { "json", "jsonc" },
			root_markers = { ".git" },
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
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-16" },
			}),
		}

		-- Configure taplo (TOML)
		vim.lsp.config.taplo = {
			cmd = { "taplo", "lsp", "stdio" },
			filetypes = { "toml" },
			root_markers = { "*.toml", ".git" },
			settings = {
				evenBetterToml = {
					schema = {
						associations = {
							["example\\.toml$"] = "https://json.schemastore.org/example.json",
						},
					},
				},
			},
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-16" },
			}),
		}

		-- Configure ltex (grammar/spell checking)
		vim.lsp.config.ltex = {
			cmd = { "ltex-ls" },
			filetypes = { "tex", "latex", "markdown", "text" },
			root_markers = { ".git" },
			settings = {
				ltex = {
					language = "ru-RU",
					enabled = true,
				},
			},
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-16" },
			}),
		}

		-- Configure sourcekit (Swift)
		vim.lsp.config.sourcekit = {
			cmd = { "sourcekit-lsp" },
			filetypes = { "swift", "objective-c", "objective-cpp" },
			root_markers = { "Package.swift", ".git" },
			capabilities = vim.tbl_deep_extend("force", capabilities, {
				offsetEncoding = { "utf-8" },
			}),
		}

		-- ============================================
		-- ENABLE LSP SERVERS PER FILETYPE
		-- ============================================

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function()
				vim.lsp.enable("gopls")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "python",
			callback = function()
				vim.lsp.enable("pyright")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "lua",
			callback = function()
				vim.lsp.enable("lua_ls")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "yaml", "yaml.docker-compose", "yaml.gitlab" },
			callback = function()
				vim.lsp.enable("yamlls")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "json", "jsonc" },
			callback = function()
				vim.lsp.enable("jsonls")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "toml",
			callback = function()
				vim.lsp.enable("taplo")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "tex", "latex", "markdown", "text" },
			callback = function()
				vim.lsp.enable("ltex")
			end,
		})

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "swift", "objective-c", "objective-cpp" },
			callback = function()
				vim.lsp.enable("sourcekit")
			end,
		})
	end,
}
