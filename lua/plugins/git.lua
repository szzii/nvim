return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require('gitsigns').setup({
				signcolumn                   = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl                        = true, -- Toggle with `:Gitsigns toggle_numhl`
				linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
				watch_gitdir                 = {
					interval = 1000,
					follow_files = true
				},
				attach_to_untracked          = true,
				current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
				current_line_blame_opts      = {
					virt_text = true,
					virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
					delay = 1000,
					ignore_whitespace = false,
				},
				current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
				sign_priority                = 6,
				update_debounce              = 100,
				status_formatter             = nil, -- Use default
				max_file_length              = 40000, -- Disable if file is longer than this (in lines)
				preview_config               = {
					border = 'single',
					style = 'minimal',
					relative = 'cursor',
					row = 0,
					col = 1
				},
			})
		end
	},

	{
		"kdheepak/lazygit.nvim",
		lazy = true,
		config = function()
			vim.g.lazygit_floating_window_winblend = 0
			vim.g.lazygit_floating_window_scaling_factor = 0.8
			vim.g.lazygit_floating_window_border = { '╭', '╮', '╰', '╯' }
		end,
		keys = {
			{ "<leader>g", ":LazyGit<CR>", mode = "n", silent = true, noremap = true, desc = 'LazyGit' }
		}
	},
}
