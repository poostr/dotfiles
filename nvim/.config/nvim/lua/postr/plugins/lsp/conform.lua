return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- go = { "goimports", "gofmt" },
				-- rust = { "rustfmt", lsp_format = "fallback" },
				python = function(bufnr)
					if require("conform").get_formatter_info("ruff_format", bufnr).available then
						return { "ruff_format", "ruff_fix" }
					else
						return { "isort" }
					end
				end,
				-- Use the "*" filetype to run formatters on all filetypes.
				["*"] = { "codespell" },
				-- Use the "_" filetype to run formatters on filetypes that don't
				-- have other formatters configured.
				["_"] = { "trim_whitespace" },
			},
			-- Set this to change the default values when calling conform.format()
			-- This will also affect the default values for format_on_save/format_after_save
			default_format_opts = {
				lsp_format = "fallback",
			},
			-- If this is set, Conform will run the formatter on save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			format_on_save = false,
			-- I recommend these options. See :help conform.format for details.
			-- 	lsp_format = "fallback",
			-- 	timeout_ms = 500,
			-- },
			-- If this is set, Conform will run the formatter asynchronously after save.
			-- It will pass the table to conform.format().
			-- This can also be a function that returns the table.
			-- format_after_save = {
			-- 	lsp_format = "fallback",
			-- },
			-- Set the log level. Use `:ConformInfo` to see the location of the log file.
			log_level = vim.log.levels.ERROR,
			-- Conform will notify you when a formatter errors
			notify_on_error = true,
			-- Conform will notify you when no formatters are available for the buffer
			notify_no_formatters = true,
			-- Custom formatters and overrides for built-in formatters
		})

		-- You can set formatters_by_ft and formatters directly
		-- require("conform").formatters_by_ft.lua = { "stylua" }
		-- require("conform").formatters.my_formatter = {
		-- 	command = "my_cmd",
		-- }

		vim.keymap.set("n", "<leader>gf", function()
			require("conform").format({ lsp_format = "fallback" })
		end)
	end,
}
