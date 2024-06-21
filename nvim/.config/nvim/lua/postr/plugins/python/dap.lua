return {
	"mfussenegger/nvim-dap",
	enabled = vim.fn.has("win32") == 0,
	-- event = "User BaseFile",
	dependencies = {
		{ "nvim-neotest/nvim-nio" },
		{ "rcarriga/nvim-dap-ui" },
		{
			"rcarriga/cmp-dap",
			dependencies = { "nvim-cmp" },
			config = function()
				require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
					sources = {
						{ name = "dap" },
					},
				})
			end,
		},
		{
			"fussenegger/nvim-dap-python",
			ft = "python",
			config = function()
				-- uses the debugypy installation by mason
				local debugpyPythonPath = require("mason-registry").get_package("debugpy"):get_install_path()
					.. "/venv/bin/python3"
				require("dap-python").setup(debugpyPythonPath, {})

				require("dap-python").test_runner = "pytest"
				local test_runners = require("dap-python").test_runners
				test_runners.your_runner = function(classname, methodname, opts)
					local args = { classname, methodname }
					return "modulename", args
				end

				-- vim.keymap.set("n", "<leader>dp", function() require("dap-python").test_method() end, { desc = "Pytest method" })
				-- vim.keymap.set("n", "<leader>pc", function() require("dap-python").test_class() end, { desc = "Pytest class" })
				-- vim.keymap.set("v", "<leader>ps", function() require("dap-python").debug_selection() end, { desc = "Pytest section" })
			end,
		},
	},
	config = function()
		require("dapui").setup()

		local dap, dapui = require("dap"), require("dapui")

		dap.listeners.before.attach.dapui_config = function()
			dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
			dapui.open()
		end
		-- dap.listeners.before.event_terminated.dapui_config = function()
		-- 	dapui.close()
		-- end
		-- dap.listeners.before.event_exited.dapui_config = function()
		-- 	dapui.close()
		-- end

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.keymap.set("n", "<F8>", ":DapToggleBreakpoint<CR>", { desc = "Toogle [B]reakpoint" })
		vim.keymap.set("n", "<leader>b", ":DapToggleBreakpoint<CR>", { desc = "Toogle [B]reakpoint" })
		vim.keymap.set("n", "<F2>", ":DapContinue<CR>", { desc = "[D]ap [C]ontinue" })
		vim.keymap.set("n", "<leader>dc", ":DapContinue<CR>", { desc = "[D]ap [C]ontinue" })
		vim.keymap.set("n", "<leader>dt", function() dapui.close() end, { desc = "[D]ap [T]erminate" })
		vim.keymap.set("n", "<F9>", ":DapStepOver<CR>", { desc = "[D]ap [S]tep over" })
		vim.keymap.set("n", "<leader>ds", ":DapStepOver<CR>", { desc = "[D]ap [S]tep over" })

		-- Python
		dap.adapters.python = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python",
			args = { "-m", "debugpy.adapter" },
		}
		dap.configurations.python = {
			{
				type = "python",
				request = "launch",
				name = "Launch file",
				program = "${file}", -- This configuration will launch the current file if used.
			},
		}

		-- Lua
		dap.adapters.nlua = function(callback, config)
			callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
		end
		dap.configurations.lua = {
			{
				type = "nlua",
				request = "attach",
				name = "Attach to running Neovim instance",
				program = function()
					pcall(require("osv").launch({ port = 8086 }))
				end,
			},
		}

		-- -- Go
		-- -- Requires:
		-- -- * You have initialized your module with 'go mod init module_name'.
		-- -- * You :cd your project before running DAP.
		-- dap.adapters.delve = {
		-- 	type = "server",
		-- 	port = "${port}",
		-- 	executable = {
		-- 		command = vim.fn.stdpath("data") .. "/mason/packages/delve/dlv",
		-- 		args = { "dap", "-l", "127.0.0.1:${port}" },
		-- 	},
		-- }
		-- dap.configurations.go = {
		-- 	{
		-- 		type = "delve",
		-- 		name = "Compile module and debug this file",
		-- 		request = "launch",
		-- 		program = "./${relativeFileDirname}",
		-- 	},
		-- 	{
		-- 		type = "delve",
		-- 		name = "Compile module and debug this file (test)",
		-- 		request = "launch",
		-- 		mode = "test",
		-- 		program = "./${relativeFileDirname}",
		-- 	},
		-- }
	end,
}
