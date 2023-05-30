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
--require('functions.runner')

vim.keymap.set('n', 'R', ':lua require("functions.runner").CompileRun()<CR>', { noremap = true, silent = true })

--vim.cmd.colorscheme "vscode"
