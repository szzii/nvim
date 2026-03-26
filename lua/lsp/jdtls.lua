-- Java LSP (JDTLS) 配置 - 使用标准 nvim-lspconfig 方式
-- 注意：JDTLS 需要为每个项目配置独立的 workspace 目录

local custom_lsp_path = vim.fn.stdpath('data') .. "/custom_lsp"
local lazy_path = vim.fn.stdpath('data') .. "/lazy"
local mason_path = vim.fn.stdpath('data') .. "/mason"
local mason_share_path = mason_path .. "/share"
local jdtls_path = custom_lsp_path .. "/jdtls"
local path_to_plugins = jdtls_path .. "/plugins/"
local lombok_path = jdtls_path .. "/lombok.jar"
local jdk21_home = "/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home"
local jdk8_home = "/Library/Java/JavaVirtualMachines/amazon-corretto-8.jdk/Contents/Home"
local java_debug_path = lazy_path .. "/java-debug"
local java_test_path = lazy_path .. "/vscode-java-test"
local mason_java_debug_path = mason_share_path .. "/java-debug-adapter"
local mason_java_test_path = mason_share_path .. "/java-test"

local system = vim.uv.os_uname()

local function first_existing_path(paths)
	for _, path in ipairs(paths) do
		if vim.uv.fs_stat(path) then
			return path
		end
	end
	return paths[1]
end

local lsp_server_candidates = {}
if system.sysname == "Darwin" then
	if system.machine == "arm64" then
		table.insert(lsp_server_candidates, jdtls_path .. "/config_mac_arm")
	end
	table.insert(lsp_server_candidates, jdtls_path .. "/config_mac")
elseif system.sysname == "Linux" then
	if system.machine == "aarch64" then
		table.insert(lsp_server_candidates, jdtls_path .. "/config_linux_arm")
	end
	table.insert(lsp_server_candidates, jdtls_path .. "/config_linux")
end
table.insert(lsp_server_candidates, jdtls_path .. "/config_mac")

local path_to_lsp_server = first_existing_path(lsp_server_candidates)

-- 查找 launcher jar（兼容不同平台）
local launcher_jars = vim.fn.glob(path_to_plugins .. "org.eclipse.equinox.launcher_*.jar", true, true)
local path_to_jar = launcher_jars[1] or path_to_plugins .. "org.eclipse.equinox.launcher_1.7.100.v20251111-0406.jar"

-- Root 标记文件
local root_markers = { "gradlew", ".git", "mvnw", "build.gradle", "pom.xml", "settings.gradle" }

local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:t")
local workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/workspace/" .. project_name

local function extend_bundles(bundles, seen, pattern, excludes)
	for _, jar in ipairs(vim.fn.glob(pattern, true, true)) do
		local filename = vim.fn.fnamemodify(jar, ":t")
		if not (excludes and excludes[filename]) and not seen[jar] then
			table.insert(bundles, jar)
			seen[jar] = true
		end
	end
end

local bundles = {}
local seen_bundles = {}
extend_bundles(bundles, seen_bundles, mason_java_debug_path .. "/com.microsoft.java.debug.plugin*.jar")
extend_bundles(bundles, seen_bundles, java_debug_path .. "/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")
extend_bundles(bundles, seen_bundles, java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar")
extend_bundles(bundles, seen_bundles, custom_lsp_path .. "/java-debug/com.microsoft.java.debug.plugin-*.jar")
extend_bundles(bundles, seen_bundles, custom_lsp_path .. "/java-debug/extension/server/com.microsoft.java.debug.plugin-*.jar")
extend_bundles(bundles, seen_bundles, custom_lsp_path .. "/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-*.jar")

local excluded_java_test_jars = {
	["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
	["jacocoagent.jar"] = true,
}
extend_bundles(bundles, seen_bundles, mason_java_test_path .. "/*.jar", excluded_java_test_jars)
extend_bundles(bundles, seen_bundles, java_test_path .. "/server/*.jar", excluded_java_test_jars)
extend_bundles(bundles, seen_bundles, java_test_path .. "/extension/server/*.jar", excluded_java_test_jars)
extend_bundles(bundles, seen_bundles, custom_lsp_path .. "/vscode-java-test/server/*.jar", excluded_java_test_jars)
extend_bundles(bundles, seen_bundles, custom_lsp_path .. "/vscode-java-test/extension/server/*.jar", excluded_java_test_jars)

local has_java_test_bundles = vim.iter(bundles):any(function(jar)
	return jar:match("java%.test")
end)

return {
	-- JDTLS 命令（性能优化版本）
	cmd = {
		jdk21_home .. '/bin/java',

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
		'-data', workspace_dir,
	},

	filetypes = { "java" },

	root_markers = root_markers,

		settings = {
			java = {
				home = jdk21_home,

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
					updateBuildConfiguration = "automatic",  -- 调试前确保 classpath/输出目录及时刷新
					runtimes = {
						{
							name = "JavaSE-1.8",
							path = jdk8_home,
						},
						{
							name = "JavaSE-21",
							path = jdk21_home,
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
			autobuild = { enabled = true },  -- 调试依赖已编译产物，关闭后容易出现“找不到主类”
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
				launchMode = "Hybrid",  -- 保留较快启动，同时允许 debug/test 进入完整模式
			},
		}
	},

	-- ========== 初始化选项（用于调试等扩展）==========
	init_options = {
		-- Java Debug / Java Test 插件 bundles（从 custom_lsp 目录自动发现）
		bundles = bundles,
	},

	-- ========== 其他配置 ==========
	-- Java 调试需要这些配置
	on_attach = function(client, bufnr)
		if client.name ~= "jdtls" then
			return
		end

		local ok_jdtls, jdtls = pcall(require, "jdtls")
		local ok_jdtls_dap, jdtls_dap = pcall(require, "jdtls.dap")
		local ok_dap, dap = pcall(require, "dap")

		if ok_jdtls and ok_jdtls_dap and ok_dap then
			jdtls.setup_dap({
				hotcodereplace = "auto",
			})

			vim.keymap.set("n", "<leader>df", function()
				jdtls_dap.setup_dap_main_class_configs({
					verbose = true,
					on_ready = function()
						dap.continue()
					end,
				})
			end, { buffer = bufnr, desc = "debug_java_main_class" })

			if has_java_test_bundles then
				vim.keymap.set("n", "<leader>dt", function()
					jdtls.test_nearest_method()
				end, { buffer = bufnr, desc = "debug_java_test_method" })

				vim.keymap.set("n", "<leader>dT", function()
					jdtls.test_class()
				end, { buffer = bufnr, desc = "debug_java_test_class" })
			end

			vim.keymap.set("n", "<leader>dc", function()
				jdtls.compile("full")
			end, { buffer = bufnr, desc = "debug_java_compile_full" })

			vim.keymap.set("n", "<leader>dr", function()
				dap.restart()
			end, { buffer = bufnr, desc = "debug_java_restart" })
		end
	end,
}
