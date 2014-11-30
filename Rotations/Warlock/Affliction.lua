--[[
	Affliction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]
-- Dynamically evaluate settings
local fetch = ProbablyEngine.interface.fetchKey

local function dynamicEval(condition, spell)
	if not condition then return false end
	return ProbablyEngine.dsl.parse(condition, spell or '')
end

-- Pet Functions
function aff_pet()
	local pet = tonumber(fetch('miraAffConfig', 'summon_pet'))
	local spellName = GetSpellName(pet)
	
	if UnitCastingInfo("player") == GetSpellInfo(pet) then return false end
	
	if ProbablyEngine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
	
	if pet == 157757 or pet == 157898 then
		if ProbablyEngine.dsl.parse("talent(7, 3)") then CastSpellByName(spellName)
		else return false end
	else CastSpellByID(pet) end
end
function aff_service_pet()
	local pet = tonumber(fetch('miraDestruConfig', 'service_pet'))
	local spellName = GetSpellName(pet)
	
	if ProbablyEngine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
	if ProbablyEngine.dsl.parse("talent(5, 2)") then CastSpellByName(spellName) end
end

-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('aoe', 'Interface\\Icons\\spell_shadow_seedofdestruction.png', 'Enable AOE', "Enables the AOE rotation within the combat rotation.")	
	ProbablyEngine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_aff_config) end))
	
	-- Force open/close to save default settings
	miLib.displayFrame(mirakuru_aff_config)
	miLib.displayFrame(mirakuru_aff_config)
end

-- Combat Rotation
local combatRotation = {
	-- Auto target enemy when Enabled
	{{
		{"/targetenemy [noexists]", "!target.exists"},
		{"/targetenemy [dead]", {"target.exists", "target.dead"}}
	}, (function() return fetch('miraAffConfig', 'auto_target') end)},
	
	-- Healing Tonic / Healthstone
	{{
		{{
			{"#5512"},
			{"#109223"}
		}, "player.glyph(56224)"},
		{{
			{"#109223"},
			{"#5512"}
			
		}, "!player.glyph(56224)"}
	}, {
		(function() return fetch('miraAffConfig', 'hs_pot_healing_check') end),
		(function() return dynamicEval('player.health <= '..fetch('miraAffConfig', 'hs_pot_healing_spin')) end)
	}},
	
	-- Dark Intent
	{"!109773", "!player.buffs.multistrike"},
	{"!109773", "!player.buffs.spellpower"},
	
	-- Burning Rush
	{{
		{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
		}}
	}, (function() return fetch('miraAffConfig', 'burning_rush_check') end)},
	
	-- Summon Pet
	{{
		{{	-- Summon pet using instant abilities
			{"!74434", {
				"!pet.alive",
				"!pet.exists",
				"!player.dead",
				"!player.buff(74434)",
				"player.soulshards > 0",
				"player.spell(688).cooldown = 0",
				(function() return fetch('miraAffConfig', 'auto_summon_pet_instant') end)
			}},
			{"/run aff_pet()", {
				"!pet.alive",
				"!pet.exists",
				"!player.dead",
				"player.buff(74434)",
				"!player.buff(108503)",
				"timeout(petCombat, 3)",
				"player.spell(688).cooldown = 0"
			}}
		}, (function() return fetch('miraAffConfig', 'auto_summon_pet_instant') end)},
		
		-- Summon pet without instant abilities
		{"/run aff_pet()", {
			"!pet.alive",
			"!pet.exists",
			"!player.dead",
			"!player.moving",
			"!player.buff(74434)",
			"!player.buff(108503)",
			"timeout(petCombat, 3)",
			"player.spell(688).cooldown = 0"
		}}
	}, (function() return fetch('miraAffConfig', 'auto_summon_pet') end)},
	
	-- Cooldown Management --
	{{
		{"#trinket1"},
		{"#trinket2"},
		{"!26297", "player.spell(26297).cooldown = 0"},
		{"!33702", "player.spell(33702).cooldown = 0"},
		{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
		{"!18540", {"!talent(7, 3)", "player.spell(18540).cooldown = 0"}},
		{"!112927", {"!talent(7, 3)", "talent(5, 1)", "player.spell(112927).cooldown = 0"}},
		{{
			{"!113860", "player.spell(113860).charges = 2"},
			{"!113860", "int.procs > 0"},
			{"!113860", "target.health <= 10"}
		}, {"talent(6, 1)", "player.spell(113860).charges > 0"}},
		{"!113860", "!talent(6, 1)", "player.spell(113860).cooldown = 0"},
		{"!/run service_pet()", {"talent(5, 2)", "player.spell(111859).cooldown = 0"}}
	}, {
		"modifier.cooldowns",
		(function()
			if fetch('miraAffConfig', 'cd_bosses_only') then
				if ProbablyEngine.condition["boss"]("target") then return true else return false end
			else return true end
		end)
	}},
	
	-- Command Demon --
	{{
		{"/petattack", {"timeout(petAttack, 1)", "pet.exists", "pet.alive"}},
		{"119913", "player.pet(115770).spell", "target.ground"},
		{"119909", "player.pet(6360).spell", "target.ground"},
		{"119911", {"player.pet(115781).spell"}},
		{"119910", {"player.pet(19467).spell"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119905", {"player.pet(115276).spell", "player.health < 80"}},
		{"119905", {"player.pet(89808).spell", "player.health < 80"}}
	}, {(function() return fetch('miraAffConfig', 'command_demon') end), "pet.exists", "pet.alive"}},
	
	-- Talents --
	{{
		{"!108359", {
			"talent(1, 1)",
			(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'darkregen_hp_spin')) end),
			"player.spell(108359).cooldown = 0",
			(function() return (UnitGetIncomingHeals("player") >= fetch('miraAffConfig', 'darkregen_healing') and true or false) end)
		}}
	}, (function() return fetch('miraAffConfig', 'darkregen_hp_check') end)},
	{{
		{"6789", {
			"talent(2, 2)",
			(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'mortal_coil_spin')) end),
			"player.spell(6789).cooldown = 0"
		}}
	}, (function() return fetch('miraAffConfig', 'mortal_coil_check') end)},
	{"!30283", {"talent(2, 3)", "modifier.ralt", "player.spell(30283).cooldown = 0"}, "ground" },
	{"!111400", {
		"talent(4, 2)", "player.moving", "!player.buff(111400)",
		(function() return fetch('miraAffConfig', 'burning_rush_check') end),
		(function() return dynamicEval("player.health > " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
	}},
	{"!108503", {
		"talent(5, 3)",
		"!player.buff(108503)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive"
	}},
	{"!137587", {"talent(6, 2)", "player.moving", "player.spell(137587).cooldown = 0"}},
	{"!152108", {
		"talent(7, 2)",
		"!player.casting(152108)",
		"player.spell(152108).cooldown = 0",
		(function() return fetch('miraAffConfig', 'cata_st') end)
	}, "target.ground"},
	
	-- AOE Rotation --
	{{
		{"!108508", {"talent(6, 3)", "player.spell(108508).cooldown = 0"}},
		{"152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
		{"!74434", {
			"!talent(7, 1)",
			"!player.buff(74434)",
			"!target.debuff(27243)",
			"player.soulshards > 2",
			"!target.debuff(114790)"
		}},
		{"!114790", {
			"!talent(7, 1)",
			"!player.moving",
			"player.buff(74434)",
			"!target.debuff(27243)",
			"!target.debuff(114790)",
			"!modifier.last(114790)"
		}},
		{"!27243", {"!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving"}},
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"}
	}, {
		"toggle.aoe",
		(function()
			if FireHack then
				if dynamicEval("target.area(10).enemies >= "..fetch('miraAffConfig', 'aoe_units')) then return true else return false end
			else
				if ProbablyEngine.condition["modifier.control"]() then return true else return false end
			end
		end)
	}},
	
	-- Mouseover multidotting --
	{{
		{"!980", {"mouseover.debuff(980).duration < 6", "!player.casting(48181)"}, "mouseover"},
		{"!30108", {"mouseover.debuff(30108).duration < 6", "!player.casting(48181)", "!player.moving", "!modifier.last(30108)"}, "mouseover"},
		{"!172", {"mouseover.debuff(146739).duration < 6", "!player.casting(48181)"}, "mouseover"}
	}, {"modifier.multitarget", "!player.target(mouseover)", "mouseover.enemy(player)"}},
	
	-- Single Target Rotation --
	{{
		{{
			{{
				{"!48181", "aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"}
			}, {"target.debuff(48181).duration <= 5", "!modifier.last(48181)"}},
			{{
				{"!48181", "aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"}
			}, {"player.soulshards = 4", "!modifier.last(48181)", "!player.casting(152108)"}}
		}, {
			"!talent(7, 1)", "!player.moving", "player.soulshards > 0", "!modifier.last(48181)",
			(function()
				if fetch('miraAffConfig', 'haunt_boss') then return dynamicEval("target.boss") end
				if not fetch('miraAffConfig', 'haunt_boss') then return true end
			end)
		}},
		
		{{
			{"!74434", "!player.buff(157698)"},
			{"!74434", "player.soulshards = 4"},
			{"!74434", "player.buff(157698).duration < 5"}
		}, {
			"talent(7, 1)", "!player.buff(74434)", "!player.moving", "player.soulshards >= 2",
			(function()
				if fetch('miraAffConfig', 'haunt_boss') then return dynamicEval("target.boss") end
				if not fetch('miraAffConfig', 'haunt_boss') then return true end
			end)
		}},
		
		{{
			{"!48181", {"player.buff(74434)", "player.buff(157698).duration < 6"}},
			{"!48181", "player.soulshards = 4"}
		}, {
			"talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving",
			(function()
				if fetch('miraAffConfig', 'haunt_boss') then return dynamicEval("target.boss") end
				if not fetch('miraAffConfig', 'haunt_boss') then return true end
			end)
		}},
		
		{"!980", {"talent(7, 2)", "player.spell(152108).cooldown > 20", "target.debuff(980).duration < 6"}},
		{"!980", {"!talent(7, 2)", "target.debuff(980).duration < 6"}},
		{"30108", {"target.debuff(30108).duration < 6", "!player.moving", "!modifier.last(30108)"}},
		{"!172", "target.debuff(146739).duration < 6"},
		{"1454", "player.mana < 40"},
		
		{{
			{"!980", "@miLib.manager(980)"},
			{"!172", "@miLib.manager(172)"},
			{"!30108", "@miLib.manager(30108)"}
		}, "modifier.multitarget"},
		
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"}
	}, {
		(function()
			if FireHack then
				if ProbablyEngine.config.read('button_states', 'aoe', false) then
					if dynamicEval("target.area(10).enemies >= "..fetch('miraAffConfig', 'aoe_units')) then return false else return true end
				else return true end
			else
				if ProbablyEngine.condition["modifier.control"]() then return false else return true end
			end
		end)
	}}
}

-- Out of combat
local beforeCombat = {
	-- Buffs
	{"109773", "!player.buffs.multistrike"},
	{"109773", "!player.buffs.spellpower"},
	
	-- Summon Pet
	{"/run aff_pet()", {
		"!pet.exists", "!pet.alive", "!player.moving", "!player.buff(108503)", "timeout(affPet, 3)", "!player.dead",
		(function() return fetch('miraAffConfig', 'auto_summon_pet') end)
	}},
	
	-- Talents --
	{{
		{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraAffConfig', 'burning_rush_spin')) end)
		}}
	}, (function() return fetch('miraAffConfig', 'burning_rush_check') end)},
	{"108503", {
		"talent(5, 3)",
		"!player.buff(108503)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive"
	}},
	{"!30283", {
		"talent(2, 3)",
		"modifier.ralt",
		"player.spell(30283).cooldown = 0"
	}, "mouseover.ground"},
	
	{{	-- Attack anything when Enabled
		{"/cast "..GetSpellInfo(172), "target.alive"}
	}, (function() return fetch('miraAffConfig', 'force_attack') end)}
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(265, "[|cff005522Mirakuru Rotations|r] Affliction Warlock", combatRotation, beforeCombat, btn)