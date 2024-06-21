-- -- from this guide https://www.arthurkoziel.com/json-schemas-in-neovim/
return {
	"someone-stole-my-name/yaml-companion.nvim",
	dependencies = {
		{ "neovim/nvim-lspconfig" },
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope.nvim" },
	},
	config = function()
		-- :Telescope yaml_schema
		require("telescope").load_extension("yaml_schema")

		local cfg = require("yaml-companion").setup({
			-- detect k8s schemas based on file content
			builtin_matchers = {
				kubernetes = { enabled = true },
			},

			-- schemas available in Telescope picker
			schemas = {
				-- not loaded automatically, manually select with
				-- :Telescope yaml_schema
				{
					name = "Argo CD Application",
					uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
				},
				-- schemas below are automatically loaded, but added
				-- them here so that they show up in the statusline
				{
					name = "Kustomization",
					uri = "https://json.schemastore.org/kustomization.json",
				},
				{
					name = "GitHub Workflow",
					uri = "https://json.schemastore.org/github-workflow.json",
				},
				{
					name = "Gitlab CI",
					uri = "https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json",
				},
				{
					name = "Ansible Playbook",
					uri = "https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json",
				},
			},

			lspconfig = {
				settings = {
					yaml = {
						validate = true,
						schemaStore = {
							enable = false,
							url = "",
						},

						-- schemas from store, matched by filename
						-- loaded automatically
						-- https://www.schemastore.org/api/json/catalog.json
						schemas = require("schemastore").yaml.schemas({
							select = {
								"kustomization.yaml",
								"GitHub Workflow",
								"gitlab-ci",
								"Ansible Playbook",
							},
						}),
					},
				},
			},
		})

		require("lspconfig")["yamlls"].setup(cfg)
	end,
}
