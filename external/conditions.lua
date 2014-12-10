--[[
	Custom conditions for Mirakuru Profiles
	Created by Mirakuru
]]

-- Check if a unit is crowd controlled
ProbablyEngine.condition.register("cc", function(target, spell)
	if miLib.CC(target) then return true else return false end
end)

-- For Affliction Warlocks, tracking amount of procs benefitting Haunt
ProbablyEngine.condition.register("aff.procs", function(target, spell)
	return miLib.affAuraProc
end)

-- Universal Crit proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
ProbablyEngine.condition.register("crit.procs", function(target, spell)
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.critTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return miLib.hasCritProc end
	else
		return miLib.hasCritProc
	end
end)

-- Universal intellect proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
ProbablyEngine.condition.register("int.procs", function(target, spell)
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.intProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return miLib.hasIntProcs end
	else
		return miLib.hasIntProcs
	end
end)

-- Pet Special Ability check
ProbablyEngine.condition.register("pet.spell", function(target, spell)
	return IsSpellKnown(spell, true)
end)