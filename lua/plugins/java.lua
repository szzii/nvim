-- Java 插件配置
-- 已移除 nvim-jdtls，改用 nvim-lspconfig 内置的 jdtls 配置
-- 配置位于: ~/.config/nvim/lsp/jdtls.lua

return {
	-- 如果需要 Java 调试支持，可以添加 nvim-dap 相关插件
	-- {
	--     "mfussenegger/nvim-jdtls",
	--     ft = "java",
	-- },
}
