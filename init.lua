vim.g.mapleader = ' '
vim.g.showbreak = '+++ '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("options")
require("keymap")
require("lazy").setup("plugins")

-- 启用 LSP 服务器（Neovim 0.11+ 新方式）
-- 会自动加载 ~/.config/nvim/lsp/ 目录下的配置
vim.lsp.enable('ts_ls')
vim.lsp.enable('basedpyright')
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')

-- 加载 LSP 相关命令
require("config.lsp-commands")

vim.keymap.set('n', 'R', ':lua require("functions.runner").CompileRun()<CR>', { noremap = true, silent = true })
