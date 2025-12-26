-- Go LSP 配置
return {
	cmd = { 'gopls' },
	filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
	root_markers = { 'go.work', 'go.mod', '.git' },
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
}
