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
		"preservim/nerdcommenter",
		lazy = true,
		init = function()
			vim.g.NERDCreateDefaultMappings = 0
		end,
		keys = {
			{ "<leader>c", "<Plug>NERDCommenterToggle", mode = { "n", "x" }, noremap = true, desc = 'Comment' },

		}
	},

	{
		"lambdalisue/suda.vim",
		config = function()
			vim.g.suda_smart_edit = 1
		end
	},

	{
		"iamcco/markdown-preview.nvim",
		build = "cd app && yarn install",
	},
}
