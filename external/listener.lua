--[[
	Combat log listener for Mirakuru Profiles
	Created by Mirakuru
]]
local unitList = {}

-- Register Combat Log events
ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
	local event			= select(2, ...)
	local sourceGUID	= select(4, ...)
	local targetGUID	= select(8, ...)
	local spellID		= select(12, ...)
	
	local specID = GetSpecializationInfo(GetSpecialization())
	local critProcs = {[162919] = true}
	local intProcs = {[177594] = true,[126683] = true,[126706] = true}	
	local affAuras = {[113860] = true,[32182] = true,[80353] = true,[2825] = true,[90355] = true,[177051] = true,[177046] = true,[176875] = true,[176942] = true,[177594] = true,[126705] = true,[126683] = true,[176941] = true}
	
	
	if event == "SPELL_AURA_APPLIED" and sourceGUID == UnitGUID("player") then
		-- Affliction
		if specID == 265 then
			if affAuras[spellID] ~= nil then miLib.affAuraProc = miLib.affAuraProc + 1 end
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
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].immo = true
				else
					unitList[targetGUID] = {immo = true}
				end
				miLib.immoCount = miLib.immoCount + 1				
			end
		end
		
		-- Affliction DOT counters
		if specID == 265 then
			if spellID == 980 then		-- Agony
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].ag = true
				else
					unitList[targetGUID] = {ag = true, cor = false, ua = false}
				end
				miLib.agonyCount = miLib.agonyCount + 1
			end
			if spellID == 146739 then	-- Corruption
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].cor = true
				else
					unitList[targetGUID] = {ag = false, cor = true, ua = false}
				end
				miLib.corrCount = miLib.corrCount + 1
			end
			if spellID == 30108 then	-- Unstable Affliction
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].ua = true
				else
					unitList[targetGUID] = {ag = false, cor = false, ua = true}
				end
				miLib.auCount = miLib.auCount + 1
			end
		end
		
		-- Shadow Priest DOT counters
		if specID == 258 then
			if spellID == 589 then		-- Shadow Word: Pain
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].swp = true
				else
					unitList[targetGUID] = {swp = true, vt = false}
				end
				miLib.swp = miLib.swp + 1
			end
			if spellID == 34914 then	-- Vampiric Touch
				if unitList[targetGUID] ~= nil then
					unitList[targetGUID].vt = true
				else
					unitList[targetGUID] = {swp = false, vt = true}
				end
				miLib.vt = miLib.vt + 1
			end
		end
	end
	
	
	if event == "SPELL_AURA_REMOVED" and sourceGUID == UnitGUID("player") then
		-- Affliction
		if specID == 265 then
			if affAuras[spellID] ~= nil then miLib.affAuraProc = miLib.affAuraProc - 1 end
		end
		
		-- Intellect trinket/buff procs
		if intProcs[spellID] ~= nil then miLib.hasIntProcs = miLib.hasIntProcs - 1 end
		
		-- Crit trinket/buff procs
		if critProcs[spellID] ~= nil then miLib.hasCritProc = miLib.hasCritProc - 1 end
		
		
		-- Destruction DOT counters
		if specID == 267 then
			if unitList[targetGUID] ~= nil then
				if spellID == 157736 then	-- Immolate
					if unitList[targetGUID].immo then
						miLib.immoCount = miLib.immoCount - 1
						unitList[targetGUID].immo = false
					end
				end
			end
		end
		
		-- Affliction DOT counters
		if specID == 265 then
			if unitList[targetGUID] ~= nil then
				if spellID == 980 then		-- Agony
					if unitList[targetGUID].ag then
						miLib.agonyCount = miLib.agonyCount - 1
						unitList[targetGUID].ag = false
					end
				end
				if spellID == 146739 then	-- Corruption
					if unitList[targetGUID].cor then
						miLib.corrCount = miLib.corrCount - 1
						unitList[targetGUID].cor = false
					end
				end
				if spellID == 30108 then	-- Unstable Affliction
					if unitList[targetGUID].ua then
						miLib.auCount = miLib.auCount - 1
						unitList[targetGUID].ua = false
					end
				end
			end
		end
		
		-- Shadow Priest DOT counters
		if specID == 258 then
			if unitList[targetGUID] ~= nil then
				if spellID == 589 then		-- Shadow Word: Pain
					if unitList[targetGUID].swp then
						miLib.swp = miLib.swp - 1
						unitList[targetGUID].swp = false
					end
				end
				if spellID == 34914 then	-- Vampiric Touch
					if unitList[targetGUID].vt then
						miLib.vt = miLib.vt - 1
						unitList[targetGUID].vt = false
					end
				end
			end
		end
	end
	
	
	if event == "UNIT_DIED" then
		if unitList[targetGUID] ~= nil then
			if specID == 267 then	-- Destruction Warlock
				miLib.immoCount = miLib.immoCount - 1
				unitList[targetGUID] = nil
			end
			
			if specID == 265 then	-- Affliction Warlock
				if unitList[targetGUID].ag then miLib.agonyCount = miLib.agonyCount - 1 end
				if unitList[targetGUID].cor then miLib.corrCount = miLib.corrCount - 1 end
				if unitList[targetGUID].ua then miLib.auCount = miLib.auCount - 1 end
				unitList[targetGUID] = nil
			end
			
			if specID == 258 then	-- Shadow Priest
				if unitList[targetGUID].vt then miLib.vt = miLib.vt - 1 end
				if unitList[targetGUID].swp then miLib.swp = miLib.swp - 1 end
				unitList[targetGUID] = nil
			end
		end
	end
end)

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
	wipe(unitList)
end)

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
	wipe(unitList)
end)