
--[[
	全局使用的函数等
]]

_G.get_filename = function(full_path)
	return string.match(full_path, ".+[/\\]([\-_%w\(\)%.]*)%s*$")
end

_G.is_path_match = function(lhs, rhs)
	local lhs_new = string.lower(string.gsub(lhs, "[\\]", "/"))
	local rhs_new = string.lower(string.gsub(rhs, "[\\]", "/"))
	return lhs_new == rhs_new
end

--print(get_filename("models/mount/feijianyueting/feijianyueting.prefab.u3dext"))