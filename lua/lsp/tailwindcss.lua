return {
	cmd = { 'tailwindcss-language-server', '--stdio' },
	filetypes = {
		'astro',
		'html',
		'css',
		'scss',
		'javascript',
		'javascriptreact',
		'typescript',
		'typescriptreact',
		'vue',
		'svelte',
	},
	root_markers = {
		'tailwind.config.js',
		'tailwind.config.cjs',
		'tailwind.config.mjs',
		'tailwind.config.ts',
		'postcss.config.js',
		'postcss.config.cjs',
		'package.json',
		'bun.lock',
		'bun.lockb',
		'.git',
	},
	settings = {
		tailwindCSS = {
			validate = true,
			includeLanguages = {
				typescript = 'javascript',
				typescriptreact = 'javascript',
			},
		},
	},
}
