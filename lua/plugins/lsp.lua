return {
	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-nvim-lsp-signature-help",
			{
				"L3MON4D3/LuaSnip",
				version = "v1.*",
				build = "make install_jsregexp",
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end,
					},
				},
				config = function()
					local luasnip = require 'luasnip'
					local types = require("luasnip.util.types")

					luasnip.config.setup({
						region_check_events = "InsertEnter",
						delete_check_events = "TextChanged,InsertLeave",
						ext_opts = {
							[types.choiceNode] = {
								active = {
									virt_text = { { "●", "GruvboxOrange" } }
								}
							},
							[types.insertNode] = {
								active = {
									virt_text = { { "●", "GruvboxBlue" } }
								}
							}
						},
					})

					local CustomLuaSnip = vim.api.nvim_create_augroup('CustomLuaSnip', { clear = true })
					local luasnip_timer = nil
					vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
						pattern = "*",
						group = CustomLuaSnip,
						callback = function()
							if luasnip_timer then
								vim.fn.timer_stop(luasnip_timer)
							end
							luasnip_timer = vim.fn.timer_start(500, function()
								require 'luasnip'.unlink_current_if_deleted()
								luasnip_timer = nil
							end)
						end
					})
				end
			},
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			local lspkind = require("lspkind")
			local lsp_helpers = require("utils.lsp-helpers")

			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0
						and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text",
						maxwidth = 50,
						ellipsis_char = "...",
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.scroll_docs(4),
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2] + 1
							local next_char = line:sub(col, col)
							cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
							if next_char ~= '' and next_char ~= ' ' then
								vim.api.nvim_feedkeys(' ', 'n', false)
							end
						else
							fallback()
						end
					end, { 'i', 's' }),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						elseif has_words_before() then
							cmp.complete()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
					["<C-c>"] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp",                priority = 1000 },
					{ name = "nvim_lsp_signature_help", priority = 900 },
					{ name = "luasnip",                 priority = 800 },
					{ name = "path",                    priority = 700 },
					{
						name = "buffer",
						priority = 500,
						option = {
							get_bufnrs = function()
								local buf = vim.api.nvim_get_current_buf()
								local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
								if byte_size > 1024 * 1024 then
									return {}
								end
								return { buf }
							end,
						},
					},
				}),
				performance = lsp_helpers.performance,
			})

			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{
						name = "cmdline",
						option = {
							ignore_cmds = { "Man", "!" },
						},
					},
				}),
			})
		end,
	},


	-- Mason: 用于安装 LSP 服务器
	{
		"williamboman/mason.nvim",
		cmd = {
			"Mason",
			"MasonInstall",
			"MasonUninstall",
			"MasonUninstallAll",
			"MasonLog",
			"MasonUpdate",
		},
		build = ":MasonUpdate",
		config = function()
			require("mason").setup({
				ensure_installed = {
					"typescript-language-server",
					"pyright",
					"gopls",
					"lua-language-server",
				},
			})
		end,
	},

	{
		"simrat39/symbols-outline.nvim",
		lazy = true,
		keys = {
			{ "<leader>p", ":SymbolsOutline<CR>", mode = "n", silent = true, noremap = true, desc = 'SymbolsOutline' }
		},
		config = function()
			require("symbols-outline").setup {
				auto_close = false,
				autofold_depth = 2,
				keymaps = {
					close = { "<Esc>", "q" },
					goto_location = "<Cr>",
					focus_location = "o",
					hover_symbol = "P",
					fold = "n",
					unfold = "i",
				},
				lsp_blacklist = {},
				symbol_blacklist = {},
				symbols = {
					File = { icon = '󰈔', hl = '@text.uri' },
					Module = { icon = '󰆧', hl = '@namespace' },
					Namespace = { icon = '󰅪', hl = '@namespace' },
					Package = { icon = '󰏗', hl = '@namespace' },
					Class = { icon = '𝓒', hl = '@type' },
					Method = { icon = 'ƒ', hl = '@method' },
					Property = { icon = '', hl = '@method' },
					Field = { icon = '󰆨', hl = '@field' },
					Constructor = { icon = '', hl = '@constructor' },
					Enum = { icon = 'ℰ', hl = '@type' },
					Interface = { icon = '󰜰', hl = '@type' },
					Function = { icon = '', hl = '@function' },
					Variable = { icon = '', hl = '@constant' },
					Constant = { icon = '', hl = '@constant' },
					String = { icon = '𝓐', hl = '@string' },
					Number = { icon = '#', hl = '@number' },
					Boolean = { icon = '⊨', hl = '@boolean' },
					Array = { icon = '󰅪', hl = '@constant' },
					Object = { icon = '⦿', hl = '@type' },
					Key = { icon = '🔐', hl = '@type' },
					Null = { icon = 'NULL', hl = '@type' },
					Event = { icon = '🗲', hl = '@type' },
					Operator = { icon = '+', hl = '@operator' },
					TypeParameter = { icon = '𝙏', hl = '@parameter' },
					Component = { icon = '󰅴', hl = '@function' },
					Fragment = { icon = '󰅴', hl = '@constant' },
				},
			}
		end
	},

	{
		"fatih/vim-go",
		lazy = true,
		ft = "go",
		build = ":GoUpdateBinaries",
		config = function()
			vim.keymap.set("n", "<LEADER><LEADER>", ":GoAlternate!<CR>", { silent = true, desc = "Go TestFile" })
		end,
	},

	{
		"akinsho/flutter-tools.nvim",
		lazy = true,
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			require("flutter-tools").setup {}
		end,
	},
}
