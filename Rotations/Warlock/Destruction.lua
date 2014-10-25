--[[
	Destruction Warlock Custom ProbablyEngine Rotation Profile
	Created by Mirakuru
	
	Fully updated for Warlords of Draenor!
	- More advanced encounter-specific coming with the release of WoD raids
]]

-- Toggles
local lib = function()
	ProbablyEngine.toggle.create('test','Interface\\Icons\\inv_misc_trinket6oih_orb2','Test Button','Just a test button!')
end

ProbablyEngine.rotation.register_custom(267, "Mirakuru", {
  -- Your Rotation Here!
}, {}, lib)

--local combatRotation = {}
--local outOfCombat = {}

--ProbablyEngine.rotation.register_custom(267, ' |cff9966ffCharred Remains|r ', inCombat, outCombat, lib)