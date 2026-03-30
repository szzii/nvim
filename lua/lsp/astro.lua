return {
	cmd = { 'astro-ls', '--stdio' },
	filetypes = { 'astro' },
	root_markers = {
		'astro.config.mjs',
		'astro.config.js',
		'astro.config.ts',
		'package.json',
		'bun.lock',
		'bun.lockb',
		'.git',
	},
	init_options = {
		typescript = {
			tsdk = '/opt/homebrew/opt/typescript/libexec/lib/node_modules/typescript/lib',
		},
	},
}
