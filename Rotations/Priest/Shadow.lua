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
	--ProbablyEngine.toggle.create('aoe', 'Interface\\Icons\\ability_warlock_fireandbrimstone.png', 'Enable AOE', "Enables the AOE rotation within the combat rotation.")	
	ProbablyEngine.toggle.create('GUI', 'Interface\\Icons\\trade_engineering.png"', 'GUI', 'Toggle GUI', (function() miLib.displayFrame(mirakuru_destru_config) end))
	
	-- Force open/close to save default settings
	--miLib.displayFrame(mirakuru_destru_config)
	--miLib.displayFrame(mirakuru_destru_config)
end


-- Combat Rotation
local combatRotation = {}

-- Out of combat
local beforeCombat = {}

-- Register our rotation
ProbablyEngine.rotation.register_custom(258, "[|cff005522Mirakuru Rotations|r] Shadow", combatRotation, beforeCombat, btn)