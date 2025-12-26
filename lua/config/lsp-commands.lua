-- LSP 相关的用户命令
local lsp_helpers = require("utils.lsp-helpers")

-- 重启 BasedPyright 并使用当前 conda 环境
vim.api.nvim_create_user_command("PyrightSetEnv", function()
	vim.cmd("LspRestart basedpyright")
	vim.notify("BasedPyright restarted with: " .. lsp_helpers.get_python_path(), vim.log.levels.INFO)
end, { desc = "Restart BasedPyright with current conda env" })
