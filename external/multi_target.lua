--[[
	Multi-target function for Mirakuru Profiles
	Created by Mirakuru
	
	Note: In development, do not use!!
]]
--#TODO: Optimize to reduce FPS drop
function miLib.populate()
	IterateObjects(function(object)
		if ProbablyEngine.parser.can_cast(17962, object) and UnitLevel(object) ~= -1 and Distance("player", object) < 5 then
			print(object)
		end
		return false
	end, ObjectTypes.Unit)
	return false
end