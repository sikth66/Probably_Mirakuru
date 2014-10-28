--[[
	Destruction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Combat Rotation
local combatRotation = {
	-- Buffs --
	{"!109773", "!player.buffs.mastery"},
	{"!109773", "!player.buffs.spellpower"},
	{"/cancelaura "..GetSpellInfo(111400), {"!player.moving", "player.buff(111400)"}},
	
	-- Cooldown Management --
	{{
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
			{"!113860", "@miLib.intProcs()"},
			{"!113860", "target.health <= 10"},
		}, {"talent(6, 1)", "player.spell(113860).charges > 0"}},
		
		-- Dark Soul
		{"!113860", "!talent(6, 1)", "player.spell(113860).cooldown = 0"},
	}, {"modifier.cooldown", "target.boss"}},
	
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
	
	-- AoE Rotation --
	{{	-- Firehack Support
	}, {"player.firehack", "target.area(10).enemies >= 5", "modifier.multitarget"}},
	{{	-- Non-Firehack Support
	}, {"!player.firehack", "modifier.control", "modifier.multitarget"}},
	
	-- Multi-dotting --
	{{
	}, "modifier.multitarget"},
	
	-- Regular Rotation --
	{{	-- Firehack Support
	}, {"player.firehack", "target.area(10).enemies < 5"}},
	
	{{	-- Non-Firehack Support
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
ProbablyEngine.rotation.register_custom(267, "[|cffa9013fMirakuru Rotations|r] Destruction", combatRotation, beforeCombat)