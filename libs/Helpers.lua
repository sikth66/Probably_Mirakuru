--[[
	Helper functions for Mirakuru Profiles
	Created by Mirakuru
]]
miLib = {}

function miLib.hasAuraOrProc()
	local procs = {113860,113858,113861,114206,32182,80353,2825,90355,108508,177051,177046,176875,176942,177594,126705,126683,138963,138703,138788,146218,146046,146202,148906,104993,137590,148897,145164,145085,171982}
	for i=1,#procs do
		if UnitBuff("player", GetSpellInfo(procs[i]), nil, nil) then
			if select(4,UnitBuff("player", GetSpellInfo(procs[i]), nil, nil)) ~= 0
				and select(4,UnitBuff("player", GetSpellInfo(procs[i]), nil, nil)) < 6 then return false end
			return true
		end
		return false
	end
	return false
end


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

ProbablyEngine.library.register("miLib", miLib)