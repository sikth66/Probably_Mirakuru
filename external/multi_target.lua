--[[
	Multi-target function for Mirakuru Profiles
	Created by Mirakuru
	
	Note: In development, do not use!!
]]
function miLib.havoc()
	if not UnitExists("target") then return false end
 
	local totalObjects = ObjectCount()
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and not UnitIsPlayer(object)
			and UnitCanAttack("player", object)
			and Distance(object, "player") <= 39.9
			and UnitPower("player", SPELL_POWER_BURNING_EMBERS, true) >= 10
			and not UnitIsUnit("target", object) then
				ProbablyEngine.dsl.parsedTarget = object
				return true
		end
	end
	return false
end