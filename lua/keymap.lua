-- colemak layout
vim.keymap.set('', 'n', 'h', { noremap = true })
vim.keymap.set('', 'e', 'j', { noremap = true })
vim.keymap.set('', 'i', 'l', { noremap = true })
vim.keymap.set('', 'u', 'k', { noremap = true })
vim.keymap.set('', 'U', '5k', { noremap = true })
vim.keymap.set('', 'E', '5j', { noremap = true })
vim.keymap.set('', 'N', '0', { noremap = true })
vim.keymap.set('', 'I', '$', { noremap = true })

vim.keymap.set('n', 'h', 'i', { noremap = true })
vim.keymap.set('', 'H', 'I', { noremap = true })
vim.keymap.set('', ';', ':', { noremap = true })
vim.keymap.set('n', 'S', '<cmd>w<CR>', { silent = true })
vim.keymap.set('n', 'F', ':lua vim.lsp.buf.format()<CR>', { silent = true })
vim.keymap.set('n', 'Q', '<cmd>q<CR>', { silent = true })
vim.keymap.set('n', '<TAB>', '>>', { noremap = true })
vim.keymap.set('x', '<TAB>', '>><ESC>', { noremap = true })
vim.keymap.set('n', '<S-TAB>', '<<', { noremap = false })
vim.keymap.set('x', '<S-TAB>', '<<<ESC>', { noremap = false })
vim.keymap.set('n', 'l', 'u', { noremap = true })

vim.keymap.set('', 'k', 'n', { noremap = true })
vim.keymap.set('', 'K', 'N', { noremap = true })
vim.keymap.set('', 'K', 'N', { noremap = true })
vim.keymap.set('', '`', '~', { noremap = true })
vim.keymap.set('', '`', '~', { noremap = true })
vim.keymap.set('v', 'Y', '"+y', { noremap = true })


vim.api.nvim_set_keymap("n", "tq", '<Cmd>bdelete %<CR>', { noremap = true, silent = true })

--vim.keymap.set('', '<LEADER>rc', ':e $HOME/.config/nvim/init.lua<CR>', { noremap = true, silent = true })
--vim.keymap.set('n', 'R', ':luafile $MYVIMRC<CR>', { noremap = true, silent = true })

vim.keymap.set('', 'sh', '<C-w>t<C-w>K', { noremap = true })
vim.keymap.set('', 'sv', '<C-w>t<C-w>H', { noremap = true })
vim.keymap.set('', 'sn', ':set nosplitright<CR>:vsplit<CR>', { noremap = true, silent = true })
vim.keymap.set('', 'se', ':set splitbelow<CR>:split<CR>', { noremap = true, silent = true })
vim.keymap.set('', 'su', ':set nosplitbelow<CR>:split<CR>', { noremap = true, silent = true })
vim.keymap.set('', 'si', ':set splitright<CR>:vsplit<CR>', { noremap = true, silent = true })
vim.keymap.set('', '<LEADER>n', '<C-w>h', { noremap = true })
vim.keymap.set('', '<LEADER>e', '<C-w>j', { noremap = true })
vim.keymap.set('', '<LEADER>u', '<C-w>k', { noremap = true })
vim.keymap.set('', '<LEADER>i', '<C-w>l', { noremap = true })
vim.keymap.set('', '<LEADER>q', '<C-w>o', { noremap = true })
vim.keymap.set('', '<LEADER>w', '<C-w>w', { noremap = true })
vim.keymap.set('', '<LEADER><CR>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'tu', ':tabe<CR>', { noremap = true, silent = true })


--vim.keymap.set("n", "<C-e>", "5<C-e> .+1<cr>==", { desc = "scoller down", silent = true })
--vim.keymap.set("n", "<C-u>", "5<C-y>", { desc = "scoller up", silent = true })

vim.keymap.set("n", "<C-e>", "<cmd>m .+1<cr>==", { desc = "Move down", silent = true })
vim.keymap.set("n", "<C-u>", "<cmd>m .-2<cr>==", { desc = "Move up", silent = true })
vim.keymap.set("i", "<C-e>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down", silent = true })
vim.keymap.set("i", "<C-u>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up", silent = true })
vim.keymap.set("v", "<C-e>", ":m '>+1<cr>gv=gv", { desc = "Move down", silent = true })
vim.keymap.set("v", "<C-u>", ":m '<-2<cr>gv=gv", { desc = "Move up", silent = true })

vim.keymap.set("n", "`", ":lua require('functions.tools').Reverse_bool()<CR>", { desc = "reverse", silent = true })

vim.keymap.set('n', 'L', vim.cmd.UndotreeToggle)
