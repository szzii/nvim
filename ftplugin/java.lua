local jdtls_path = vim.fn.stdpath('data') .. "/custom_lsp/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"

local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local workspace_dir = '/Users/szz/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

local path_to_lsp_server = jdtls_path .. "/config_mac"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
local lombok_path = jdtls_path .. "/lombok.jar"
local mason_path = vim.fn.glob(vim.fn.stdpath("data") .. "/mason/")


local bundles = {}

vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))

vim.list_extend(
	bundles,
	vim.split(
		vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
		"\n"
	)
)

local on_attach = function()
	require('jdtls').setup_dap({ hotcodereplace = 'auto' })
	require('jdtls.dap').setup_dap_main_class_configs()


	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = buffer,
		callback = function()
			vim.lsp.buf.format { async = false }
		end
	})

	vim.api.nvim_create_autocmd('BufWritePost', {
		buffer = bufnr,
		desc = 'refresh codelens',
		callback = function()
			pcall(vim.lsp.codelens.refresh)
		end,
	})

	pcall(vim.lsp.codelens.refresh)
end

--os.execute("mkdir -p " .. workspace_dir .. " >> /dev/null")

local config = {
	flags = {
		debounce_text_changes = 80,
		allow_incremental_sync = true,
	},
	root_dir = root_dir,
	filetypes = { "java" },
	init_options = {
		bundles = bundles,
	},
	on_attach = on_attach,
	cmd = {
		'/Users/szz/.javahome/jdk-17.0.1.jdk/Contents/Home/bin/java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ALL',
		'-javaagent:' .. lombok_path,
		'-Xmx1g',
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', workspace_dir,
	},

	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	settings = {
		java = {
			home = '/Users/szz/.javahome/jdk-17.0.1.jdk/Contents/Home',
			configuration = {
				updateBuildConfiguration = "interactive",
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/jdk1.8.0_301.jdk/Contents/Home",
					},
					{
						name = "JavaSE-11",
						path = "/Users/szz/.javahome/jdk-11.0.13.jdk/Contents/Home",
					},
					{
						name = "JavaSE-17",
						path = "/Users/szz/.javahome/jdk-17.0.1.jdk/Contents/Home",
					}
				}
			},
			format = {
				enable = true,
				--settings = {
				---- https://github.com/google/styleguide/blob/gh-pages/eclipse-java-google-style.xml
				--url = vim.fn.stdpath('data') .. "/eclipse/eclipse-java-google-style.xml",
				--profile = "GoogleStyle",
				--},
			},
			completion = {
				maxResults = 30,
				postfix = { enabled = true },
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
					"org.junit.jupiter.api.DynamicContainer.*",
					"org.junit.jupiter.api.DynamicTest.*"
				},
				importOrder = {
					"java",
					"javax",
					"com",
					"org"
				},
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},
			autobuild = { enabled = true },
			eclipse = { downloadSources = true, },
			saveActions = { organizeImports = true },
			-- LSP Related
			implementationsCodeLens = { enabled = true },
			referencesCodeLens = { enabled = true, },
			signatureHelp = { enabled = true },
			inlayHints = {
				parameterNames = { enabled = true },
			},
			maven = {
				downloadSources = true,
				updateSnapshots = true,
			},
			-- On Save Cleanup
			cleanup = {
				actionsOnSave = {
					"addOverride",
				},
			},
		}
	},
}

require('jdtls').start_or_attach(config)
