local jdtls_path = vim.fn.stdpath('data') .. "/custom_lsp/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"

local root_markers = { "gradlew", ".git", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
local workspace_dir = '/Users/szz/.cache/jdtls/workspace/' .. vim.fn.fnamemodify(root_dir, ':p:h:t')

local path_to_lsp_server = jdtls_path .. "/config_mac"
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.1000.v20250131-0606.jar"
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
end

local config = {
	flags = {
		debounce_text_changes = 150,  -- Consistent with other LSPs
		allow_incremental_sync = true,
	},
	root_dir = root_dir,
	filetypes = { "java" },
	init_options = {
		bundles = bundles,
	},
	on_attach = on_attach,
	cmd = {
		'/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home/bin/java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ERROR',  -- Reduce logging for better performance
		'-Xmx2G',  -- Limit max heap size
		'-Xms256m',  -- Initial heap size
		'-XX:+UseG1GC',  -- Use G1 garbage collector
		'-XX:+UseStringDeduplication',  -- Reduce memory usage
		'-javaagent:' .. lombok_path,
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
			home = '/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home',
			-- Performance optimizations
			maxConcurrentBuilds = 1,
			import = {
				gradle = {
					enabled = true,
					offline = { enabled = false },
				},
				maven = { enabled = true },
			},
			configuration = {
				updateBuildConfiguration = "automatic",  -- Change to automatic for better performance
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home",
					},
				}
			},
			format = {
				enable = true,
			},
			completion = {
				maxResults = 20,  -- Reduce for better performance
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
			autobuild = { enabled = false },  -- Disable autobuild for better performance, build manually when needed
			eclipse = { downloadSources = false, },  -- Disable for better performance
			sources = {
				organizeImports = {
					starThreshold = 5,
					staticStarThreshold = 5,
				},
			},
			saveActions = { organizeImports = false },  -- Disable on save for better performance
			-- LSP Related - all disabled for performance
			implementationsCodeLens = { enabled = false },
			referencesCodeLens = { enabled = false },
			signatureHelp = { enabled = true },
			inlayHints = {
				parameterNames = { enabled = false },
			},
			-- Disable validation for better performance
			validation = {
				enabled = true,
				-- Only enable essential validations
				incomplete_classpath = "warning",
			},
			maven = {
				downloadSources = false,  -- Disable for better performance
				updateSnapshots = false,  -- Disable auto update
			},
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
				},
				useBlocks = true,
			},
			contentProvider = { preferred = 'fernflower' },
			-- On Save Cleanup - disabled for performance
			cleanup = {
				actionsOnSave = {},  -- Disable all cleanup actions for better performance
			},
			-- Performance: Limit parallel downloads
			server = {
				launchMode = "Hybrid",
			},
		}
	},
}

require('jdtls').start_or_attach(config)
