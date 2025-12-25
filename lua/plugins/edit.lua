return {

	"tpope/vim-surround",

	{
		"gcmt/wildfire.vim",
		config = function()
			vim.g.wildfire_objects = { 'i\'', 'i"', 'i)', 'i]', 'i}', 'i>' }
		end
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup {
			}
		end
	},

	{
		"mg979/vim-visual-multi",
		init = function()
			vim.g.VM_leader = ','
			vim.g.VM_maps   = {
				['i']                  = 'k',
				['I']                  = 'K',

				['Find Under']         = '<C-k>',
				['Find Subword Under'] = '<C-k>',
				['Skip Region']        = '<c-n>',
				['Remove Region']      = 'q',
			}
		end
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup({
				toggler = {
					line = '<leader>c',
				},
				opleader = {
					line = '<leader>c',
				},
			})
		end,
		keys = {
			{ "<leader>c", mode = { "n", "x" }, desc = 'Comment toggle' },
		},
	},

	{
		"lambdalisue/suda.vim",
		config = function()
			vim.g.suda_smart_edit = 1
		end
	},

	{
		"iamcco/markdown-preview.nvim",
		lazy = true,
		ft = { "markdown" },
		build = "cd app && yarn install",
	},
}
