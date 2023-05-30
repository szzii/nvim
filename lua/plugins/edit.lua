return {

	"tpope/vim-surround",

	{
		"gcmt/wildfire.vim",
		config = function()
			-- 配置 wildfire.vim 插件
			vim.g.wildfire_objects = { 'i\'', 'i"', 'i)', 'i]', 'i}', 'i>' }
		end
	},

	{
		"windwp/nvim-autopairs",
		config = function()
			require("nvim-autopairs").setup {
			}
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp = require('cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
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

	-- only mocos
	"ybian/smartim",

	{
		"lambdalisue/suda.vim",
		config = function()
			vim.g.suda_smart_edit = 1
		end
	},

}
