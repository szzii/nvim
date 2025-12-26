-- TypeScript/JavaScript LSP 配置
local lsp_helpers = require("utils.lsp-helpers")

return {
	cmd = { 'typescript-language-server', '--stdio' },
	filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
	root_markers = { 'package.json', 'tsconfig.json', 'jsconfig.json', '.git' },
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
}
