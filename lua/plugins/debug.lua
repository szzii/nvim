return {

	{
		"mfussenegger/nvim-dap",
		config = function()
			vim.fn.sign_define('DapBreakpoint', {
				text = '●',
				texthl = 'DiagnosticError',
				linehl = '',
				numhl = 'DiagnosticError'
			})
			vim.fn.sign_define('DapLogPoint', {
				text = '◆',
				texthl = 'DiagnosticInfo',
				linehl = '',
				numhl = 'DiagnosticInfo'
			})

			vim.fn.sign_define('DapStopped', {
				text = '▶',
				texthl = 'DiagnosticError',
				linehl = 'DiagnosticUnderlineError',
				numhl = 'DiagnosticError'
			})

			vim.keymap.set('n', '<F6>', function() require('dap').restart() end, { desc = 'debug_restart' })
			vim.keymap.set('n', '<F8>', function() require('dap').run_to_cursor() end, { desc = 'debug_run_to_cursor' })
			vim.keymap.set('n', '<F9>', function() require('dap').step_back() end, { desc = 'debug_step_back' })
			vim.keymap.set('n', '<F10>', function() require('dap').step_over() end, { desc = 'debug_step_over' })
			vim.keymap.set('n', '<F11>', function() require('dap').step_into() end, { desc = 'debug_step_into' })
			vim.keymap.set('n', '<F12>', function() require('dap').step_out() end, { desc = 'debug_step_out' })
			vim.keymap.set('n', '<Leader>B',
				function() require('dap').set_breakpoint(vim.fn.input('Condition: '), nil, nil) end,
				{ desc = 'conditional_breakpoint' })
			vim.keymap.set('n', '<Leader>b', function() require('dap').toggle_breakpoint() end, { desc = 'toggle_breakpoint' })
			vim.keymap.set({ 'n', 'v' }, '<Leader>H', function()
				require('dap.ui.widgets').hover()
			end, { desc = 'debug_hover' })
		end
	},
	{
		"mfussenegger/nvim-dap-python",
		dependencies = { "mfussenegger/nvim-dap" },
		ft = "python",
		config = function()
			-- Function to get Python path from conda or fallback
			local function get_python_path()
				-- Check for active conda environment
				local conda_prefix = os.getenv("CONDA_PREFIX")
				if conda_prefix then
					local conda_python = conda_prefix .. "/bin/python"
					if vim.fn.executable(conda_python) == 1 then
						return conda_python
					end
				end
				-- Fallback to local config or system python
				local ok, local_config = pcall(require, "local")
				return ok and local_config.python_path or "/usr/local/bin/python3"
			end

			require("dap-python").setup(get_python_path())

			-- Command to switch Python environment for debugging
			vim.api.nvim_create_user_command("DapPythonSetEnv", function(opts)
				local python_path = opts.args
				if vim.fn.executable(python_path) == 1 then
					require("dap-python").setup(python_path)
					vim.notify("DAP Python set to: " .. python_path, vim.log.levels.INFO)
				else
					vim.notify("Invalid Python path: " .. python_path, vim.log.levels.ERROR)
				end
			end, { nargs = 1, desc = "Set Python path for DAP" })

			-- Python specific keymaps
			vim.keymap.set('n', '<leader>dn', function() require('dap-python').test_method() end, { desc = 'debug_test_method' })
			vim.keymap.set('n', '<leader>df', function() require('dap-python').test_class() end, { desc = 'debug_test_class' })
			vim.keymap.set('v', '<leader>ds', function() require('dap-python').debug_selection() end, { desc = 'debug_selection' })
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
				desc = 'debug_close_and_terminate'
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
				desc = 'debug_continue'
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
