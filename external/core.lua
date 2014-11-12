--[[
	Core settings and functions for Mirakuru Profiles
	Created by Mirakuru
]]
miLib = {}
miLib.hasIntProcs = 0
miLib.affAuraProc = 0
miLib.intProcTimer = 0

-- Register commands
ProbablyEngine.command.register('miracle', function(msg, box)
local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == "config" or command == "settings" then
		if GetSpecializationInfo(GetSpecialization()) == 265 then
			miLib.displayFrame(mirakuru_aff_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 267 then
			miLib.displayFrame(mirakuru_destru_config)
		end		
	end
end)

-- Configure interface
function miLib.displayFrame(frame)
	if not createFrame then
		windowRef = ProbablyEngine.interface.buildGUI(frame)
		createFrame = true
		frameState = true
		
		windowRef.parent:SetEventListener('OnClose', function()
			createFrame = false
			frameState = false
		end)

	elseif createFrame == true and frameState == true then
		windowRef.parent:Hide()
		frameState = false

	elseif createFrame == true and frameState == false then
		windowRef.parent:Show()
		frameState = true
	end
end

ProbablyEngine.library.register("miLib", miLib)