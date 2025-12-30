return {

	{
		"ethanholz/nvim-lastplace",
		event = "BufReadPre",  -- 延迟加载优化
		config = function()
			require 'nvim-lastplace'.setup {}
			vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
			vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
			vim.g.lastplace_open_folds = 1
		end
	},

	{
		"petertriho/nvim-scrollbar",
		event = "BufReadPost",  -- 延迟加载优化
		dependencies = {
			'kevinhwang91/nvim-hlslens',
		},
		config = function()
			require("scrollbar.handlers.search").setup()
			require("scrollbar").setup({
				show = true,
				handle = {
					text = " ",
					color = "#928374",
					hide_if_all_visible = true,
				},
				marks = {
					Search = { color = "yellow" },
					Misc = { color = "purple" },
				},
				handlers = {
					cursor = false,
					diagnostic = true,
					gitsigns = true,
					handle = true,
					search = true,
				},
			})
		end,
	},

	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
			search = {
				command = "rg",
				args = {
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--max-depth=5",  -- 性能优化：限制搜索深度
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		}
	},
	{
		"goolord/alpha-nvim",
		event = function()  -- 条件加载：只在空目录启动时加载
			if vim.fn.argc() == 0 then
				return "VimEnter"
			end
		end,
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require 'alpha'.setup(require 'alpha.themes.startify'.config)
			vim.keymap.set('n', '<leader>1', ':Alpha<CR>', { noremap = true, silent = true })
		end
	},


}
