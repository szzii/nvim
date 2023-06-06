return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = false,
				update_in_insert = false,
				severity_sort = false,
			})

			local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
			end

			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or border
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			vim.api.nvim_create_autocmd('LspAttach', {
				group = vim.api.nvim_create_augroup('UserLspConfig', {}),
				callback = function(ev)
					local opts = { buffer = ev.buf }
					vim.keymap.set('n', '<leader>[', vim.diagnostic.goto_prev, { desc = 'diagnostic_goto_prev' })
					vim.keymap.set('n', '<leader>]', vim.diagnostic.goto_next, { desc = 'diagnostic_goto_next' })
					vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'setloclist' })

					vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'definition' })
					--vim.keymap.set('n', '<leader>d', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'declaration' })
					vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'hover' })
					vim.keymap.set('n', '<leader>v', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'implementation' })
					vim.keymap.set('n', '<leader>r', vim.lsp.buf.references, { buffer = ev.buf, desc = 'references' })

					vim.keymap.set('n', '<leader>m', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'signature_help' })

					vim.keymap.set('n', '<space>k', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'rename' })
					vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'type_definition' })

					vim.keymap.set({ 'n', 'v' }, '<leader>z', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'code_action' })
				end,

			})
		end,

	},
	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
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
				version = "<CurrentMajor>.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
				-- install jsregexp (optional!).
				build = "make install_jsregexp",
				dependencies = {
					{
						"rafamadriz/friendly-snippets",
						config = function()
							require("luasnip.loaders.from_vscode").lazy_load()
						end
					}
				}
			},
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			-- Set up nvim-cmp.
			local cmp = require 'cmp'
			local luasnip = require 'luasnip'
			local lspkind = require 'lspkind'


			local has_words_before = function()
				unpack = unpack or table.unpack
				local line, col = unpack(vim.api.nvim_win_get_cursor(0))
				return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
			end

			cmp.setup {
				snippet = {
					expand = function(args)
						require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},
				formatting = {
					format = lspkind.cmp_format({
						mode = 'symbol_text', -- show only symbol annotations
						maxwidth = 50,   -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
						ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
					})
				},
				mapping = cmp.mapping.preset.insert({
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-e>'] = cmp.mapping.scroll_docs(4),
					['<CR>'] = cmp.mapping.confirm {
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					},
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
					['<C-c>'] = cmp.mapping.abort(),
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'nvim_lsp_signature_help' },
					{ name = 'luasnip' },
					{ name = 'path' }
				})
			}
			-- `/` cmdline setup.
			cmp.setup.cmdline('/', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- `:` cmdline setup.
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{
						name = 'cmdline',
						option = {
							ignore_cmds = { 'Man', '!' }
						}
					}
				})
			})
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
		end
	},
	{
		"L3MON4D3/LuaSnip",
		version = "1.*",
		build = "make install_jsregexp",
	},
	{
		"folke/neodev.nvim",
		config = function()
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			require("neodev").setup({
				-- add any options here, or leave empty to use the default settings
			})
		end
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			-- LSP settings (for overriding per client)

			local function save_format()
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = buffer,
					callback = function()
						vim.lsp.buf.format { async = false }
					end
				})
			end

			local function refresh_codelens()
				vim.api.nvim_create_autocmd('BufWritePost', {
					buffer = bufnr,
					desc = 'refresh codelens',
					callback = function()
						pcall(vim.lsp.codelens.refresh)
					end,
				})
			end

			local function hover_diagnostic()
				vim.api.nvim_create_autocmd("CursorHold", {
					buffer = bufnr,
					callback = function()
						local opts = {
							focusable = false,
							close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
							border = 'rounded',
							source = 'always',
							prefix = ' ',
							scope = 'cursor',
						}
						vim.diagnostic.open_float(nil, opts)
					end
				})
			end


			local handlers = {
				function(server_name) -- default handler (optional)
					require("lspconfig")[server_name].setup {
						on_attach = function()
							save_format()
							refresh_codelens()
							hover_diagnostic()
							pcall(vim.lsp.codelens.refresh)
						end
					}
				end,

				['pyright'] = function()
					require 'lspconfig'.pyright.setup {
						on_attach = function()
							hover_diagnostic()
						end,
					}
				end,
				['gopls'] = function()
					require 'lspconfig'.gopls.setup {
						on_attach = function()
							hover_diagnostic()
						end,
						settings = {
							gopls = {
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true
								}
							}

						}
					}
				end,

			}

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "pyright" },
				automatic_installation = false,
				handlers = handlers
			})
		end
	},
	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.fn.sign_define('DapBreakpoint', {
				text = ' ',
				texthl = 'DiagnosticError',
				linehl = '',
				numhl = 'DiagnosticError'
			})
			vim.fn.sign_define('DapLogPoint', {
				text = ' ',
				texthl = 'DiagnosticInfo',
				linehl = '',
				numhl = 'DiagnosticInfo'
			})

			vim.fn.sign_define('DapStopped', {
				text = ' ',
				texthl = 'DiagnosticError',
				linehl = 'DiagnosticUnderlineError',
				numhl = 'DiagnosticError'
			})

			vim.keymap.set('n', '<F8>', function() require('dap').run_to_cursor() end)
			vim.keymap.set('n', '<F9>', function() require('dap').step_back() end)
			vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
			vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
			vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
			vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'toggle_breakpoint' })
			vim.keymap.set('n', '<Leader>B',
				function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
				{ desc = 'breakpoints_log' })
			vim.keymap.set({ 'n', 'v' }, '<Leader>H', function()
				require('dap.ui.widgets').hover()
			end, { desc = 'debug_hover' })
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		keys = {
			{
				'<F4>',
				function()
					require("dapui").close()
					require('dap').terminate()
				end,
				mode = 'n',
				silent = true,
			},
			{
				'<F5>',
				function()
					require("dapui").open()
					require('dap').continue()
				end,
				mode = 'n',
				silent = true,
			},
		},
		config = function()
			require("dapui").setup(
				{
					expand_lines = false,
					force_buffers = true,
					element_mappings = {
					},
					floating = {
						border = "single",
						mappings = {
							close = { "q", "<Esc>" }
						}
					},
					layouts = {
						{
							elements = {
								{
									id = "watches",
									size = 0.25
								},
								{
									id = "breakpoints",
									size = 0.25
								},
								{
									id = "stacks",
									size = 0.25
								},
								{
									id = "scopes",
									size = 0.25
								}
							},
							position = "right",
							size = 40
						},
						{
							elements = { {
								id = "repl",
								size = 0.5
							}, {
								id = "console",
								size = 0.5
							} },
							position = "bottom",
							size = 10
						}
					},
					mappings = {
						edit = "h",
						expand = { "<CR>", "<2-LeftMouse>", "i", "n" },
						open = "o",
						remove = "d",
						repl = "r",
						toggle = "t"
					},
					render = {
						indent = 1,
						max_value_lines = 100
					}
				}
			)
		end
	},
	{
		"lvimuser/lsp-inlayhints.nvim",
		config = function()
			require("lsp-inlayhints").setup()
			vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
			vim.api.nvim_create_autocmd("LspAttach", {
				group = "LspAttach_inlayhints",
				callback = function(args)
					if not (args.data and args.data.client_id) then
						return
					end

					local bufnr = args.buf
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					require("lsp-inlayhints").on_attach(client, bufnr)
				end,
			})
		end
	},

	"mfussenegger/nvim-jdtls",
	{
		"fatih/vim-go",
		lazy = true,
		ft = 'go',
		build = ':GoUpdateBinaries',
		config = function()
			vim.keymap.set('n', '<LEADER><LEADER>', ':GoAlternate!<CR>', { silent = true, desc = 'Go TestFile' })
		end
	},
	{
		'akinsho/flutter-tools.nvim',
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
			'stevearc/dressing.nvim', -- optional for vim.ui.select
		},
		config = function()
			require("flutter-tools").setup {
				lsp = {
					on_attach = function()
						vim.api.nvim_create_autocmd("BufWritePre", {
							buffer = buffer,
							callback = function()
								vim.lsp.buf.format { async = false }
							end
						})
						vim.api.nvim_create_autocmd("CursorHold", {
							buffer = bufnr,
							callback = function()
								local opts = {
									focusable = false,
									close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
									border = 'rounded',
									source = 'always',
									prefix = ' ',
									scope = 'cursor',
								}
								vim.diagnostic.open_float(nil, opts)
							end
						})
					end,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
						renameFilesWithClasses = "prompt", -- "always"
						enableSnippets = true,
						updateImportsOnRename = true,
					}
				}
			}
		end
	},
}
