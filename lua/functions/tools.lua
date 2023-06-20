local M = {}

M.Reverse_bool = function()
	local cword = vim.fn.expand("<cword>")

	if string.lower(cword) ~= 'true' and string.lower(cword) ~= 'false' then
		vim.fn.execute('normal ~')
		return
	end
	print(cword)

	if cword == 'true' then
		vim.fn.execute('normal bcw' .. 'false')
	elseif cword == 'false' then
		vim.fn.execute('normal bcw' .. 'true')
	elseif cword == 'True' then
		vim.fn.execute('normal bcw' .. 'False')
	elseif cword == 'False' then
		vim.fn.execute('normal bcw' .. 'True')
	elseif cword == 'TRUE' then
		vim.fn.execute('normal bcw' .. 'FALSE')
	elseif cword == 'FALSE' then
		vim.fn.execute('normal bcw' .. 'TRUE')
	end
end

return M
