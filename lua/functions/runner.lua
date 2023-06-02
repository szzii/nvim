local Runner = {}

Runner.CompileRun = function()
	vim.cmd('w')
	local filetype = vim.bo.filetype
	if filetype == 'java' then
		Runner.RunJavaFiles()
	end
	if filetype == 'python' then
		vim.fn['asyncrun#run']("", { save = 1 }, "python3 $(VIM_FILENAME)")
	end
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
