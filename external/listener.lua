--[[
	Combat log listener for Mirakuru Profiles
	Created by Mirakuru
]]

-- Store units temporarily
miLib.unitList = {}

-- Register Combat Log events
ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event			= select(2, ...)
	local sourceGUID	= select(4, ...)
	local targetGUID	= select(8, ...)
	local spellID		= select(12, ...)
	
	local specID = GetSpecializationInfo(GetSpecialization())
	local mastProcs = {[176941] = true}
	local critProcs = {[162919] = true,[177046] = true}
	local intProcs = {[177594] = true,[126683] = true,[126705] = true}
	local hasteProcs = {[177051] = true,[176875] = true,[90355] = true,[2825] = true,[80353] = true,[32182] = true}
	
	if event == "SPELL_CAST_START" and sourceGUID == UnitGUID("player") then
		if spellID == 48181 then miLib.hauntCasted = true end
	end
	
	if event == "SPELL_CAST_FAILED" and sourceGUID == UnitGUID("player") then
		if spellID == 48181 then miLib.hauntCasted = false end
	end
	
	if event == "SPELL_CAST_SUCCESS" and sourceGUID == UnitGUID("player") then
		if spellID == 48181 or spellID == 74434 then miLib.shardTimer = GetTime() end
	end
	
	if event == "SPELL_AURA_APPLIED" and sourceGUID == UnitGUID("player") then
		-- Haunt
		if spellID == 48181 and miLib.hauntCasted then miLib.hauntCasted = false end
		
		-- Corruption
		if spellID == 146739 then miLib.lastCorrupt = targetGUID end
		
		-- Mastery trinket/buff procs
		if mastProcs[spellID] ~= nil then
			miLib.hasMastProcs = miLib.hasMastProcs + 1
			miLib.mastProcTimer = select(7,UnitBuff("player", GetSpellInfo(spellID)))
		end
		
		-- Haste trinket/buff procs
		if hasteProcs[spellID] ~= nil then
			miLib.hasHasteProcs = miLib.hasHasteProcs + 1
			miLib.hasteProcTimer = select(7,UnitBuff("player", GetSpellInfo(spellID)))
		end
		
		-- Intellect trinket/buff procs
		if intProcs[spellID] ~= nil then
			miLib.hasIntProcs = miLib.hasIntProcs + 1
			miLib.intProcTimer = select(7,UnitBuff("player", GetSpellInfo(spellID)))
		end
		
		-- Crit trinket/buff procs
		if critProcs[spellID] ~= nil then
			miLib.hasCritProc = miLib.hasCritProc + 1
			miLib.critTimer = select(7,UnitBuff("player", GetSpellInfo(spellID)))
		end
		
		
		-- Destruction DOT counters
		if specID == 267 then
			if spellID == 157736 then	-- Immolate
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].immo = true
				else
					miLib.unitList[targetGUID] = {immo = true}
				end
				miLib.immoCount = miLib.immoCount + 1
			end
		end
		
		-- Affliction DOT counters
		if specID == 265 then
			if spellID == 980 then		-- Agony
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].ag = true
				else
					miLib.unitList[targetGUID] = {ag = true, cor = false, ua = false}
				end
				miLib.agonyCount = miLib.agonyCount + 1
			end
			if spellID == 146739 then	-- Corruption
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].cor = true
				else
					miLib.unitList[targetGUID] = {ag = false, cor = true, ua = false}
				end
				miLib.corrCount = miLib.corrCount + 1
			end
			if spellID == 30108 then	-- Unstable Affliction
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].ua = true
				else
					miLib.unitList[targetGUID] = {ag = false, cor = false, ua = true}
				end
				miLib.auCount = miLib.auCount + 1
			end
		end
		
		-- Shadow Priest DOT counters
		if specID == 258 then
			if spellID == 589 then		-- Shadow Word: Pain
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].swp = true
				else
					miLib.unitList[targetGUID] = {swp = true, vt = false}
				end
				miLib.swp = miLib.swp + 1
			end
			if spellID == 34914 then	-- Vampiric Touch
				if miLib.unitList[targetGUID] ~= nil then
					miLib.unitList[targetGUID].vt = true
				else
					miLib.unitList[targetGUID] = {swp = false, vt = true}
				end
				miLib.vt = miLib.vt + 1
			end
		end
	end
	
	
	if event == "SPELL_AURA_REMOVED" and sourceGUID == UnitGUID("player") then
		-- Mastery trinket/buff procs
		if mastProcs[spellID] ~= nil then miLib.hasMastProcs = miLib.hasMastProcs - 1 end
		
		-- Haste trinket/buff procs
		if hasteProcs[spellID] ~= nil then miLib.hasHasteProcs = miLib.hasHasteProcs - 1 end
		
		-- Intellect trinket/buff procs
		if intProcs[spellID] ~= nil then miLib.hasIntProcs = miLib.hasIntProcs - 1 end
		
		-- Crit trinket/buff procs
		if critProcs[spellID] ~= nil then miLib.hasCritProc = miLib.hasCritProc - 1 end
		
		
		-- Destruction DOT counters
		if specID == 267 then
			if miLib.unitList[targetGUID] ~= nil then
				if spellID == 157736 then	-- Immolate
					if miLib.unitList[targetGUID].immo then
						miLib.immoCount = miLib.immoCount - 1
						miLib.unitList[targetGUID].immo = false
					end
				end
			end
		end
		
		-- Affliction DOT counters
		if specID == 265 then
			if miLib.unitList[targetGUID] ~= nil then
				if spellID == 980 then		-- Agony
					if miLib.unitList[targetGUID].ag then
						miLib.agonyCount = miLib.agonyCount - 1
						miLib.unitList[targetGUID].ag = false
					end
				end
				if spellID == 146739 then	-- Corruption
					if miLib.unitList[targetGUID].cor then
						miLib.corrCount = miLib.corrCount - 1
						miLib.unitList[targetGUID].cor = false
					end
				end
				if spellID == 30108 then	-- Unstable Affliction
					if miLib.unitList[targetGUID].ua then
						miLib.auCount = miLib.auCount - 1
						miLib.unitList[targetGUID].ua = false
					end
				end
			end
		end
		
		-- Shadow Priest DOT counters
		if specID == 258 then
			if miLib.unitList[targetGUID] ~= nil then
				if spellID == 589 then		-- Shadow Word: Pain
					if miLib.unitList[targetGUID].swp then
						miLib.swp = miLib.swp - 1
						miLib.unitList[targetGUID].swp = false
					end
				end
				if spellID == 34914 then	-- Vampiric Touch
					if miLib.unitList[targetGUID].vt then
						miLib.vt = miLib.vt - 1
						miLib.unitList[targetGUID].vt = false
					end
				end
			end
		end
	end
	
	if event == "SPELL_AURA_REFRESH" and sourceGUID == UnitGUID("player") then
		-- Haunt
		if spellID == 48181 and miLib.hauntCasted then miLib.hauntCasted = false end
		
		-- Corruption
		if spellID == 146739 then miLib.lastCorrupt = targetGUID end
	end
	
	if event == "UNIT_DIED" then
		if miLib.unitList[targetGUID] ~= nil then
			if specID == 267 then	-- Destruction Warlock
				if miLib.unitList[targetGUID].immo then miLib.immoCount = miLib.immoCount - 1 end
				miLib.unitList[targetGUID] = nil
			end
			
			if specID == 265 then	-- Affliction Warlock
				if miLib.unitList[targetGUID].ag then miLib.agonyCount = miLib.agonyCount - 1 end
				if miLib.unitList[targetGUID].cor then miLib.corrCount = miLib.corrCount - 1 end
				if miLib.unitList[targetGUID].ua then miLib.auCount = miLib.auCount - 1 end
				miLib.unitList[targetGUID] = nil
			end
			
			if specID == 258 then	-- Shadow Priest
				if miLib.unitList[targetGUID].vt then miLib.vt = miLib.vt - 1 end
				if miLib.unitList[targetGUID].swp then miLib.swp = miLib.swp - 1 end
				miLib.unitList[targetGUID] = nil
			end
		end
	end
end)

-- Reset counters/clear table when entering combat
ProbablyEngine.listener.register("PLAYER_REGEN_DISABLED", function(...)
	local specID = GetSpecializationInfo(GetSpecialization())
	
	if specID == 258 then
		miLib.vt = 0
		miLib.swp = 0
	end
	if specID == 265 then
		miLib.auCount = 0
		miLib.corrCount = 0
		miLib.agonyCount = 0
	end
	if specID == 267 then miLib.immoCount = 0 end
	wipe(miLib.unitList)
end)

-- Reset counters/clear table when leaving combat
ProbablyEngine.listener.register("PLAYER_REGEN_ENABLED", function(...)
	local specID = GetSpecializationInfo(GetSpecialization())
	
	if specID == 258 then
		miLib.vt = 0
		miLib.swp = 0
	end
	if specID == 265 then
		miLib.auCount = 0
		miLib.corrCount = 0
		miLib.agonyCount = 0
	end
	if specID == 267 then miLib.immoCount = 0 end
	wipe(miLib.unitList)
end)