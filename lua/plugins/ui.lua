return {

	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"szzii/vscode.nvim",
		},
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = 'vscode',
					component_separators = { left = '', right = '' },
					section_separators = { left = '', right = '' },
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					}
				},
				sections = {
					lualine_a = { 'mode' },
					lualine_b = { 'branch', 'diff', 'diagnostics' },
					lualine_c = { 'searchcount' },
					lualine_x = {
						'encoding', 'fileformat', 'filetype',
					},
					lualine_y = { 'progress' },
					lualine_z = { 'location' }
				},
			})
		end,
	},
	{
		'romgrk/barbar.nvim',
		dependencies = {
			'lewis6991/gitsigns.nvim',  -- OPTIONAL: for git status
			'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
		},
		init = function() vim.g.barbar_auto_setup = false end,
		config = function()
			local map = vim.api.nvim_set_keymap
			local opts = { noremap = true, silent = true }
			require 'barbar'.setup {
				exclude_ft = { 'javascript', 'qf' },
				icons = {
				},
			}

			-- Move to previous/next
			map('n', 'tn', '<Cmd>BufferPrevious<CR>', opts)
			map('n', 'ti', '<Cmd>BufferNext<CR>', opts)
			-- Re-order to previous/next
			map('n', 'tN', '<Cmd>BufferMovePrevious<CR>', opts)
			map('n', 'tI', '<Cmd>BufferMoveNext<CR>', opts)
			-- Goto buffer in position...
			map('n', 't1', '<Cmd>BufferGoto 1<CR>', opts)
			map('n', 't2', '<Cmd>BufferGoto 2<CR>', opts)
			map('n', 't3', '<Cmd>BufferGoto 3<CR>', opts)
			map('n', 't4', '<Cmd>BufferGoto 4<CR>', opts)
			map('n', 't5', '<Cmd>BufferGoto 5<CR>', opts)
			map('n', 't6', '<Cmd>BufferGoto 6<CR>', opts)
			map('n', 't7', '<Cmd>BufferGoto 7<CR>', opts)
			map('n', 't8', '<Cmd>BufferGoto 8<CR>', opts)
			map('n', 't9', '<Cmd>BufferGoto 9<CR>', opts)
			map('n', 't0', '<Cmd>BufferLast<CR>', opts)
			-- Pin/unpin buffer
			map('n', 'tp', '<Cmd>BufferPin<CR>', opts)
			-- Close buffer
			map('n', 'tq', '<Cmd>BufferClose<CR>', opts)
			map('n', 'tQ', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)
			map('n', 'tl', '<Cmd>BufferCloseBuffersLeft<CR>', opts)
			map('n', 'tr', '<Cmd>BufferCloseBuffersRight<CR>', opts)
			-- Wipeout buffer
			--                 :BufferWipeout
			-- Close commands
			--                 :BufferCloseAllButCurrent
			--                 :BufferCloseAllButPinned
			--                 :BufferCloseAllButCurrentOrPinned
			--                 :BufferCloseBuffersLeft
			--                 :BufferCloseBuffersRight
			-- Magic buffer-picking mode
			map('n', '<C-p>', '<Cmd>BufferPick<CR>', opts)
		end,
		version = '^1.0.0', -- optional: only update when a new 1.x version is released
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			--"rcarriga/nvim-notify",
		},
		config = function()
			--require("notify").setup({
			--background_colour = "#000000",
			--})
			require("noice").setup({
				cmdline = {
					format = {
						cmdline = { icon = " " },
						search_down = { icon = " ⌄" },
						search_up = { icon = " ⌃" },
						filter = { icon = " " },
						lua = { icon = " " },
						help = { icon = " " },
					}
				},
				popupmenu = {
					enabled = true,
					backend = "cmp",
				},
				lsp = {
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
				},
				-- you can enable a preset for easier configuration
				presets = {
					bottom_search = true,    -- use a classic bottom cmdline for search
					command_palette = false, -- position the cmdline and popupmenu together
					long_message_to_split = true, -- long messages will be sent to a split
					inc_rename = false,      -- enables an input dialog for inc-rename.nvim
					lsp_doc_border = false,  -- add a border to hover docs and signature help
				},
			})
		end
	},

	{
		"Xuyuanp/scrollbar.nvim",
	},

	{
		"szzii/vscode.nvim",
		dependencies = {
			"romgrk/barbar.nvim",
			"folke/which-key.nvim",
		},
		config = function()
			require('vscode').setup({
				-- Enable transparent background
				transparent = true,

				italic_comments = true,

				-- Override highlight groups (see ./lua/vscode/theme.lua)
				group_overrides = {
					-- this supports the same val table as vim.api.nvim_set_hl
					-- use colors from this colorscheme by requiring vscode.colors!

					-- vim
					Search = { bg = "#65FF58", fg = "#26120F", bold = true },
					CursorLineNr = { fg = "white" },
					CursorLine = { bold = true, bg = "#222222" },
					NormalFloat = { bg = 'NONE' },

					-- coc.nvim
					CocHighlightText = { bold = true, bg = "#4B4B4B" },

					-- scrollbar
					ScrollbarHandle = { fg = '#26DAFF', bg = 'NONE' },
					ScrollbarWarnHandle = { fg = 'yellow' },
					ScrollbarErrorHandle = { fg = 'red' },
					ScrollbarInfoHandle = { fg = 'white' },
					ScrollbarHintHandle = { fg = 'grey' },
					ScrollbarWarn = { fg = 'yellow' },
					ScrollbarError = { fg = 'red' },
					ScrollbarInfo = { fg = 'white' },
					ScrollbarHint = { fg = 'grey' },

					-- barbar
					BufferTabpageFill = { bg = 'NONE' },

					BufferCurrent = { fg = 'white', bg = 'NONE', bold = true },
					BufferCurrentIndex = { fg = 'white', bg = 'NONE' },
					BufferCurrentMod = { fg = '#d7ba7d', bg = 'NONE', bold = true },
					BufferCurrentSign = { fg = 'grey', bg = 'NONE' },
					BufferCurrentIcon = { bg = 'NONE' },
					BufferCurrentTarget = { bg = 'NONE' },

					BufferInactive = { fg = '#808080', bg = 'NONE' },
					BufferInactiveIndex = { fg = '#808080', bg = 'NONE' },
					BufferInactiveMod = { fg = '#808080', bg = 'NONE' },
					BufferInactiveSign = { bg = 'NONE' },
					BufferInactiveTarget = { bg = 'NONE' },

					-- nvim-treesitter
					['@variable'] = { fg = "#F5ECEB" },
					['@parameter'] = { fg = "#F5ECEB" },
					['@field'] = { fg = "#F5ECEB" },
					['@constant'] = { italic = true },
					['@type.qualifier.java'] = { link = "@keyword" },
					['@exception.java'] = { link = "@keyword" },

					-- leap.nvim
					LeapMatch = { fg = 'yellow' },
					-- LeapLabelPrimary = { fg = 'red' }
					-- LeapLabelSecondary = { fg = 'blue' }
					-- LeapLabelSelected = { fg = 'black' }
					LeapBackdrop = { fg = 'grey' },

					-- Diagnostic
					DiagnosticWarn = { fg = 'yellow', bg = 'NONE' },
					DiagnosticError = { fg = 'red', bg = 'NONE' },
					DiagnosticHint = { fg = 'grey', bg = 'NONE' },
					DiagnosticInfo = { fg = 'white', bg = 'NONE' },

					-- which key
					WhichKeyFloat = { bg = 'NONE' },
					--WhichKeyBorder = { fg = 'grey' },

					-- BufferCurrentIcon = { fg = 'yellow'}
				}
			})
		end
	},

	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = {
			"nvim-treesitter/playground",
		},
		config = function()
			require 'nvim-treesitter.configs'.setup {
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = "all",

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (for "all")
				ignore_install = { "javascript" },

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					--disable = { "c", "rust" },
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			}
		end

	},

	{
		'glepnir/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {
				theme = 'hyper',
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = '󰊳 Update', group = '@property', action = 'Lazy update', key = 'u' },
						{
							icon = ' ',
							icon_hl = '@variable',
							desc = 'Files',
							group = 'Label',
							action = 'Telescope find_files',
							key = 'f',
						},
						{
							desc = ' Apps',
							group = 'DiagnosticHint',
							action = 'Telescope app',
							key = 'a',
						},
						{
							desc = ' dotfiles',
							group = 'Number',
							action = 'Telescope dotfiles',
							key = 'd',
						},
					},
					footer = {} --your footer
				},
				--hide = {
				--statusline    -- hide statusline default is true
				--tabline       -- hide the tabline
				--winbar        -- hide winbar
				--},
				--preview = {
				--command       -- preview command
				--file_path     -- preview file path
				--file_height   -- preview file height
				--file_width    -- preview file width
				--},
			}
		end,
		dependencies = { { 'nvim-tree/nvim-web-devicons' } }
	},
	{
		"onsails/lspkind.nvim",
		config = function()
			require('lspkind').init({
				mode = 'symbol_text',
				preset = 'codicons',
				symbol_map = {
					Text = "󰉿",
					Method = "󰆧",
					Function = "󰊕",
					Constructor = "",
					Field = "󰜢",
					Variable = "󰀫",
					Class = "󰠱",
					Interface = "",
					Module = "",
					Property = "󰜢",
					Unit = "󰑭",
					Value = "󰎠",
					Enum = "",
					Keyword = "󰌋",
					Snippet = "",
					Color = "󰏘",
					File = "󰈙",
					Reference = "󰈇",
					Folder = "󰉋",
					EnumMember = "",
					Constant = "󰏿",
					Struct = "󰙅",
					Event = "",
					Operator = "󰆕",
					TypeParameter = "",
				},
			})
		end
	},


}
