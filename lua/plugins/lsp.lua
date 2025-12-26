-- LSP 插件配置
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		config = function()

			local faint = "#4F4F4F"
			vim.api.nvim_set_hl(0, "LspReferenceText", { bg = faint })
			vim.api.nvim_set_hl(0, "LspReferenceRead", { bg = faint })
			vim.api.nvim_set_hl(0, "LspReferenceWrite", { bg = faint })
			
			-- 诊断配置
			vim.diagnostic.config({
				virtual_text = {
					spacing = 4,
					prefix = '●',
					severity = { min = vim.diagnostic.severity.ERROR },
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "E",
						[vim.diagnostic.severity.WARN] = "W",
						[vim.diagnostic.severity.HINT] = "H",
						[vim.diagnostic.severity.INFO] = "I",
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

			-- LSP Attach 时的键位映射
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					local client = vim.lsp.get_client_by_id(ev.data.client_id)
					if client then
						-- 禁用语义高亮（性能优化）
						client.server_capabilities.semanticTokensProvider = nil
					end

					-- 启用 document highlight
					if client.server_capabilities.documentHighlightProvider then
						vim.lsp.buf.document_highlight()

						-- Cursor 移动时自动更新高亮
						vim.api.nvim_create_autocmd({"CursorHold", "CursorHoldI"}, {
							buffer = ev.buf,
							callback = vim.lsp.buf.document_highlight,
						})

						-- 清除高亮
						vim.api.nvim_create_autocmd("CursorMoved", {
							buffer = ev.buf,
							callback = vim.lsp.buf.clear_references,
						})
					end

					-- 诊断导航
					vim.keymap.set("n", "<leader>[", vim.diagnostic.goto_prev, { desc = "diagnostic_goto_prev" })
					vim.keymap.set("n", "<leader>]", vim.diagnostic.goto_next, { desc = "diagnostic_goto_next" })
					vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "diagnostic_list" })
					vim.keymap.set('n', '<space>w', vim.diagnostic.open_float, { desc = "diagnostic_float" })

					-- LSP 导航
					vim.keymap.set("n", "<leader>d", vim.lsp.buf.definition, { buffer = ev.buf, desc = "definition" })
					vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, { buffer = ev.buf, desc = "type_definition" })
					vim.keymap.set("n", "<leader>v", vim.lsp.buf.implementation, { buffer = ev.buf, desc = "implementation" })
					vim.keymap.set("n", "<leader>R", vim.lsp.buf.references, { buffer = ev.buf, desc = "references" })
					vim.keymap.set("n", "<leader>r", vim.lsp.buf.incoming_calls, {
						buffer = ev.buf,
						desc = "incoming_calls (callers)"
					})

					--代码操作
					vim.keymap.set({ "n", "v" }, "<leader>z", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "code_action" })
					vim.keymap.set("n", "<space>k", vim.lsp.buf.rename, { buffer = ev.buf, desc = "rename" })

					-- helper functions
					vim.keymap.set("n", "<leader>h", vim.lsp.buf.hover, { buffer = ev.buf, desc = "hover" })

					-- ========== Signature Help 签名帮助 ==========
					vim.keymap.set("n", "<leader>m", vim.lsp.buf.signature_help, {
						buffer = ev.buf,
						desc = "signature_help"
					})


					-- 可选：配置自动触发（输入括号时）
					if client.server_capabilities.signatureHelpProvider then
						vim.api.nvim_create_autocmd("TextChangedI", {
							buffer = ev.buf,
							callback = function()
								local line = vim.api.nvim_get_current_line()
								local col = vim.api.nvim_win_get_cursor(0)[2]
								local char = line:sub(col, col)

								-- 输入 '(' 或 ',' 时自动触发
								if char == "(" or char == "," then
									vim.lsp.buf.signature_help()
								end
							end,
						})
					end
				end,
			})
		end,
	},
}
