return {

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			popup_mappings = {
				scroll_down = "<c-e>", -- binding to scroll down inside the popup
				scroll_up = "<c-u>", -- binding to scroll up inside the popup
			},
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
	},

	{
		"ethanholz/nvim-lastplace",
		config = function()
			require 'nvim-lastplace'.setup {}
			vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
			vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
			vim.g.lastplace_open_folds = 1
		end
	},

	{ "folke/neoconf.nvim", cmd = "Neoconf" },


	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("indent_blankline").setup {
				-- for example, context is off by default, use this to turn it on
				show_current_context = true,
			}
			vim.g.indent_blankline_filetype_exclude = { "lspinfo", "checkhealth", "help", "man", "startify", "markdown",
				"json", "jsonc", "qf", "dashboard" }
		end
	},


	{
		"yianwillis/vimcdoc",
		lazy = true,
		ft = "vim"
	},

	{
		"airblade/vim-rooter",
		config = function()
			vim.g.rooter_patterns = { '.git', 'Makefile', '*.sln', 'pom.xml', 'build.gradle', 'Cargo.toml', 'go.mod' }
			vim.g.rooter_cd_cmd = 'lcd'
		end
	}

}
