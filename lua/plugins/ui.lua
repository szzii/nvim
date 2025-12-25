return {

	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			"szzii/vscode.nvim",
		},
		config = function()
			-- Load theme from local config
			local ok, local_config = pcall(require, "local")
			local lualine_theme = ok and local_config.theme and local_config.theme.lualine_theme or "vscode"

			require("lualine").setup({
				options = {
					icons_enabled = true,
					theme = lualine_theme,
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
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"stevearc/dressing.nvim",
		},
		config = function()
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
				-- Install only the languages you actually use
				ensure_installed = {
					"lua", "vim", "vimdoc",
					"typescript", "tsx", "javascript", "jsdoc",
					"python",
					"go",
					"java",
					"rust",
					"c", "cpp",
					"html", "css", "scss",
					"json", "jsonc", "yaml", "toml",
					"markdown", "markdown_inline",
					"bash", "diff", "git_config", "git_rebase", "gitcommit", "gitignore",
					"dart",
				},

				sync_install = false,
				auto_install = true,

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
				-- Incremental selection
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<CR>",
						node_incremental = "<CR>",
						scope_incremental = "<leader><TAB>",
						node_decremental = "<S-CR>",
					},
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
		config = function()
			-- Load theme transparency from local config
			local ok, local_config = pcall(require, "local")
			local transparent = ok and local_config.theme and local_config.theme.transparent or true

			require("vscode").setup({
				transparent = transparent,
				italic_comments = true,
				group_overrides = {
				StatusLine = { bg = "NONE" },
				StatusLineNC = { bg = "NONE" },
				lualine_a_normal = { bg = "NONE" },
				lualine_b_normal = { bg = "NONE" },
				lualine_c_normal = { bg = "NONE" },
				lualine_x_normal = { bg = "NONE" },
				lualine_y_normal = { bg = "NONE" },
				lualine_z_normal = { bg = "NONE" },
				lualine_a_insert = { bg = "NONE" },
				lualine_b_insert = { bg = "NONE" },
				lualine_c_insert = { bg = "NONE" },
				lualine_x_insert = { bg = "NONE" },
				lualine_y_insert = { bg = "NONE" },
				lualine_z_insert = { bg = "NONE" },
				lualine_a_visual = { bg = "NONE" },
				lualine_b_visual = { bg = "NONE" },
				lualine_c_visual = { bg = "NONE" },
				lualine_x_visual = { bg = "NONE" },
				lualine_y_visual = { bg = "NONE" },
				lualine_z_visual = { bg = "NONE" },
				lualine_a_replace = { bg = "NONE" },
				lualine_b_replace = { bg = "NONE" },
				lualine_c_replace = { bg = "NONE" },
				lualine_x_replace = { bg = "NONE" },
				lualine_y_replace = { bg = "NONE" },
				lualine_z_replace = { bg = "NONE" },
				lualine_a_command = { bg = "NONE" },
				lualine_b_command = { bg = "NONE" },
				lualine_c_command = { bg = "NONE" },
				lualine_x_command = { bg = "NONE" },
				lualine_y_command = { bg = "NONE" },
				lualine_z_command = { bg = "NONE" },
				lualine_a_terminal = { bg = "NONE" },
				lualine_b_terminal = { bg = "NONE" },
				lualine_c_terminal = { bg = "NONE" },
				lualine_x_terminal = { bg = "NONE" },
				lualine_y_terminal = { bg = "NONE" },
				lualine_z_terminal = { bg = "NONE" },
				Search = { bg = "#65FF58", fg = "#26120F", bold = true },
				CursorLineNr = { fg = "white" },
				CursorLine = { bold = true, bg = "#222222" },
				NormalFloat = { bg = "NONE" },
				LspInlayHint = { bg = "NONE", fg = "grey", italic = true },
				["@variable"] = { fg = "#F5ECEB" },
				["@parameter"] = { fg = "#F5ECEB" },
				["@field"] = { fg = "#F5ECEB" },
				["@constant"] = { italic = true },
				["@type.qualifier.java"] = { link = "@keyword" },
				["@exception.java"] = { link = "@keyword" },
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
				BufferLineFill = { bg = "NONE" },
				BufferLineBufferSelected = { bold = true },
				BufferLineDevIconLuaInactive = { fg = "grey" },
				BufferLineInfo = { fg = "grey" },
				BufferLineNumbers = { fg = "grey" },
				BufferLineCloseButton = { fg = "grey" },
				LeapMatch = { fg = "yellow" },
				LeapBackdrop = { fg = "grey" },
				NeoTreeCursorLine = { bg = "#5a5a5a" },
				WhichKeyFloat = { bg = "NONE" },
				},
			})
		end,
	},
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinNew" },
	}

}
