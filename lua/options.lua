vim.opt.termguicolors = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.autochdir = true
vim.opt.exrc = true
vim.opt.secure = true
vim.opt.encoding = 'utf-8'

-- line number
vim.opt.scrolloff = 10
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = 'number'
vim.opt.relativenumber = true
vim.opt.wrap = true
-- vim.opt.listchars = { tab = ' ', trail = '▒' }

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

-- indent
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.indentexpr = ''
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = false
vim.opt.foldmethod = 'indent'
vim.opt.foldenable = false

-- spilt
vim.opt.splitright = true
vim.opt.splitbelow = false

-- system
vim.opt.mouse = 'a'
vim.opt.concealcursor = 'nc'
vim.opt.hidden = true
vim.opt.signcolumn = 'yes'
vim.opt.showcmd = false
vim.opt.showmode = false
vim.opt.timeout = true
vim.opt.ttimeout = false
vim.opt.timeoutlen = 1000
vim.opt.updatetime = 300  -- Increase for better performance
vim.opt.virtualedit = 'block'
vim.opt.ttyfast = true
vim.opt.tw = 0
vim.opt.viewoptions = "cursor,folds,unix"
vim.opt.laststatus = 2
vim.opt.undofile = true
