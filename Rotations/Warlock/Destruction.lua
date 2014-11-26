--[[
	Destruction Warlock - Custom ProbablyEngine Rotation Profile
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
function destru_pet()
	local pet = tonumber(fetch('miraDestruConfig', 'summon_pet'))
	local spellName = GetSpellName(pet)
	
	if UnitCastingInfo("player") == GetSpellInfo(pet) then return false end
	
	if ProbablyEngine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
	
	if pet == 157757 or pet == 157898 then
		if ProbablyEngine.dsl.parse("talent(7, 3)") then CastSpellByName(spellName)
		else return false end
	else CastSpellByID(pet) end
end
function destru_service_pet()
	local pet = tonumber(fetch('miraDestruConfig', 'service_pet'))
	local spellName = GetSpellName(pet)
	
	if ProbablyEngine.dsl.parse("player.spell("..pet..").cooldown > 0") then return false end
	if ProbablyEngine.dsl.parse("talent(5, 2)") then CastSpellByName(spellName) end
end

-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('aoe', 'Interface\\Icons\\ability_warlock_fireandbrimstone.png', 'Enable AOE', "Enables the AOE rotation within the combat rotation.")	
	ProbablyEngine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_destru_config) end))
	
	-- Force open/close to save default settings
	miLib.displayFrame(mirakuru_destru_config)
	miLib.displayFrame(mirakuru_destru_config)
end


-- Combat Rotation
local combatRotation = {
	{{	-- Auto target enemy when Enabled
		{"/targetenemy [noexists]", "!target.exists"},
		{"/targetenemy [dead]", {"target.exists", "target.dead"}}
	}, (function() return fetch('miraDestruConfig', 'auto_target') end)},
	
	
	{{	-- Healing Tonic / Healthstone
		{{
			{"#5512"},
			{"#109223"}
		}, "player.glyph(56224)"},
		{{
			{"#109223"},
			{"#5512"}
			
		}, "!player.glyph(56224)"}
	}, {
		(function() return fetch('miraDestruConfig', 'hs_pot_healing_check') end),
		(function() return dynamicEval('player.health <= '..fetch('miraDestruConfig', 'hs_pot_healing_spin')) end)
	}},
	
	
	-- Buffs --
	{"!109773", "!player.buffs.multistrike"},
	{"!109773", "!player.buffs.spellpower"},	
	{{	-- Burning Rush
		{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
		}}
	}, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},
	
	
	{{	-- Summon Pet
		{"!120451", {
			"!pet.alive",
			"!pet.exists",
			"player.embers > 10",
			"!player.buff(108503)",
			"player.spell(120451).cooldown = 0",
			(function() return fetch('miraDestruConfig', 'auto_summon_pet_instant') end)
		}},
		
		{"/run destru_pet()", {
			"!pet.alive",
			"!pet.exists",
			"!player.dead",
			"!player.moving",
			"!player.buff(108503)",
			"timeout(petCombat, 3)",
			(function() return fetch('miraDestruConfig', 'auto_summon_pet') end)
		}}
	}},
	
	
	{{	-- Cooldown Management --
		{{	-- Boss Only
			-- Trinkets
			{"#trinket1"},
			{"#trinket2"},
			
			-- Racials
			{"!26297", "player.spell(26297).cooldown = 0"},
			{"!33702", "player.spell(33702).cooldown = 0"},
			{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
			
			-- Doomguard / Terrorguard
			{"!18540", {"!talent(7, 3)", "player.spell(18540).cooldown = 0"}},
			{"!112927", {"!talent(7, 3)", "talent(5, 1)", "player.spell(112927).cooldown = 0"}},
			
			{{	-- Dark Soul: Archimonde's Darkness
				{"!113858", "player.spell(113858).charges = 2"},
				{"!113858", "player.int.procs > 0"},
				{"!113858", "target.health <= 10"}
			}, {
				"talent(6, 1)", "player.spell(113858).charges > 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
			
			-- Dark Soul
			{"!113858", {
				"!talent(6, 1)", "player.spell(113858).cooldown = 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
			
			-- Grimoire of Service
			{"/run destru_service_pet()", "talent(5, 2)"}
		}, {(function() return fetch('miraDestruConfig', 'cd_bosses_only') end), "target.boss"}},
		
		{{	-- Any target
			-- Trinkets
			{"#trinket1"},
			{"#trinket2"},
			
			-- Racials
			{"!26297", "player.spell(26297).cooldown = 0"},
			{"!33702", "player.spell(33702).cooldown = 0"},
			{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
			
			-- Doomguard / Terrorguard
			{"!18540", {"!talent(7, 3)", "player.spell(18540).cooldown = 0"}},
			{"!112927", {"!talent(7, 3)", "talent(5, 1)", "player.spell(112927).cooldown = 0"}},
			
			{{	-- Dark Soul: Archimonde's Darkness
				{"!113858", "player.spell(113858).charges = 2"},
				{"!113858", "player.int.procs > 0"},
				{"!113858", "target.health <= 10"}
			}, {
				"talent(6, 1)", "player.spell(113858).charges > 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
			
			-- Dark Soul
			{"!113858", {
				"!talent(6, 1)", "player.spell(113858).cooldown = 0",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_darksoul')) end)
			}},
			
			-- Grimoire of Service
			{"/run destru_service_pet()", "talent(5, 2)"}
		}, (function() return (not fetch('miraDestruConfig', 'cd_bosses_only') and true or false) end)}
	}, "modifier.cooldowns"},
	
	
	{{	-- Command Demon --
		{"/petattack", {"timeout(petAttack, 1)", "pet.exists", "pet.alive"}},
		{"119913", "player.pet(115770).spell", "target.ground"},
		{"119909", "player.pet(6360).spell", "target.ground"},
		{"119911", {"player.pet(115781).spell"}},
		{"119910", {"player.pet(19467).spell"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119905", {"player.pet(115276).spell", "player.health < 80"}},
		{"119905", {"player.pet(89808).spell", "player.health < 80"}}
	}, {(function() return fetch('miraDestruConfig', 'command_demon') end), "pet.exists", "pet.alive"}},
	
	
	-- Talents --
	{{
		{"!108359", {	-- Dark Regeneration
			"talent(1, 1)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'darkregen_hp_spin')) end),
			"player.spell(108359).cooldown = 0",
			(function() return (UnitGetIncomingHeals("player") >= fetch('miraDestruConfig', 'darkregen_healing') and true or false) end)
		}}
	}, (function() return fetch('miraDestruConfig', 'darkregen_hp_check') end)},
	{{
		{"6789", {		-- Mortal Coil
			"talent(2, 2)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'mortal_coil_spin')) end),
			"player.spell(6789).cooldown = 0"
		}}
	}, (function() return fetch('miraDestruConfig', 'mortal_coil_check') end)},
	{"!30283", {"talent(2, 3)", "modifier.ralt", "player.spell(30283).cooldown = 0"}, "ground"},
	{"!111400", {
		"talent(4, 2)", "player.moving", "!player.buff(111400)",
		(function() return fetch('miraDestruConfig', 'burning_rush_check') end),
		(function() return dynamicEval("player.health > " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
	}},
	{"!108503", {	-- Grimoire of Sacrifice
		"talent(5, 3)",
		"!player.buff(108503)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive"
	}},
	{"!137587", {"talent(6, 2)", "player.moving", "player.spell(137587).cooldown = 0"}},
	
	
	-- Rain of Fire hotkey --
	{"104232", "modifier.lalt", "mouseover.ground"},
	
	
	-- AoE Rotation --
	{{
		{{	-- Firehack support
			{"152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
			{"108683", "!player.buff(108683)"},
			{"108686", {"!target.debuff(157736)", "!player.moving"}},
			{"157701", {
				"talent(7, 1)",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'cb_fnb_embers')) end)
			}},
			{"108685", "player.spell(108685).charges > 0"},
			{"114654", "!player.moving"}
		}, {
			"player.firehack",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) end),
			(function() return dynamicEval("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) end)
		}},
		
		{{	-- Non-Firehack Support
			{"152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
			{"108683", "!player.buff(108683)"},
			{"108686", {"!target.debuff(157736)", "!player.moving"}},
			{"157701", {
				"talent(7, 1)",
				(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'cb_fnb_embers')) end)
			}},
			{"108685", "player.spell(108685).charges > 0"},
			{"114654", "!player.moving"}
		}, {"!player.firehack", "modifier.control",
			(function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) end)
		}}
	}, "toggle.aoe"},
	
	
	-- Single Target Rotation --
	{{	-- Firehack Support
		{"/cancelaura "..GetSpellInfo(108683), "player.buff(108683)"},
		
		{{	-- Havoc
			{"80240", "@miLib.havoc()"}
		}, "modifier.multitarget"},
		
		{{	-- Shadowburn
			{"!17877", "player.embers >= 25"},
			{"!17877", "player.buff(113858).duration >= 1"},
			{"!17877", "target.ttd < 10"}
		}, "target.health <= 20"},
		
		{{	-- Immolate
			{{
				{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 6"}},
				{"348", "!talent(7, 2)"}
			}, {"target.debuff(157736).duration < 1.5", "!player.buff(113858)"}},
			{"348", {"!talent(7, 2)", "!target.debuff(157736)"}},
			{"348", {"talent(7, 2)", "!target.debuff(157736)", "player.spell(152108).cooldown > 6"}}
		}, {"!player.moving", "!modifier.last(348)",
			(function()
				if dynamicEval("player.buff(80240).count >= 3") then
					if dynamicEval("player.embers >= 10") then return false else return true end
				else return true end
			end)
		}},
		
		-- Oops, close on capping embers
		{"116858", {"player.time < 5", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)}},
		
		{{	-- Prioritize cleaving with Havoc
			{"!17877", {"target.health <= 20", "player.buff(80240)"}},
			{"!116858", {
				"target.health > 20", "!player.moving", "!player.casting(116858)", "player.buff(80240).count >= 3",
				(function() return dynamicEval("player.buff(80240).duration >= "..miLib.round((2.5 / ((GetHaste("player") / 100)  + 1)),2)) end)
			}}
		}, "player.embers >= 10"},
		
		-- Cataclysm of fucks given
		{"152108", {"talent(7, 2)", (function() return fetch('miraDestruConfig', 'cata_st') end), "player.spell(152108).cooldown = 0"}, "target.ground"},
		
		{{	-- Interrupt regular profile behavior if we can cleave with Havoc
			{"17962", {"player.spell(17962).charges = 2", "target.debuff(157736)"}},
			
			{{	-- They didn't remove Chaos Bolt yet?
				{"116858", "player.int.procs > 0"},
				{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
				{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..miLib.round((2.5 / ((GetHaste("player") / 100)  + 1)),2)) end)},
				{"116858", {"target.ttd >= 4", "target.ttd < 20"}}
			}, {"player.buff(117828).count < 3", "player.embers >= 10", "!player.moving", "!player.casting(116858)"}},
			
			{"348", {"target.debuff(157736).duration < 4.5", "!player.moving", "!modifier.last(348)", "!player.buff(113858)"}},
			{"17962", "player.spell(17962).charges > 0"},
			
			{{	-- Immolate Multitarget
				{"348", "@miLib.immolate()"}
			}, "modifier.multitarget"},
			
			{"29722", "!player.moving"}
		}, {
			(function()
				if dynamicEval("player.buff(80240).count >= 3") then
					if dynamicEval("player.embers >= 10") then return false else return true end
				else return true end
			end)
		}}
	}, {"player.firehack",
		(function()
			local aoe = ProbablyEngine.config.read("button_states").aoe
			if aoe then
				if dynamicEval("target.area(10).enemies >= "..fetch('miraDestruConfig', 'aoe_units')) then
					if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then return false else return true end
				else return true end
			else return true end
		end)
	}},

	{{	-- Non-Firehack Support
		{"/cancelaura "..GetSpellInfo(108683), "player.buff(108683)"},
		
		{{	-- Shadowburn
			{"!17877", "player.embers >= 25"},
			{"!17877", "player.buff(113858).duration >= 1"},
			{"!17877", "target.ttd < 10"}
		}, "target.health <= 20"},
		
		{{	-- Immolate
			{{
				{"348", {"talent(7, 2)", "player.spell(152108).cooldown > 6"}},
				{"348", "!talent(7, 2)"}
			}, {"target.debuff(157736).duration < 1.5", "!player.buff(113858)"}},
			{"348", {"!talent(7, 2)", "!target.debuff(157736)"}},
			{"348", {"talent(7, 2)", "!target.debuff(157736)", "player.spell(152108).cooldown > 6"}}
		}, {"!player.moving", "!modifier.last(348)",
			(function()
				if dynamicEval("player.buff(80240).count >= 3") then
					if dynamicEval("player.embers >= 10") then return false else return true end
				else return true end
			end)
		}},
		
		-- Oops, close on capping embers
		{"116858", {"player.time < 5", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)}},
		
		{{	-- Prioritize cleaving with Havoc
			{"!17877", {"target.health <= 20", "player.buff(80240)"}},
			{"!116858", {
				"target.health > 20", "!player.moving", "!player.casting(116858)", "player.buff(80240).count >= 3",
				(function() return dynamicEval("player.buff(80240).duration >= "..miLib.round((2.5 / ((GetHaste("player") / 100)  + 1)),2)) end)
			}}
		}, "player.embers >= 10"},
		
		-- Cataclysm of fucks given
		{"152108", {"talent(7, 2)", (function() return fetch('miraDestruConfig', 'cata_st') end), "player.spell(152108).cooldown = 0"}, "target.ground"},
		
		{{	-- Interrupt regular profile behavior if we can cleave with Havoc
			{"17962", {"player.spell(17962).charges = 2", "target.debuff(157736)"}},
			
			{{	-- They didn't remove Chaos Bolt yet?
				{"116858", "player.int.procs > 0"},
				{"116858", (function() return dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_cb_max')) end)},
				{"116858", (function() return dynamicEval("player.buff(113858).duration >= "..miLib.round((2.5 / ((GetHaste("player") / 100)  + 1)),2)) end)},
				{"116858", {"target.ttd >= 4", "target.ttd < 20"}}
			}, {"player.buff(117828).count < 3", "player.embers >= 10", "!player.moving", "!player.casting(116858)"}},
			
			{"348", {"target.debuff(157736).duration < 4.5", "!player.moving", "!modifier.last(348)", "!player.buff(113858)"}},
			{"17962", "player.spell(17962).charges > 0"},
			{"29722", "!player.moving"}
		}, {
			(function()
				if dynamicEval("player.buff(80240).count >= 3") then
					if dynamicEval("player.embers >= 10") then return false else return true end
				else return true end
			end)
		}}
	}, {"!player.firehack",
		(function()
			local aoe = ProbablyEngine.config.read("button_states").aoe
			if aoe then
				if dynamicEval("modifier.control") then
					if dynamicEval("player.embers >= "..fetch('miraDestruConfig', 'embers_fnb')) then return false else return true end
				else return true end
			else return true end
		end)
	}}
}

-- Out of combat
local beforeCombat = {
	-- Buffs
	{"109773", "!player.buffs.multistrike"},
	{"109773", "!player.buffs.spellpower"},
	
	-- Summon Pet --
	{"/run destru_pet()", {
		"!pet.exists", "!pet.alive", "!player.moving", "!player.buff(108503)", "timeout(petOOC, 3)", "!player.dead",
		(function() return fetch('miraDestruConfig', 'auto_summon_pet') end)
	}},
	
	-- Talents --
	{{
		{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
		{"/cancelaura "..GetSpellInfo(111400), {
			"player.buff(111400)",
			(function() return dynamicEval("player.health <= " .. fetch('miraDestruConfig', 'burning_rush_spin')) end)
		}}
	}, (function() return fetch('miraDestruConfig', 'burning_rush_check') end)},
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
		{"/cast "..GetSpellInfo(29722), "target.alive"}
	}, (function() return fetch('miraDestruConfig', 'force_attack') end)}
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(267, "[|cff005522Mirakuru Rotations|r] Destruction Warlock", combatRotation, beforeCombat, btn)