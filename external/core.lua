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

-- Shadow multidotting counters
miLib.vt = 0
miLib.swp = 0
miLib.vent = 0

-- Proc Counters
miLib.hasIntProcs = 0
miLib.affAuraProc = 0
miLib.hasCritProc = 0

-- Last registered proc timers
miLib.critTimer = 0
miLib.intProcTimer = 0

-- Register commands
ProbablyEngine.command.register('miracle', function(msg, box)
local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == "config" or command == "settings" then
		if GetSpecializationInfo(GetSpecialization()) == 265 then
			miLib.displayFrame(mirakuru_aff_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 267 then
			miLib.displayFrame(mirakuru_destru_config)
		elseif GetSpecializationInfo(GetSpecialization()) == 258 then
			miLib.displayFrame(mirakuru_shadow_config)
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

-- Rounding function
function miLib.round(num, idp)
	return tonumber(string.format("%." .. (idp or 0) .. "f", num))
end

-- Crowd Control abilities
function miLib.CC(unit)
	local CC = {118,28272,28271,61305,61721,61780,9484,3355,19386,339,6770,6358,20066,51514,115078,115268}
	for i=1,#CC do
		if UnitDebuff(unit,GetSpellInfo(CC[i])) then return true end
	end
	return false
end

--[[function getCreatureType(unit)
	local creature = {"Critter", "Totem", "Non-combat Pet", "Wild Pet"}
	for i=1, #creature do
		if UnitCreatureType(unit) == creature[i] then return false end
	end
	
	-- Battle Pets
	if UnitIsBattlePet(unit)
		and UnitIsWildBattlePet(unit) then return false else return true end
end]]

-- Checks if a unit is within our 180 degree cone of attack
function infront(unit)
	local aX, aY, aZ = ObjectPosition(unit)
	local bX, bY, bZ = ObjectPosition('player')
	local playerFacing = GetPlayerFacing()
	local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
	return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
end

ProbablyEngine.library.register("miLib", miLib)