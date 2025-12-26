-- Java LSP (JDTLS) 配置 - 使用标准 nvim-lspconfig 方式
-- 注意：JDTLS 需要为每个项目配置独立的 workspace 目录

local jdtls_path = vim.fn.stdpath('data') .. "/custom_lsp/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"
local path_to_lsp_server = jdtls_path .. "/config_mac"
local lombok_path = jdtls_path .. "/lombok.jar"

-- 查找 launcher jar（兼容不同平台）
local launcher_jars = vim.fn.glob(path_to_plugins .. "org.eclipse.equinox.launcher_*.jar", true, true)
local path_to_jar = launcher_jars[1] or path_to_plugins .. "org.eclipse.equinox.launcher_1.2.1100.v20240722-2106.jar"

-- Root 标记文件
local root_markers = { "gradlew", ".git", "mvnw", "build.gradle", "pom.xml", "settings.gradle" }

return {
	-- JDTLS 命令
	cmd = {
		'/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home/bin/java',
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=ERROR',
		'-Xmx2G',
		'-Xms256m',
		'-XX:+UseG1GC',
		'-XX:+UseStringDeduplication',
		'-javaagent:' .. lombok_path,
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',
		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', '/Users/szz/.cache/jdtls/workspace/workspace',
	},

	filetypes = { "java" },

	root_markers = root_markers,

	settings = {
		java = {
			home = '/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home',

			-- 构建工具
			import = {
				gradle = {
					enabled = true,
					offline = { enabled = false },
				},
				maven = { enabled = true },
			},

			-- 项目配置
			configuration = {
				updateBuildConfiguration = "automatic",
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home",
						default = true,
					},
				}
			},

			format = {
				enabled = false,
			},

			completion = {
				maxResults = 20,
				postfix = { enabled = true },
				favoriteStaticMembers = {
					"org.junit.Assert.*",
					"org.junit.Assume.*",
					"org.junit.jupiter.api.Assertions.*",
					"org.junit.jupiter.api.Assumptions.*",
				},
				importOrder = { "java", "javax", "com", "org" },
				filteredTypes = {
					"com.sun.*",
					"io.micrometer.shaded.*",
					"java.awt.*",
					"jdk.*",
					"sun.*",
				},
			},

			-- 性能优化
			autobuild = { enabled = false },
			eclipse = { downloadSources = false },
			maven = {
				downloadSources = false,
				updateSnapshots = false,
			},

			sources = {
				organizeImports = {
					starThreshold = 5,
					staticStarThreshold = 5,
				},
			},
			saveActions = { organizeImports = false },

			-- Code Lens
			implementationsCodeLens = { enabled = false },
			referencesCodeLens = { enabled = false },

			signatureHelp = { enabled = true },
			inlayHints = {
				parameterNames = { enabled = false },
			},

			validation = {
				enabled = true,
				incomplete_classpath = "warning",
			},

			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
				},
				useBlocks = true,
			},

			contentProvider = { preferred = 'fernflower' },

			cleanup = {
				actionsOnSave = {},
			},

			server = {
				launchMode = "Hybrid",
			},
		}
	},
}
