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
				{"!113858", "player.spell(113858).charges = 2"},
				{"!113858", "player.int.procs > 0"},
				{"!113858", "target.health <= 10"},
			}, {"talent(6, 1)", "player.spell(113858).charges > 0"}},
			
			-- Dark Soul
			{"!113858", "!talent(6, 1)", "player.spell(113858).cooldown = 0"},
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
	{{	-- Firehack support
		{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
		{"108683", {"!player.buff(108683)", "player.embers >= 20"}},
		{"108686", {"target.debuff(157736).duration < 1.5", "!player.moving"}},
		{"108685", "player.spell(108685).charges = 2"},
		
		{{
			{{
				{"157701", "player.embers >= 25"},
				{"157701", "player.int.procs > 0"},
				{"157701", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
			}, {"talent(7, 1)","player.buff(117828).count < 3"}},

			{"157701", "player.embers >= 32"},
			{"157701", "player.int.procs > 0"},
			{"157701", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
			{"157701", {"player.buff(145164)", "player.embers > 27"}},
		}, "player.buff(117828).count < 3"},
		
		{"108686", {"target.debuff(157736).duration < 6", "!player.moving"}},
		
		{{
			{"104232", "player.buff(117828)"},
			{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
		}, "!player.buff(104232)", "target.ground"},
		{{
			{"104232", "player.buff(117828)"},
			{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
		}, {"talent(6, 3)", "player.buff(108508).duration < 1"}, "target.ground"},
		
		{"108686", {"!target.debuff(157736)", "!player.moving"}},
		{"108685", "player.spell(108685).charges > 0"},
		{"114654", "!player.moving"},
	}, {"player.firehack", "target.area(10).enemies >= 4", "modifier.multitarget"}},
	
	{{	-- Non-Firehack Support
		{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}, "target.ground"},
		{"108683", {"!player.buff(108683)", "player.embers >= 20"}},
		{"108686", {"target.debuff(157736).duration < 1.5", "!player.moving"}},
		{"108685", "player.spell(108685).charges = 2"},
		
		{{
			{{
				{"157701", "player.embers >= 25"},
				{"157701", "player.int.procs > 0"},
				{"157701", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
			}, {"talent(7, 1)","player.buff(117828).count < 3"}},

			{"157701", "player.embers >= 32"},
			{"157701", "player.int.procs > 0"},
			{"157701", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
			{"157701", {"player.buff(145164)", "player.embers > 27"}},
		},"player.buff(117828).count < 3"},
		
		{"108686", {"target.debuff(157736).duration < 6", "!player.moving"}},
		
		{{
			{"104232", "player.buff(117828)"},
			{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
		}, "!player.buff(104232)", "target.ground"},
		{{
			{"104232", "player.buff(117828)"},
			{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
		}, {"talent(6, 3)", "player.buff(108508).duration < 1"}, "target.ground"},
		
		{"108686", {"!target.debuff(157736)", "!player.moving"}},
		{"108685", "player.spell(108685).charges > 0"},
		{"114654", "!player.moving"},
	}, {"!player.firehack", "modifier.control", "modifier.multitarget"}},
	
	-- Single-target
	{{	-- Shadowburn
		{"17877", "player.embers >= 25"},
		{"17877", "target.ttd < 25"},
		{"17877", "player.int.procs > 0"},
	}, {"talent(7, 1)", "player.embers > 10"}},
	
	{"348", {"target.debuff(157736).duration < 1.5", "!player.moving"}},
	{"17962", "player.spell(17962).charges = 2"},
	
	{{
		{"116858", "player,.buff(170000)"},
		{{
			{"116858", "player.embers >= 25"},
			{"116858", "player.int.procs > 0"},
			{"116858", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
		}, "player.buff(165455)"},
		{{
			{"116858", "player.embers >= 25"},
			{"116858", "player.int.procs > 0"},
			{"116858", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
		}, "talent(7, 1)"},
		{{
			{"116858", "player.embers >= 25"},
			{"116858", "player.int.procs > 0"},
			{"116858", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
		}, "talent(7, 1)"},

		{"116858", "player.embers >= 32"},
		{"116858", "player.int.procs > 0"},
		{"116858", {"player.buff(113858)", "player.buff(113858).duration > 2.8"}},
		{"116858", {"player.buff(145164)", "player.embers > 27"}},
	}, {"player.buff(117828).count < 3", "!player.moving"}},
	
	{"348", {"target.debuff(157736).duration < 6", "!player.moving"}},

	{{
		{"104232", "player.buff(117828)"},
		{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
	}, "!player.buff(104232)", "target.ground"},
	{{
		{"104232", "player.buff(117828)"},
		{"104232", {"talent(6, 3)", "player.buff(108508).duration < 1"}},
	}, {"talent(6, 3)", "player.buff(108508).duration < 1"}, "target.ground"},

	{"348", {"!target.debuff(157736)", "!player.moving"}},
	{"17962", "player.spell(17962).charges > 0"},
	{"29722", "!player.moving"},
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
ProbablyEngine.rotation.register_custom(267, "[|cffa9013fMirakuru Rotations|r] Destruction", combatRotation, beforeCombat, btn)