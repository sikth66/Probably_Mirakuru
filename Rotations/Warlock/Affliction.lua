--[[
	Affliction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Combat Rotation
local combatRotation = {
	-- Buffs
	{ "!109773", "!player.buffs.mastery" },
	{ "!109773", "!player.buffs.spellpower" },
	{ "/cancelaura "..GetSpellInfo(111400), { "!player.moving", "player.buff(111400)" }},
	
	-- Talents --
	{ "!108359", {	-- Dark Regeneration
		"talent(1, 1)",
		"player.health < 40",
		"player.spell(108359).cooldown = 0",
		(function() if UnitGetIncomingHeals("player") < 8000 then return false else return true end end),
	}},
	{ "6789", {		-- Mortal Coil
		"talent(2, 2)",
		"player.health < 85",
		"player.spell(6789).cooldown = 0",
	}},
	{ "!30283", {	-- Shadowfury
		"talent(2, 3)",
		"modifier.lalt",
		"player.spell(30283).cooldown = 0",
	}, "mouseover.ground" },
	{ "!111400", {	-- Burning Rush
		"talent(4, 2)",
		"player.moving",
		"player.health > 70",
		"!player.buff(111400)",
	}},
	{ "!108503", {	-- Grimoire of Sacrifice
		"talent(5, 3)",
		"!player.buff(108503)",
		"!talent(7, 3)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive",
	}},
	{ "!137587", {	-- Kil'jaeden's Cunning
		"talent(6, 2)",
		"player.moving",
		"player.spell(137587).cooldown = 0",
	}},
	
	-- Cooldown management --
	{{
		-- Grimoire of Service
		{ "!111897", { "talent(5, 2)", "player.spell(111897).cooldown = 0" }},
		-- Trinkets
		{ "!#trinket1" },
		{ "!#trinket2" },
		-- Racials
		{ "!26297", "player.spell(26297).cooldown = 0" },
		{ "!33702", "player.spell(33702).cooldown = 0" },
		{ "!28730", { "player.mana <= 90", "player.spell(28730).cooldown = 0" }},
		-- Doomguard / Infernal
		{ "!18540", {
			"!talent(7, 3)",
			"target.area(15).enemies < 5",
			"player.spell(18540).cooldown = 0",
			"player.firehack",
		}},
		{ "!1122", {
			"!talent(7, 3)",
			"target.area(15).enemies >= 5",
			"player.spell(1122).cooldown = 0",
			"player.firehack",
		}},
		{ "!18540", {
			"!talent(7, 3)",
			"player.spell(18540).cooldown = 0",
			"!player.firehack",
		}},
		{ "!112927", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"target.area(15).enemies < 5",
			"player.spell(112927).cooldown = 0",
			"player.firehack",
		}},
		{ "!140762", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"target.area(15).enemies >= 5",
			"player.spell(140762).cooldown = 0",
			"player.firehack",
		}},
		{ "!112927", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"player.spell(112927).cooldown = 0",
			"!player.firehack",
		}},
		
		-- Dark Soul
		{ "!113860", "!talent(6, 1)", "player.spell(113860).cooldown = 0" },
		{{
			{ "!113860", "player.spell(113860).charges = 2" },
			--{ "Dark Soul: Misery", "@miLib.hasAuraOrProc" },
			{ "!113860", "target.health <= 10" },
		}, { "talent(6, 1)", "player.spell(113860).charges > 0" }},
	}, { "target.boss", "modifier.cooldowns" }},
	
	-- AoE Rotation
	{{	-- Firehack Support
		{ "!108508", { "talent(6, 3)", "player.spell(108508).cooldown = 0" }},
		{ "!152108", { "talent(7, 2)", "player.spell(152108).cooldown = 0" }},
		{ "!74434", {	-- Soulburn
			"!talent(7, 1)",
			"!player.buff(74434)",
			"!target.debuff(27243)",
			"player.soulshards > 2",
			"!target.debuff(114790)",
		}},
		{ "!114790", {	-- Soulburn: Seed of Corruption
			"!talent(7, 1)",
			"!player.moving",
			"player.buff(74434)",
			"!target.debuff(27243)",
			"!target.debuff(114790)",
			"!modifier.last(114790)",
		}},
		{ "!27243", { "!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving" }},
		{ "103103", "!player.moving" },
		{ "1454", "player.health > 40" },
	}, { "player.firehack", "target.area(10).enemies >= 7" }},
	
	{{	-- Non-Firehack Support
		{ "!108508", { "talent(6, 3)", "player.spell(108508).cooldown = 0" }},
		{ "!152108", { "talent(7, 2)", "player.spell(152108).cooldown = 0" }},
		{ "!74434", {	-- Soulburn
			"!talent(7, 1)",
			"!player.buff(74434)",
			"!target.debuff(27243)",
			"player.soulshards > 2",
			"!target.debuff(114790)",
		}},
		{ "!114790", {	-- Soulburn: Seed of Corruption
			"!talent(7, 1)",
			"!player.moving",
			"player.buff(74434)",
			"!target.debuff(27243)",
			"!target.debuff(114790)",
			"!modifier.last(114790)",
		}},
		{ "!27243", { "!target.debuff(27243)", "!target.debuff(114790)", "!modifier.last(114790)", "!player.moving" }},
		{ "103103", "!player.moving" },
		{ "1454", "player.health > 40" },
	}, { "!player.firehack", "modifier.control" }},
	
	-- Regular Rotation --
	{{	-- Firehack Support
		{{	-- Attempt proper Haunt usage and shard pooling
			{{
				--{ "!48181", "@miLib.hasAuraOrProc()" },
				{ "!48181", "player.buff(113860)" },
				{ "!48181", "player.soulshards > 2" },
				{ "!48181", { "target.health < 15", "player.soulshards > 0" }},
			}, "target.debuff(48181).duration < 4" },
			{{
				--{ "!48181", { "@miLib.hasAuraOrProc()" }},
				{ "!48181", "player.buff(113860)" },
				{ "!48181", "player.soulshards > 2" },
				{ "!48181", { "target.health < 15", "player.soulshards > 0" }},
			}, "player.soulshards = 4" },
		}, { "!talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving", "!player.casting(30108)" }},
		
		{{	-- Proper Soulburn usage when talented Soulburn: Haunt
			{ "!74434", "!player.buff(157698)" },
			{ "!74434", { "player.soulshards = 4", "player.buff(157698).duration < 5" }},
		}, { "talent(7, 1)", "!player.buff(74434)", "!player.moving", "player.soulshards > 0" }},
		
		{{	-- Soulburn: Haunt (Talent)
			{ "!48181", { "player.buff(74434)", "player.buff(157698).duration < 5" }},
			{ "!48181", "player.soulshards = 4" },
		}, { "talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving" }},
		
		{{	-- Agony
			{ "980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"target.debuff(980).duration < 6",
			}},
			{ "980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"!target.debuff(980)",
			}},
			{ "980", {"!talent(7, 2)", "target.debuff(980).duration < 6" }},
			{ "980", {"!talent(7, 2)", "!target.debuff(980)" }},
		}, "target.health > 1 " },
		
		{{	-- Unstable Affliction
			{ "30108", "target.debuff(30108).duration < 6" },
			{ "30108", "!target.debuff(30108)" },
		}, { "!player.moving", "target.health > 1", "!modifier.last(30108)", "!player.casting(48181)" }},
		
		{{	-- Corruption
			{ "172", "target.debuff(146739).duration < 6" },
			{ "172", "!target.debuff(146739)" },
		}, "target.health > 1" },
		
		{ "1454", "player.mana < 40" },
		{ "103103", "!player.moving" },
		{ "1454", "player.health > 40" },
	}, { "player.firehack", "target.area(10).enemies < 7" }},
	
	{{	-- Non-Firehack Support
		{{	-- Attempt proper Haunt usage and shard pooling
			{{
				--{ "!48181", "@miLib.hasAuraOrProc()" },
				{ "!48181", "player.buff(113860)" },
				{ "!48181", "player.soulshards > 2" },
				{ "!48181", { "target.health < 15", "player.soulshards > 0" }},
			}, "target.debuff(48181).duration < 4" },
			{{
				--{ "!48181", { "@miLib.hasAuraOrProc()" }},
				{ "!48181", "player.buff(113860)" },
				{ "!48181", "player.soulshards > 2" },
				{ "!48181", { "target.health < 15", "player.soulshards > 0" }},
			}, "player.soulshards = 4" },
		}, { "!talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving" }},
		
		{{	-- Proper Soulburn usage when talented Soulburn: Haunt
			{ "!74434", "!player.buff(157698)" },
			{ "!74434", { "player.soulshards = 4", "player.buff(157698).duration < 5" }},
		}, { "talent(7, 1)", "!player.buff(74434)", "!player.moving", "player.soulshards > 0" }},
		
		{{	-- Soulburn: Haunt (Talent)
			{ "!48181", { "player.buff(74434)", "player.buff(157698).duration < 5" }},
			{ "!48181", "player.soulshards = 4" },
		}, { "talent(7, 1)", "!modifier.last(48181)", "player.soulshards > 0", "!player.moving" }},
		
		{{	-- Agony
			{ "980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"target.debuff(980).duration < 6",
			}},
			{ "980", {
				"talent(7, 2)",
				"player.spell(152108).cooldown > 20",
				"!target.debuff(980)",
			}},
			{ "980", {"!talent(7, 2)", "target.debuff(980).duration < 6" }},
			{ "980", {"!talent(7, 2)", "!target.debuff(980)" }},
		}, "target.health > 1 " },
		
		{{	-- Unstable Affliction
			{ "30108", "target.debuff(30108).duration < 6" },
			{ "30108", "!target.debuff(30108)" },
		}, { "!player.moving", "target.health > 1", "!modifier.last(30108)" }},
		
		{{	-- Corruption
			{ "172", "target.debuff(146739).duration < 6" },
			{ "172", "!target.debuff(146739)" },
		}, "target.health > 1" },
		
		{ "1454", "player.mana < 40" },
		{ "103103", "!player.moving" },
		{ "1454", "player.health > 40" },
	}, { "!player.firehack", "!modifier.control" }}
}

-- Out of combat
local beforeCombat = {
	-- Buffs
	{ "109773", "!player.buffs.mastery" },
	{ "109773", "!player.buffs.spellpower" },
	{ "/cancelaura "..GetSpellInfo(111400), { "!player.moving", "player.buff(111400)" }},
	
	-- Talent: Grimoire of Sacrifice
	{ "108503", {
		"talent(5, 3)",
		"!player.buff(108503)",
		"!talent(7, 3)",
		"player.spell(108503).cooldown = 0",
		"pet.exists",
		"pet.alive",
	}},
	{ "!30283", {	-- Shadowfury
		"talent(2, 3)",
		"modifier.lalt",
		"player.spell(30283).cooldown = 0",
	}, "mouseover.ground" },
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(265, "[|cffa9013fMirakuru Rotations|r] Affliction", combatRotation, beforeCombat)