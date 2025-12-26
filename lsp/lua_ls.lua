-- Lua LSP 配置
return {
	cmd = { 'lua-language-server' },
	filetypes = { 'lua' },
	root_markers = { '.luarc.json', '.luarc.jsonc', '.git' },
	settings = {
		Lua = {
			telemetry = { enable = false },
			runtime = {
				version = 'LuaJIT',
				path = vim.split(package.path, ';'),
			},
			diagnostics = {
				globals = { 'vim' },
				disable = { 'missing-fields' },
				enable = true,
				unusedLocalExclude = { '_*' },
			},
			workspace = {
				library = {
					vim.env.VIMRUNTIME,
					"${3rd}/luv/library",
					vim.fn.stdpath('config'),
					"${3rd}/busted/library",
					"${3rd}/luassert/library",
					"${3rd}/nvim-api/library",
				},
				checkThirdParty = false,
				maxPreload = 5000,
				preloadFileSize = 1000,
			},
			completion = {
				enable = true,
				callSnippet = 'Replace',
				keywordSnippet = 'Replace',
				showWord = 'Enable',
				autoRequire = true,
				showParams = true,
			},
			hint = {
				enable = true,
				setType = true,
				paramType = true,
				paramName = 'All',
				arrayIndex = 'Enable',
				semicolon = 'Disable',
			},
			format = {
				enable = false,
				defaultConfig = {
					indent_size = '2',
					indent_style = 'space',
				},
			},
			semantic = {
				enable = false,
			},
		},
	},
}
