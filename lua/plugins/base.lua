return {

	{
		"ethanholz/nvim-lastplace",
		config = function()
			require 'nvim-lastplace'.setup {}
			vim.g.lastplace_ignore_buftype = "quickfix,nofile,help"
			vim.g.lastplace_ignore_filetype = "gitcommit,gitrebase,svn,hgcommit"
			vim.g.lastplace_open_folds = 1
		end
	},

	{
		"petertriho/nvim-scrollbar",
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
				},
				-- regex that will be used to match keywords.
				-- don't replace the (KEYWORDS) placeholder
				pattern = [[\b(KEYWORDS)\b]], -- match without the extra colon. You'll likely get false positives
			},
		}
	},
	{
		"goolord/alpha-nvim",
		event = "VimEnter",
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require 'alpha'.setup(require 'alpha.themes.startify'.config)
			vim.keymap.set('n', '<leader>1', ':Alpha<CR>', { noremap = true, silent = true })
		end
	},
	{
  "RRethy/vim-illuminate",
  config = function()
    require('illuminate').configure({
      delay = 100,               -- 延迟 ms
			providers = {
        'lsp',
        'treesitter',
        'regex',
			},
      filetypes_denylist = { "NvimTree", "TelescopePrompt" },
    })
		    -- VSCode 风格淡色
    local faint = "#3C3C3C"
    vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = faint })
    vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = faint })
    vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = faint })

    -- 闪烁效果
    local function flash()
      vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#4F4F4F" })
      vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#4F4F4F" })
      vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#4F4F4F" })

      vim.defer_fn(function()
        vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = faint })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = faint })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = faint })
      end, 150)
    end

    vim.api.nvim_create_autocmd("User", {
      pattern = "Illuminated",
      callback = flash,
    })
  end,
}


}
