return {
	cmd = { 'biome', 'lsp-proxy' },
	filetypes = {
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
		'json',
		'jsonc',
		'css',
		'scss',
	},
	root_markers = {
		'biome.json',
		'biome.jsonc',
		'package.json',
		'bun.lock',
		'bun.lockb',
		'.git',
	},
}
