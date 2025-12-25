-- Load local configuration
local ok, local_config = pcall(require, "local")
local use_colemak = ok and local_config.use_colemak or false

-- Layout-specific key mappings (table-driven)
local layout_keys = {
	colemak = {
		-- Basic navigation remapping
		{ mode = '', from = 'n', to = 'h' },
		{ mode = '', from = 'e', to = 'j' },
		{ mode = '', from = 'i', to = 'l' },
		{ mode = '', from = 'u', to = 'k' },
		{ mode = '', from = 'U', to = '5k' },
		{ mode = '', from = 'E', to = '5j' },
		{ mode = '', from = 'N', to = '0' },
		{ mode = '', from = 'I', to = '$' },
		{ mode = 'n', from = 'h', to = 'i' },
		{ mode = '', from = 'H', to = 'I' },
		-- Additional mappings
		{ mode = 'n', from = 'l', to = 'u' },  -- undo
		{ mode = '', from = 'k', to = 'n' },   -- next search
		{ mode = '', from = 'K', to = 'N' },   -- previous search
	},
}

-- Apply layout-specific keymaps
local keys = use_colemak and layout_keys.colemak or layout_keys.qwerty
for _, map in ipairs(keys) do
	vim.keymap.set(map.mode, map.from, map.to, { noremap = true })
end
-- Universal keymaps (always applied)
-- Redo with both Ctrl+r and Ctrl+R
vim.keymap.set('n', '<C-r>', '<cmd>redo<CR>', { desc = 'Redo' })
vim.keymap.set('', ';', ':', { noremap = true })
vim.keymap.set('n', 'S', '<cmd>w<CR>', { silent = true })
vim.keymap.set('n', 'F', function() require("conform").format({ lsp_fallback = true }) end, { silent = true, desc = "Format buffer" })
vim.keymap.set('n', 'Q', '<cmd>q<CR>', { silent = true })
-- Indentation with Tab in visual/select/normal mode
vim.api.nvim_set_keymap('n', '<TAB>', '>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<TAB>', '>gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('s', '<TAB>', '>gv', { noremap = true, silent = true })  -- Select mode
vim.api.nvim_set_keymap('n', '<S-TAB>', '<<', { noremap = true, silent = true })
vim.api.nvim_set_keymap('x', '<S-TAB>', '<gv', { noremap = true, silent = true })
vim.api.nvim_set_keymap('s', '<S-TAB>', '<gv', { noremap = true, silent = true })  -- Select mode

vim.keymap.set('', '`', '~', { noremap = true })
vim.keymap.set('v', 'Y', '"+y', { noremap = true })
vim.api.nvim_set_keymap("n", "tq", '<Cmd>bdelete %<CR>', { noremap = true, silent = true })

-- Window management keymaps (layout-aware)
local window_keys = {
	colemak = {
		{ mode = '', from = 'sn', to = ':set nosplitright<CR>:vsplit<CR>', opts = { noremap = true, silent = true } },
		{ mode = '', from = 'se', to = ':set splitbelow<CR>:split<CR>', opts = { noremap = true, silent = true } },
		{ mode = '', from = 'su', to = ':set nosplitbelow<CR>:split<CR>', opts = { noremap = true, silent = true } },
		{ mode = '', from = 'si', to = ':set splitright<CR>:vsplit<CR>', opts = { noremap = true, silent = true } },
		{ mode = '', from = '<LEADER>n', to = '<C-w>h', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>e', to = '<C-w>j', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>u', to = '<C-w>k', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>i', to = '<C-w>l', opts = { noremap = true } },
	},
	qwerty = {
		{ mode = '', from = '<LEADER>h', to = '<C-w>h', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>j', to = '<C-w>j', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>k', to = '<C-w>k', opts = { noremap = true } },
		{ mode = '', from = '<LEADER>l', to = '<C-w>l', opts = { noremap = true } },
	},
}

-- Universal window keymaps
vim.keymap.set('', 'sh', '<C-w>t<C-w>K', { noremap = true })
vim.keymap.set('', 'sv', '<C-w>t<C-w>H', { noremap = true })

-- Apply layout-specific window keymaps
local win_keys = use_colemak and window_keys.colemak or window_keys.qwerty
for _, map in ipairs(win_keys) do
	vim.keymap.set(map.mode, map.from, map.to, map.opts)
end
vim.keymap.set('', '<LEADER>q', '<C-w>o', { noremap = true })
vim.keymap.set('', '<LEADER>w', '<C-w>w', { noremap = true })
vim.keymap.set('', '<LEADER><CR>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'tu', ':tabe<CR>', { noremap = true, silent = true })

-- Move lines keymaps (layout-aware)
local move_keys = {
	colemak = {
		down = '<C-e>',
		up = '<C-u>',
	},
	qwerty = {
		down = '<C-j>',
		up = '<C-k>',
	},
}

local move = use_colemak and move_keys.colemak or move_keys.qwerty
vim.keymap.set("n", move.down, "<cmd>m .+1<cr>==", { desc = "Move down", silent = true })
vim.keymap.set("n", move.up, "<cmd>m .-2<cr>==", { desc = "Move up", silent = true })
vim.keymap.set("i", move.down, "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", silent = true })
vim.keymap.set("i", move.up, "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", silent = true })
vim.keymap.set("v", move.down, ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
vim.keymap.set("v", move.up, ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

-- Other utility keymaps
vim.keymap.set("n", "`", ":lua require('functions.tools').Reverse_bool()<CR>", { desc = "reverse", silent = true })
