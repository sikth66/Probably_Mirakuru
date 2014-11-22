--[[
	Custom conditions for Mirakuru Profiles
	Created by Mirakuru
]]
-- Check if a unit is crowd controlled
ProbablyEngine.condition.register("cc", function(target)
	local isCC = miLib.CC
	if isCC then return true else return false end
end)

-- Affliction specific, counts beneficient procs for Haunt
ProbablyEngine.condition.register("aff.procs", function(target)
	local count = miLib.affAuraProc
	return count
end)

-- Universal, counts +Intellect procs and stacking procs (6+) stacks
ProbablyEngine.condition.register("int.procs", function(target)
	local count = miLib.hasIntProcs
	local timer = miLib.intProcTimer
	
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if timer - GetTime() >= (2.5 / ((GetHaste("player") / 100)  + 1)) then return count end
	else
		return count
	end
end)

-- Command Demon specific, checks if our pet knows a Special Ability
ProbablyEngine.condition.register("pet.spell", function(target, spell)
	return IsSpellKnown(spell, true)
end)