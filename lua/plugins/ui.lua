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
					theme = "vscode",
					component_separators = { left = "", right = "" },
					section_separators = { left = "", right = "" },
					ignore_focus = {},
					always_divide_middle = true,
					globalstatus = false,
					refresh = {
						statusline = 1000,
						tabline = 1000,
						winbar = 1000,
					},
				},
				sections = {
					lualine_a = { "mode" },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "searchcount" },
					lualine_x = {
						"encoding",
						"fileformat",
						"filetype",
					},
					lualine_y = { "progress" },
					lualine_z = { "location" },
				},
			})
		end,
	},
	{
		'akinsho/bufferline.nvim',
		version = "*",
		dependencies = 'nvim-tree/nvim-web-devicons',
		config = function()
			local bufferline = require('bufferline')
			bufferline.setup({
				options = {
					style_preset = bufferline.style_preset.no_italic,
					--numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
					numbers = function(opts)
						return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
					end,
				},
				highlights = {
					fill = {
						bg = 'none',
					}
				}
			})
			vim.api.nvim_set_keymap("n", "t1", ':BufferLineGoToBuffer 1<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t2", ':BufferLineGoToBuffer 2<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t3", ':BufferLineGoToBuffer 3<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t4", ':BufferLineGoToBuffer 4<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t5", ':BufferLineGoToBuffer 5<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t6", ':BufferLineGoToBuffer 6<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t7", ':BufferLineGoToBuffer 7<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t8", ':BufferLineGoToBuffer 8<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t9", ':BufferLineGoToBuffer 9<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "t0", ':BufferLineGoToBuffer -1<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "ti", '<Cmd>BufferLineCycleNext<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "tn", '<Cmd>BufferLineCyclePrev<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "TI", '<Cmd>BufferLineMoveNext<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "TN", '<Cmd>BufferLineMovePrev<CR>', { noremap = true, silent = true })
			vim.api.nvim_set_keymap("n", "tQ", '<Cmd>BufferLineCloseOthers<CR>', { noremap = true, silent = true })
			--vim.api.nvim_set_keymap("n", "Ti", ':BufferLineMoveNext<CR>', { silent = true, expr = true })
			--vim.api.nvim_set_keymap("n", "Tn", ':BufferLineMovePrev<CR>', { silent = true, expr = true })
			--vim.api.nvim_set_keymap("n", "TN", ':lua require"bufferline".move_to(1)<CR>', { silent = true, expr = true })
		end,
	},

	--{
	--"romgrk/barbar.nvim",
	--dependencies = {
	--"lewis6991/gitsigns.nvim",  -- OPTIONAL: for git status
	--"nvim-tree/nvim-web-devicons", -- OPTIONAL: for file icons
	--},
	--init = function()
	--vim.g.barbar_auto_setup = false
	--end,
	--config = function()
	--local map = vim.api.nvim_set_keymap
	--local opts = { noremap = true, silent = true }
	--require("barbar").setup({
	--animation = false,
	--exclude_ft = { "javascript", "qf" },
	--icons = {
	--buffer_index = true,
	--},
	--})

	---- Move to previous/next
	--map("n", "tn", "<Cmd>BufferPrevious<CR>", opts)
	--map("n", "ti", "<Cmd>BufferNext<CR>", opts)
	---- Re-order to previous/next
	--map("n", "tN", "<Cmd>BufferMovePrevious<CR>", opts)
	--map("n", "tI", "<Cmd>BufferMoveNext<CR>", opts)
	---- Goto buffer in position...
	--map("n", "t1", "<Cmd>BufferGoto 1<CR>", opts)
	--map("n", "t2", "<Cmd>BufferGoto 2<CR>", opts)
	--map("n", "t3", "<Cmd>BufferGoto 3<CR>", opts)
	--map("n", "t4", "<Cmd>BufferGoto 4<CR>", opts)
	--map("n", "t5", "<Cmd>BufferGoto 5<CR>", opts)
	--map("n", "t6", "<Cmd>BufferGoto 6<CR>", opts)
	--map("n", "t7", "<Cmd>BufferGoto 7<CR>", opts)
	--map("n", "t8", "<Cmd>BufferGoto 8<CR>", opts)
	--map("n", "t9", "<Cmd>BufferGoto 9<CR>", opts)
	--map("n", "t0", "<Cmd>BufferLast<CR>", opts)
	---- Pin/unpin buffer
	--map("n", "tp", "<Cmd>BufferPin<CR>", opts)
	---- Close buffer
	--map("n", "tq", "<Cmd>BufferClose<CR>", opts)
	--map("n", "tQ", "<Cmd>BufferCloseAllButCurrentOrPinned<CR>", opts)
	--map("n", "tl", "<Cmd>BufferCloseBuffersLeft<CR>", opts)
	--map("n", "tr", "<Cmd>BufferCloseBuffersRight<CR>", opts)
	---- Wipeout buffer
	----                 :BufferWipeout
	---- Close commands
	----                 :BufferCloseAllButCurrent
	----                 :BufferCloseAllButPinned
	----                 :BufferCloseAllButCurrentOrPinned
	----                 :BufferCloseBuffersLeft
	----                 :BufferCloseBuffersRight
	---- Magic buffer-picking mode
	--map("n", "<C-p>", "<Cmd>BufferPick<CR>", opts)
	--end,
	--version = "^1.0.0", -- optional: only update when a new 1.x version is released
	--},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim", -- optional for vim.ui.select
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
					},
				},
				messages = {
					enabled = true,         -- enables the Noice messages UI
					view = "notify",        -- default view for messages
					view_error = "notify",  -- view for errors
					view_warn = "notify",   -- view for warnings
					view_history = "messages", -- view for :messages
					view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
				},
				popupmenu = {
					enabled = true,
					backend = "cmp",
				},
				lsp = {
					progress = {
						enabled = false,
					},
					-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
					override = {
						["vim.lsp.util.convert_input_to_markdown_lines"] = true,
						["vim.lsp.util.stylize_markdown"] = true,
						["cmp.entry.get_documentation"] = true,
					},
					message = {
						-- Messages shown by lsp servers
						enabled = false,
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
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/playground",
		},
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the five listed parsers should always be installed)
				ensure_installed = "all",

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (for "all")
				--ignore_install = { "javascript" },

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
					--disable = function(lang, buf)
					--local max_filesize = 100 * 1024 -- 100 KB
					--local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					--if ok and stats and stats.size > max_filesize then
					--return true
					--end
					--end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	},

	{
		"onsails/lspkind.nvim",
		config = function()
			require("lspkind").init({
				mode = "symbol_text",
				preset = "codicons",
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
		end,
	},


	{
		"szzii/vscode.nvim",
		--dependencies = {
		--"folke/which-key.nvim",
		--},
		config = function()
			require("vscode").setup({
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
					NormalFloat = { bg = "NONE" },
					LspInlayHint = { bg = "NONE", fg = "grey", italic = true },

					-- nvim-treesitter
					["@variable"] = { fg = "#F5ECEB" },
					["@parameter"] = { fg = "#F5ECEB" },
					["@field"] = { fg = "#F5ECEB" },
					["@constant"] = { italic = true },
					["@type.qualifier.java"] = { link = "@keyword" },
					["@exception.java"] = { link = "@keyword" },

					-- barbar
					BufferTabpageFill = { bg = "NONE" },
					BufferCurrent = { fg = "white", bg = "NONE", bold = true },
					BufferCurrentIndex = { fg = "white", bg = "NONE" },
					BufferCurrentMod = { fg = "#d7ba7d", bg = "NONE", bold = true },
					BufferCurrentSign = { fg = "grey", bg = "NONE" },
					BufferCurrentIcon = { bg = "NONE" },
					BufferCurrentTarget = { bg = "NONE" },

					BufferInactive = { fg = "#808080", bg = "NONE" },
					BufferInactiveIndex = { fg = "#808080", bg = "NONE" },
					BufferInactiveMod = { fg = "#808080", bg = "NONE" },
					BufferInactiveSign = { bg = "NONE" },
					BufferInactiveTarget = { bg = "NONE" },

					-- bufferline
					BufferLineFill = { bg = "NONE" },
					BufferLineBufferSelected = { bold = true },
					BufferLineDevIconLuaInactive = { fg = "grey" },
					BufferLineInfo = { fg = "grey" },
					BufferLineNumbers = { fg = "grey" },
					BufferLineCloseButton = { fg = "grey" },

					-- leap.nvim
					LeapMatch = { fg = "yellow" },
					-- LeapLabelPrimary = { fg = 'red' }
					-- LeapLabelSecondary = { fg = 'blue' }
					-- LeapLabelSelected = { fg = 'black' }
					LeapBackdrop = { fg = "grey" },

					-- neo-tree
					NeoTreeCursorLine = { bg = "#5a5a5a" },

					-- Diagnostic
					--DiagnosticWarn = { fg = 'yellow', bg = 'NONE' },
					--DiagnosticError = { fg = "red", bg = "NONE" },
					--DiagnosticHint = { fg = 'grey', bg = 'NONE' },
					--DiagnosticInfo = { fg = 'white', bg = 'NONE' },

					-- which key
					WhichKeyFloat = { bg = "NONE" },
					--WhichKeyBorder = { fg = 'grey' },

					-- BufferCurrentIcon = { fg = 'yellow'}

				},
			})
		end,
	},
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinNew" },
	}

	--{
	--"Bekaboo/dropbar.nvim",
	--config = function()
	--require("dropbar").setup({
	--})
	--end
	--}

}
