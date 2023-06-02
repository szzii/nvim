-- See `:help vim.lsp.start_client` for an overview of the supported `config` options.

local jdtls_path = vim.fn.stdpath('data') .. "/custom_lsp/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local path_to_lsp_server = jdtls_path .. "/config_mac"
local workspace_dir = '/Users/szz/.cache/jdtls/workspace/' .. project_name
local path_to_jar = path_to_plugins .. "org.eclipse.equinox.launcher_1.6.400.v20210924-0641.jar"
local lombok_path = jdtls_path .. "/lombok.jar"

os.execute("mkdir -p " .. workspace_dir .. " >> /dev/null")

local config = {
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

	root_dir = require('jdtls.setup').find_root({ '.git', 'mvnw', 'gradlew', 'build.gradle' }),


	-- 💀
	-- Here you can configure eclipse.jdt.ls specific settings
	-- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
	-- for a list of options

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
			eclipse = {
				downloadSources = true,
			},
			maven = {
				downloadSources = true,
			},
			implementationsCodeLens = {
				enabled = true,
			},
			referencesCodeLens = {
				enabled = true,
			},
			--inlayhints = {
			--parameterNames = {
			--enabled = true,
			--},
			--},
			saveActions = {
				organizeImports = false
			},
			format = {
				enabled = true,
			},
			signatureHelp = {
				enabled = true
			},
			completion = {
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
				}
			},
		},
	},

	-- Language server `initializationOptions`
	-- You need to extend the `bundles` with paths to jar files
	-- if you want to use additional eclipse.jdt.ls plugins.
	--
	-- See https://github.com/mfussenegger/nvim-jdtls#java-debug-installation
	--
	-- If you don't plan on using the debugger or other eclipse.jdt.ls plugins you can remove this
	--init_options = {
	--},
	on_attach = function()
		require('jdtls').setup_dap({ hotcodereplace = 'auto' })
		require('jdtls.dap').setup_dap_main_class_configs()
	end
}


-- This bundles definition is the same as in the previous section (java-debug installation)
local bundles = {
	vim.fn.glob(
		vim.fn.stdpath('data') ..
		"/custom_lsp/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar", 1),
};

-- This is the new part
vim.list_extend(bundles,
	vim.split(vim.fn.glob(vim.fn.stdpath('data') .. "/custom_lsp/vscode-java-test/server/*.jar", 1), "\n"))

config['init_options'] = {
	bundles = bundles,
}

require('jdtls').start_or_attach(config)
