return {
	"nvim-neotest/neotest",
	dependencies = {
    "linux-cultist/venv-selector.nvim",
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-python",
	},
	event = "VeryLazy",
	config = function()
		local neotest = require("neotest")

		neotest.setup({

			-- Run the nearest test
			vim.keymap.set( "n", "<leader>tr", "<cmd>lua require('neotest').run.run()<CR>", { desc = "[T]est [R]un Nearest" }),

			-- Run the current file
			vim.keymap.set( "n", "<leader>tf", "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<CR>", { desc = "[T]est Run [F]ile" }),

			--Debug the nearest test (requires nvim-dap and adapter support)
			vim.keymap.set( "n", "<leader>td", "<cmd>lua require('neotest').run.run({strategy = 'dap'})<CR>", { desc = "[T]est [D]ebug" }),

			--Stop the nearest test, see :h neotest.run.stop()
			vim.keymap.set("n", "<leader>ts", "<cmd>lua require('neotest').run.stop()<CR>", { desc = "[T]est [S]top" }),

      vim.keymap.set("n", "<leader>tw", "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<CR>", { desc = "[T]est [W]atch" }),
			vim.keymap.set("n", "<leader>tS", "<cmd>lua require('neotest').summary.toggle()<CR>", { desc = "[T]est [S]ummary toggle" }),

			vim.keymap.set( "n", "<leader>to", "<cmd>lua require('neotest').output_panel.toggle()<CR>", { desc = "[T]est [O]tput" }),

			-- Test output panel clear
			vim.keymap.set( "n", "<leader>tx", "<cmd>lua require('neotest').output_panel.clear()<CR>", { desc = "[T]est Clear" }),

      status = { virtual_text = true },
			output = {
				enabled = true,
			     quiet = true,
			     last_run = true,
			     auto_close = true,
           open_on_run = "short",
			},
			output_panel = {
				enabled = true,
				open = "bot split | resize 10",
			},
			adapters = {
				require("neotest-python")({
					dap = {
						justMyCode = false,
						console = "integratedTerminal",
					},
					args = { "-sv", "--log-level", "DEBUG" },
					python = require("venv-selector").get_active_path(),
					runner = "pytest",
				}),
			},
		})

    local neotest_ns = vim.api.nvim_create_namespace("neotest")
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          -- Replace newline and tab characters with space for more compact diagnostics
          local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
          return message
        end,
      },
    }, neotest_ns)

	end,
}
