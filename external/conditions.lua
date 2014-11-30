--[[
	Custom conditions for Mirakuru Profiles
	Created by Mirakuru
]]
-- Check if a unit is crowd controlled
ProbablyEngine.condition.register("cc", function(target)
	if miLib.CC(target) then return true else return false end
end)

-- Affliction specific, counts beneficient procs for Haunt
ProbablyEngine.condition.register("aff.procs", function()
	return miLib.affAuraProc
end)

-- Universal, counts +Intellect procs and stacking procs (6+) stacks
ProbablyEngine.condition.register("crit.procs", function()
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.critTimer - GetTime() >= (2.5 / ((GetHaste("player") / 100)  + 1)) then return miLib.hasCritProc end
	else
		return miLib.hasCritProc
	end
end)

-- Universal, counts +Intellect procs and stacking procs (6+) stacks
ProbablyEngine.condition.register("int.procs", function()
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.intProcTimer - GetTime() >= (2.5 / ((GetHaste("player") / 100)  + 1)) then return miLib.hasIntProcs end
	else
		return miLib.hasIntProcs
	end
end)

-- Command Demon specific, checks if our pet knows a Special Ability
ProbablyEngine.condition.register("pet.spell", function(target, spell)
	return IsSpellKnown(spell, true)
end)