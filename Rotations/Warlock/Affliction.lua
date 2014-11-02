--[[
	Affliction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('autopet', 'Interface\\Icons\\ability_warlock_demonicempowerment.png', 'Command Demon', "Enable automatic usage of summoned pet's Special Ability.")
	ProbablyEngine.toggle.create('bossOnly', 'Interface\\Icons\\spell_holy_sealofvengeance.png', 'Cooldowns: Boss', "Toggle the exclusive usage of cooldowns on Boss units.")
	ProbablyEngine.toggle.create('stCataclysm', 'Interface\\Icons\\achievement_zone_cataclysm.png', 'Single-target Cataclysm', "Toggle the use of Cataclysm in single-target rotation.")
end

-- Combat Rotation
local combatRotation = {
	-- Buffs --
	{"!109773", "!player.buffs.mastery"},
	{"!109773", "!player.buffs.spellpower"},
	{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
	
	-- Cooldown Management --
	{{
		{{	-- Boss Only
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
				{"!113860", "player.spell(113860).charges = 2"},
				{"!113860", "player.int.procs > 0"},
				{"!113860", "target.health <= 10"},
			}, {"talent(6, 1)", "player.spell(113860).charges > 0"}},
			
			-- Dark Soul
			{"!113860", "!talent(6, 1)", "player.spell(113860).cooldown = 0"},
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
				{"!113860", "player.spell(113860).charges = 2"},
				{"!113860", "player.int.procs > 0"},
				{"!113860", "target.health <= 10"},
			}, {"talent(6, 1)", "player.spell(113860).charges > 0"}},
			
			-- Dark Soul
			{"!113860", "!talent(6, 1)", "player.spell(113860).cooldown = 0"},
		}, "!toggle.bossOnly"},
	},"modifier.cooldowns"},
	
	-- Talents --
	{"!108359", {	-- Dark Regeneration
		"talent(1, 1)",
		"player.health < 40",
		"player.spell(108359).cooldown = 0",
		(function() return (UnitGetIncomingHeals("player") < 8000 and false or true) end),
	}},
	{"6789", {		-- Mortal Coil
		"talent(2, 2)",
		"player.health < 85",
		"player.spell(6789).cooldown = 0",
	}},
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
	{"!152108", {	-- Cataclysm
		"talent(7, 2)",
		"toggle.stCataclysm",
		"player.spell(152108).cooldown = 0"
	}, "target.ground"},
	
	-- Command Demon
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
	{{	-- Firehack Support
		{"!108508", {"talent(6, 3)", "player.spell(108508).cooldown = 0"}},
		{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
		{"!74434", {	-- Soulburn
			"!talent(7, 1)",
			"!player.buff(74434)",
			"!target.debuff(27243)",
			"player.soulshards > 2",
			"!target.debuff(114790)",
		}},
		{"!114790", {	-- Soulburn: Seed of Corruption
			"!talent(7, 1)",
			"!player.moving",
			"player.buff(74434)",
			"!target.debuff(27243)",
			"!target.debuff(114790)",
			"!modifier.last(114790)",
		}},
		{"!27243", { "!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving"}},
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"},
	}, {"player.firehack", "target.area(10).enemies >= 4", "modifier.multitarget"}},
	
	{{	-- Non-Firehack Support
		{"!108508", {"talent(6, 3)", "player.spell(108508).cooldown = 0"}},
		{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
		{"!74434", {	-- Soulburn
			"!talent(7, 1)",
			"!player.buff(74434)",
			"!target.debuff(27243)",
			"player.soulshards > 2",
			"!target.debuff(114790)",
		}},
		{"!114790", {	-- Soulburn: Seed of Corruption
			"!talent(7, 1)",
			"!player.moving",
			"player.buff(74434)",
			"!target.debuff(27243)",
			"!target.debuff(114790)",
			"!modifier.last(114790)",
		}},
		{"!27243", {"!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving"}},
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"},
	}, {"!player.firehack", "modifier.control", "modifier.multitarget"}},
	
	-- Multi-dotting --
	{{
		-- Agony
		{"!980", {"!mouseover.debuff(980)", "!player.casting(48181)"}, "mouseover"},
		{"!980", {"mouseover.debuff(980).duration < 6", "!player.casting(48181)"}, "mouseover"},
		-- Unstable Affliction
		{"!30108", {
			"!mouseover.debuff(30108)",
			"!player.casting(48181)",
			"!player.moving",
			"!modifier.last(30108)",
		}, "mouseover"},
		{"!30108", {
			"mouseover.debuff(30108).duration < 6",
			"!player.casting(48181)",
			"!player.moving",
			"!modifier.last(30108)",
		}, "mouseover"},
		-- Corruption
		{"!172", {"!mouseover.debuff(146739)", "!player.casting(48181)"}, "mouseover"},
		{"!172", {"mouseover.debuff(146739).duration < 6", "!player.casting(48181)"}, "mouseover"},
	}, "modifier.multitarget"},
	
	-- Regular Rotation --
	{{	-- Firehack Support
		{{	-- Attempt proper Haunt usage and shard pooling
			{{
				{"!48181", "player.aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"},
			}, "target.debuff(48181).duration < 4"},
			{{
				{"!48181", "player.aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"},
			}, "player.soulshards = 4"},
		}, {"!talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving", "!player.casting(30108)"}},
		
		{{	-- Proper Soulburn usage when talented Soulburn: Haunt
			{"!74434", "!player.buff(157698)"},
			{"!74434", { "player.soulshards = 4", "player.buff(157698).duration < 5"}},
		}, {"talent(7, 1)", "!player.buff(74434)", "!player.moving", "player.soulshards > 0"}},
		
		{{	-- Soulburn: Haunt (Talent)
			{"!48181", {"player.buff(74434)", "player.buff(157698).duration < 5"}},
			{"!48181", "player.soulshards = 4" },
		}, {"talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving"}},
		
		{{	-- Agony
			{"980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"target.debuff(980).duration < 6",
			}},
			{"980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"!target.debuff(980)",
			}},
			{"980", {"!talent(7, 2)", "target.debuff(980).duration < 6"}},
			{"980", {"!talent(7, 2)", "!target.debuff(980)"}},
		}, "target.health > 1 "},
		
		{{	-- Unstable Affliction
			{"30108", "target.debuff(30108).duration < 6"},
			{"30108", "!target.debuff(30108)"},
		}, {"!player.moving", "target.health > 1", "!modifier.last(30108)", "!player.casting(48181)"}},
		
		{{	-- Corruption
			{"172", "target.debuff(146739).duration < 6"},
			{"172", "!target.debuff(146739)"},
		}, "target.health > 1"},
		
		{"1454", "player.mana < 40"},
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"},
	}, {"player.firehack", "target.area(10).enemies < 4"}},
	
	{{	-- Non-Firehack Support
		{{	-- Attempt proper Haunt usage and shard pooling
			{{
				{"!48181", "player.aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"},
			}, "target.debuff(48181).duration < 4"},
			{{
				{"!48181", "player.aff.procs > 0"},
				{"!48181", "player.buff(113860)"},
				{"!48181", "player.soulshards > 2"},
				{"!48181", "target.health < 15"},
			}, "player.soulshards = 4"},
		}, {"!talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving"}},
		
		{{	-- Proper Soulburn usage when talented Soulburn: Haunt
			{"!74434", "!player.buff(157698)"},
			{"!74434", { "player.soulshards = 4", "player.buff(157698).duration < 5"}},
		}, {"talent(7, 1)", "!player.buff(74434)", "!player.moving", "player.soulshards > 0"}},
		
		{{	-- Soulburn: Haunt (Talent)
			{"!48181", { "player.buff(74434)", "player.buff(157698).duration < 5"}},
			{"!48181", "player.soulshards = 4"},
		}, {"talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving"}},
		
		{{	-- Agony
			{"980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"target.debuff(980).duration < 6",
			}},
			{"980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"!target.debuff(980)",
			}},
			{"980", {"!talent(7, 2)", "target.debuff(980).duration < 6"}},
			{"980", {"!talent(7, 2)", "!target.debuff(980)"}},
		}, "target.health > 1 " },
		
		{{	-- Unstable Affliction
			{"30108", "target.debuff(30108).duration < 6"},
			{"30108", "!target.debuff(30108)"},
		}, {"!player.moving", "target.health > 1", "!modifier.last(30108)"}},
		
		{{	-- Corruption
			{"172", "target.debuff(146739).duration < 6"},
			{"172", "!target.debuff(146739)"},
		}, "target.health > 1"},
		
		{"1454", "player.mana < 40"},
		{"103103", "!player.moving"},
		{"1454", "player.health > 40"},
	}, {"!player.firehack", "!modifier.control"}}
}

-- Out of combat
local beforeCombat = {
	-- Buffs
	{"109773", "!player.buffs.mastery"},
	{"109773", "!player.buffs.spellpower"},
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
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(265, "[|cffa9013fMirakuru Rotations|r] Affliction", combatRotation, beforeCombat, btn)