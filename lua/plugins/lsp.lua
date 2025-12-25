return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
		},
		config = function()
			local lsp_helpers = require("utils.lsp-helpers")

			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = '●',
					-- Only show virtual text for errors (performance optimization)
					severity = { min = vim.diagnostic.severity.ERROR },
				},
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = true,
				-- Reduce diagnostic update frequency
				float = {
					source = 'always',
					border = 'rounded',
				},
			})

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end


			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)

					client.server_capabilities.semanticTokensProvider = nil
					vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev, { desc = "diagnostic_goto_prev" })
					vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next, { desc = "diagnostic_goto_next" })
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic_list" })
					vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, { desc = "diagnostic_float" })

					vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { buffer = ev.buf, desc = "definition" })
					--vim.keymap.set('n', '<leader>d', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'declaration' })
					vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover" })
					vim.keymap.set(
						"n",
						"<leader>v",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "implementation" }
					)
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })

					vim.keymap.set(
						"n",
						"<leader>m",
						vim.lsp.buf.signature_help,
						{ buffer = ev.buf, desc = "signature_help" }
					)

					vim.keymap.set("n", "<space>k", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename" })
					vim.keymap.set(
						"n",
						"<leader>D",
						vim.lsp.buf.type_definition,
						{ buffer = ev.buf, desc = "type_definition" }
					)

					vim.keymap.set(
						{ "n", "v" },
						"<leader>z",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "code_action" }
					)
				end,
			})
		end,
	},
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
				-- follow latest release.
				version = "v1.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
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
							-- Debounce: wait 500ms before unlinking
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
			-- Set up nvim-cmp.
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


			-- If you want insert `(` after select function or method item
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)

			cmp.setup({
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = "symbol_text", -- show only symbol annotations
						maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					}),
				},
				mapping = cmp.mapping.preset.insert({
					["<C-u>"] = cmp.mapping.scroll_docs(-4),
					["<C-e>"] = cmp.mapping.scroll_docs(4),
					['<CR>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							-- 检查光标后的字符
							local line = vim.api.nvim_get_current_line()
							local col = vim.api.nvim_win_get_cursor(0)[2] + 1
							local next_char = line:sub(col, col)

							-- 确认补全
							cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })

							-- 如果光标后不是空格也不是行尾，添加空格
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
							-- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
							-- they way you will only jump inside the snippet region
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
							-- Limit buffer completion scope for better performance
							get_bufnrs = function()
								local buf = vim.api.nvim_get_current_buf()
								local byte_size = vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
								if byte_size > 1024 * 1024 then -- 1MB
									return {}
								end
								return { buf }
							end,
						},
					},
				}),
				performance = lsp_helpers.performance,
			})
			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})

			-- `:` cmdline setup.
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
	{
		"folke/neodev.nvim",
		ft = "lua",
		config = function()
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			require("neodev").setup({
				-- add any options here, or leave empty to use the default settings
			})
		end,
	},
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
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"neovim/nvim-lspconfig",
		},
		config = function()
			local function refresh_codelens(bufnr)
				vim.api.nvim_create_autocmd("BufWritePost", {
					buffer = bufnr,
					desc = "refresh codelens",
					callback = function()
						pcall(vim.lsp.codelens.refresh)
					end,
				})
			end


			local handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup({
						flags = lsp_helpers.lsp_flags,
					})
				end,
				["ts_ls"] = function()
					local lspconfig = require('lspconfig')
					lspconfig.ts_ls.setup({
						flags = lsp_helpers.lsp_flags,
						-- Support single file mode
						single_file_support = true,
						root_dir = function(filename)
							-- Try to find project root, fallback to file directory
							return lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git")(filename)
									or vim.fn.fnamemodify(filename, ":p:h")
						end,
						init_options = {
							preferences = {
								-- Better import suggestions
								importModuleSpecifierPreference = "relative",
								importModuleSpecifierEnding = "minimal",
							},
						},
						on_attach = function(client, bufnr)
							-- Disable tsserver's formatting in favor of prettier/eslint
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
						settings = {
							typescript = {
								inlayHints = lsp_helpers.inlay_hints_off,
								-- TypeScript specific settings
								suggest = {
									includeCompletionsForModuleExports = true,
								},
								format = {
									enable = false, -- Use external formatter
								},
							},
							javascript = {
								inlayHints = lsp_helpers.inlay_hints_off,
								suggest = {
									includeCompletionsForModuleExports = true,
								},
								format = {
									enable = false, -- Use external formatter
								},
							}
						}
					})
				end,
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						flags = lsp_helpers.lsp_flags,
						on_init = function(client)
							client.config.settings.python.pythonPath = lsp_helpers.get_python_path()
						end,
						on_attach = function()
						end,
						settings = {
							python = {
								pythonPath = lsp_helpers.get_python_path(),
								analysis = {
									autoImportCompletions = true,
									autoSearchPaths = true,
									-- Use openFilesOnly for better performance
									diagnosticMode = "openFilesOnly",
									useLibraryCodeForTypes = true,
									logLevel = "Warning",
									typeCheckingMode = "off",
									-- Limit indexing for better performance
									indexing = true,
									-- Disable some expensive checks
									useLibraryCodeForTypesIfNoStubsPresent = false,
								}
							},
							single_file_support = true,
						}
					})

					-- Command to restart LSP with new Python environment
					vim.api.nvim_create_user_command("PyrightSetEnv", function()
						vim.cmd("LspRestart pyright")
						vim.notify("Pyright restarted with: " .. lsp_helpers.get_python_path(), vim.log.levels.INFO)
					end, { desc = "Restart Pyright with current conda env" })
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						flags = lsp_helpers.lsp_flags,
						on_attach = function()
						end,
						settings = {
							gopls = {
								hints = {
									-- Reduce hints for better performance
									assignVariableTypes = false,
									compositeLiteralFields = false,
									constantValues = false,
									functionTypeParameters = false,
									parameterNames = true, -- Keep only parameter names
									rangeVariableTypes = false,
								},
								-- Performance optimizations
								analyses = {
									unusedparams = false,
									shadow = false,
								},
								staticcheck = false,
							},
						},
					})
				end,
			}

			local ok, err = pcall(function()
				require("mason-lspconfig").setup({
					-- Auto install these LSP servers
					ensure_installed = {
						"ts_ls", -- TypeScript/JavaScript
						"pyright", -- Python
						"gopls", -- Go
						"lua_ls", -- Lua
					},
					automatic_installation = true,
					handlers = handlers,
				})
			end)
			if not ok then
				vim.notify("mason-lspconfig setup error: " .. tostring(err), vim.log.levels.WARN)
			end
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
					-- These keymaps can be a string or a table for multiple keys
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
