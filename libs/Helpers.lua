--[[
	Helper functions for Mirakuru Profiles
	Created by Mirakuru
]]
miLib = {}
miLib.hasIntProcs = 0
miLib.affAuraProc = 0

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event		= select(2, ...)
	local source	= select(4, ...)
	local spell		= select(12, ...)
	local stacks	= select(16, ...)
	local affAuras = {[113860] = true,[32182] = true,[80353] = true,[2825] = true,[90355] = true,[177051] = true,[177046] = true,[176875] = true,[176942] = true,[177594] = true,[126705] = true,[126683] = true,[146218] = true,[146046] = true,[146202] = true,[148906] = true,[137590] = true,[14889] = true}
	local intProcs = {[146047] = true,[104993] = true,[148907] = true,[146184] = true,[177594] = true,[126683] = true,[126706] = true}
	
	if event == "SPELL_AURA_APPLIED" and source == UnitGUID("player") then
		if affAuras[spell] ~= nil then
			if stacks ~= nil then
				if stacks >= 6 then miLib.affAuraProc = miLib.affAuraProc + 1 end
			else miLib.affAuraProc = miLib.affAuraProc + 1 end
		end
		if intProcs[spell] ~= nil then
			if stacks ~= nil then
				if stacks >= 6 then miLib.hasIntProcs = miLib.hasIntProcs + 1 end
			else miLib.hasIntProcs = miLib.hasIntProcs + 1 end
		end
	end

	if event == "SPELL_AURA_REMOVED" and source == UnitGUID("player") then
		if intProcs[spell] ~= nil then miLib.hasIntProcs = miLib.hasIntProcs - 1 end
		if affAuras[spell] ~= nil then miLib.affAuraProc = miLib.affAuraProc - 1 end
	end
end)
function miLib.affProcs()
	if miLib.affAuraProc >= 1 then return true end
	return false
end
function miLib.intProcs()
	if miLib.hasIntProcs >= 1 then return true end
	return false
end

--[[
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
end]]

ProbablyEngine.library.register("miLib", miLib)