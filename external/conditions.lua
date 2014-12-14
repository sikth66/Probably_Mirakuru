--[[
	Custom conditions for Mirakuru Profiles
	Created by Mirakuru
]]

-- Check if a unit is crowd controlled
ProbablyEngine.condition.register("cc", function(target, spell)
	if miLib.CC(target) then return true else return false end
end)

-- Universal Haste proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
ProbablyEngine.condition.register("haste.procs", function(target, spell)
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.hasteProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return miLib.hasHasteProcs end
	else
		return miLib.hasHasteProcs
	end
end)

-- Universal Mastery proc counter, factors in 6+ stacks for stacking procs
-- and remaining time for Destruction Warlocks
ProbablyEngine.condition.register("mastery.procs", function(target, spell)
	if select(1,GetSpecializationInfo(GetSpecialization())) == 267 then
		if miLib.mastProcTimer - GetTime() >= (2.5/((GetHaste("player")/100)+1)) then return miLib.hasMastProcs end
	else
		return miLib.hasMastProcs
	end
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

-- Register a new movement command with Fox/KJC
ProbablyEngine.condition.register("moving", function(target)
    local speed, _ = GetUnitSpeed(target)
	if UnitBuff("player", 172106) or UnitBuff("player", 137587) then return false end
    return speed ~= 0
end)

-- Small condition for spell traveling (Note: Only works for Haunt yet!)
ProbablyEngine.condition.register("spell.traveling", function(target, spell)
	if miLib.hauntCasted then return false else return true end
end)

-- Countdown to when a Soulshard is regenerating
ProbablyEngine.condition.register("shardregen", function(target, spell)
    if miLib.shardTimer > 0 and miLib.shardTimer <= 20 then
		return GetTime() - miLib.shardTimer
	end
	return 0
end)

-- Check last cast Corruption against our current target
ProbablyEngine.condition.register("corruption", function(target)
	if not miLib.lastCorrupt or miLib.lastCorrupt ~= UnitGUID("target") then return true end
	return false
end)