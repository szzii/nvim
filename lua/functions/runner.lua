local Runner = {}

-- Get Python path from conda or local config
local function get_python_path()
	local conda_prefix = os.getenv("CONDA_PREFIX")
	if conda_prefix then
		local conda_python = conda_prefix .. "/bin/python"
		if vim.fn.executable(conda_python) == 1 then
			return conda_python
		end
	end
	local ok, local_config = pcall(require, "local")
	return ok and local_config.python_path or "python3"
end

local function elementExists(arr, target)
	for _, value in ipairs(arr) do
		if value == target then
			return true
		end
	end
	return false
end

Runner.CompileRun = function()
	vim.cmd('w')
	local filetype = vim.bo.filetype
	local webfiles = { 'javascript', 'javascriptreact' }

	if filetype == 'java' then
		Runner.RunJavaFiles()
	elseif filetype == 'vue' then
		vim.fn['asyncrun#run']("", { save = 1 }, "npm run dev")
	elseif filetype == 'python' then
		vim.fn['asyncrun#run']("", { save = 1 }, get_python_path() .. " $(VIM_FILENAME)")
	elseif filetype == 'dart' then
		vim.cmd("FlutterRun")
	elseif filetype == 'lua' then
		vim.fn['asyncrun#run']("", { save = 1 }, "lua $(VIM_FILENAME)")
	elseif filetype == 'c' then
		vim.fn['asyncrun#run']("", { save = 1 }, "clang $(VIM_FILENAME) -o $(VIM_FILENOEXT) && ./$(VIM_FILENOEXT)")
	elseif filetype == 'cpp' then
		vim.fn['asyncrun#run']("", { save = 1 },
			"clang++ -std=c++11 $(VIM_FILENAME) -Wall -o $(VIM_FILENOEXT) && ./$(VIM_FILENOEXT)")
	end
	if elementExists(webfiles, filetype) then
		vim.fn['asyncrun#run']("", { save = 1 }, "npm start")
	end
end

-- TODO java-test and gradle
Runner.RunJavaFiles = function()
	local wordspacedir = vim.fn.FindRootDirectory()
	if wordspacedir ~= '' then
		local fileName = vim.fn.expand("%")

		-- Test Run
		if string.sub(fileName, -9) == 'Test.java' or string.sub(fileName, -10) == 'Tests.java' then
			local testRunArg = ''

			if vim.fn.expand('<cword>') ~= '' then
				testRunArg = vim.fn.expand("%:t:r") .. "#" .. vim.fn.expand("<cword>")
			else
				testRunArg = vim.fn.expand("%:t:r")
			end
			vim.fn['asyncrun#run']("", { save = 1 }, "mvn package -Dtest=" .. testRunArg .. " test")
		else
			-- Maven Run
			vim.fn['asyncrun#run']("", { save = 1 }, "mvn clean spring-boot:run")
		end
	else
		-- class file Run
		vim.fn['asyncrun#run']("", { save = 1 }, "javac $(VIM_FILENAME) && java $(VIM_FILENOEXT)")
	end
end

return Runner
