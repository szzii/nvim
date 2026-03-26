return {
	{
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ui = {
					border = "rounded",
				},
			})
		end,
	},
	{
		'skywind3000/asyncrun.vim',
		config = function()
			vim.g.asyncrun_open = 12
			vim.g.asyncrun_encs = 'utf-8'
		end

	}
}
