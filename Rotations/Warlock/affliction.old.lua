--[[
	Affliction Warlock - Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Buttons
local buttons = function() end

	--[[{{
		{ "Unbound Will", "player.debuff.type = Magic" },
		{ "Unbound Will", "player.state.incapacitate" },
		{ "Unbound Will", "player.state.disorient" },
		{ "Unbound Will", "player.state.charm" },
		{ "Unbound Will", "player.state.sleep" },
		{ "Unbound Will", "player.state.snare" },
		{ "Unbound Will", "player.state.fear" },
		{ "Unbound Will", "player.state.root" },
		{ "Unbound Will", "player.state.stun" },
	}, { "talent(4, 3)", "player.spell(Unbound Will).cooldown = 0" }},
	]]--

-- Shared Logic
local sharedLogic = {
	-- Combat buffing
	{ "Dark Intent", "player.buffs.spellpower" },
	{ "Dark Intent", "player.buffs.mastery" },
	
	-- Talent: Grimoire of Sacrifice
	{ "Grimoire of Sacrifice", {
		"talent(5, 3)",
		"!player.buff(Grimoire of Sacrifice)",
		"!talent(7, 3)",
		"player.spell(Grimoire of Sacrifice).cooldown = 0",
		"pet.exists",
		"pet.alive",
	}},
}

-- Combat Rotation
local combatRotation = {
	-- Refresh targets
	--{ "/run miLib.UnitsAroundUnit()", "timeout(timer, 1)" },
	
	-- Shared Logic
	sharedLogic,
	
	--[[
	-- Talents
	{ "Dark Regeneration", {
		"talent(1, 1)",
		"player.health < 40",
		"player.spell(Dark Regeneration).cooldown = 0",
		(function() return ((UnitGetIncomingHeals("player") < 8000) and false or true) end),
	}},
	
	{ "Mortal Coil", {
		"talent(2, 2)",
		"player.health < 85",
		"player.spell(Mortal Coil).cooldown = 0",
	}},
	
	{ "Shadowfury", {
		"talent(2, 3)",
		"modifier.lalt",
		"player.spell(Shadowfury).cooldown = 0",
	}, "ground" },
	
	{ "/cancelaura Burning Rush", { "!player.moving", "player.buff(Burning Rush)" }},
	{ "Burning Rush", {
		"talent(4, 2)",
		"player.moving",
		"!player.buff(Burning Rush)",
	}},
	
	{ "Kil'jaeden's Cunning", {
		"talent(6, 2)",
		"player.moving",
		"player.spell(Kil'jaeden's Cunning).cooldown = 0",
	}},
	
	-- Cooldown management --
	{{
		-- Grimoire of Service
		{ "Grimoire: Felhunter", { "talent(5, 2)", "player.spell(Grimoire: Felhunter).cooldown = 0" }},
		
		-- Trinkets
		{ "#trinket1" },
		{ "#trinket2" },
		
		-- Racials
		{ "Berserking", "player.spell(Berserking).cooldown = 0" },
		{ "Blood Fury", "player.spell(Blood Fury).cooldown = 0" },
		{ "Arcane Torrent", { "player.mana <= 90", "player.spell(Arcane Torrent).cooldown = 0" }},
		
		-- Doomguard / Infernal
		{ "Summon Doomguard", {
			"!talent(7, 3)",
			"target.area(15).enemies < 5",
			"player.spell(Summon Doomguard).cooldown = 0",
			"firehack",
		}},
		{ "Summon Infernal", {
			"!talent(7, 3)",
			"target.area(15).enemies >= 5",
			"player.spell(Summon Infernal).cooldown = 0",
			"firehack",
		}},
		{ "Summon Doomguard", {
			"!talent(7, 3)",
			"player.spell(Summon Doomguard).cooldown = 0",
			"!firehack",
		}},
		{ "Summon Terrorguard", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"target.area(15).enemies < 5",
			"player.spell(Summon Terrorguard).cooldown = 0",
			"firehack",
		}},
		{ "Summon Abyssal", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"target.area(15).enemies >= 5",
			"player.spell(Summon Abyssal).cooldown = 0",
			"firehack",
		}},
		{ "Summon Terrorguard", {
			"!talent(7, 3)",
			"talent(5, 1)",
			"player.spell(Summon Terrorguard).cooldown = 0",
			"!firehack",
		}},
		
		-- Dark Soul
		{ "Dark Soul: Misery", "!talent(6, 1)", "player.spell(Dark Soul: Misery).cooldown = 0" },
		{{
			{ "Dark Soul: Misery", "player.spell(Dark Soul: Misery).charges = 2" },
			--{ "Dark Soul: Misery", "@miLib.hasAuraOrProc" },
			{ "Dark Soul: Misery", "target.health <= 10" },
		}, { "talent(6, 1)", "player.spell(Dark Soul: Misery).charges > 0" }},
	}, { "target.boss", "modifier.cooldowns" }},
	
	-- AoE / Cleave Rotation
	{{	-- Firehack
		{ "Mannoroth's Fury", { "talent(6, 3)", "player.spell(Mannoroth's Fury).cooldown = 0" }},
		{ "Cataclysm", { "talent(7, 2)", "player.spell(Cataclysm).cooldown = 0" }},
		{ "Soulburn", {
			"!talent(7, 1)",
			"player.soulshards > 2",
			"!player.buff(Soulburn)",
		}},
		{ "Seed of Corruption", {
			"!talent(7, 1)",
			"player.buff(Soulburn)",
			"!target.debuff(Seed of Corruption)",
		}},
		{ "Seed of Corruption",  "!target.debuff(Seed of Corruption)" },
	}, { "firehack", "target.area(10).enemies >= 6" }},
	
	{{	-- No Firehack
		{ "Mannoroth's Fury", { "talent(6, 3)", "player.spell(Mannoroth's Fury).cooldown = 0" }},
		{ "Cataclysm", { "talent(7, 2)", "player.spell(Cataclysm).cooldown = 0" }},
		{ "Soulburn", {
			"!talent(7, 1)",
			"player.soulshards > 2",
			"!player.buff(Soulburn)",
		}},
		{ "Seed of Corruption", {
			"!talent(7, 1)",
			"player.buff(Soulburn)",
			"!target.debuff(Seed of Corruption)",
		}},
		{ "Seed of Corruption", "!target.debuff(Seed of Corruption)" },
	}, "modifier.rctrl" },
	
	-- Single-Target Rotation
	{{	-- Attempt proper Haunt usage and shard pooling
		{{
			--{ "Haunt", { "@miLib.hasAuraOrProc" }},
			{ "Haunt", { "player.buff(Dark Soul: Misery)" }},
			{ "Haunt", { "player.soulshards > 2" }},
			{ "Haunt", { "target.health < 15", "player.soulshards > 0" }},
		}, "target.debuff(Haunt).duration < 4" },
		{{
			--{ "Haunt", { "@miLib.hasAuraOrProc" }},
			{ "Haunt", { "player.buff(Dark Soul: Misery)" }},
			{ "Haunt", { "player.soulshards > 2" }},
			{ "Haunt", { "target.health < 15", "player.soulshards > 0" }},
		}, "player.soulshards = 4" },
	}, { "!talent(7, 1)", "!modifier.last(Haunt)", "player.soulshards > 0", "!player.moving" }},
	
	{{	-- Proper Soulburn usage when talented
		{ "Soulburn", "!player.buff(Haunting Spirits)" },
		{ "Soulburn", { "player.soulshards = 4", "player.buff(Haunting Spirits).duration < 5" }},
	}, { "talent(7, 1)", "!player.buff(Soulburn)", "!player.moving", "player.soulshards > 0" }},
	
	{{	-- Soulburn: Haunt (Talent)
		{ "Haunt", { "player.buff(Soulburn)", "player.buff(Haunting Spirits).duration < 5" }},
		{ "Haunt", "player.soulshards = 4" },
	}, { "talent(7, 1)", "!modifier.last(Haunt)", "player.soulshards > 0", "!player.moving" }},
	
	-- Multidotting
	--{ "/run miLib.dots(980, 980)", (function() return (unitsNeedAgony >= 1) end) },
	
	{{	-- Agony
		{ "Agony", {
			"talent(7, 2)",
			"player.spell(Cataclysm).cooldown > 20",
			"target.debuff(Agony).duration < 6",
		}},
		{ "Agony", {
			"talent(7, 2)",
			"player.spell(Cataclysm).cooldown > 20",
			"!target.debuff(Agony)",
		}},
		{ "Agony", {"!talent(7, 2)", "target.debuff(Agony).duration < 6" }},
		{ "Agony", {"!talent(7, 2)", "!target.debuff(Agony)" }},
	}, "target.health > 1500000 " },
	
	{{	-- Unstable Affliction
		{ "Unstable Affliction", "target.debuff(Unstable Affliction).duration < 5" },
		{ "Unstable Affliction", "!target.debuff(Unstable Affliction)" },
	}, { "!player.moving", "target.health > 1500000" }},
	
	{{	-- Corruption
		{ "Corruption", "target.debuff(Corruption).duration < 6" },
		{ "Corruption", "!target.debuff(Corruption)" },
	}, "target.health > 1500000" },
	
	{ "Life Tap", "player.mana < 40" },

	{ "Drain Soul", "!player.moving" }
	]]
}

-- Out of combat
local beforeCombat = {
	-- Shared logic
	--sharedLogic,
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(265, "[|cffa9013fMirakuru Rotations|r] Affliction", combatRotation, nil, nil)