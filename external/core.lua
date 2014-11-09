--[[
	Core settings and functions for Mirakuru Profiles
	Created by Mirakuru
]]
miLib = {}
miLib.hasIntProcs = 0
miLib.affAuraProc = 0

-- Configure interface
function miLib.displayFrame(frame)
	local displayFrame, windowRef
	if not displayFrame then
		windowRef = ProbablyEngine.interface.buildGUI(frame)
		displayFrame = true
		windowRef.parent:SetEventListener('OnClose', function()
			displayFrame = false
		end)
	end
end

ProbablyEngine.library.register("miLib", miLib)