--[[
	Interface file for Mirakuru Profiles
	Created by Mirakuru
]]
ProbablyEngine.command.register('miracle', function(msg, box)
local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == "config" or command == "settings" then
		ProbablyEngine.interface.buildGUI(mirakuru_aff_config)
	end
end)

mirakuru_aff_config = {
	key = "miraAffConfig",
	title = "Affliction Warlock",
	subtitle = "Configuration",
	color = "a9013f",
	width = 215,
	height = 350,
	config = {
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
			default = 4,
			desc = "Start AoEing at this unit count."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Multi-dotting Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "spinner",
			text = "Agony Count",
			key = "agony_units",
			default = 4,
			desc = "How many units to cast Agony on when multidotting."
		},
		{
			type = "spinner",
			text = "Corruption Count",
			key = "corruption_units",
			default = 4,
			desc = "How many units to cast Corruption on when multidotting."
		},
		{
			type = "spinner",
			text = "Unstable Affliction Count",
			key = "corruption_units",
			default = 4,
			desc = "How many units to cast Unstable Affliction on when multidotting."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Grimoire Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "dropdown",
			text = "Select Pet",
			key = "petSelection",
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
			desc = "Set which pet to summon or sacrifice.",
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
			text = "Unending Resolve",
			key = "unending_resolve",
			default_spin = 35,
			default_check = false,
			desc = "Activates after reaching this HP value."
		},
		{type = "spacer"},{type = "spacer"},
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
			default = 8000,
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