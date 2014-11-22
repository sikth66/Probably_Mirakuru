--[[
	Multi-target function for Mirakuru Profiles
	Created by Mirakuru
	
	Note: In development, do not use!!
]]
-- Havoc
function miLib.havoc()
	local isCC = miLib.CC
	local totalObjects = ObjectCount()
	local parse = ProbablyEngine.dsl.parse
	local fetch = ProbablyEngine.interface.fetchKey
	local aoe = ProbablyEngine.config.read("button_states").aoe
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
	
	if aoe then
		if parse("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) then return false end
	end
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and not UnitIsPlayer(object)
			and UnitAffectingCombat(object)
			and UnitCanAttack("player", object)
			and not UnitIsUnit("target", object)
			and Distance(object, "player") <= 39.9
			and LineOfSight(object, "player") then
				if not isCC(object) then
					ProbablyEngine.dsl.parsedTarget = object
					return true
				end
		end
	end
	return false
end

-- Immolate Multidotting
function miLib.immolate()
	local isCC = miLib.CC
	local counter = miLib.immoCount
	local totalObjects = ObjectCount()
	local can_cast = ProbablyEngine.parser.can_cast
	
	if counter >= 4 then return false end
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
		if ObjectIsType(object, ObjectTypes.Unit)
			and infront(object)
			and not UnitIsPlayer(object)
			and UnitAffectingCombat(object)
			and can_cast(348, object, false)
			and LineOfSight(object, "player")
			and UnitCanAttack("player", object)
			and not UnitIsUnit("target", object)
			and Distance(object, "player") <= 39.9
			and not UnitDebuff(object, GetSpellInfo(348), nil, "PLAYER") then
				if not isCC(object) then
					ProbablyEngine.dsl.parsedTarget = object
					return true
				end
		end
	end
	return false
end