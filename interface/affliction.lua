--[[
	Interface file for Affliction [Mirakuru Profiles]
	Created by Mirakuru
]]
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
			text = "AOE Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "spinner",
			text = "AOE Unit Count",
			key = "aoe_units",
			default = 5,
			width = 50,
			desc = "When enabled, start AoEing at this unit threshold."
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
			width = 50,
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
					key = "111859"
				},
				{
					text = "Voidwalker",
					key = "111895"
				},
				{
					text = "Felhunter",
					key = "111897"
				},
				{
					text = "Succubus",
					key = "111896"
				},
				{
					text = "Doomguard",
					key = "157906"
				},
				{
					text = "Infernal",
					key = "157907"
				}
			},
			desc = "Set which pet use for Grimoire of Service.",
			default = "111897",
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