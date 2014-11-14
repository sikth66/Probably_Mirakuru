--[[
	Core settings and functions for Mirakuru Profiles
	Created by Mirakuru
]]
-- Library Table
miLib = {}

-- Multidotting counters
miLib.auCount = 0
miLib.corrCount = 0
miLib.immoCount = 0
miLib.agonyCount = 0

-- Proc Counters
miLib.hasIntProcs = 0
miLib.affAuraProc = 0

-- Last Intellect proc timer
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

-- Test
--[[
local PI_2 = (math.pi * 2)
function infront(a, b)
	local aX, aY, aZ = ObjectPosition(a)
	local bX, bY, bZ = ObjectPosition(b)
	local playerFacing = GetPlayerFacing()
	local facing = math.atan2(bY - aY, bX - aX) % PI_2
	return math.abs(math.deg(playerFacing - facing)) > 90
end]]
function infront(unit)
	local aX, aY, aZ = ObjectPosition(unit)
	local bX, bY, bZ = ObjectPosition('player')
	local playerFacing = GetPlayerFacing()
	local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
	return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
end

ProbablyEngine.library.register("miLib", miLib)