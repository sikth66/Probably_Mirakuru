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
	-- Auto target enemy when Enabled
	{{
		{"/targetenemy [noexists]", "!target.exists"},
		{"/targetenemy [dead]", {"target.exists", "target.dead"}}
	}, (function() return fetch('miraShadowConfig', 'auto_target') end)},
	
	-- Healing Tonic / Healthstone
	{{
		{"#109223"},
		{"#5512"}
	}, {
		(function() return fetch('miraShadowConfig', 'stone_pot_check') end),
		(function() return dynamicEval('player.health <= '..fetch('miraShadowConfig', 'stone_pot_spin')) end)
	}},
	
	-- Feathers / Power Word: Shield
	{{
		{"17", {"talent(2, 1)", "!player.debuff(6788)"}},
		{"121536", {"talent(2, 2)", "player.spell(121536).charges > 1", "player.buff(121557).duration < 0.2", "player.moving"}, "player.ground"}
	}, (function() return fetch('miraShadowConfig', 'speed_increase') end)},
	
	-- Cooldowns --
	{{
		{"#trinket1"},
		{"#trinket2"},
		{"!26297", {"player.spell(26297).cooldown = 0", "!player.hashero"}},
		{"!33702", "player.spell(33702).cooldown = 0"},
		{"!28730", {"player.mana <= 90", "player.spell(28730).cooldown = 0"}},
		{"!132604", {"talent(3, 2)", "player.spell(132604).cooldown = 0"}},
		{"!132603", {"!talent(3, 2)", "player.spell(132603).cooldown = 0"}}
	}, {
		"modifier.cooldowns",
		(function()
			if fetch('miraShadowConfig', 'cd_bosses_only') then
				if ProbablyEngine.condition["boss"]("target") then return true else return false end
			else return true end
		end)
	}},
	
	-- Silence
	{"15487", {"target.interruptAt(20)", "target.distance < 30"}},
	
	-- Mouseover Multidotting --
	{{
		{"589", "mouseover.debuff(589).duration <= 6", "mouseover"},
		{"34914", {"mouseover.debuff(34914).duration <= 6", "!player.moving"}, "mouseover"}
	}, {"!player.target(mouseover)", "mouseover.enemy(player)"}},
	
	-- Defensive Cooldowns --
	{{
		--{"!586", {"player.glyph(55684)", "incoming.damage"}}
	}, (function() return fetch('miraShadowConfig', 'fade') end)},
	
	{{
		--{"!47858", {"player.spell(47858).cooldown = 0", "@miLib.bossEvents()"}},
		{"!47858", {
			"player.spell(47858).cooldown = 0",
			(function() return dynamicEval("player.health <= " .. fetch('miraShadowConfig', 'dispersion_spin')) end)
		}}
	}, (function() return fetch('miraShadowConfig', 'dispersion_check') end)},
	
	-- Void Tendrils
	{{
		{"!108920", {"player.spell(108920).cooldown = 0", "target.distance <= 8"}},
		{{
			{"!108920", {"player.spell(108920).cooldown = 0", "player.area(10).enemies >= 1"}}
		}, "player.firehack"}
	}, (function() return fetch('miraShadowConfig', 'tendrils') end)},
	
	-- AOE Rotation .. if you can call it AOE --
	{{
		{{
			{"!2944", "player.shadoworbs >= 5"},
			{"!2944", {"player.buff(167254)", "player.buff(167254).duration <= 1.5"}},
		}, "player.shadoworbs >= 3"},
		{{
			{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
			{{
				{"!32379", "@miLib.manager(32379, 0, 20)"}
			}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
			{"!129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
		}},
		{"!8092", "player.spell(8092).cooldown = 0"},
		{"!589", "@miLib.manager(589)"},
		{"!589", "!target.debuff(589)"},
		{"48045", "!player.moving"}
	}, {
		"toggle.aoe",
		(function()
			if FireHack then
				if dynamicEval("target.area(10).enemies >= "..fetch('miraShadowConfig', 'msear_units')) then return true else return false end
			else
				if ProbablyEngine.condition["modifier.control"]() then return true else return false end
			end
		end)
	}},
	
	-- Combat Routine
	{{
		-- Clarity of Power
		{{
			-- Clarity of Power with Insanity
			{{
				-- Dotweaving, over 20% health
				{{
					-- Devouring Plague
					{{
						{"!2944", {"target.debuff(34914)", "target.debuff(589)", "player.shadoworbs >= 5"}},
						{"!2944", {"player.buff(167254)", "player.buff(167254).duration <= 1.5"}},
						{"!2944", {
							"target.debuff(34914)",
							"target.debuff(589)",
							"!player.buff(132573)",
							(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
						}}
					}, "player.shadoworbs >= 3"},
					
					-- Shadow Word: Death
					{{
						{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
						{{
							{"!32379", "@miLib.manager(32379, 0, 20)"}
						}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
						{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
					}},
					
					-- Mind Blast
					{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)"}},
					{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 4"}},
					
					-- Shadow Word: Pain
					{{
						{"589", {
							"player.shadoworbs = 4",
							"player.buff(165628)",
							"!target.debuff(589)",
							"!target.debuff(158831)",
							(function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round((1.2*(1.5/((100+GetHaste("player"))/100))),2)) end),
							(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
						}},
						{"589", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(589)"}}
					}},
					
					-- Vampiric Touch
					{"34914", {"player.shadoworbs = 5", "!target.debuff(158831)", "!target.debuff(34914)", "!player.moving", "!modifier.last(34914)"}},
					
					-- Mind Flay: Insanity
					{"!129197", {
						"!player.moving",
						"player.buff(132573)",
						"timeout(insanity, 1)",
						"player.buff(132573).duration > 0.35",
						(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}},
					{"129197", {"!player.moving", "player.buff(132573)"}},
					
					-- Shadow Word: Pain
					{"589", {
						"player.shadoworbs >= 2",
						"target.debuff(589).duration >= 6",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
						"target.debuff(34914)",
						"player.hashero",
						"!player.buff(165628)"
					}},
					
					-- Vampiric Touch
					{"34914", {
						"!player.moving",
						"!modifier.last(34914)",
						"player.shadoworbs >= 2",
						"target.debuff(34914).duration >= 5",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end),
						"player.hashero",
						"!player.buff(165628)"
					}},
					
					-- Level 90 Talents
					{{
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
						}}
					}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},
					
					-- Multidotting
					{{
						{"!589", "@miLib.manager(589)"},
						{{
							{"!34914", {"@miLib.manager(34914)"}}
						}, {"!modifier.last(34914)", "!player.moving"}}
					}, {"player.shadoworbs <= 4", "modifier.multitarget"}},
					
					-- Mind Spike
					{{
						{"73510", {
							"player.buff(132573)",
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
					
					-- Mind Flay
					{"15407", {
						"!player.moving",
						"target.debuff(589)",
						"target.debuff(34914)",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.9*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}},
					
					-- Mind Spike
					{"73510", {
						"!player.moving",
						"!target.debuff(158831)",
						(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.4*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}},
					
					-- Shadow Word: Pain
					{"589", "player.moving"}
				}, "target.health > 20"},
				
				-- COP Execute (Lite)
				{{
					-- Devouring Plague
					{"!2944", "player.shadoworbs = 5"},
					
					-- Mind Blast
					{"!8092", "player.spell(8092).cooldown = 0"},
					
					-- Shadow Word: Death
					{{
						{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
						{{
							{"!32379", "@miLib.manager(32379, 0, 20)"}
						}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
						{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
					}},
					
					-- Devouring Plague
					{{
						{"!2944", (function() return dynamicEval("player.spell(8092).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
						{"!2944", {
							"target.health < 20",
							(function() return dynamicEval("player.spell(32379).cooldown < "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
						}}
					}, "player.shadoworbs >= 3"},
					
					-- Mind Flay: Insanity
					{"!129197", {
						"!player.moving",
						"player.buff(132573)",
						"timeout(insanity, 1)",
						"!modifier.last(129197)",
						"!player.buff(132573).duration > 0.35",
						(function() return dynamicEval("player.buff(132573).duration < "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
					}},
					{"129197", {"!player.moving", "player.buff(132573)"}},
					
					-- Level 90 Talents
					{{
						{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
						{"122121", {"talent(6, 2)", "target.distance <= 24"}},
						{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
					}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},
					
					-- Multidotting
					{{
						{"!589", "@miLib.manager(589)"},
						{{
							{"!34914", {"@miLib.manager(34914)"}}
						}, {"!modifier.last(34914)", "!player.moving"}}
					}, {"player.shadoworbs <= 4", "modifier.multitarget"}},
					
					-- Mind Spike
					{"73510", "!player.moving"},
					
					-- Shadow Word: Pain
					{"589", "player.moving"}
				}, "target.health <= 20"}
			}, "talent(3, 3)"},
			
			-- Regular Clarity of Power combat
			{{
				-- Devouring Plague
				{{
					{"!2944", (function() return dynamicEval("player.spell(8092).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)},
					{"!2944", {
						"target.health < 20",
						(function() return dynamicEval("player.spell(32379).cooldown <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*1.0),2)) end)
					}}
				}, "player.shadoworbs >= 3"},
				
				-- Mind Blast
				{"!8092", "player.spell(8092).cooldown = 0"},
				
				-- Shadow Word: Death
				{{
					{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
					{{
						{"!32379", "@miLib.manager(32379, 0, 20)"}
					}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
					{"!129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
				}},
				
				-- Level 90 Talents
				{{
					{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
					{"122121", {"talent(6, 2)", "target.distance <= 24"}},
					{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
				}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},
				
				-- Multidotting
				{{
					{"!589", "@miLib.manager(589)"},
					{{
						{"!34914", {"@miLib.manager(34914)"}}
					}, {"!modifier.last(34914)", "!player.moving"}}
				}, {"player.shadoworbs <= 4", "modifier.multitarget"}},
				
				-- Mind Spike (Surge of Darkness)
				{"73510", "player.buff(87160)"},
				
				-- Mind Flay during Devouring Plague
				{"15407", {"!player.moving", "target.debuff(158831)"}},
				
				-- Mind Spike without Devouring Plague
				{"73510", {"!player.moving", "!target.debuff(158831)"}},
				
				-- Shadow Word: Pain
				{"589", "player.moving"}
			}, "!talent(3, 3)"}
		}, "talent(7, 1)"},
		
		-- Void Entropy rotation
		{{
			-- Void Entropy
			{"!155361", {"target.ttd > 60", "player.shadoworbs >= 3", "!target.debuff(155361)", "!player.casting(155361)", "!player.moving"}},
			
			-- Devouring Plague
			{{
				{"!2944", {
					"target.debuff(155361)",
					(function() return dynamicEval("target.debuff(155361).duration <= "..miLib.round(((1.5/((100+GetHaste("player"))/100))*2),2)) end)
				}},
				{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 10", "player.shadoworbs = 5"}},
				{"!2944", {"target.debuff(155361)", "target.debuff(155361).duration < 20", "player.shadoworbs = 5"}},
				{"!2944", {"target.debuff(155361)", "player.shadoworbs = 5"}}
			}, {"player.shadoworbs >= 3", "!player.casting(155361)"}},
			
			-- Mind Blast
			{{
				{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
				{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},
				{"!8092", {
					"!player.moving",
					"player.shadoworbs <= 4",
					"player.spell(8092).cooldown = 0",
				}}
			}, "!player.casting(155361)"},
			
			-- Shadow Word: Death
			{{
				{"!32379", {"player.spell(32379).cooldown = 0", "target.health < 20"}},
				{{
					{"!32379", "@miLib.manager(32379, 0, 20)"}
				}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
				{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
			}, "player.shadoworbs <= 4"},
			
			-- Shadow Word: Pain
			{"589", {
				"player.shadoworbs = 4",
				"target.debuff(589)",
				"player.buff(165628)",
				"target.debuff(589).duration < 9",
				"player.spell(8092).cooldown < 1.2",
				(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.2*(1.5/((100+GetHaste("player"))/100))),2)) end)
			}},
			
			-- Mind Flay: Insanity
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
			
			-- Mind Spike: Surge of Darkness
			{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},
			
			-- Shadow Word: Pain
			{"589", {"target.debuff(589).duration < 6"}},
			
			-- Vampiric Touch
			{"34914", {"!modifier.last(34914)", "target.debuff(34914).duration < 6", "!player.moving"}},
			
			-- Multidotting
			{{
				{"!589", "@miLib.manager(589)"},
				{{
					{"!34914", {"@miLib.manager(34914)"}}
				}, {"!modifier.last(34914)", "!player.moving"}}
			}, "modifier.multitarget"},
			
			-- Level 90 Talents
			{{
				{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
				{"122121", {"talent(6, 2)", "target.distance <= 24"}},
				{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
			}, {
				(function() return fetch('miraShadowConfig', 'l90_talents') end),
				(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
			}},
			
			-- Mind Spike: Surge of Darkness
			{"73510", {
				"talent(3, 1)",
				"player.buff(87160)",
				(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)
			}},
			
			-- Mind Flay
			{"15407", {"!player.moving",
				(function() return dynamicEval("player.spell(8092).cooldown > "..miLib.round((0.5*(1.5/((100+GetHaste("player"))/100))),2)) end)}},
			
			-- Movement
			{"589", "player.moving"}
		}, "talent(7, 2)"},
		
		-- Auspicious Spirits rotation
		{{
			-- Shadow Word: Death
			{{
				{"!32379", {"target.health < 20", "player.shadoworbs <= 4"}},
				{"!32379", {"target.health < 20", "player.spell(32379).cooldown = 0"}},
				{{
					{"!32379", "@miLib.manager(32379, 0, 20)"}
				}, {"modifier.multitarget", "player.spell(32379).cooldown = 0"}},
				{"129176", {"player.glyph(120583)", "player.spell(32379).cooldown = 0", "player.health > 20"}}
			}},
			
			-- Mind Blast
			{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},
			
			-- Devouring Plague
			{{
				{"!2944", "player.shadoworbs = 5"},
				{{
					{"!2944", "player.spell(8092).cooldown < 1.5"},
					{"!2944", {"player.spell(8092).cooldown < 1.5", "target.health < 20"}}
				}, "player.shadoworbs >= 3"}
			}},
			
			-- Mind Blast
			{"!8092", {"talent(5, 3)", "player.buff(124430)", "player.spell(8092).cooldown = 0"}},
			{"!8092", {"player.spell(8092).cooldown = 0", "player.shadoworbs <= 2", "player.glyph(162532)", "!player.moving"}},
			{"!8092", {"player.spell(8092).cooldown = 0", "!player.moving"}},
			
			-- Mind Flay: Insanity
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
			
			-- Shadow Word: Pain
			{"589", "target.debuff(589).duration < 6"},
			
			-- Vampiric Touch
			{"34914", {
				"!player.moving",
				(function() return dynamicEval("target.debuff(34914).duration < "..miLib.round((15*0.3+(1.5/((100+GetHaste("player"))/100))),2)) end)
			}},
			
			-- Multidotting
			{{
				{"!589", "@miLib.manager(589)"},
				{{
					{"!34914", {"@miLib.manager(34914)"}}
				}, {"!modifier.last(34914)", "!player.moving"}}
			}, "modifier.multitarget"},
			
			-- Devouring Plague
			{"2944", {"!talent(7, 2)", "player.shadoworbs >= 3", "target.debuff(158831)", "target.debuff(158831).duration < 0.9"}},
			
			-- Mind Spike: Surge of Darkness
			{"73510", {"talent(3, 1)", "player.buff(87160).count = 3"}},
			
			-- Level 90 Talents
			{{
				{"120644", {"talent(6, 3)", "target.distance <= 30", "target.distance >= 17"}},
				{"122121", {"talent(6, 2)", "target.distance <= 24"}},
				{"127632", {"talent(6, 1)", "target.distance >= 11", "target.distance <= 39"}}
			}, (function() return fetch('miraShadowConfig', 'l90_talents') end)},
			
			-- Mind Spike: Surge of Darkness
			{"73510", {"talent(3, 1)", "player.buff(87160)"}},
			
			-- Dots with Mind Flay: Insanity
			{{
				{"589", {"target.debuff(589)", "target.debuff(589).duration <= 9"}},
				{"34914", {"target.debuff(34914)", "target.debuff(34914).duration <= 9"}}
			}, {"talent(3, 3)", "player.shadoworbs >= 2"}},
			
			-- Mind Flay
			{"15407", "player.spell(8092).cooldown > 0.5"}
		}, {"!talent(7, 1)", "!talent(7, 2)"}}
	}, (function()
			if ProbablyEngine.config.read('button_states', 'aoe', false) then
				if FireHack then
					if dynamicEval("target.area(10).enemies >= "..fetch('miraShadowConfig', 'msear_units')) then return false else return true end
				else
					if ProbablyEngine.condition["modifier.control"]() then return false else return true end
				end
			else return true end
		end)
	}
}

-- Out of combat
local beforeCombat = {
	-- Buffing
	{{
		{"15473", "!player.buff(15473)"},
		{"21562", "!player.buffs.stamina"}
	}, "player.alive"},
	
	-- Raid/Party buffing
	{{
		--{"21562", "@miLib.raidbuffing()"}
	}, (function() return fetch('miraShadowConfig', 'buff_raid') end)},
	
	-- Feathers / Power Word: Shield
	{{
		{"17", {"talent(2, 1)", "!player.debuff(6788)"}},
		{"121536", {"talent(2, 2)", "player.spell(121536).charges > 1", "player.buff(121557).duration < 0.2", "player.moving"}, "player.ground"}
	}, {(function() return fetch('miraShadowConfig', 'speed_increase') end),
		(function() return (not fetch('miraShadowConfig', 'speed_increase_combat') and true or false) end)}},
	
	-- Auto combat
	{{
		{"/cast "..GetSpellInfo(589), "target.alive"}
	}, (function() return fetch('miraShadowConfig', 'force_attack') end)}
}

-- Register our rotation
ProbablyEngine.rotation.register_custom(258, "[|cff005522Mirakuru Rotations|r] Shadow Priest", combatRotation, beforeCombat, btn)