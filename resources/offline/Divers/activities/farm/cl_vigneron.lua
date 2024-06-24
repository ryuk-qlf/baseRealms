ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local inFarm = false

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local coords = GetEntityCoords(PlayerPedId(), false)
        local farmvin = Vdist2(coords, -1867.461, 2235.968, 87.566)
        local traitementvin = Vdist2(coords, 612.97, 2794.14, 42.07)
        local ventevin = Vdist2(coords, 2547.82, 342.42, 108.46)
        
        if PlayerData.job and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ems" then
            if farmvin <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startFarm', "raisin")
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            elseif traitementvin <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startTrait', "vin", "raisin", 'vigne')
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            elseif ventevin <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startVente', "vin")
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            else
                if inFarm then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                end
                wait = 5500
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('entreprise:stopFarm')
AddEventHandler('entreprise:stopFarm', function()
    inFarm = false
end)