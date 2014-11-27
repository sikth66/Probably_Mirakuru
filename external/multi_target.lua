--[[
	Multi-target functions for Mirakuru Profiles
	Created by Mirakuru
]]

-- The functions bellow use the Object Manager supplied by Firehack to search and verify
-- potential multidotting and cleaving targets. These might be a little resource heavy
-- so use with caution.

-- Havoc cleaving
function miLib.havoc()
	local totalObjects = ObjectCount()
	local fetch = ProbablyEngine.interface.fetchKey
	local charges,maxCharges,start,duration = GetSpellCharges(17962)
	local _,_,_,backdraft = UnitBuff("player", GetSpellInfo(117828))
	local _,_,_,_,_,_,darksoul = UnitBuff("player", GetSpellInfo(113858))
	local _,_,_,_,_,_,immolate = UnitDebuff("target", GetSpellInfo(348), nil, "PLAYER")
	
	if charges == maxCharges then return false end
	if not UnitExists("target") then return false end
	if backdraft and backdraft > 2 then return false end
	if immolate and immolate - GetTime() < 6 then return false end
	if ProbablyEngine.condition["moving"]("player") then return false end
	if charges < maxCharges and (start + duration - GetTime()) < 2 then return false end
	
	if not darksoul then
		if UnitPower("player", SPELL_POWER_BURNING_EMBERS, true) < (fetch('miraDestruConfig', 'embers_cb_max') - 2) then return false end
	end
	
	if ProbablyEngine.config.read("button_states").aoe then
		if ProbablyEngine.dsl.parse("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) then return false end
	end
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and infront(object)
			and not UnitIsPlayer(object)
			and UnitAffectingCombat(object)
			and UnitCanAttack("player", object)
			and not UnitIsUnit("target", object)
			and ProbablyEngine.condition["distance"](object) <= 40
			and LineOfSight(object, "player") then
				if not miLib.CC(object) then
					ProbablyEngine.dsl.parsedTarget = object
					return true
				end
		end
	end
	return false
end

-- Shadowburn sniping
function miLib.snipe_fh(spell, hp)
	local totalObjects = ObjectCount()
	
	if not spell or not hp then return false end
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and infront(object)
			and not UnitIsPlayer(object)
			and UnitAffectingCombat(object)
			and LineOfSight(object, "player")
			and UnitCanAttack("player", object)
			and not UnitIsUnit("target", object)
			and ProbablyEngine.condition["health"](object) <= hp
			and ProbablyEngine.parser.can_cast(spell, object, true)
			and ProbablyEngine.condition["distance"](object) <= 40 then
				if not miLib.CC(object) then
					ProbablyEngine.dsl.parsedTarget = object
					return true
				end
		end
	end
	return false
end

-- Immolate multidotting
function miLib.immolate()
	local totalObjects = ObjectCount()
	
	if miLib.immoCount >= 4 then return false end
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and infront(object)
			and not UnitIsPlayer(object)
			and UnitAffectingCombat(object)
			and ProbablyEngine.parser.can_cast(348, object, false)
			and LineOfSight(object, "player")
			and UnitCanAttack("player", object)
			and not UnitIsUnit("target", object)
			and ProbablyEngine.condition["distance"](object) <= 40
			and not UnitDebuff(object, GetSpellInfo(348), nil, "PLAYER") then
				if not miLib.CC(object) then
					ProbablyEngine.dsl.parsedTarget = object
					return true
				end
		end
	end
	return false
end

-- The functions bellow tries to search all available raid and party members for
-- a valid target to multidot, cleave or snipe. It's less resource heavy but obviously
-- have it's own downsides compared to using the Object Manager.

-- Sniping
function miLib.snipe(spell, hp)
	-- No spell/hp to snipe with given
	if not hp or not spell then return false end
	
	-- Raid or Party?
	local groupType = IsInRaid() and "raid" or "party"
	
	-- Find a valid target
	for i = 1, GetNumGroupMembers() do
		local target = groupType..i.."target"
		local health = math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100)
		if not UnitIsUnit("target", target)
			and health <= hp
			and UnitCanAttack("player", target)
			and ProbablyEngine.condition["distance"](target) <= 40
			and ProbablytEngine.parser.can_cast(spell, target, false) then
				if not miLib.CC(target) then
					ProbablyEngine.dsl.parsedTarget = target
					return true
				end
		end
	end
	return false
end

-- Multidotting
function miLib.dot(spell, count)
	-- No spell was passed
	if not spell or not count then return false end
	
	-- Raid or Party?
	local groupType = IsInRaid() and "raid" or "party"
	
	-- Find the counters
	if spell == 348 and miLib.immoCount >= count then return false end
	if spell == 30108 and miLib.auCount >= count then return false end
	if spell == 172 and miLib.corrCount >= count then return false end
	if spell == 980 and miLib.agonyCount >= count then return false end
	
	-- Find a valid target
	for i = 1, GetNumGroupMembers() do
		local target = groupType..i.."target"
		if not UnitIsUnit("target", target)
			and UnitCanAttack("player", target)
			and ProbablyEngine.condition["distance"](target) <= 40
			and not UnitDebuff(target, GetSpellInfo(spell), nil, "PLAYER")
			and ProbablytEngine.parser.can_cast(spell, target, false) then
				if not miLib.CC(target) then
					ProbablyEngine.dsl.parsedTarget = target
					return true
				end
		end
	end
	return false
end