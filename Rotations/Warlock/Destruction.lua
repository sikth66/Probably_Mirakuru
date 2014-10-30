--[[
	Destruction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('autopet', 'Interface\\Icons\\ability_warlock_demonicempowerment.png', 'Auto Command Demon', "Enable automatic usage of summoned pet's Special Ability.")
end

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
	
	-- Command Demon
	{{
		{"119913", "player.pet(115770).spell", "target.ground"},
		{"119909", "player.pet(6360).spell", "target.ground"},
		{"119911", {"player.pet(115781).spell", "target.casting"}},
		{"119910", {"player.pet(19467).spell", "target.casting"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119907", {"player.pet(17735).spell", "target.threat < 100"}},
		{"119905", {"player.pet(115276).spell", "player.health < 80"}},
		{"119905", {"player.pet(89808).spell", "player.health < 80"}},
	}, "toggle.autopet"},
	
	-- AoE Rotation --
	{{	-- Firehack Support
	}, {"player.firehack", "target.area(10).enemies >= 4", "modifier.multitarget"}},
	
	{{	-- Non-Firehack Support
	}, {"!player.firehack", "modifier.control", "modifier.multitarget"}},
	
	-- Multi-dotting --
	{{
		{"348", "!mouseover.debuff(157736)", "mouseover"},
		{"348", "mouseover.debuff(157736).duration <= 6", "mouseover"},
	}, {"modifier.multitarget", "!player.moving"}},
	
	-- Regular Rotation --
	{{	-- Firehack Support
		-- Rain of Fire while moving
		{"!104232", {"player.moving","!player.buff(104232)"}, "target.ground"},
		{"!104232", {"player.moving","player.buff(104232).duration < 5"}, "target.ground"},
		
		-- Shadowburn
		{"!17877", {"talent(7, 1)", "player.embers >= 25"}},
		{"!17877", "target.health <= 10"},
		{"!17877", "player.int.procs > 0"},
		{"!17877", {"player.buff(146202).duration < 10", "player.buff(146202).duration > 1.7"}},
		
		{{	-- Immolate
			{"!348", {"target.debuff(157736).duration <= 1.5", "!modifier.last(348)"}},
			{"348", {"!target.debuff(157736)", "!modifier.last(348)"}},
			{"348", {"target.debuff(157736).duration <= 6", "!modifier.last(348)"}},
		}, "!player.moving"},
		
		{{	-- Conflagrate
			{"17962", "player.buff(117828).count < 3"},
			{"17962", "!player.buff(117828)"},
		}},
		
		{"!152108", {"talent(7, 2)", "player.spell(152108).cooldown = 0"}},
		{{	-- Chaos Bolt
			{"116858", {"player.buff(170000)", "player.embers > 10"}},

			{{	-- Chaos Bolt: T17 Logic
				{"116858", "player.embers >= 26"},
				{"116858", {"player.int.procs > 0", "player.embers >= 15"}},
				{"116858", {"player.buff(113858)", "player.buff(113858).duration > 1.7"}},
			}, {"player.buff(117828).count < 3", "player.embers >= 10"}},
			
(trinket.proc.intellect.react&trinket.proc.intellect.remains>cast_time)
|buff.dark_soul.up)
			{{	-- Chaos Bolt: Charred Remains
				{"116858", "player.embers >= 25"},
			}, {"talent(7,1)","player.buff(117828).count < 3"}},
actions+=/chaos_bolt,if=buff.backdraft.stack<3&(burning_ember>=3.5|(trinket.proc.intellect.react&trinket.proc.intellect.remains>cast_time)|buff.dark_soul.up|(burning_ember>=3&buff.ember_master.react))
		}},
		
		{"29722", "!player.moving"},
	}, {"player.firehack", "target.area(10).enemies < 4"}},
	
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