--[[
	Custom conditions for Mirakuru Profiles
	Created by Mirakuru
]]

-- Affliction specific, counts beneficient procs for Haunt
ProbablyEngine.condition.register("aff.procs", function(target)
	local count = miLib.affAuraProc
	return count
end)

-- Universal, counts +Intellect procs and stacking procs (6+) stacks
ProbablyEngine.condition.register("int.procs", function(target)
	local count = miLib.hasIntProcs
	return count
end)

-- Command Demon specific, checks if our pet knows a Special Ability
ProbablyEngine.condition.register("pet.spell", function(target, spell)
	return IsSpellKnown(spell, true)
end)