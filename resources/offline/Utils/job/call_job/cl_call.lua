ESX = nil

local callActive = false
local work = {}
local target = {}
local soundid = GetSoundId() 

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

Citizen.CreateThread(function()
    while true do
		local time = 1000
		if callActive then
			time = 1
		end
		if callActive and IsControlJustPressed(1, 246) then
			RemoveBlip(target.blip)
			target.blip = AddBlipForCoord(target.pos.x, target.pos.y, target.pos.z)
			SetBlipRoute(target.blip, true)
			if soundid ~= nil then
				StopSound(soundid)
			end
			TriggerServerEvent("call:AccepteCall", ESX.PlayerData.job.name)
			callActive = false
		end
		if callActive and IsControlJustPressed(1, 75) then
			if soundid ~= nil then
				StopSound(soundid)
			end
			ESX.ShowNotification("Vous avez ~r~refusé~s~ la demande.")
			callActive = false
		end
		local playerPos = GetEntityCoords(PlayerPedId(), true)
		if target.pos ~= nil then
			coords = vector3(target.pos.x, target.pos.y, target.pos.z)
		end
		if target.pos ~= nil and GetDistanceBetweenCoords(playerPos, coords, false) < 5 then
			RemoveBlip(target.blip)
		end
		Wait(time)
	end
end)

RegisterNetEvent("call:callIncoming")
AddEventHandler("call:callIncoming", function(job, pos, msg, type)
    work = job
    target.pos = pos
	coords = GetEntityCoords(GetPlayerPed(-1))
	dist = CalculateTravelDistanceBetweenPoints(coords.x, coords.y, coords.z, target.pos.x, target.pos.y, target.pos.z)
	if dist >= 10000.0 then
		dist = 'Plus de 10 KM'
		streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(target.pos.x, target.pos.y, target.pos.z)).. " ("..dist..")"
	else
		streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(target.pos.x, target.pos.y, target.pos.z)).. " ("..math.ceil(dist).."m)"
	end
	if type ~= "fire" then
		callActive = true
		ESX.ShowAdvancedNotification('Centrale', '~b~Appel d\'urgence: 911', '~b~Localisation : ~s~'..streetname..'\n~b~Infos :~s~ '..msg..'', "CHAR_CALL911", 1)
		ESX.ShowNotification("Appuyez sur vos touches.\n~b~(Y/F)")
	end
	if type == "code99" then
		if soundid then
			StopSound(soundid)
		end
		PlaySoundFrontend(soundid, "Arming_Countdown", "GTAO_Speed_Convoy_Soundset", 0)
	elseif type == "fire" then
		local zone = GetNameOfZone(target.pos.x, target.pos.y, target.pos.z)

		ESX.ShowAdvancedNotification('Centrale', '~b~Appel d\'urgence: 911', '~b~Localisation : ~s~('..GetLabelText(zone)..') '..streetname..'\n~b~Infos :~s~ '..msg..'', "CHAR_CALL911", 1)
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)
	else
		PlaySoundFrontend(-1, "Start_Squelch", "CB_RADIO_SFX", 0)	
	end
end)

AddEventHandler('playerDropped', function()
	TriggerServerEvent("player:serviceOff", nil)
end)

RegisterCommand("annulerappel", function()
	if DoesBlipExist(target.blip) then
		RemoveBlip(target.blip)
	end	
end)

-- Exemple Call --

-- RegisterCommand("sv", function()
-- 	sv = not sv
-- 	if sv then
-- 		print('on')
-- 		TriggerServerEvent("player:serviceOn", "police")
-- 	else
-- 		print('off')
-- 		TriggerServerEvent("player:serviceOff", "police")
-- 	end
-- end)

-- RegisterCommand("cop", function()
-- 	ESX.TriggerServerCallback('JobInService',function(count)
-- 		if count >= 1 then
-- 			print(count)
-- 		else
-- 			print(count)
-- 		end
--  end, 'police')
-- end)

-- RegisterCommand("call", function()
-- 	TriggerServerEvent("call:makeCallSpecial", "police", GetEntityCoords(GetPlayerPed(-1)),"Demande de renfort")
-- end)