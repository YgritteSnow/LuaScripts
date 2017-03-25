require "utilities"
local traverse_folder = require "traverse_folder"

_G.ResourceFiles = {
	{res_name = "PathData.dat",
	file_path = "E:/WorkProjects/nine_data/trunk/BaseData/PathData.dat",
	match_pattern = "ID%s*=%s*(%d+)%s*,%s*Path%s*=%s*(.*)$",
	},
	{res_name = "SkillGfxData.xml",
	file_path = "E:/WorkProjects/nine_client/trunk/Output/Configs/SkillGfxData.xml",
	match_pattern =  "SkillGfx%s*ID=\"(%d+)\"%s*FilePath=\"(.-)\"",
	},
	{res_name = "sound_cfg.lua",
	file_path = "E:/WorkProjects/nine_client/trunk/Output/Configs/sound_cfg.lua",
	match_pattern = "%[(%d+)%]+ = {\"(.-)\"",
	},
	{res_name = "ECResPath.lua",
	file_path = "E:/WorkProjects/nine_client/trunk/Output/Configs/ECResPath.lua",
	match_pattern = "%s*(%w*)%s*=.*\"(.*)\"",
	},
}

local load_respath = function() -- 加载资源列表
	local count = 0
	local res_map = {}
	for _,info in pairs(ResourceFiles) do
		count = 0
		--cur_map = {}
		local icon_file = io.open(info.file_path)
		for line in icon_file:lines() do

				local id, path = string.match(line, info.match_pattern)
				if id and path then
					path = string.lower(string.gsub(path, "\\", "/"))
					local file_name = get_filename(path)
					if file_name then
				if info.res_name == "PathData" then
					--print(id, path)
				end
						count = count + 1
						res_map[file_name] = id
					end
				end

		end
		print(string.format("%d files in [%s] is loaded.", count, info.res_name))
		--res_map[info.res_name] = cur_map
	end
	return res_map
end

--print(string.match("fx_stats_onselected = \"Models/Effect/common/prompt/fx_select_red.prefab.u3dext\",",
--	".*=.*\"(.*)\""
--	))
local res_all = load_respath()
return res_all