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
	-- JDTLS 命令（性能优化版本）
	cmd = {
		'/Library/Java/JavaVirtualMachines/jdk-23.jdk/Contents/Home/bin/java',

		-- ========== Eclipse JDT.LS 配置 ==========
		'-Declipse.application=org.eclipse.jdt.ls.core.id1',
		'-Dosgi.bundles.defaultStartLevel=4',
		'-Declipse.product=org.eclipse.jdt.ls.core.product',
		'-Dlog.protocol=true',
		'-Dlog.level=WARNING',  -- 只显示警告和错误

		-- ========== 内存配置（性能优化）==========
		'-Xmx1G',               -- 降低最大堆内存（1G 足够，减少 GC 压力）
		'-Xms512m',             -- 提高初始堆内存（避免动态扩容）
		'-XX:NewRatio=1',       -- 年轻代与老年代比例 1:1（更多年轻代空间）

		-- ========== GC 配置（低延迟优化）==========
		'-XX:+UseG1GC',         -- 使用 G1 垃圾收集器
		'-XX:MaxGCPauseMillis=100',  -- 最大 GC 暂停时间
		'-XX:G1HeapRegionSize=8m',   -- G1 区域大小
		'-XX:+UseStringDeduplication',  -- 字符串去重（减少内存）

		-- ========== 编译优化 ==========
		'-XX:+TieredCompilation',    -- 分层编译（快速启动）
		'-XX:TieredStopAtLevel=1',   -- 只编译到 C1（快速启动，牺牲峰值性能）

		-- ========== 其他性能优化 ==========
		'-XX:+UseCompressedOops',    -- 压缩对象指针（64 位系统）
		'-XX:+UseCompressedClassPointers',  -- 压缩类指针
		'-Djava.net.preferIPv4Stack=true',  -- 优先使用 IPv4（更快）
		'-Djdtls.java.bridge.maxBuildCount=1',  -- 限制并行构建数

		-- ========== Lombok 支持 ==========
		'-javaagent:' .. lombok_path,

		-- ========== Java 模块配置 ==========
		'--add-modules=ALL-SYSTEM',
		'--add-opens', 'java.base/java.util=ALL-UNNAMED',
		'--add-opens', 'java.base/java.lang=ALL-UNNAMED',

		-- ========== JDTLS 启动参数 ==========
		'-jar', path_to_jar,
		'-configuration', path_to_lsp_server,
		'-data', '/Users/szz/.cache/jdtls/workspace/workspace',
	},

	filetypes = { "java" },

	root_markers = root_markers,

	settings = {
		java = {
			home = '/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home',

			-- ========== 性能优化配置 ==========
			maxConcurrentBuilds = 1,      -- 限制并发构建数
			referencesCodeLens = { enabled = false },  -- 禁用 Code Lens
			implementationsCodeLens = { enabled = false },

			-- 构建工具配置
			import = {
				gradle = {
					enabled = true,
					offline = { enabled = false },
					wrapper = { enabled = true },  -- 使用 Gradle Wrapper
				},
				maven = {
					enabled = true,
					downloadSources = false,  -- 不下载源码（提升速度）
				},
			},

			-- 项目配置
			configuration = {
				updateBuildConfiguration = "interactive",  -- 改为交互式（避免自动构建）
				runtimes = {
					{
						name = "JavaSE-1.8",
						path = "/Library/Java/JavaVirtualMachines/jdk-1.8.jdk/Contents/Home",
						default = true,
					},
				}
			},

			-- ========== 格式化（禁用以提升速度）==========
			format = {
				enabled = false,  -- 使用外部格式化工具（如 google-java-format）
			},

			-- ========== 代码补全优化 ==========
			completion = {
				maxResults = 15,  -- 减少补全结果数量（提升响应速度）
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

			-- ========== 更多性能优化 ==========
			autobuild = { enabled = false },  -- 禁用自动构建
			eclipse = {
				downloadSources = false,  -- 不下载源码
			},
			maven = {
				downloadSources = false,
				updateSnapshots = false,
			},
			sources = {
				organizeImports = {
					starThreshold = 99,  -- 提高 star import 阈值（减少导入整理）
					staticStarThreshold = 99,
				},
			},
			saveActions = {
				organizeImports = false,  -- 保存时不自动整理导入
			},

			-- ========== 签名帮助和内联提示 ==========
			signatureHelp = { enabled = true },
			inlayHints = {
				parameterNames = { enabled = false },
			},

			-- ========== 验证配置 ==========
			validation = {
				enabled = true,
				incomplete_classpath = "warning",
			},

			-- ========== 代码生成 ==========
			codeGeneration = {
				toString = {
					template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
				},
				useBlocks = true,
			},

			-- ========== 反编译器 ==========
			contentProvider = { preferred = 'fernflower' },

			-- ========== 保存时清理（禁用）==========
			cleanup = {
				actionsOnSave = {},  -- 禁用所有自动清理
			},

			-- ========== 服务器模式 ==========
			server = {
				launchMode = "LightWeight",  -- 使用轻量级模式（更快启动）
			},
		}
	},

	-- ========== 初始化选项（用于调试等扩展）==========
	init_options = {
		-- Java Debug 插件 bundles（如果已安装）
		bundles = {},
	},

	-- ========== 其他配置 ==========
	-- Java 调试需要这些配置
	on_attach = function(client, bufnr)
		-- nvim-jdtls 会在后台自动配置 DAP
		-- 这里不需要额外的配置
	end,
}
