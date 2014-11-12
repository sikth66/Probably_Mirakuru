--[[
	Combat log listener for Mirakuru Profiles
	Created by Mirakuru
]]
ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event		= select(2, ...)
	local source	= select(4, ...)
	local target	= select(8, ...)
	local spell		= select(12, ...)
	local stacks	= select(16, ...)
	local intProcs = {[146047] = true,[104993] = true,[148907] = true,[146184] = true,[177594] = true,[126683] = true,[126706] = true,[146046] = true,[146202] = true,[148906] = true}
	local affAuras = {[113860] = true,[32182] = true,[80353] = true,[2825] = true,[90355] = true,[177051] = true,[177046] = true,[176875] = true,[176942] = true,[177594] = true,[126705] = true,[126683] = true,[146218] = true,[146046] = true,[146202] = true,[148906] = true,[137590] = true,[14889] = true}
	
	if event == "SPELL_AURA_APPLIED" and source == UnitGUID("player") then
		if affAuras[spell] ~= nil then miLib.affAuraProc = miLib.affAuraProc + 1 end
		if intProcs[spell] ~= nil then
			miLib.hasIntProcs = miLib.hasIntProcs + 1
			miLib.intProcTimer = select(7,UnitBuff("player", GetSpellInfo(spell), nil))
		end
	end
	if event == "SPELL_AURA_REMOVED" and source == UnitGUID("player") then
		if affAuras[spell] ~= nil then miLib.affAuraProc = miLib.affAuraProc - 1 end
		if intProcs[spell] ~= nil then miLib.hasIntProcs = miLib.hasIntProcs - 1 end
	end
return end)
