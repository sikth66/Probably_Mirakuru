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
end


-- Combat Rotation
local combatRotation = {}

-- Out of combat
local beforeCombat = {}

-- Register our rotation
ProbablyEngine.rotation.register_custom(258, "[|cff005522Mirakuru Rotations|r] Shadow Priest", combatRotation, beforeCombat, btn)