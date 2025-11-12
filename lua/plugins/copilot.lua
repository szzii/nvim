-- Load local configuration
local ok, local_config = pcall(require, "local")
local copilot_enabled = ok and local_config.copilot_enabled or true

return {
	{
		"github/copilot.vim",
		enabled = copilot_enabled,
		config = function()
			vim.g.copilot_enabled = copilot_enabled
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

			-- Use Colemak-aware keymaps if enabled
			local use_colemak = ok and local_config.use_colemak or false
			if use_colemak then
				vim.api.nvim_set_keymap("i", "<C-u>", 'copilot#Previous()', { silent = true, expr = true })
				vim.api.nvim_set_keymap("i", "<C-e>", 'copilot#Next()', { silent = true, expr = true })
			else
				vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
				vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Next()', { silent = true, expr = true })
			end
		end
	},
	{
		"yetone/avante.nvim",
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
				or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		---@module 'avante'
		---@type avante.Config
		opts = function()
			-- Load provider settings from local config
			local avante_provider = ok and local_config.avante_provider or "ollama"
			local avante_providers = ok and local_config.avante_providers or {}

			return {
				-- add any opts here
				-- this file can contain specific instructions for your project
				instructions_file = "avante.md",
				-- Provider from local.lua
				provider = avante_provider,
				providers = avante_providers,
			}
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			"echasnovski/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			{
				-- support for image pasting
				"HakonHarnes/img-clip.nvim",
				event = "VeryLazy",
				opts = {
					-- recommended settings
					default = {
						embed_image_as_base64 = false,
						prompt_for_file_name = false,
						drag_and_drop = {
							insert_mode = true,
						},
						-- required for Windows users
						use_absolute_path = true,
					},
				},
			},
			{
				-- Make sure to set this up properly if you have lazy=true
				'MeanderingProgrammer/render-markdown.nvim',
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
	},
}
