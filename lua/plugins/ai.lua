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
			-- vim.g.copilot_no_mappings = 0  -- Disable all default copilot mappings
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
}

