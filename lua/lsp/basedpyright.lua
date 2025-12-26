-- Python LSP 配置 (BasedPyright)
local lsp_helpers = require("utils.lsp-helpers")

return {
	cmd = { 'basedpyright-langserver', '--stdio' },
	filetypes = { 'python' },
	root_markers = { 'pyproject.toml', 'setup.py', '.git' },
	settings = {
		basedpyright = {
			analysis = {
				autoImportCompletions = true,
				autoSearchPaths = true,
				diagnosticMode = 'openFilesOnly',
				useLibraryCodeForTypes = true,
				logLevel = 'Warning',
				typeCheckingMode = 'standard',
				indexing = true,
			},
		},
		python = {
			pythonPath = lsp_helpers.get_python_path(),
		},
	},
	on_init = function(client)
		client.config.settings.python.pythonPath = lsp_helpers.get_python_path()
	end,
}
