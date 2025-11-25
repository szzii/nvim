-- LSP helper functions and common configurations
local M = {}

-- Common inlay hints configuration (disabled for performance)
M.inlay_hints_off = {
	includeInlayParameterNameHints = 'literals',  -- Only show for literals
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayFunctionParameterTypeHints = false,
	includeInlayVariableTypeHints = false,
	includeInlayVariableTypeHintsWhenTypeMatchesName = false,
	includeInlayPropertyDeclarationTypeHints = false,
	includeInlayFunctionLikeReturnTypeHints = false,
	includeInlayEnumMemberValueHints = false,
}

-- Common LSP flags for performance
M.lsp_flags = {
	debounce_text_changes = 300,  -- Reduce LSP request frequency (300ms for better performance)
	allow_incremental_sync = true,
}

-- Common performance settings
M.performance = {
	debounce = 200,
	throttle = 80,
	fetching_timeout = 300,
	max_view_entries = 20,
}

-- Get Python path from conda or local config
M.get_python_path = function()
	local conda_prefix = os.getenv("CONDA_PREFIX")
	if conda_prefix then
		local conda_python = conda_prefix .. "/bin/python"
		if vim.fn.executable(conda_python) == 1 then
			return conda_python
		end
	end
	local ok, local_config = pcall(require, "local")
	return ok and local_config.python_path or "/usr/local/bin/python3"
end

return M
