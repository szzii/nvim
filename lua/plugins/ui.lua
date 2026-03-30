local vscode_plugin = {
	dir = vim.fn.stdpath("config") .. "/vscode.nvim",
	name = "vscode.nvim",
}

return {

	{ "nvim-tree/nvim-web-devicons", lazy = true },
	{
		"nvim-lualine/lualine.nvim",
		dependencies = {
			vscode_plugin,
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
						statusline = 100,
						tabline = 100,
						winbar = 100,
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
			local function set_bufferline_transparent()
				local groups = {
					"BufferLineFill",
					"BufferLineBackground",
					"BufferLineBufferVisible",
					"BufferLineBufferSelected",
					"BufferLineSeparator",
					"BufferLineSeparatorVisible",
					"BufferLineSeparatorSelected",
					"BufferLineTabSeparator",
					"BufferLineTabSeparatorSelected",
					"BufferLineCloseButton",
					"BufferLineCloseButtonVisible",
					"BufferLineCloseButtonSelected",
					"BufferLineDiagnostic",
					"BufferLineDiagnosticVisible",
					"BufferLineDiagnosticSelected",
					"BufferLineHint",
					"BufferLineHintVisible",
					"BufferLineHintSelected",
					"BufferLineInfo",
					"BufferLineInfoVisible",
					"BufferLineInfoSelected",
					"BufferLineWarning",
					"BufferLineWarningVisible",
					"BufferLineWarningSelected",
					"BufferLineError",
					"BufferLineErrorVisible",
					"BufferLineErrorSelected",
					"BufferLineModified",
					"BufferLineModifiedVisible",
					"BufferLineModifiedSelected",
					"BufferLineDuplicate",
					"BufferLineDuplicateVisible",
					"BufferLineDuplicateSelected",
					"BufferLinePick",
					"BufferLinePickVisible",
					"BufferLinePickSelected",
					"TabLine",
					"TabLineFill",
					"TabLineSel",
				}

				for _, group in ipairs(groups) do
					local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
					if ok then
						hl.bg = "NONE"
						hl.ctermbg = "NONE"
						vim.api.nvim_set_hl(0, group, hl)
					end
				end
			end

			local bufferline = require('bufferline')
			bufferline.setup({
				options = {
					style_preset = bufferline.style_preset.no_italic,
					--numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
					numbers = function(opts)
						return string.format('%s|%s', opts.id, opts.raise(opts.ordinal))
					end,
					-- 性能优化：限制 buffer 名称长度
					max_name_length = 18,
					tab_size = 18,
					truncate_names = true,
				},
				highlights = {
					fill = {
						bg = 'none',
					},
					background = { bg = "none" },
					buffer_selected = { bg = "none", bold = true },
					buffer_visible = { bg = "none" },
					separator = { bg = "none" },
					separator_selected = { bg = "none" },
					separator_visible = { bg = "none" },
					close_button = { bg = "none" },
					close_button_selected = { bg = "none" },
					close_button_visible = { bg = "none" },
					diagnostic = { bg = "none" },
					diagnostic_selected = { bg = "none" },
					diagnostic_visible = { bg = "none" },
					hint = { bg = "none" },
					hint_selected = { bg = "none" },
					hint_visible = { bg = "none" },
					info = { bg = "none" },
					info_selected = { bg = "none" },
					info_visible = { bg = "none" },
					warning = { bg = "none" },
					warning_selected = { bg = "none" },
					warning_visible = { bg = "none" },
					error = { bg = "none" },
					error_selected = { bg = "none" },
					error_visible = { bg = "none" },
					modified = { bg = "none" },
					modified_selected = { bg = "none" },
					modified_visible = { bg = "none" },
				}
			})
			set_bufferline_transparent()
			vim.api.nvim_create_autocmd("ColorScheme", {
				group = vim.api.nvim_create_augroup("BufferlineTransparent", { clear = true }),
				callback = function()
					vim.schedule(set_bufferline_transparent)
				end,
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
					view = "mini",          -- default view for messages
					view_error = "mini",    -- view for errors
					view_warn = "mini",     -- view for warnings
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
		config = function()
			require("nvim-treesitter").setup({
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
					-- 大文件性能保护：超过 100KB 的文件禁用 Treesitter
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,
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
		dir = vscode_plugin.dir,
		name = vscode_plugin.name,
		config = function()
			-- Load theme transparency from local config
			local ok, local_config = pcall(require, "local")
			local transparent = ok and local_config.theme and local_config.theme.transparent or true

			require("vscode").setup({
				transparent = transparent,
				italic_comments = true,
				italic_keywords = true,
				italic_parameters = false,
				bold_types = true,
				bold_functions = false,
				bold_constants = false,
				group_overrides = {
					["@variable"] = { fg = "#F5F7FA" },
					["@variable.global"] = { fg = "#F5F7FA" },
					["@parameter"] = { fg = "#8CCBFF" },
					["@variable.parameter"] = { fg = "#8CCBFF" },
					["@variable.member"] = { fg = "#C6E6FF" },
					["@field"] = { fg = "#F5F7FA" },
					["@property"] = { fg = "#F5F7FA" },
					["@constant"] = { fg = "#F2E6A8", italic = true },
					["@constant.builtin"] = { fg = "#F2E6A8", italic = true },
					BufferLineBufferSelected = { bold = true },
					BufferLineDevIconLuaInactive = { fg = "#7D8590" },
					BufferLineInfo = { fg = "#7D8590" },
					BufferLineNumbers = { fg = "#7D8590" },
					BufferLineCloseButton = { fg = "#7D8590" },
				},
			})
		end,
	},
	-- { 
	-- 	"catppuccin/nvim",
	-- 	name = "catppuccin",
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("catppuccin").setup({
	-- 				flavour = "mocha", -- latte, frappe, macchiato, mocha
	-- 				transparent_background = true, -- disables setting the background color.
	-- 		})
	--
	-- 		-- setup must be called before loading
	-- 		vim.cmd.colorscheme "catppuccin-nvim"
	-- 	end
	-- },
	{
		"nvim-zh/colorful-winsep.nvim",
		config = true,
		event = { "WinNew" },
	}

}
