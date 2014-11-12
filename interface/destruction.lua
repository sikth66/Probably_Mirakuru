--[[
	Interface file for Destruction [Mirakuru Profiles]
	Created by Mirakuru
]]
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
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Use Cataclysm in Single-target rotation.",
			key = "cata_st",
			desc = "Enables the use of Cataclysm in both the single-target and AOE rotations."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Only use cooldowns on bosses.",
			key = "cd_bosses_only",
			desc = "Forces the combat rotation to only use long-term cooldowns on Boss type units."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Command Demon",
			key = "command_demon",
			desc = "Enables the Combat Rotation to control your demon for you in combat using smart-logic."
		},
		{type = "spacer"},
		{
			type = "checkspin",
			default_check = true,
			default_spin = 35,
			width = 50,
			text = "Healing Tonic \ Healthstone",
			key = "hs_pot_healing",
			desc = "Enable automatic usage of Healing Tonic or Healthstone when your HP drops bellow this %."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Destruction Specific Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = true,
			text = "Use Rain of Fire in Single-target rotation.",
			key = "rof_st",
			desc = "Enables the use of Rain of Fire in the Single Target rotation."
		},
		{type = "spacer"},
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
			text = "Min. Embers for Chaos Bolt",
			key = "embers_cb",
			width = 50,
			min = 0,
			max = 40,
			default = 20,
			step = 0.1,
			desc = "This setting is ignored with temporary crit buffs! Minimum Embers before casting Chaos Bolt."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "Max Embers for Chaos Bolt",
			key = "embers_cb_max",
			width = 50,
			min = 0,
			max = 40,
			default = 30,
			step = 0.1,
			desc = "This setting is ignored with temporary crit buffs! Maximum Embers before casting Chaos Bolt."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "AOE Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "spinner",
			text = "AOE Unit Count",
			key = "aoe_units",
			width = 50,
			default = 4,
			desc = "When enabled, start AoEing at this unit threshold."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "spinner",
			text = "Min. Embers for Fire and Brimstone",
			key = "embers_fnb",
			width = 50,
			min = 0,
			max = 40,
			default = 15,
			step = 0.1,
			desc = "Minimum embers before casting Fire and Brimstone to start AOEing."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "AoE Chaos Bolt minimum units",
			key = "cb_fnb_units",
			width = 50,
			min = 0,
			max = 40,
			default = 4,
			step = 1,
			desc = "Minimum units in range required to cast Chaos Bolt with Fire and Brimstone without Charred Remains."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "AoE Chaos Bolt minimum Embers",
			key = "cb_fnb_embers",
			width = 50,
			min = 0,
			max = 40,
			default = 25,
			step = 1,
			desc = "Minimum Embers to cast Chaos Bolt during Fire and Brimstone with Charred Remains."
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
			default = true,
			text = "Auto Summon Pet",
			key = "auto_summon_pet",
			desc = "Automatically summon the selected pet when it's dead or no pets are active!"
		},
		{
			type = "checkbox",
			default = true,
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