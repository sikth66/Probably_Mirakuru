--[[
	Shadow Priest - Custom ProbablyEngine Rotation Profile
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

-- Buttons
local btn = function()
	ProbablyEngine.toggle.create('aoe', 'Interface\\Icons\\spell_shadow_mindshear.png', 'Enable AOE', "Enables the AOE rotation within the combat rotation.")	
	ProbablyEngine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_shadow_config) end))
end


-- Combat Rotation
local combatRotation = {
	-- Mouseover Multidotting --
	{{
		{"589", "mouseover.debuff(589).duration <= 6", "mouseover"},
		{"34914", {"mouseover.debuff(34914).duration <= 6", "!player.moving"}, "mouseover"},
	}, "modifier.multitarget"},
	
	{{	-- Clarity of Power
		{{	-- Clarity of Power with Insanity
			{{	-- Dotweaving
				{{	-- Devouring Plague
					{"!2944", {"target.debuff(34914)", "target.debuff(589)", "player.shadoworbs >= 5"}},
					{"!2944", {"player.buff(167254)", "player.buff(167254).duration <= 1.5"}},
					{"!2944", {
						"target.debuff(34914)",
						"target.debuff(589)",
						"!player.buff(132573)",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}}
				}},
				{{	-- Shadow Word: Death
					{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
					-- Shadow Word: Death sniping and glyph support missing
				}},
				-- Mind Harvest needed
				{"!8092", {"!player.glyph(162532)", "player.spell(8092).cooldown = 0", "player.shadoworbs <= 4"}},
				{{	-- Shadow Word: Pain
					{"589", {
						"player.shadoworbs = 4",
						"player.buff(165628)",
						"!target.debuff(589)",
						"!target.debuff(158831)",
						(function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round((1.2*(1.5/((100+GetHaste("player"))/100))),2)) end),
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}},
					{"589", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(589)"}},
					{"589", "player.moving"}
				}},
				{"34914", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(34914)", "!player.moving", "!modifier.last(34914)"}},
				{"!129197", {
					"!player.moving",
					"player.buff(132573)",
					"timeout(insanity, 1)",
					"!modifier.last(129197)",
					"!player.buff(132573).duration > 0.35",
					(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
				}},
				{"129197", {"!player.moving", "player.buff(132573)"}},
				{"589", {
					"player.shadoworbs >= 2",
					"target.debuff(589).duration >= 6",
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
					"target.debuff(34914)",
					"player.hashero",
					"!player.buff(165628)"
				}},
				{"34914", {
					"!player.moving",
					"!modifier.last(34914)",
					"player.shadoworbs >= 2",
					"target.debuff(34914).duration >= 5",
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
					"player.hashero",
					"!player.buff(165628)"
				}},
				{"120644", {
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
					"talent(6, 3)",
					"target.distance <= 30",
					"target.distance >= 17"
				}},
				{"122121", {
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
					"talent(6, 2)",
					"target.distance <= 24"
				}},
				{"127632", {
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
					"talent(6, 1)",
					"target.distance >= 11",
					"target.distance <= 39"
				}},
				--[[
				{{	-- multidotting
					--actions.cop_dotweave+=/shadow_word_pain,if=primary_target=0&(!ticking|remains<=18*0.3),cycle_targets=1,max_cycle_targets=5
					--actions.cop_dotweave+=/vampiric_touch,if=primary_target=0&(!ticking|remains<=15*0.3),cycle_targets=1,max_cycle_targets=5
				}}]]
				{{	-- Mind Spike
					{"73510", {
						(function() return dynamicEval("player.buff(132573).duration <= "..miLib.round((1.5/((100+GetHaste("player"))/100)),2)) end),
						"player.hashero",
						"!target.debuff(589)",
						"!target.debuff(34914)"
					}},
					{{
						{"73510", {"target.debuff(589)", "!target.debuff(34914)"}},
						{"73510", {"!target.debuff(589)", "target.debuff(34914)"}}
					}, {
						"!player.moving",
						"player.shadoworbs <= 2",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}}
				}},
				{"15407", {
					"!player.moving",
					"target.debuff(589)",
					"target.debuff(34914)",
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.9*(1.5/((100+GetHaste("player"))/100))),2)) end)
				}},
				{"73510", {
					"!player.moving",
					"!target.debuff(158831)",
					(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
				}}
			}, "target.health > 20"},
			
			{{	-- COP Execute (Lite)
				{"!2944", "player.shadoworbs = 5"},
				-- Mind Harvest support needed
				{"!8092", {"!player.glyph(162532)", "player.spell(8092).cooldown = 0"}},
				{{	-- Shadow Word: Death
					{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
					-- Shadow Word: Death sniping and glyph support missing
				}},
				{{
					{"!2944", (function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
					{"!2944", {
						"target.health < 20",
						(function() return dynamicEval("player.spell(32379).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
					}}
				}, "player.shadoworbs >= 3"},
				{"!129197", {
					"!player.moving",
					"player.buff(132573)",
					"timeout(insanity, 1)",
					"!modifier.last(129197)",
					"!player.buff(132573).duration > 0.35",
					(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
				}},
				{"129197", {"!player.moving", "player.buff(132573)"}},
				{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
				{"122121", {"talent(6, 2)", "target.distance <= 24"}},
				{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}},
				--[[
				{{	-- multidotting
					actions.cop_mfi+=/shadow_word_pain,if=remains<(15*0.3)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
					actions.cop_mfi+=/vampiric_touch,if=remains<(18*0.3+cast_time)&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
				}}]]
				{"73510", "!player.moving"},
				{"589", "player.moving"}
			}, "target.health <= 20"}
		}, "talent(3, 3)"},
		
		{{	-- Regular Clarity of Power combat
			{{
				{"!2944", (function() return dynamicEval("player.spell(8092).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
				{"!2944", {
					"target.health < 20",
					(function() return dynamicEval("player.spell(32379).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
				}}
			}, "player.shadoworbs >= 3"},
			-- Mind Harvest needed
			{"!8092", {"!player.glyph(162532)", "player.spell(8092).cooldown = 0"}},
			{{	-- Shadow Word: Death
				{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
				-- Shadow Word: Death sniping and glyph support missing
			}},
			{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
			{"122121", {"talent(6, 2)", "target.distance <= 24"}},
			{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}},
			--[[
			{{	-- Multitargeting
				actions.cop+=/shadow_word_pain,if=miss_react&!ticking&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
				actions.cop+=/vampiric_touch,if=remains<cast_time&miss_react&active_enemies<=5&primary_target=0,cycle_targets=1,max_cycle_targets=5
			}}]]
			{"73510", "player.buff(87160)"},
			{"15407", {"!player.moving", "target.debuff(158831)"}},
			{"73510", {"!player.moving", "!target.debuff(158831)"}},
			{"589", "player.moving"}
		}, "!talent(3, 3)"}
	}, "talent(7, 1)"},
	
	{{	-- Void Entropy
		{"155361", {"target.ttd > 60", "player.shadoworbs >= 3", "!target.debuff(155361)"}},
		
		-- Void Entropy multitargeting coming here
		
		{{	-- Devouring Plague
			{"!2944", {
				"target.debuff(155361)",
				(function() return dynamicEval("target.debuff(155361).duration <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*2),2)) end)
			}},
			{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 10", "player.shadoworbs = 5"}},
			{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 20", "player.shadoworbs = 5"}},
			{"!2944", {"target.debuff(155361)", "player.shadoworbs = 5"}}
		}, {"player.shadoworbs >= 3", "!player.casting(155361)"}},
		
		{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
		-- Glyph of Mind Harvest support coming here
		{"!8092", {
			"!player.moving",
			"!player.glyph(162532)",
			"player.shadoworbs <= 4",
			"player.spell(8092).cooldown = 0",
		}},
		
		{{	-- Shadow Word: Death
			{"!32379", "target.health < 20"},
			-- Shadow Word: Death sniping and glyph support missing
		}, {"player.spell(32379).cooldown = 0", "player.shadoworbs <= 4"}},
		
		{"589", {
			"player.shadoworbs = 4",
			"target.debuff(589)",
			"player.buff(165628)",
			"target.debuff(589).duration < 9",
			"player.spell(8092).cooldown < 1.2",
			(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
		}},
		
		-- Insanity
		{"!129197", {
			"talent(3, 3)",
			"!player.moving",
			"player.buff(132573)",
			"timeout(insanity, 1)",
			"!modifier.last(129197)",
			(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
			(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
		}},
		{"129197", {
			"talent(3, 3)",
			"!player.moving",
			"player.buff(132573)",
			(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
		}},
		
		-- Surge of Darkness
		{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},
		
		-- Dotting
		{"589", "player.moving"},
		{"589", {"target.debuff(589).duration < 6"}},
		{"34914", {"!modifier.last(34914)", "target.debuff(34914).duration < 5.25"}},
		-- Multidotting here
		
		{{	-- Level 45 talents
			{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
			{"122121", {"talent(6, 2)", "target.distance <= 24"}},
			{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
		}, (function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)},
		
		-- Surge of Darkness procs
		{"73510", {
			"talent(3, 1)",
			"player.buff(87160)",
			(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
		}},
		
		-- Mind Flay
		{"15407", (function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)}
	}, "talent(7, 2)"},
	
	{{
		{"!32379", {"target.health < 20", "player.shadoworbs <= 4"}},
		{{	-- Shadow Word: Death
			{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
			-- Shadow Word: Death sniping and glyph support missing
		}},
		-- Mind Harvest needed
		{{	-- Devouring Plague
			{"!2944", "player.shadoworbs = 5"},
			{{
				{"!2944", "player.spell(8092).cooldown < 1.5"},
				{"!2944", {"player.spell(8092).cooldown < 1.5", "target.health < 20"}}
			}, "player.shadoworbs >= 3"}
		}},
		
		{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
		-- Mind Harvest needed
		{"!8092", {"player.spell(8092).cooldown = 0", "!player.moving"}},
		
		-- Insanity
		{"!129197", {
			"talent(3, 3)",
			"!player.moving",
			"player.buff(132573)",
			"timeout(insanity, 1)",
			"!modifier.last(129197)",
			(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
			(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
		}},
		{"129197", {"talent(3, 3)", "!player.moving", "player.buff(132573)"}},
		
		{"589", "target.debuff(589).duration < 6"},
		{"34914", (function() return dynamicEval("target.debuff(34914).duration < "..miLib.round((15*0.3+(1.5/((100+GetHaste("player"))/100))),2)) end)},
		-- Multidotting needed
		
		{"2944", {"!talent(7, 2)", "player.shadoworbs >= 3", "target.debuff(158831)", "target.debuff(158831).duration < 0.9"}},
		
		-- Surge of Darkness
		{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},

		-- Level 45 Talents
		{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
		{"122121", {"talent(6, 2)", "target.distance <= 24"}},
		{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}},
		
		-- Surge of Darkness
		{"73510", {"talent(3, 1)", "player.buff(87160)"}},
		
		{{
			{"589", {"target.debuff(589)", "target.debuff(589).duration <= 9"}},
			{"34914", {"target.debuff(34914)", "target.debuff(34914).duration <= 9"}}
		}, {"talent(3, 3)", "player.shadoworbs >= 2"}},
		
		-- Mind Flay
		{"15407", "player.spell(8092).cooldown > 0.5"}
	}, {"!talent(7, 1)", "!talent(7, 2)"}}
}

-- Out of combat
local beforeCombat = {}

-- Register our rotation
ProbablyEngine.rotation.register_custom(258, "[|cff005522Mirakuru Rotations|r] Shadow Priest", combatRotation, beforeCombat, btn)