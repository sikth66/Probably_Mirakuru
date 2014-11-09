--[[
	Interface file for Mirakuru Profiles
	Created by Mirakuru
]]
ProbablyEngine.command.register('miracle', function(msg, box)
local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == "config" or command == "settings" then
		if GetSpecialization() == 1 then
			miLib.displayFrame(mirakuru_aff_config)
		end
		if GetSpecialization() == 3 then
			miLib.displayFrame(mirakuru_destru_config)
		end		
	end
end)

mirakuru_aff_config = {
	key = "miraAffConfig",
	profiles = true,
	title = "Affliction Warlock",
	subtitle = "Configuration",
	color = "005522",
	width = 250,
	height = 450,
	config = {
		{
			type = "header",
			text = "General Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = false,
			text = "Auto Target",
			key = "auto_target",
			desc = "Set new target if your target is dead or you have no target."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = false,
			text = "Force Attack",
			key = "force_attack",
			desc = "Force attack your target even if not in combat!"
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "AOE Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "AOE Unit Count",
			key = "aoe_units",
			default_spin = 4,
			default_check = false,
			desc = "When enabled, start AoEing at this unit threshold."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			text = "Enbable Multidotting",
			key = "multidotting",
			default = true,
			desc = "Toggles the ability to multidot on mouseover."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Multi-dotting Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "Agony Count",
			key = "agony_units",
			default_spin = 4,
			default_check = false,
			desc = "How many units to cast Agony on when multidotting."
		},
		{
			type = "checkspin",
			text = "Corruption Count",
			key = "corruption_units",
			default_spin = 4,
			default_check = false,
			desc = "How many units to cast Corruption on when multidotting."
		},
		{
			type = "checkspin",
			text = "Unstable Affliction Count",
			key = "ua_units",
			default_spin = 4,
			default_check = false,
			desc = "How many units to cast Unstable Affliction on when multidotting."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Grimoire & Pet Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = false,
			text = "Auto Summon Pet",
			key = "auto_summon_pet",
			desc = "Automatically summon the selected pet when it's dead or no pets are active!"
		},
		{
			type = "checkbox",
			default = false,
			text = ".. and only using instant abilities.",
			key = "auto_summon_pet_instant",
			desc = "Only summon a pet in combat using instant abilities."
		},
		{
			type = "dropdown",
			text = "Select Pet",
			key = "summon_pet",
			list = {
				{
					text = "Imp",
					key = "688"
				},
				{
					text = "Voidwalker",
					key = "697"
				},
				{
					text = "Felhunter",
					key = "691"
				},
				{
					text = "Succubus",
					key = "712"
				}
			},
			desc = "Set which pet to summon or sacrifice.",
			default = "691",
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "dropdown",
			text = "Select Service Pet",
			key = "service_pet",
			list = {
				{
					text = "Imp",
					key = "imp"
				},
				{
					text = "Voidwalker",
					key = "voidwalker"
				},
				{
					text = "Felhunter",
					key = "felhunter"
				},
				{
					text = "Succubus",
					key = "succubus"
				}
			},
			desc = "Set which pet use for Grimoire of Service.",
			default = "felhunter",
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Defensive Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "Dark Regeneration",
			key = "darkregen_hp",
			default_spin = 40,
			default_check = true,
			desc = "Activates after reaching this HP value."
		},
		{
			type = "spinner",
			text = "Incoming Healing",
			key = "darkregen_healing",
			width = 50,
			min = 1000,
			max = 20000,
			default = 15000,
			step = 100,
			desc = "Incoming healing required to activate Dark Regeneration."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Talent Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "Mortal Coil",
			key = "mortal_coil",
			default_spin = 85,
			default_check = true,
			desc = "Use at or under this HP value."
		},
		{
			type = "checkspin",
			text = "Burning Rush",
			key = "burning_rush",
			default_spin = 70,
			default_check = true,
			desc = "Minimum health required for Burning Rush."
		}
	}
}

mirakuru_destru_config = {
	key = "miraDestruConfig",
	profiles = true,
	title = "Destruction Warlock",
	subtitle = "Configuration",
	color = "005522",
	width = 250,
	height = 450,
	config = {
		{
			type = "header",
			text = "General Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = false,
			text = "Auto Target",
			key = "auto_target",
			desc = "Set new target if your target is dead or you have no target."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = false,
			text = "Force Attack",
			key = "force_attack",
			desc = "Force attack your target even if not in combat!"
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Destruction Specific Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "spinner",
			text = "Minimum Embers for Dark Soul",
			key = "embers_darksoul",
			width = 50,
			min = 0,
			max = 40,
			default = 0.9,
			step = 0.1,
			desc = "Minimum Embers required before casting Dark Soul: Instability."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "Minimum Embers for Chaos Bolt",
			key = "embers_cb",
			width = 50,
			min = 0,
			max = 40,
			default = 20,
			step = 0.1,
			desc = "This setting is ignored with temporary crit buffs!"
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "Max Embers for Chaos Bolt",
			key = "embers_cb_max",
			width = 50,
			min = 0,
			max = 40,
			default = 32,
			step = 0.1,
			desc = "This setting is ignored with temporary crit buffs!"
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "AOE Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "AOE Unit Count",
			key = "aoe_units",
			default_spin = 4,
			default_check = false,
			desc = "When enabled, start AoEing at this unit threshold."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			text = "Enbable Multidotting",
			key = "multidotting",
			default = true,
			desc = "Toggles the ability to multidot on mouseover."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Grimoire & Pet Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = false,
			text = "Auto Summon Pet",
			key = "auto_summon_pet",
			desc = "Automatically summon the selected pet when it's dead or no pets are active!"
		},
		{
			type = "checkbox",
			default = false,
			text = ".. and only using instant abilities.",
			key = "auto_summon_pet_instant",
			desc = "Only summon a pet in combat using instant abilities."
		},
		{
			type = "dropdown",
			text = "Select Pet",
			key = "summon_pet",
			list = {
				{
					text = "Imp",
					key = "688"
				},
				{
					text = "Voidwalker",
					key = "697"
				},
				{
					text = "Felhunter",
					key = "691"
				},
				{
					text = "Succubus",
					key = "712"
				}
			},
			desc = "Set which pet to summon or sacrifice.",
			default = "691",
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "dropdown",
			text = "Select Service Pet",
			key = "service_pet",
			list = {
				{
					text = "Imp",
					key = "imp"
				},
				{
					text = "Voidwalker",
					key = "voidwalker"
				},
				{
					text = "Felhunter",
					key = "felhunter"
				},
				{
					text = "Succubus",
					key = "succubus"
				}
			},
			desc = "Set which pet use for Grimoire of Service.",
			default = "felhunter",
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Defensive Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "Dark Regeneration",
			key = "darkregen_hp",
			default_spin = 40,
			default_check = true,
			desc = "Activates after reaching this HP value."
		},
		{
			type = "spinner",
			text = "Incoming Healing",
			key = "darkregen_healing",
			width = 50,
			min = 1000,
			max = 20000,
			default = 15000,
			step = 100,
			desc = "Incoming healing required to activate Dark Regeneration."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Talent Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkspin",
			text = "Mortal Coil",
			key = "mortal_coil",
			default_spin = 85,
			default_check = true,
			desc = "Use at or under this HP value."
		},
		{
			type = "checkspin",
			text = "Burning Rush",
			key = "burning_rush",
			default_spin = 70,
			default_check = true,
			desc = "Minimum health required for Burning Rush."
		}
	}
}