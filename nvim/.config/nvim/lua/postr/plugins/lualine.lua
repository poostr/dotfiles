return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"AlexvZyl/nordic.nvim",
	},
	config = function()
		local lualine = require("lualine")
		local lazy_status = require("lazy.status") -- to configure lazy pending updates count

		-- get schema for current buffer
		local function get_schema()
			if vim.bo.filetype ~= "yaml" then
				return ""
			end
			local schema = require("yaml-companion").get_buf_schema(0)
			if schema and schema.result and schema.result[1] and schema.result[1].name == "none" then
				return ""
			end
			return schema and schema.result and schema.result[1] and schema.result[1].name or ""
		end

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				theme = "nordic",
        refresh = {
          statusline = 1000
        },
				component_separators = "|",
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_x = {
					"venv-selector",
					get_schema,
					{
						lazy_status.updates,
						cond = lazy_status.has_updates,
						color = { fg = "#ff9e64" },
					},
					"filetype" ,
					"encoding",
				},
			},
		})
	end,
}
