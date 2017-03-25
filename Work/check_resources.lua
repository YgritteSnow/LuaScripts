
--[[
	输入文件夹名称和处理文件的函数，遍历文件夹内所有文件，如果检查通过，那么执行该函数
	todo：
	1. 只根据文件名，没有根据全路径检查
	2. 没有检查文件内部引用的文件名，例如 .lua 文件
]]

local res = require "load_resources"
local traverse = require "traverse_folder"

local if_replace = false
local to_check_folder = "E:/WorkProjects/nine_client/trunk/Output/Configs"
local resource_postfix = {
	".lua",
	".u3dext",
	".anim",
	".prefab",
	".png",
	".asset",
	".unity",
}
local file_postfix = {
	".lua",
	".xml",
	".dat",
}
local file_prefix_x = {
	"configs"
}

local debug_count = 10000

local dump_map = {}
local dump_func = function(file_name, res_name)
	dump_map[res_name..file_name] = {file_name, res_name}
end

local gsub_pattern = "[\"\'].-[\\/].-[\"\']"
local match_pattern = "[\"\'](.-[\\/].-)[\"\']"
local gsub_pattern_obj = function(filename, match)
	local new_match = string.lower(string.gsub(string.match(match, match_pattern), "[\\]", "/"))
	debug_count=debug_count-1
	if debug_count < 0 then error("asdfasdf") end
	for _,v in pairs(resource_postfix) do
		if new_match:find(v) then
			local id = res[get_filename(new_match)]
			if not id then
				if not get_filename(new_match) then print("no file name!!!!"..match.."|||"..new_match)
				else dump_func(filename, get_filename(new_match))
				end
				return match
			end
			return ""..id
		end
	end
	--print(string.format("file[%s]:resource[%s] is not a valid resource", filename, match))
	return match
end

local check_file = function(src_path, pattern, pattern_obj, dst_path)
	pattern = pattern or gsub_pattern
	pattern_obj = pattern_obj or gsub_pattern_obj
	dst_path = dst_path or src_path

	local src = io.open(src_path)
	local dst_str = ""
	local line_count = 0
	for line in src:lines() do
		line_count = line_count + 1
		local newline = string.gsub(line, pattern, function(match)
				gsub_pattern_obj(src_path, match)
			end)
		dst_str = dst_str..'\n'..newline
	end
	src:close()

	if if_replace then
		dst = io.open(dst_path, "w")
		if not dst then
			dst_path = dst_path.."._jjcopy"
			dst = io.open(dst_path, "w")
		end
		dst:write(dst_str)
		dst:close()
	end
end

local check_filename = function(filename)
	filename = string.lower(filename)

	local ok = false
	-- 后缀是否合法（用来指定文件格式）
	for _,v in pairs(file_postfix) do
		if filename:find(v.."$") then
			ok = true
		end
	end
	if not ok then return false end

	-- 前缀是否非法（用来排除某些文件夹内的引用）
	for _,v in pairs(file_prefix_x) do
		if filename:find("^"..v) then
			return false
		end
	end
	
	-- 是否是资源文件（用来排除加载所用的资源文件）
	local simple_name = get_filename(filename)
	for _,v in pairs(ResourceFiles) do
		local resource_name = get_filename(v.file_path)
		if simple_name == string.lower(resource_name) then
			return false
		end
	end

	return true
end

do
	dump_map = {}
	TraverseFolder(to_check_folder, check_filename, check_file)
	print("========================================================")
	print(string.format("Checked in folder[%s]:", to_check_folder))
	for _,v in pairs(dump_map) do
		print(string.format("file[%s]:resource[%s] is not defined in resources", v[1]:match(to_check_folder.."(.+)"), v[2]))
	end
end