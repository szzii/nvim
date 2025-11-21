-- Machine-specific configuration
-- This file is gitignored and should be customized for each machine
-- Copy from local.lua.example and modify as needed

local M = {}

-- Keyboard layout configuration
M.use_colemak = true  -- Set to false if you use standard QWERTY layout

-- Debug configurations
M.python_path = "/usr/local/bin/python3"  -- Adjust for your system

-- AI/Copilot configuration
M.copilot_enabled = true  -- Enable/disable GitHub Copilot
M.avante_provider = "qianwen"  -- Options: "qianwen", "ollama", "openai", etc.
M.avante_providers = {
	qianwen = {
		__inherited_from = "openai",
		api_key_name = "DASHSCOPE_API_KEY",
		endpoint = "https://dashscope.aliyuncs.com/compatible-mode/v1",
		model = "qwen3-coder-plus",
		disable_tools = false,
	},
	ollama = {
		__inherited_from = "openai",
		api_key_name = "",
		endpoint = "http://127.0.0.1:11434/v1",
		model = "qwen2.5:14b",
		disable_tools = false,
	},
}

-- Theme configuration
M.theme = {
	transparent = true,
	lualine_theme = "vscode",
}

-- Editor preferences (optional overrides)
M.editor = {
	tabstop = 2,
	shiftwidth = 2,
	expandtab = false,
}

return M
