--[[
	Mirakuru Profiles - Spell Manager
	
	License:
		Released under the GNU GENERAL PUBLIC LICENSE V2
		If you use, modify or redistribute this code, please attach this header.
	
	Description:
		The goal of this Spell Manager is to scan for, parse and cache all available
		units around you within your cone of attack using an Object Manager when available
		or by scanning your Raid/Party's targets.
		
		Repeats the caching process per frame rather than continuously to reduce
		CPU and Memory footprint.
]]

-- Store units
cachedUnits = {}

-- Create the caching
local function cache(cache_type, blacklist, combatCheck)
	-- Make sure we're trying to parse the correct type
	if not tostring(cache_type) then cache_type = "default" end
	if not cache_type or cache_type ~= "firehack" or (cache_type == "firehack" and not FireHack) then cache_type = "default" end
	
	-- Blacklist/Whitelist sanity check
	if blacklist and type(blacklist) ~= "table" then blacklist = nil end
	
	-- Make sure we start with a clean slate
	wipe(cachedUnits)
	
	-- Using Object Manager
	if cache_type == "firehack" then
		local totalObjects = ObjectCount()
		for i=1, totalObjects do
			local object = ObjectWithIndex(i)
			if ObjectExists(object) then
				if ObjectIsType(object, ObjectTypes.Unit) then
					if LineOfSight(object, "player") then
						if UnitCanAttack("player", object) then
							if not UnitIsPlayer(object) then
								if not UnitIsOtherPlayersPet(object) then
									if ProbablyEngine.condition["alive"](object) then
										if ProbablyEngine.condition["distance"](object) < 40 then
											if ((not combatCheck and true) or UnitAffectingCombat(object)) then
												if not blacklist or (blacklist and blacklist[UnitID(object)] ~= UnitID(object)) then
													table.insert(cachedUnits, {
														object = object,
														guid = UnitGUID(object),
														hp = UnitHealth(object),
														hp2 = math.floor((UnitHealth(object)/UnitHealthMax(object))*100)
													})
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Spell Manager
function miLib.manager(spell, maxCount, minHealth)
	local specID = GetSpecializationInfo(GetSpecialization())
	local dots = {[589] = true,[34914] = true,[348] = true,[172] = true,[980] = true,[30108] = true}
	
	-- Sanity checks
	if not spell then return false end
	if not maxCount then maxCount = 1 end
	if not minHealth then minHealth = 20 end
	if not UnitExists("target") then return false end
	
	-- Havoc cleaving
	if spell == 80240 then
		local darksoul = UnitBuff("player", GetSpellInfo(113858))
		local embers = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
		
		-- Halt cleaving during AOE
		if FireHack then
			if ProbablyEngine.config.read('button_states', 'aoe', false) then
				if ProbablyEngine.dsl.parse("target.area(10).enemies >= "..ProbablyEngine.interface.fetchKey('miraDestruConfig', 'aoe_units')) then return false end
			end
		end
		
		-- Don't use Havoc with Backdraft up to force a CB cast
		if UnitBuff("player", GetSpellInfo(117828))
			and select(4,UnitBuff("player", GetSpellInfo(117828))) > 3 then return false end
		
		-- Not worth parsing anything if it's on cooldown
		if GetSpellCooldown(80240) ~= 0 then return false end
		
		-- Avoid cancelling a Chaos Bolt cast
		if UnitCastingInfo("player") == GetSpellInfo(116858) then return false end
		
		-- Not worth using Havoc when we can't cleave
		if embers < 10 then return false end
		
		-- Decide how to use Havoc
		if UnitLevel("target") == -1 then
			if math.floor((UnitHealth("target")/UnitHealthMax("target"))*100) > 25 then
				for i=1, #cachedUnits do
					if cachedUnits[i].hp2 < 20 then
						if not miLib.CC(cachedUnits[i].object) then
							if not UnitIsUnit("target", cachedUnits[i].object) then
								if ProbablyEngine.parser.can_cast(80240, cachedUnits[i].object, true) then
									ProbablyEngine.dsl.parsedTarget = "target"
									return true
								end
							end
						end
					end
				end
				
				for i=1, #cachedUnits do
					if cachedUnits[i].hp2 > 20 then
						if not miLib.CC(cachedUnits[i].object) then
							if (embers >= ProbablyEngine.interface.fetchKey('miraDestruConfig', 'embers_cb_max') or darksoul or miLib.hasCritProc >= 1 or miLib.hasIntProcs >= 1) then
								if not UnitIsUnit("target", cachedUnits[i].object) then
									if ProbablyEngine.parser.can_cast(80240, cachedUnits[i].object, true) then
										ProbablyEngine.dsl.parsedTarget = cachedUnits[i].object
										return true
									end
								end
							end
						end
					end
				end
				return false
			else
				if math.floor((UnitHealth("target")/UnitHealthMax("target"))*100) < 20 then
					for i=1, #cachedUnits do
						if not miLib.CC(cachedUnits[i].object) then
							if cachedUnits[i].hp2 > 20 then
								if not UnitIsUnit("target", cachedUnits[i].object) then
									if ProbablyEngine.parser.can_cast(80240, cachedUnits[i].object, true) then
										ProbablyEngine.dsl.parsedTarget = cachedUnits[i].object
										return true
									end
								end
							end
						end
					end
				end
				return false
			end
			return false
		else
			for i=1, #cachedUnits do
				if cachedUnits[i].hp2 > 20 then
					if not miLib.CC(cachedUnits[i].object) then
						if (embers >= ProbablyEngine.interface.fetchKey('miraDestruConfig', 'embers_cb_max') or darksoul or miLib.hasCritProc >= 1 or miLib.hasIntProcs >= 1) then
							if not UnitIsUnit("target", cachedUnits[i].object) then
								if ProbablyEngine.parser.can_cast(80240, cachedUnits[i].object, true) then
									ProbablyEngine.dsl.parsedTarget = cachedUnits[i].object
									return true
								end
							end
						end
					end
				end
			end
			return false
		end
		return false
	end
	
	-- Can we snipe with ProbablyEngine?
	if spell == 17877 or spell == 32379 then
		for i=1, #cachedUnits do
			if math.floor((UnitHealth(cachedUnits[i].object)/UnitHealthMax(cachedUnits[i].object))*100) < minHealth then
				if not miLib.CC(cachedUnits[i].object) then
					if not UnitIsUnit("target", cachedUnits[i].object) then
						if infront(cachedUnits[i].object) then
							RunMacroText("/stopcasting")
							CastSpellByID(spell, cachedUnits[i].object)
							return true
						end
					end
				end
			end
		end
		return false
	end
	
	-- Multidotting
	if dots[spell] then
		if specID == 258 then	-- Shadow
			if spell == 589 and miLib.swp >= ProbablyEngine.interface.fetchKey('miraShadowConfig', 'swp_count') then return false end
			if spell == 34914 and miLib.vt >= ProbablyEngine.interface.fetchKey('miraShadowConfig', 'vt_count') then return false end
		end
		if specID == 267 then	-- Destruction
			if spell == 348 and miLib.immoCount >= maxCount then return false end
		end
		if specID == 265 then	-- Affliction
			if spell == 172 and miLib.corrCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'corruption_units') then return false end
			if spell == 980 and miLib.agonyCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'agony_units') then return false end
			if spell == 30108 and miLib.auCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'ua_units') then return false end
		end
		
		for i=1, #cachedUnits do
			if cachedUnits[i].hp2 >= 5 then
				if not miLib.CC(cachedUnits[i].object) then
					if not UnitIsUnit("target", cachedUnits[i].object) then
						if infront(cachedUnits[i].object) then
							if not UnitDebuff(cachedUnits[i].object, GetSpellInfo(spell), nil, "PLAYER") then
								if ProbablyEngine.parser.can_cast(spell, cachedUnits[i].object, false) then
									ProbablyEngine.dsl.parsedTarget = cachedUnits[i].object
									return true
								end
							end
						end
					end
				end
			end
		end
	end
	return false
end

-- Call cache and throttle
C_Timer.NewTicker(0.1, (function()
	if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		if ProbablyEngine.module.player.combat then cache("firehack", nil, true) end
	end
end), nil)