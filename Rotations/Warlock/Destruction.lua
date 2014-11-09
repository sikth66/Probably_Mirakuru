--[[
	Destruction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]
-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('autopet', 'Interface\\Icons\\ability_warlock_demonicempowerment.png', 'Command Demon', "Enable automatic usage of summoned pet's Special Ability.")
	ProbablyEngine.toggle.create('bossOnly', 'Interface\\Icons\\spell_holy_sealofvengeance.png', 'Cooldowns: Boss', "Toggle the exclusive usage of cooldowns on Boss units.")
	ProbablyEngine.toggle.create('stCataclysm', 'Interface\\Icons\\achievement_zone_cataclysm.png', 'Single-target Cataclysm', "Toggle the use of Cataclysm in single-target rotation.")
	
	-- GUI
	local test = ProbablyEngine.interface.fetchKey('miraDestruConfig', 'aoe_units_check')
	if test ~= nil then return else
		miLib.displayFrame(mirakuru_destru_config)
	end
end

-- Dynamically evaluate settings
local fetch = ProbablyEngine.interface.fetchKey

local function dynamicEval(condition, spell)
	if not condition then return false end
	return ProbablyEngine.dsl.parse(condition, spell or '')
end

-- Pet Selections
function setPet()
	local pet = fetch('miraAffConfig', 'summon_pet')
	if pet ~= nil then return pet end
end

function servicePet()
	local pet = fetch('miraAffConfig', 'service_pet')
	if pet ~= nil then return pet end
end

-- Combat Rotation
local combatRotation = {
	-- Auto target enemy when Enabled
	{{
		{"/targetenemy [noexists]", "!target.exists"},
		{"/targetenemy [dead]", {"target.exists", "target.dead"}},
	}, (function() return fetch('miraDestruConfig', 'auto_target') end)},
	
	
	-- Buffs --
	{"!109773", "!player.buffs.multistrike"},
	{"!109773", "!player.buffs.spellpower"},
	{{
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end),
		}},
	}, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},
	{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
	
	
	-- Summon Pet
	{{
		-- Summon pet using instant abilities
		{"120451", {
			"!pet.alive",
			"!pet.exists",
			"player.embers > 10",
			"!player.buff(108503)",
			"player.spell(120451).cooldown = 0",
			(function() return fetch('miraDestruConfig', 'auto_summon_pet_instant') end),
		}},
		
		-- Summon pet without instant abilities
		{"/run CastSpellByID(setPet())", {
			"!pet.alive",
			"!pet.exists",
			"!player.buff(108503)",
			"timeout(petCombat, 3)",
			"!modifier.last(120451)",
			"player.spell(120451).cooldown > 0",
			(function() return fetch('miraDestruConfig', 'auto_summon_pet') end),
			(function() return dynamicEval("player.spell("..setPet()..").cooldown = 0") end),
		}},
	}},
	
	
	-- Cooldown Management --
	{{
		{{	-- Boss Only
			-- Grimoire of Service
			{"!/run CastSpellByID(servicePet())", {
				"talent(5, 2)",
				(function() return dynamicEval("player.spell("..servicePet()..").cooldown = 0") end),
			}},
			
			-- Trinkets
			{"!#trinket1" },
			{"!#trinket2" },
			
			-- Racials
			{"!26297", "player.spell(26297).cooldown = 0" },
			{"!33702", "player.spell(33702).cooldown = 0" },
			{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
			
			{"!18540", {	-- Doomguard
				"!talent(7, 3)",
				"player.spell(18540).cooldown = 0",
			}},
			{"!112927", {	-- Terrorguard
				"!talent(7, 3)",
				"talent(5, 1)",
				"player.spell(112927).cooldown = 0",
			}},
			
			-- Archimonde's Darkness
			{{
				{"!113858", "player.spell(113858).charges = 2"},
				{"!113858", "player.int.procs > 0"},
				{"!113858", "target.health <= 10"},
			}, {"talent(6, 1)", "player.spell(113858).charges > 0"}},
			
			-- Dark Soul
			{"!113858", "!talent(6, 1)", "player.spell(113858).cooldown = 0"},
		}, {"toggle.bossOnly", "target.boss"}},
		{{	-- Any target
			-- Grimoire of Service
			{"!111897", {"talent(5, 2)", "player.spell(111897).cooldown = 0"}},
			
			-- Trinkets
			{"!#trinket1" },
			{"!#trinket2" },
			
			-- Racials
			{"!26297", "player.spell(26297).cooldown = 0" },
			{"!33702", "player.spell(33702).cooldown = 0" },
			{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
			
			{"!18540", {	-- Doomguard
				"!talent(7, 3)",
				"player.spell(18540).cooldown = 0",
			}},
			{"!112927", {	-- Terrorguard
				"!talent(7, 3)",
				"talent(5, 1)",
				"player.spell(112927).cooldown = 0",
			}},
			
			-- Archimonde's Darkness
			{{
				{"!113858", "player.spell(113858).charges = 2"},
				{"!113858", "player.int.procs > 0"},
				{"!113858", "target.health <= 10"},
			}, {
				"talent(6, 1)",
				"player.spell(113858).charges > 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
			
			-- Dark Soul
			{"!113858", {
				"!talent(6, 1)",
				"player.spell(113858).cooldown = 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
		}, "!toggle.bossOnly"},
	},"modifier.cooldowns"},
	
	
	-- Talents --
	{{
		{"!108359", {	-- Dark Regeneration
			"talent(1, 1)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'darkregen_hp_spin')) end),
			"player.spell(108359).cooldown = 0",
			(function() return (UnitGetIncomingHeals("player") < fetch('miraDestruConfig', 'darkregen_healing') and false or true) end),
		}},
	}, (function() return fetch('miraDestruConfig', 'darkregen_hp_check') end)},
	{{
		{"6789", {		-- Mortal Coil
			"talent(2, 2)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'mortal_coil_spin')) end),
			"player.spell(6789).cooldown = 0",
		}},
	}, (function() return fetch('miraDestruConfig', 'mortal_coil_check') end)},
	{"!30283", {	-- Shadowfury
		"talent(2, 3)",
		"modifier.ralt",
		"player.spell(30283).cooldown = 0",
	}, "ground" },
	{"!111400", {	-- Burning Rush
		"talent(4, 2)",
		"player.moving",
		"player.health > 70",
		"!player.buff(111400)",
	}},
	{"!108503", {	-- Grimoire of Sacrifice
		"talent(5, 3)",
		"!player.buff(108503)",
		"!talent(7, 3)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive",
	}},
	{"!137587", {	-- Kil'jaeden's Cunning
		"talent(6, 2)",
		"player.moving",
		"player.spell(137587).cooldown = 0",
	}},
	
	
	-- Command Demon
	{"/petattack", {"timeout(petAttack, 1)", "pet.exists", "pet.alive"}},
	{{
		{"119913", "player.pet(115770).spell", "target.ground"},
		{"119909", "player.pet(6360).spell", "target.ground"},
		{"119911", {"player.pet(115781).spell"}},
		{"119910", {"player.pet(19467).spell"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119905", {"player.pet(115276).spell", "player.health < 80"}},
		{"119905", {"player.pet(89808).spell", "player.health < 80"}},
	}, {"toggle.autopet", "pet.exists", "pet.alive"}},
	
	
	-- AoE Rotation --
	{{
		{{	-- Firehack support
			{"104232", "!player.buff(104232)", "target.ground"},
			{"104232", "player.buff(104232).duration <= 2", "target.ground"},
			{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
			{"108683", "!player.buff(108683)"},
			{"108686", {"!target.debuff(157736)", "!player.moving"}},
			{"108685", "player.spell(108685).charges = 2"},
			{"108686", {"target.debuff(157736).duration < 6", "!player.moving"}},
			{"157701", {
				"talent(7, 1)",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'cb_fnb_embers')) end)
			}},
			{"114654", "!player.moving"},
		}, {
			"player.firehack",
			(function() return fetch('miraDestruConfig', 'aoe_units_check') end),
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) end),
			(function() return dynamicEval("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units_spin')) end),
		}},
		
		{{	-- Non-Firehack Support
			{"104232", "!player.buff(104232)", "target.ground"},
			{"104232", "player.buff(104232).duration <= 2", "target.ground"},
			{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
			{"108683", "!player.buff(108683)"},
			{"108686", {"!target.debuff(157736)", "!player.moving"}},
			{"108685", "player.spell(108685).charges = 2"},
			{"108686", {"target.debuff(157736).duration < 6", "!player.moving"}},
			{"157701", {
				"talent(7, 1)",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'cb_fnb_embers')) end)
			}},
			{"114654", "!player.moving"},
		}, {"!player.firehack", "modifier.control"}}
	}, "modifier.multitarget"},
	
	
	-- Single-target
	{"/cancelaura "..GetSpellInfo(108683), "player.buff(108683)"},
	
	{{
		{{	-- Shadowburn
			{"!17877", "player.buff(80240)"},
			{"!17877", "player.embers >= 25"},
			{"!17877", "player.buff(113858)"},
			{"!17877", "target.ttd < 15"},
		}, {"talent(7, 1)", "target.health <= 20", "player.embers >= 10"}},
		
		{{
			{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 2"}},
			{"348", "!talent(7, 2)"},
		}, {"target.debuff(157736).duration < 1.5", "!player.moving", "!modifier.last(384)"}},
		
		{"104232", "!player.buff(104232)", "target.ground"},
		{"116858", {"player.buff(80240).duration > 2.5", "player.buff(80240).count >= 3"}},
		{"17962", "player.spell(17962).charges = 2"},
		{"!152108", {"talent(7, 2)", "toggle.stCataclysm", "player.spell(152108).cooldown = 0"}, "target.ground"},
		
		{{	-- Chaos Bolt (Charred Remains)
			{"116858"},
			{"116858", "player.buff(117828).count < 3"},
		}, {
			"talent(7, 1)",
			"target.health > 20",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"116858", {"player.int.procs > 0", "player.embers >= 10"}},
		
		{{	-- Chaos Bolt (Non-Charred Remains)
			{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
			{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..(3 / ((GetHaste("player") / 100)  + 1))) end)},
			{"116858", "target.ttd < 20"},
			{"116858", {"player.buff(165455)", "player.embers >= 25"}},
		}, {
			"target.health > 20",
			"player.buff(117828).count < 3",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"348", {"target.debuff(157736).duration < 4", "!player.moving", "!modifier.last(384)"}},
		{"348", {"!target.debuff(157736)", "!player.moving", "!modifier.last(384)"}},
		{"17962", "player.spell(17962).charges > 0"},
		{"29722", "!player.moving"}
	}, {
		"player.firehack",
		(function() return fetch('miraDestruConfig', 'aoe_units_check') end),
		(function() return dynamicEval("target.area(10).enemies < "..fetch('miraDestruConfig', 'aoe_units_spin')) end),
		(function() return dynamicEval("player.embers < "..fetch('miraDestruConfig', 'embers_fnb')) end),
	}},
	
	{{
		{{	-- Shadowburn
			{"!17877", "player.buff(80240)"},
			{"!17877", "player.embers >= 25"},
			{"!17877", "player.buff(113858)"},
			{"!17877", "target.ttd < 15"},
		}, {"talent(7, 1)", "target.health <= 20", "player.embers >= 10"}},
		
		{{
			{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 2"}},
			{"348", "!talent(7, 2)"},
		}, {"target.debuff(157736).duration < 1.5", "!player.moving", "!modifier.last(384)"}},
		
		{"104232", "!player.buff(104232)", "target.ground"},
		{"116858", {"player.buff(80240).duration > 2.5", "player.buff(80240).count >= 3"}},
		{"17962", "player.spell(17962).charges = 2"},
		{"!152108", {"talent(7, 2)", "toggle.stCataclysm", "player.spell(152108).cooldown = 0"}, "target.ground"},
		
		{{	-- Chaos Bolt (Charred Remains)
			{"116858"},
			{"116858", "player.buff(117828).count < 3"},
		}, {
			"talent(7, 1)",
			"target.health > 20",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"116858", {"player.int.procs > 0", "player.embers >= 10"}},
		
		{{	-- Chaos Bolt (Non-Charred Remains)
			{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
			{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..(3 / ((GetHaste("player") / 100)  + 1))) end)},
			{"116858", "target.ttd < 20"},
			{"116858", {"player.buff(165455)", "player.embers >= 25"}},
		}, {
			"target.health > 20",
			"player.buff(117828).count < 3",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"348", {"target.debuff(157736).duration < 4", "!player.moving", "!modifier.last(384)"}},
		{"348", {"!target.debuff(157736)", "!player.moving", "!modifier.last(384)"}},
		{"17962", "player.spell(17962).charges > 0"},
		{"29722", "!player.moving"}
	}, {
		"player.firehack",
		(function() if fetch('miraDestruConfig', 'aoe_units_check') == false then return true end end),
	}},
	
	{{
		{{	-- Shadowburn
			{"!17877", "player.buff(80240)"},
			{"!17877", "player.embers >= 25"},
			{"!17877", "player.buff(113858)"},
			{"!17877", "target.ttd < 15"},
		}, {"talent(7, 1)", "target.health <= 20", "player.embers >= 10"}},
		
		{{
			{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 2"}},
			{"348", "!talent(7, 2)"},
		}, {"target.debuff(157736).duration < 1.5", "!player.moving", "!modifier.last(384)"}},
		
		{"104232", "!player.buff(104232)", "target.ground"},
		{"116858", {"player.buff(80240).duration > 2.5", "player.buff(80240).count >= 3"}},
		{"17962", "player.spell(17962).charges = 2"},
		{"!152108", {"talent(7, 2)", "toggle.stCataclysm", "player.spell(152108).cooldown = 0"}, "target.ground"},
		
		{{	-- Chaos Bolt (Charred Remains)
			{"116858"},
			{"116858", "player.buff(117828).count < 3"},
		}, {
			"talent(7, 1)",
			"target.health > 20",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"116858", {"player.int.procs > 0", "player.embers >= 10"}},
		
		{{	-- Chaos Bolt (Non-Charred Remains)
			{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
			{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..(3 / ((GetHaste("player") / 100)  + 1))) end)},
			{"116858", "target.ttd < 20"},
			{"116858", {"player.buff(165455)", "player.embers >= 25"}},
		}, {
			"target.health > 20",
			"player.buff(117828).count < 3",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb')) end)
		}},
		
		{"348", {"target.debuff(157736).duration < 4", "!player.moving", "!modifier.last(384)"}},
		{"348", {"!target.debuff(157736)", "!player.moving", "!modifier.last(384)"}},
		{"17962", "player.spell(17962).charges > 0"},
		{"29722", "!player.moving"}
	}, {"!player.firehack","!modifier.control"}}
}

-- Out of combat
local beforeCombat = {
	-- Buffs
	{"109773", "!player.buffs.multistrike"},
	{"109773", "!player.buffs.spellpower"},
	{{
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end),
		}},
	}, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},
	{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
	
	-- Talent: Grimoire of Sacrifice
	{"108503", {
		"talent(5, 3)",
		"!player.buff(108503)",
		"!talent(7, 3)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive",
	}},
	{"!30283", {	-- Shadowfury
		"talent(2, 3)",
		"modifier.ralt",
		"player.spell(30283).cooldown = 0",
	}, "mouseover.ground"},
	
	-- Summon Pet
	{"/run CastSpellByID(setPet())", {
		"!pet.exists", "!pet.alive", "!player.buff(108503)", "timeout(petOOC, 3)",
		(function() return fetch('miraDestruConfig', 'auto_summon_pet') end),
	}},
	
	-- Attack anything when Enabled
	{{
		{"/cast "..GetSpellInfo(29722), "target.alive"}
	}, (function() return fetch('miraDestruConfig', 'force_attack') end)}
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(267, "[|cff005522Mirakuru Rotations|r] Destruction", combatRotation, beforeCombat, btn)