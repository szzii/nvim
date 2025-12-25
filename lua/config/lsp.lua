-- Neovim 0.11+ 原生 LSP 配置
local lsp_helpers = require("utils.lsp-helpers")

-- Root 辅助函数 - 确保始终返回有效目录
local function find_root(bufnr, markers)
	local root = vim.fs.root(bufnr, markers)
	if root then
		return root
	end
	-- Fallback to file directory
	return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p:h')
end

-- ========== 诊断配置 ==========
vim.diagnostic.config({
	virtual_text = {
		spacing = 4,
		prefix = '●',
		severity = { min = vim.diagnostic.severity.ERROR },
	},
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = " ",
			[vim.diagnostic.severity.WARN] = " ",
			[vim.diagnostic.severity.HINT] = " ",
			[vim.diagnostic.severity.INFO] = " ",
		},
	},
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		source = 'always',
		border = 'rounded',
	},
})

-- ========== LSP 键位映射 ==========
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			-- 禁用语义高亮（性能优化）
			client.server_capabilities.semanticTokensProvider = nil
		end

		-- 诊断导航
		vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev, { desc = "diagnostic_goto_prev" })
		vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next, { desc = "diagnostic_goto_next" })
		vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic_list" })
		vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, { desc = "diagnostic_float" })

		-- LSP 功能
		vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { buffer = ev.buf, desc = "definition" })
		vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover" })
		vim.keymap.set("n", "<leader>v", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "implementation" })
		vim.keymap.set("n", "<leader>r", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })
		vim.keymap.set("n", "<leader>m", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "signature_help" })
		vim.keymap.set("n", "<space>k", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename" })
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "type_definition" })
		vim.keymap.set({ "n", "v" }, "<leader>z", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "code_action" })
	end,
})

-- ========== 启用 LSP 服务器 ==========

-- TypeScript/JavaScript LSP
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	callback = function(ev)
		vim.lsp.start({
			name = 'ts_ls',
			cmd = { 'typescript-language-server', '--stdio' },
			root_dir = find_root(ev.buf, { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' }),
			settings = {
				typescript = {
					inlayHints = lsp_helpers.inlay_hints_off,
					suggest = {
						includeCompletionsForModuleExports = true,
					},
					format = {
						enable = false,
					},
					preferences = {
						importModuleSpecifierPreference = 'relative',
						importModuleSpecifierEnding = 'minimal',
					},
				},
				javascript = {
					inlayHints = lsp_helpers.inlay_hints_off,
					suggest = {
						includeCompletionsForModuleExports = true,
					},
					format = {
						enable = false,
					},
				},
			},
			on_attach = function(client)
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end,
		})
	end,
})

-- Python LSP (Pyright)
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'python',
	callback = function(ev)
		vim.lsp.start({
			name = 'pyright',
			cmd = { 'pyright-langserver', '--stdio' },
			root_dir = find_root(ev.buf, { 'pyproject.toml', 'setup.py', '.git' }),
			settings = {
				python = {
					pythonPath = lsp_helpers.get_python_path(),
					analysis = {
						autoImportCompletions = true,
						autoSearchPaths = true,
						diagnosticMode = 'openFilesOnly',
						useLibraryCodeForTypes = true,
						logLevel = 'Warning',
						typeCheckingMode = 'off',
						indexing = true,
						useLibraryCodeForTypesIfNoStubsPresent = false,
					},
				},
			},
			on_init = function(client)
				client.config.settings.python.pythonPath = lsp_helpers.get_python_path()
			end,
		})
	end,
})

-- Go LSP (gopls)
vim.api.nvim_create_autocmd('FileType', {
	pattern = { 'go', 'gomod', 'gowork', 'gotmpl' },
	callback = function(ev)
		vim.lsp.start({
			name = 'gopls',
			cmd = { 'gopls' },
			root_dir = find_root(ev.buf, { 'go.work', 'go.mod', '.git' }),
			settings = {
				gopls = {
					hints = {
						assignVariableTypes = false,
						compositeLiteralFields = false,
						constantValues = false,
						functionTypeParameters = false,
						parameterNames = true,
						rangeVariableTypes = false,
					},
					analyses = {
						unusedparams = false,
						shadow = false,
					},
					staticcheck = false,
				},
			},
		})
	end,
})

-- Lua LSP
vim.api.nvim_create_autocmd('FileType', {
	pattern = 'lua',
	callback = function(ev)
		vim.lsp.start({
			name = 'lua_ls',
			cmd = { 'lua-language-server' },
			root_dir = find_root(ev.buf, { '.git' }),
			settings = {
				Lua = {
					telemetry = { enable = false },
					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library"
						},
					},
				},
			},
		})
	end,
})

-- ========== 自定义命令 ==========

-- 原生 LspInfo 命令替代品
vim.api.nvim_create_user_command("LspInfo", function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })

	if #clients == 0 then
		vim.notify("No active LSP clients for this buffer", vim.log.levels.WARN)
		return
	end

	local info = {}
	table.insert(info, "╔════════════════════════════════════════════════════════════╗")
	table.insert(info, "║              LSP Clients - Buffer " .. bufnr .. "                      ║")
	table.insert(info, "╚════════════════════════════════════════════════════════════╝")

	for _, client in ipairs(clients) do
		table.insert(info, "")
		table.insert(info, "📌 Client: " .. (client.name or "Unknown"))
		table.insert(info, "   ├─ ID: " .. client.id)
		table.insert(info, "   ├─ Root: " .. (client.config.root_dir or "None"))
		table.insert(info, "   ├─ CMD: " .. vim.inspect(client.config.cmd):gsub("\n", " "))

		-- 显示支持的文件类型
		local filetypes = client.config.filetypes or {}
		if #filetypes > 0 then
			table.insert(info, "   └─ Filetypes: " .. table.concat(filetypes, ", "))
		else
			table.insert(info, "   └─ Filetypes: None")
		end

		-- 显示能力
		local caps = client.server_capabilities
		if caps then
			table.insert(info, "   📦 Capabilities:")
			table.insert(info, "      ├─ Completion: " .. (caps.completionProvider and "✓" or "✗"))
			table.insert(info, "      ├─ Definition: " .. (caps.definitionProvider and "✓" or "✗"))
			table.insert(info, "      ├─ References: " .. (caps.referencesProvider and "✓" or "✗"))
			table.insert(info, "      ├─ Hover: " .. (caps.hoverProvider and "✓" or "✗"))
			table.insert(info, "      ├─ Rename: " .. (caps.renameProviderSupport == "yes" and "✓" or "✗"))
			table.insert(info, "      └─ Format: " .. (caps.documentFormattingProvider and "✓" or "✗"))
		end
	end

	table.insert(info, "")
	table.insert(info, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
	table.insert(info, "Total active clients: " .. #clients)
	table.insert(info, "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")

	-- 在浮动窗口或新缓冲区显示
	local lines = info
	vim.cmd("new")
	vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
	vim.bo.modifiable = false
	vim.bo.modified = false
	vim.bo.buftype = "nofile"
	vim.bo.bufhidden = "wipe"
	vim.api.nvim_win_set_width(0, 80)
	vim.api.nvim_buf_set_option(0, 'filetype', 'lspinfo')
end, { desc = "Show LSP client information (native)" })

vim.api.nvim_create_user_command("LspRestart", function(opts)
	local client_name = opts.args
	if client_name == "" then
		vim.notify("Usage: LspRestart <client_name>", vim.log.levels.ERROR)
		return
	end

	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = client_name })

	if #clients == 0 then
		vim.notify("No LSP client found with name: " .. client_name, vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id, true)
		vim.schedule(function()
			vim.lsp.enable(client_name)
			vim.notify("Restarted LSP client: " .. client_name, vim.log.levels.INFO)
		end)
	end
end, { nargs = 1, desc = "Restart LSP client", complete = "customlist,v:lua._lsp_client_list" })

vim.api.nvim_create_user_command("LspStop", function(opts)
	local client_name = opts.args
	local bufnr = vim.api.nvim_get_current_buf()
	local clients

	if client_name == "" then
		-- 停止当前缓冲区的所有客户端
		clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	else
		-- 停止指定的客户端
		clients = vim.lsp.get_active_clients({ bufnr = bufnr, name = client_name })
	end

	if #clients == 0 then
		vim.notify("No LSP clients to stop", vim.log.levels.WARN)
		return
	end

	for _, client in ipairs(clients) do
		vim.lsp.stop_client(client.id)
		vim.notify("Stopped LSP client: " .. client.name, vim.log.levels.INFO)
	end
end, { nargs = "?", desc = "Stop LSP client(s)", complete = "customlist,v:lua._lsp_client_list" })

-- 用于命令补全的函数
_G._lsp_client_list = function()
	local bufnr = vim.api.nvim_get_current_buf()
	local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
	local names = {}
	for _, client in ipairs(clients) do
		table.insert(names, client.name)
	end
	return names
end

vim.api.nvim_create_user_command("PyrightSetEnv", function()
	vim.cmd("LspRestart pyright")
	vim.notify("Pyright restarted with: " .. lsp_helpers.get_python_path(), vim.log.levels.INFO)
end, { desc = "Restart Pyright with current conda env" })

