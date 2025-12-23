-- Load local configuration
local ok, local_config = pcall(require, "local")
local copilot_enabled = ok and local_config.copilot_enabled or true

return {
	{
		"github/copilot.vim",
		enabled = copilot_enabled,
		config = function()
			vim.g.copilot_enabled = copilot_enabled
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.api.nvim_set_keymap("i", "<C-o>", 'copilot#Accept("<CR>")', { silent = true, expr = true })

			-- Use Colemak-aware keymaps if enabled
			local use_colemak = ok and local_config.use_colemak or false
			if use_colemak then
				vim.api.nvim_set_keymap("i", "<C-u>", 'copilot#Previous()', { silent = true, expr = true })
				vim.api.nvim_set_keymap("i", "<C-e>", 'copilot#Next()', { silent = true, expr = true })
			else
				vim.api.nvim_set_keymap("i", "<C-k>", 'copilot#Previous()', { silent = true, expr = true })
				vim.api.nvim_set_keymap("i", "<C-j>", 'copilot#Next()', { silent = true, expr = true })
			end
		end
	},
	{
		"NickvanDyke/opencode.nvim",
		dependencies = {
			-- Recommended for `ask()` and `select()`.
			-- Required for `snacks` provider.
			---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
			{ "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
		},
		config = function()
			---@type opencode.Opts
			vim.g.opencode_opts = {
				-- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition".
			}

			-- Required for `opts.events.reload`.
			vim.o.autoread = true

			-- Recommended/example keymaps.
			vim.keymap.set({ "n", "x" }, "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end,
				{ desc = "Ask opencode" })
			vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end,
				{ desc = "Execute opencode action…" })
			vim.keymap.set({ "n", "t" }, "<C-.>", function() require("opencode").toggle() end, { desc = "Toggle opencode" })

			vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this ") end,
				{ expr = true, desc = "Add range to opencode" })
			vim.keymap.set("n", "goo", function() return require("opencode").operator("@this ") .. "_" end,
				{ expr = true, desc = "Add line to opencode" })

			vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,
				{ desc = "opencode half page up" })
			vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end,
				{ desc = "opencode half page down" })

			-- You may want these if you stick with the opinionated "<C-a>" and "<C-x>" above — otherwise consider "<leader>o".
			vim.keymap.set("n", "+", "<C-a>", { desc = "Increment", noremap = true })
			vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement", noremap = true })
		end,
	},
	{
		"coder/claudecode.nvim",
		dependencies = { "folke/snacks.nvim" },
		config = true,
		keys = {
			{ "<leader>a",  nil,                              desc = "AI/Claude Code" },
			{ "<leader>ac", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude" },
			{ "<leader>af", "<cmd>ClaudeCodeFocus<cr>",       desc = "Focus Claude" },
			{ "<leader>ar", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
			{ "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
			{ "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
			{ "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
			{ "<leader>as", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
			{
				"<leader>as",
				"<cmd>ClaudeCodeTreeAdd<cr>",
				desc = "Add file",
				ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
			},
			-- Diff management
			{ "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
			{ "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny diff" },
		},
	}
}
