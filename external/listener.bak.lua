--[[
	Combat log listener for Mirakuru Profiles
	Created by Mirakuru
]]
unitList = {}

ProbablyEngine.listener.register("PLAYER_REGEN_DISABLED", function(...)
	wipe(unitList)
	miLib.vt = 0
	miLib.swp = 0
	miLib.auCount = 0
	miLib.corrCount = 0
	miLib.immoCount = 0
	miLib.agonyCount = 0
end)

ProbablyEngine.listener.register("PLAYER_REGEN_ENABLED", function(...)
	wipe(unitList)
	miLib.vt = 0
	miLib.swp = 0
	miLib.auCount = 0
	miLib.corrCount = 0
	miLib.immoCount = 0
	miLib.agonyCount = 0
end)

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event		= select(2, ...)
	local source	= select(4, ...)
	local target	= select(8, ...)
	local spell		= select(12, ...)
	local stacks	= select(16, ...)
	local intProcs = {[146047] = true,[104993] = true,[148907] = true,[146184] = true,[177594] = true,[126683] = true,[126706] = true,[146046] = true,[146202] = true,[148906] = true}
	local affAuras = {[113860] = true,[32182] = true,[80353] = true,[2825] = true,[90355] = true,[177051] = true,[177046] = true,[176875] = true,[176942] = true,[177594] = true,[126705] = true,[126683] = true,[146218] = true,[146046] = true,[146202] = true,[148906] = true,[137590] = true,[14889] = true}
	local critProcs = {[162920] = true, [162919] = true}
	
	if event == "SPELL_AURA_APPLIED" and source == UnitGUID("player") then
		if affAuras[spell] ~= nil then miLib.affAuraProc = miLib.affAuraProc + 1 end
		if intProcs[spell] ~= nil then
			miLib.hasIntProcs = miLib.hasIntProcs + 1
			miLib.intProcTimer = select(7,UnitBuff("player", GetSpellInfo(spell), nil))
		end
		if critProcs[spell] ~= nil then
			miLib.hasCritProc = miLib.hasCritProc + 1
			miLib.critTimer = select(7,UnitBuff("player", GetSpellInfo(spell), nil))
		end
		
		-- Immolate Counter
		if spell == 157736 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.immoCount = miLib.immoCount + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
		-- Shadow Word: Pain
		if spell == 589 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.swp = miLib.swp + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
		-- Vampiric Touch
		if spell == 34914 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.vt = miLib.vt + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
		-- Agony
		if spell == 980 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.agonyCount = miLib.agonyCount + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
		-- Corruption
		if spell == 146739 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.corrCount = miLib.corrCount + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
		-- Unstable Affliction
		if spell == 30108 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.auCount = miLib.auCount + 1
			table.insert(unitList, {guid = target, spell = spell})
		end
	end
	
	if event == "SPELL_AURA_REMOVED" and source == UnitGUID("player") then
		if affAuras[spell] ~= nil then miLib.affAuraProc = miLib.affAuraProc - 1 end
		if intProcs[spell] ~= nil then miLib.hasIntProcs = miLib.hasIntProcs - 1 end
		if critProcs[spell] ~= nil then miLib.hasCritProc = miLib.hasCritProc - 1 end
		
		-- Immolate Counter
		if spell == 157736 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.immoCount = miLib.immoCount - 1
		end
		-- Shadow Word: Pain
		if spell == 589 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.swp = miLib.swp - 1
		end
		-- Vampiric Touch
		if spell == 34914 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.vt = miLib.vt - 1
		end
		-- Agony
		if spell == 980 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.agonyCount = miLib.agonyCount - 1
		end
		-- Corruption
		if spell == 146739 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.corrCount = miLib.corrCount - 1
		end
		-- Unstable Affliction
		if spell == 30108 and (UnitExists("target") and UnitGUID("target") ~= target) then
			miLib.auCount = miLib.auCount - 1
		end
	end
	
	if event == "UNIT_DIED" then
		for i=1, #unitList do
			if unitList[i].guid == target then
				if unitList[i].spell == 157736 then
					miLib.immoCount = miLib.immoCount - 1
					tremove(unitList, i)
				end
				if unitList[i].spell == 589 then
					miLib.swp = miLib.swp - 1
					tremove(unitList, i)
				end
				if unitList[i].spell == 34914 then
					miLib.vt = miLib.vt - 1
					tremove(unitList, i)
				end
				if unitList[i].spell == 980 then
					miLib.agonyCount = miLib.agonyCount - 1
					tremove(unitList, i)
				end
				if unitList[i].spell == 146739 then
					miLib.corrCount = miLib.corrCount - 1
					tremove(unitList, i)
				end
				if unitList[i].spell == 30108 then
					miLib.auCount = miLib.auCount - 1
					tremove(unitList, i)
				end
			end
		end
	end
return end)
