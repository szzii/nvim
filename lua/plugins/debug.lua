return {

	{
		"mfussenegger/nvim-dap-python",
		config = function ()
			require("dap-python").setup("/opt/homebrew/anaconda3/bin/python")
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

			require("dap-python").setup("python")

			vim.keymap.set('n', '<F6>', function() require('dap').restart() end)
			vim.keymap.set('n', '<F8>', function() require('dap').run_to_cursor() end)
			vim.keymap.set('n', '<F9>', function() require('dap').step_back() end)
			vim.keymap.set('n', '<F10>', function() require('dap').step_over() end)
			vim.keymap.set('n', '<F11>', function() require('dap').step_into() end)
			vim.keymap.set('n', '<F12>', function() require('dap').step_out() end)
			vim.keymap.set('n', '<Leader>B',
				function() require('dap').toggle_breakpoint(vim.fn.input('Condition: '), nil, nil) end,
				{ desc = 'toggle_breakpoint' })
			vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'toggle_breakpoint' })
			vim.keymap.set({ 'n', 'v' }, '<Leader>H', function()
				require('dap.ui.widgets').hover()
			end, { desc = 'debug_hover' })
		end
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		library = { plugins = { "nvim-dap-ui" }, types = true },
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
					if vim.bo.filetype == 'lua' then
						require "osv".run_this()
					else
						require('dap').continue()
					end
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
									id = "stacks",
									size = 0.40
								},
								{
									id = "scopes",
									size = 0.60
								},
							},
							position = "right",
							size = 35
						},
						{
							elements = {
								{
									id = "console",
									size = 1
								},
							},
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
		"jbyuki/one-small-step-for-vimkind",
		config = function()
			local dap = require "dap"
			dap.configurations.lua = {
				{
					type = 'nlua',
					request = 'attach',
					name = "Attach to running Neovim instance",
				}
			}
			dap.adapters.nlua = function(callback, config)
				callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
			end
		end
	}
}
