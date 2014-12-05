--[[
	Mirakuru Profiles - Unit Manager
	
	License:
		Released under the GNU GENERAL PUBLIC LICENSE V2
		If you use, modify or redistribute this code, please attach this header.
	
	Description:
		The manager parses available units around you when an Object Manager
		is unlocked and available, otherwise defaults to scanning Party and Raid
		targets for available units and caching them.
		
		Stores units per frame rather than parsing on-demand for reduced cpu footprint
]]

-- Manager cache
local unitCache = {}
local function cache()
	local specID = GetSpecializationInfo(GetSpecialization())
	wipe(unitCache)
	
	if FireHack then
		local totalObjects = ObjectCount()
		for i=1, totalObjects do
			local object = ObjectWithIndex(i)
			if ObjectExists(object) then
				if ObjectIsType(object, ObjectTypes.Unit) then
					if ProbablyEngine.condition["distance"](object) <= 40 then
						if UnitAffectingCombat(object) then
							if (specID ~= 258 and infront(object) or true) then
								if LineOfSight(object, "player") then
									if UnitCanAttack("player", object) then
										if not UnitIsPlayer(object) then
											if ProbablyEngine.condition["alive"](object) then
												table.insert(unitCache, object)
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
	else
		local groupType = IsInRaid() and "raid" or "party"
		for i = 1, GetNumGroupMembers() do
			local target = groupType..i.."target"
			if ProbablyEngine.condition["alive"](target) then
				if ProbablyEngine.condition["distance"](target) <= 40 then
					if UnitAffectingCombat(target) then
						if (specID ~= 258 and ProbablyEngine.condition["infront"](target) or true) then
							if UnitCanAttack(target) then
								if not UnitIsPlayer(target) then
									table.insert(unitCache, target)
								end
							end
						end
					end
				end
			end
		end
	end
end

-- Call cache manager and throttle
C_Timer.NewTicker(0.1, (function()
	if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		if ProbablyEngine.module.player.combat then cache() end
	end
end), nil)

-- Manager parser
function miLib.manager(spell, counter, health)
	local specID = GetSpecializationInfo(GetSpecialization())
	
	-- Error checks
	if not spell then return false end
	if not counter then counter = 1 end
	if not UnitExists("target") then return false end
	
	-- Counters
	if specID == 258 then	-- Shadow
		if spell == 589 and miLib.swp >= ProbablyEngine.interface.fetchKey('miraShadowConfig', 'swp_count') then return false end
		if spell == 34914 and miLib.vt >= ProbablyEngine.interface.fetchKey('miraShadowConfig', 'vt_count') then return false end
	end
	if specID == 267 then	-- Destruction
		if spell == 348 and miLib.immoCount >= counter then return false end
	end
	if specID == 265 then	-- Affliction
		if spell == 172 and miLib.corrCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'corruption_units') then return false end
		if spell == 980 and miLib.agonyCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'agony_units') then return false end
		if spell == 30108 and miLib.auCount >= ProbablyEngine.interface.fetchKey('miraAffConfig', 'ua_units') then return false end
	end
	
	-- Parse Object Manager
	if spell == 80240 then
		local embers = UnitPower("player", SPELL_POWER_BURNING_EMBERS, true)
		local darksoul = UnitBuff("player", GetSpellInfo(113858))
		
		if FireHack then
			if ProbablyEngine.config.read('button_states', 'aoe', false) then
				if ProbablyEngine.dsl.parse("target.area(10).enemies >= "..ProbablyEngine.interface.fetchKey('miraDestruConfig', 'aoe_units')) then return false end
			end
		end
		
		for i=1,#unitCache do
			if not miLib.CC(unitCache[i]) then
				if not UnitIsUnit("target", unitCache[i]) then
					if ProbablyEngine.parser.can_cast(spell, unitCache[i], false) then
						if (embers >= ProbablyEngine.interface.fetchKey('miraDestruConfig', 'embers_cb_max') or darksoul) then
							ProbablyEngine.dsl.parsedTarget = unitCache[i]
							return true
						end
					end
				end
			end
		end
	else
		if spell ~= 17877 and spell ~= 32379 then
			for i=1,#unitCache do
				local _,_,_,_,_,_,debuff = UnitDebuff(unitCache[i], GetSpellInfo(spell), nil, "PLAYER")
				if not miLib.CC(unitCache[i]) then
					if not UnitIsUnit("target", unitCache[i]) then
						if not debuff or debuff - GetTime() < 5.5 then
							if specID == 265 then
								if not UnitCastingInfo("player") then
									if ProbablyEngine.parser.can_cast(spell, unitCache[i], true) then
										ProbablyEngine.dsl.parsedTarget = unitCache[i]
										return true
									end
								end
							elseif specID == 258 then
								if UnitChannelInfo("player") == GetSpellInfo(48045) then
									if ProbablyEngine.parser.can_cast(spell, unitCache[i], true) then
										ProbablyEngine.dsl.parsedTarget = unitCache[i]
										return true
									end
								else
									if ProbablyEngine.parser.can_cast(spell, unitCache[i], false) then
										ProbablyEngine.dsl.parsedTarget = unitCache[i]
										return true
									end
								end
							else
								if ProbablyEngine.parser.can_cast(spell, unitCache[i], false) then
									ProbablyEngine.dsl.parsedTarget = unitCache[i]
									return true
								end
							end
						end
					end
				end
			end
		else
			if not health then return false end
			for i=1,#unitCache do
				if not miLib.CC(unitCache[i]) then
					if not UnitIsUnit("target", unitCache[i]) then
						if ProbablyEngine.condition["health"](unitCache[i]) <= health then
							if ProbablyEngine.parser.can_cast(spell, unitCache[i], true) then
								ProbablyEngine.dsl.parsedTarget = unitCache[i]
								return true
							end
						end
					end
				end
			end
		end
	end
	return false
end