-- 项目根目录自动检测和切换模块
local M = {}

-- 项目根目录标记文件
local root_markers = {
	'.git',
	'package.json',
	'tsconfig.json',
	'jsconfig.json',
	'pyproject.toml',
	'setup.py',
	'go.mod',
	'go.work',
	'Cargo.toml',
	'.luarc.json',
	'pom.xml',
	'build.gradle',
	'settings.gradle',
	'gradlew',
}

-- 缓存当前项目根目录
local current_root = nil

-- 获取项目根目录
function M.get_root()
	-- 使用当前 buffer 获取根目录
	local buf = vim.api.nvim_get_current_buf()
	local root = vim.fs.root(buf, root_markers)

	-- 如果没找到，使用文件所在目录
	if not root then
		local filepath = vim.api.nvim_buf_get_name(buf)
		if filepath ~= '' then
			root = vim.fn.fnamemodify(filepath, ':p:h')
		else
			root = vim.fn.getcwd()
		end
	end

	return root
end

-- 切换到项目根目录
function M.change_root()
	local new_root = M.get_root()

	-- 如果根目录发生变化，切换工作目录
	if new_root and new_root ~= current_root and new_root ~= vim.fn.getcwd() then
		current_root = new_root
		vim.cmd('lcd ' .. new_root)

		-- 可选：显示通知（注释掉避免打扰）
		-- vim.notify('Project root: ' .. new_root, vim.log.levels.INFO)
	end
end

-- 自动切换函数（用于 autocmd）
function M.auto_change_root()
	-- 获取 buffer 的根目录
	local buf = vim.api.nvim_get_current_buf()
	local root = vim.fs.root(buf, root_markers)

	if root and root ~= vim.fn.getcwd() then
		vim.cmd('lcd ' .. root)
		current_root = root
	end
end

-- 设置自动切换
function M.setup()
	-- BufReadPost 时自动切换到项目根目录
	vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufEnter' }, {
		group = vim.api.nvim_create_augroup('AutoProjectRoot', { clear = true }),
		callback = function()
			-- 延迟执行，避免影响启动速度
			vim.defer_fn(function()
				M.auto_change_root()
			end, 100)
		end,
		pattern = '*',
	})

	-- LSP Attach 时也切换目录
	vim.api.nvim_create_autocmd('LspAttach', {
		group = vim.api.nvim_create_augroup('LspProjectRoot', { clear = true }),
		callback = function(ev)
			local client = vim.lsp.get_client_by_id(ev.data.client_id)
			if client and client.config.root_dir then
				local lsp_root = client.config.root_dir
				if lsp_root and lsp_root ~= vim.fn.getcwd() then
					vim.cmd('lcd ' .. lsp_root)
					current_root = lsp_root
				end
			end
		end,
	})

	-- VimResized 时检查（可选）
	vim.api.nvim_create_autocmd('VimResized', {
		group = vim.api.nvim_create_augroup('ResizeProjectRoot', { clear = true }),
		callback = function()
			M.change_root()
		end,
	})
end

return M
