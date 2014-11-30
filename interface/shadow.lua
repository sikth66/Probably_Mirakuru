--[[
	Interface file for Shadow Priest [Mirakuru Profiles]
	Created by Mirakuru
]]
mirakuru_shadow_config = {
	key = "miraShadowConfig",
	profiles = true,
	title = "Shadow Priest",
	subtitle = "Configuration",
	color = "005522",
	width = 250,
	height = 450,
	config = {
		{type = "spacer"},
		{
			type = "texture",texture = "Interface\\AddOns\\Probably_Mirakuru\\interface\\media\\splash.blp",
			width = 100,
			height = 100,
			offset = 70,
			y = 40,
			center = true
		},
		{type = "spacer"},{type = "spacer"},{type = "spacer"},
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
			desc = "Automatically sets a new target should your current target die or disappear."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = false,
			text = "Force Attack",
			key = "force_attack",
			desc = "Forces the combat routine to attack your target, even when not in combat."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Party/Raid Buffing",
			key = "buff_raid",
			desc = "Enables the combat routine to scan and buff your raid or party."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Use run speed increases",
			key = "speed_increase",
			desc = "Automatically use Angelic Feathers or Power Word: Shield to increase your run speed."
		},
		{
			type = "checkbox",
			default = false,
			text = "... Only in Combat.",
			key = "speed_increase_combat",
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Combat Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = true,
			text = "Save cooldowns for bosses",
			key = "cd_bosses_only",
			desc = "When enabled, forces the combat routine to hold CDs until you target a boss."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Automatically use level 90 talents",
			key = "l90_talents",
			desc = "When enabled, the combat routine will determine the most optimal use of your level 90 talent."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Multi-target Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "spinner",
			text = "Mind Sear",
			key = "msear_units",
			width = 50,
			min = 0,
			max = 20,
			default = 4,
			step = 1,
			desc = "Minimum number of enemies required to cast Mind Sear."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "Shadow Word: Pain",
			key = "swp_count",
			default = 4,
			min = 0,
			max = 20,
			width = 50,
			desc = "Maximum number of units to cast Shadow Word: Pain on in combat."
		},
		{type = "spacer"},
		{
			type = "spinner",
			text = "Vampiric Touch",
			key = "vt_count",
			default = 4,
			min = 0,
			max = 20,
			width = 50,
			desc = "Maximum number of units to cast Vampiric Touch on in combat."
		},
		{type = "spacer"},{type = "spacer"},
		{
			type = "header",
			text = "Defensive Settings",
			align = "center",
		},
		{type = "rule"},
		{
			type = "checkbox",
			default = true,
			text = "Auto Fade",
			key = "fade",
			desc = "Automatically use Fade when glyphed."
		},
		{type = "spacer"},
		{
			type = "checkbox",
			default = true,
			text = "Auto Void Tendrils",
			key = "tendrils",
			desc = "Automatically counter enemies by using Void Tendrils when they get too close."
		},
		{type = "spacer"},
		{
			type = "checkspin",
			default_check = true,
			default_spin = 19,
			width = 50,
			text = "Dispersion",
			key = "dispersion",
			desc = "Use Dispersion in emergencies or to counter boss mechanics when available."
		},
		{type = "spacer"},
		{
			type = "checkspin",
			default_check = true,
			default_spin = 35,
			width = 50,
			text = "Healthstone / Healing Tonic",
			key = "stone_pot",
			desc = "Automatically use Healthstone or Healing Tonic when you reach this health percentage."
		},
	}
}