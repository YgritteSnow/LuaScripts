
--[[
	输入文件夹名称和处理文件的函数，遍历文件夹内所有文件，如果检查通过，那么执行该函数
]]

local lfs = require "lfs"
_G.TraverseFolder = function(folder_path, check_func, do_func)
	--local g = io.popen('dir E:\\LuaScripts')
	--local all = g:read('*all')
	--local fff = io.open("aaa.txt", "w")
	--fff:write(all)
	--fff:close()

	local attr = lfs.attributes(folder_path)
	if not attr then print(folder_path) end
	if attr.mode == "directory" then
		for i in lfs.dir(folder_path) do
			if i ~= "." and i ~= ".." then
				local child = folder_path.."/"..i
				TraverseFolder(child, check_func, do_func)
			end
		end
	elseif attr.mode == "file" then
		if not check_func or check_func(folder_path) then
			if do_func then do_func(folder_path) end
		end
	end
end