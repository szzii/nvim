return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				underline = true,
				update_in_insert = false,
				severity_sort = false,
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
					vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
						pattern = "*",
						group = CustomLuaSnip,
						command = "lua require'luasnip'.unlink_current()"
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
					['<CR>'] = cmp.mapping.confirm({ select = true }),
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
					{ name = "nvim_lsp" },
					{ name = "nvim_lsp_signature_help" },
					{ name = "luasnip" },
					{ name = "path" },
				}),
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
		config = function()
			-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
			require("neodev").setup({
				-- add any options here, or leave empty to use the default settings
			})
		end,
	},
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			-- LSP settings (for overriding per client)

			--local function save_format(bufnr)
				--vim.api.nvim_create_autocmd("BufWritePre", {
					--buffer = bufnr,
					--callback = function()
						--vim.lsp.buf.format({ async = false })
					--end,
				--})
			--end

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
						on_attach = function(client, bufnr)
							if client.supports_method("textDocument/formatting") then
								save_format(bufnr)
							end
							if client.supports_method("textDocument/codeLens") then
								pcall(vim.lsp.codelens.refresh)
								refresh_codelens(bufnr)
							end
						end,
					})
				end,
				["tsserver"] = function()
					require('lspconfig').tsserver.setup({
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = 'all',
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayVariableTypeHintsWhenTypeMatchesName = false,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								}
							},
							javascript = {
								inlayHints = {
									includeInlayParameterNameHints = 'all',
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayVariableTypeHintsWhenTypeMatchesName = false,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								}
							}
						}
					})
				end,
				["pyright"] = function()
					require("lspconfig").pyright.setup({
						on_attach = function()
						end,
						settings = {
							pyright = {
								disableLanguageServices = true,
								disableOrganizeImports = true,
							},
							python = {
								analysis = {
									autoImportCompletions = true,
									autoSearchPaths = true,
									diagnosticMode = "openFilesOnly",
									useLibraryCodeForTypes = true,
									logLevel = "Warning",
									typeCheckingMode = "basic"
								}
							},
							single_file_support = true,
						}
					})
				end,
				["gopls"] = function()
					require("lspconfig").gopls.setup({
						on_attach = function()
						end,
						settings = {
							gopls = {
								hints = {
									assignVariableTypes = true,
									compositeLiteralFields = true,
									constantValues = true,
									functionTypeParameters = true,
									parameterNames = true,
									rangeVariableTypes = true,
								},
							},
						},
					})
				end,
			}

			require("lspconfig").nginx_ls.setup({})

			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls", "rust_analyzer", "pyright" },
				automatic_installation = false,
				handlers = handlers,
			})
		end,
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
		end,
	},
	{
		"RRethy/vim-illuminate",
		config = function()
			-- default configuration
			require('illuminate').configure({
				-- providers: provider used to get references in the buffer, ordered by priority
				providers = {
					'lsp',
					'treesitter',
					'regex',
				},
				-- delay: delay in milliseconds
				delay = 100,
				-- filetype_overrides: filetype specific overrides.
				-- The keys are strings to represent the filetype while the values are tables that
				-- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
				filetype_overrides = {},
				-- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
				filetypes_denylist = {
					'dirvish',
					'fugitive',
				},
				-- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
				filetypes_allowlist = {},
				-- modes_denylist: modes to not illuminate, this overrides modes_allowlist
				-- See `:help mode()` for possible values
				modes_denylist = {},
				-- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
				-- See `:help mode()` for possible values
				modes_allowlist = {},
				-- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
				-- Only applies to the 'regex' provider
				-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
				providers_regex_syntax_denylist = {},
				-- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
				-- Only applies to the 'regex' provider
				-- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
				providers_regex_syntax_allowlist = {},
				-- under_cursor: whether or not to illuminate under the cursor
				under_cursor = false,
				-- large_file_cutoff: number of lines at which to use large_file_config
				-- The `under_cursor` option is disabled when this cutoff is hit
				large_file_cutoff = nil,
				-- large_file_config: config to use for large files (based on large_file_cutoff).
				-- Supports the same keys passed to .configure
				-- If nil, vim-illuminate will be disabled for large files.
				large_file_overrides = nil,
				-- min_count_to_highlight: minimum number of matches required to perform highlighting
				min_count_to_highlight = 1,
				-- should_enable: a callback that overrides all other settings to
				-- enable/disable illumination. This will be called a lot so don't do
				-- anything expensive in it.
				should_enable = function(bufnr) return true end,
				-- case_insensitive_regex: sets regex case sensitivity
				case_insensitive_regex = true,
			})
			vim.cmd([[
				hi IlluminatedWordText gui=NONE
				hi IlluminatedWordRead gui=NONE
				hi IlluminatedWordWrite gui=NONE
			]])
		end

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
			require("flutter-tools").setup({
				lsp = {
					on_attach = function()
					end,
					settings = {
						showTodos = true,
						completeFunctionCalls = true,
						analysisExcludedFolders = { "<path-to-flutter-sdk-packages>" },
						renameFilesWithClasses = "prompt", -- "always"
						enableSnippets = true,
						updateImportsOnRename = true,
					},
				},
			})
		end,
	},
}
