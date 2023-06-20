local Runner = {}

Runner.CompileRun = function()
	vim.cmd('w')
	local filetype = vim.bo.filetype

	if filetype == 'java' then
		Runner.RunJavaFiles()
	elseif filetype == 'python' then
		vim.fn['asyncrun#run']("", { save = 1 }, "python3 $(VIM_FILENAME)")
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
	--if filetype == 'go' then
	--local file_name = vim.fn.expand('%')
	--if l:file =~# '^\f\+_test\.go$'
	--:GoTestFunc
	--elseif l:file =~# '^\f\+\.go$'
	--:GoRun
	--end
	--end
end

-- TODO java-test and gradle
Runner.RunJavaFiles = function()
	local wordspacedir = vim.fn.FindRootDirectory()
	if wordspacedir ~= '' then
		local fileName = vim.fn.expand("%")
		local suffix = string.sub(fileName, -1, 9)
		vim.cmd('echo ' .. suffix)

		-- Test Run
		--if string.upper(suffix) == 'TEST.JAVA' or string.upper(suffix) == 'TESTS.java' then
		--local testRunArg = ''

		--if vim.fn.expand('<cword>') ~= '' then
		--testRunArg = vim.fn.expand("%:t:r") .. "#" .. vim.fn.expand("<cword>")
		--else
		--testRunArg = vim.fn.expand("%:t:r")
		--end

		--vim.fn['asyncrun#run']("", { save = 1 }, "mvn package -Dtest=" .. testRunArg .. " test")
		--end

		-- Maven Run
		vim.fn['asyncrun#run']("", { save = 1 }, "mvn clean spring-boot:run")
	else
		-- class file Run
		vim.fn['asyncrun#run']("", { save = 1 }, "javac $(VIM_FILENAME) && java $(VIM_FILENOEXT)")
	end
end

return Runner
