--[[
	Multi-target function for Mirakuru Profiles
	Created by Mirakuru
	
	Note: In development, do not use!!
]]
--#TODO: Optimize to reduce FPS drop
function miLib.dots(spell, refreshTimer)
	IterateObjects(function(object)
		--if UnitCanAttack("player", object)
		--	and UnitReaction(object, "player") <= 4
		--	and UnitLevel(object) ~= -1
		--	and LineOfSight(object, "player")
		--	and Distance(object, "player") < 20
		--then
		if ProbablyEngine.parser.can_cast(spell, object) and UnitLevel(object) ~= -1 then
			if not UnitDebuff(object, GetSpellInfo(spell), nil, "player") then
				CastSpellByID(spell, object)
				return true
			elseif (select(7,UnitDebuff(object, GetSpellInfo(spell), nil, "player")) - GetTime()) < refreshTimer then
				CastSpellByID(spell, object)
				return true
			end
			return false
		end
		return false
	end, ObjectTypes.Unit)
	return false
end