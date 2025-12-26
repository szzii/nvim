-- Java 插件配置
-- nvim-jdtls 用于 Java 调试支持（与 nvim-lspconfig 的 jdtls 配合使用）

return {
	{
		"mfussenegger/nvim-jdtls",
		dependencies = {
			"mfussenegger/nvim-dap",  -- 调试支持
		},
		ft = "java",
		config = function()
			-- nvim-jdtls 会自动配置 dap 适配器
			-- 它不会启动 jdtls LSP（由 nvim-lspconfig 负责）
			-- 只提供调试增强功能
		end,
	},
}
