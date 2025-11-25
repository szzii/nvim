return {
	-- TypeScript tools and utilities
	{
		"pmizio/typescript-tools.nvim",
		ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		enabled = false, -- Set to true if you want to use this instead of ts_ls
		config = function()
			require("typescript-tools").setup({
				on_attach = function(client, bufnr)
					-- Custom keymaps for TypeScript tools
					vim.keymap.set('n', '<leader>to', ':TSToolsOrganizeImports<CR>',
						{ buffer = bufnr, desc = 'Organize Imports' })
					vim.keymap.set('n', '<leader>ts', ':TSToolsSortImports<CR>',
						{ buffer = bufnr, desc = 'Sort Imports' })
					vim.keymap.set('n', '<leader>tu', ':TSToolsRemoveUnused<CR>',
						{ buffer = bufnr, desc = 'Remove Unused' })
					vim.keymap.set('n', '<leader>tf', ':TSToolsFixAll<CR>',
						{ buffer = bufnr, desc = 'Fix All' })
					vim.keymap.set('n', '<leader>ta', ':TSToolsAddMissingImports<CR>',
						{ buffer = bufnr, desc = 'Add Missing Imports' })
				end,
				settings = {
					-- Better TypeScript experience
					tsserver_file_preferences = {
						includeInlayParameterNameHints = "literals",
						includeInlayParameterNameHintsWhenArgumentMatchesName = false,
						includeInlayFunctionParameterTypeHints = false,
						includeInlayVariableTypeHints = false,
						includeInlayPropertyDeclarationTypeHints = false,
						includeInlayFunctionLikeReturnTypeHints = false,
						includeInlayEnumMemberValueHints = false,
					},
				},
			})
		end,
	},

	-- Auto-close and auto-rename HTML tags
	{
		"windwp/nvim-ts-autotag",
		ft = { "html", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue", "svelte" },
		config = function()
			require('nvim-ts-autotag').setup({
				filetypes = {
					'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact',
					'vue', 'svelte', 'xml',
				},
			})
		end,
	},

	-- Better syntax highlighting for TypeScript
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"typescript",
					"tsx",
					"javascript",
					"jsdoc",
					"json",
					"html",
					"css",
					"vim",
					"lua",
					"python",
					"go",
					"rust",
					"markdown",
					"markdown_inline",
				},
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
						scope_incremental = "<TAB>",
						node_decremental = "<S-CR>",
					},
				},
			})
		end,
	},

	-- Code formatting with conform.nvim (replaces null-ls)
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					javascriptreact = { "prettier" },
					typescript = { "prettier" },
					typescriptreact = { "prettier" },
					json = { "prettier" },
					jsonc = { "prettier" },
					html = { "prettier" },
					css = { "prettier" },
					scss = { "prettier" },
					markdown = { "prettier" },
				},
				-- Format on save (optional, set to false if you prefer manual formatting)
				format_on_save = {
					timeout_ms = 500,
					lsp_fallback = true,
				},
			})
		end,
	},

	-- Linting with nvim-lint (replaces null-ls diagnostics)
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint" },
				javascriptreact = { "eslint" },
				typescript = { "eslint" },
				typescriptreact = { "eslint" },
			}

			-- Use local eslint from node_modules if available
			lint.linters.eslint.cmd = function()
				local local_eslint = vim.fn.fnamemodify("./node_modules/.bin/eslint", ":p")
				if vim.fn.executable(local_eslint) == 1 then
					return local_eslint
				end
				return "eslint"
			end

			-- Auto lint on save (only if eslint exists)
			vim.api.nvim_create_autocmd({ "BufWritePost" }, {
				callback = function()
					-- Check if eslint is available before running
					local eslint_config = vim.fn.glob(".eslintrc*") ~= "" or vim.fn.glob("eslint.config.*") ~= ""
					if eslint_config then
						lint.try_lint()
					end
				end,
			})
		end,
	},

	-- Better error display
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>xx", ":TroubleToggle<CR>", mode = "n", desc = "Toggle Trouble" },
			{ "<leader>xw", ":TroubleToggle workspace_diagnostics<CR>", mode = "n", desc = "Workspace Diagnostics" },
			{ "<leader>xd", ":TroubleToggle document_diagnostics<CR>", mode = "n", desc = "Document Diagnostics" },
			{ "<leader>xq", ":TroubleToggle quickfix<CR>", mode = "n", desc = "Quickfix" },
			{ "<leader>xl", ":TroubleToggle loclist<CR>", mode = "n", desc = "Location List" },
			{ "gR", ":TroubleToggle lsp_references<CR>", mode = "n", desc = "LSP References" },
		},
		config = function()
			require("trouble").setup({
				icons = true,
				fold_open = "",
				fold_closed = "",
				indent_lines = false,
				signs = {
					error = "",
					warning = "",
					hint = "",
					information = "",
				},
				use_diagnostic_signs = true,
			})
		end,
	},

	-- Package info for package.json
	{
		"vuki656/package-info.nvim",
		ft = "json",
		dependencies = { "MunifTanjim/nui.nvim" },
		config = function()
			require("package-info").setup({
				colors = {
					up_to_date = "#3C4048",
					outdated = "#d19a66",
				},
			})

			-- Package info keymaps (only in package.json)
			vim.api.nvim_create_autocmd("BufEnter", {
				pattern = "package.json",
				callback = function()
					vim.keymap.set('n', '<leader>ps', require('package-info').show,
						{ buffer = true, desc = 'Show package versions' })
					vim.keymap.set('n', '<leader>pc', require('package-info').hide,
						{ buffer = true, desc = 'Hide package versions' })
					vim.keymap.set('n', '<leader>pu', require('package-info').update,
						{ buffer = true, desc = 'Update package' })
					vim.keymap.set('n', '<leader>pd', require('package-info').delete,
						{ buffer = true, desc = 'Delete package' })
					vim.keymap.set('n', '<leader>pi', require('package-info').install,
						{ buffer = true, desc = 'Install package' })
				end,
			})
		end,
	},

	-- Inline type hints (experimental)
	{
		"marilari88/twoslash-queries.nvim",
		ft = { "typescript", "typescriptreact" },
		config = function()
			require("twoslash-queries").setup({
				multi_line = true,
				is_enabled = false, -- Enable manually with :TwoslashQueriesEnable
			})

			-- Keymaps for twoslash queries
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "typescript", "typescriptreact" },
				callback = function()
					vim.keymap.set('n', '<leader>ti', ':TwoslashQueriesInspect<CR>',
						{ buffer = true, desc = 'TypeScript Inspect Type' })
				end,
			})
		end,
	},
}
