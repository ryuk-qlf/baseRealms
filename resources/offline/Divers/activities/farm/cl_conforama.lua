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

local Conforama = {
    AssetJob = {
        PositionVehCreate = vector3(53.42, -1728.98, 29.30),
        Heading = 50.0, 
        ModelVeh = "utillitruck2"
    },
}

local inFarm = false

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local coords = GetEntityCoords(PlayerPedId(), false)
        local farmPlanche = GetDistanceBetweenCoords(coords, vector3(1202.16, -1318.03, 35.22), true)
        local traitementPlanche = GetDistanceBetweenCoords(coords, vector3(-108.61, -1060.16, 27.27), true)
        local venteMeuble = GetDistanceBetweenCoords(coords, vector3(1183.48, -3304.06, 6.91), true)

        if PlayerData.job and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ems" then
            if farmPlanche <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        TriggerServerEvent('entreprise:startFarm', "planche")
                        inFarm = true
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            elseif traitementPlanche <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startTrait', "meuble", "planche", 'conforama')
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            elseif venteMeuble <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startVente', "meuble")
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

CreateThread(function()
    while true do
        local xtime = 1000
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = GetDistanceBetweenCoords(plyCoords, vector3(58.92, -1733.58, 29.30), true)
        local dist2 = GetDistanceBetweenCoords(plyCoords, vector3(43.50, -1723.67, 29.30), true)
        
        if PlayerData.job and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ems" then
            if dist <= 1.5 then
                xtime = 5
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Cassandra~s~")
                if IsControlJustPressed(0, 51) then                   
                    if not ESX.Game.IsSpawnPointClear(Conforama.AssetJob.PositionVehCreate, 5) then
                        ESX.ShowNotification("Il y'a déjà un véhicule sur place")	
                    else
                        RequestModel(Conforama.AssetJob.ModelVeh)
                        while not HasModelLoaded(Conforama.AssetJob.ModelVeh) do
                            Wait(100)
                        end
                        local Veh = CreateVehicle(Conforama.AssetJob.ModelVeh, Conforama.AssetJob.PositionVehCreate, Conforama.AssetJob.Heading, true, false)
                        SetVehicleFixed(Veh)
                        TaskWarpPedIntoVehicle(PlayerPedId(), Veh, -1)
                        SetEntityAsMissionEntity(Veh, true, false)
                        SetVehRadioStation(Veh, 0)
                        Wait(350)
                    end
                end
            end

            if dist2 <= 7.5 and IsPedInAnyVehicle(PlayerPedId(), false) then
                xtime = 5
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~ranger le véhicule~s~")
                if IsControlJustPressed(0, 51) then
                    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                    local props = ESX.Game.GetVehicleProperties(vehicle)

                    if props.model == GetHashKey("utillitruck2") then
                        ESX.Game.DeleteVehicle(vehicle)
                        ESX.ShowNotification("Vous avez ranger le ~g~véhicule~s~ du conforama.")
                    else
                        ESX.ShowNotification("~r~Vous ne pouvez pas ranger se véhicule.")
                    end
                end
            end
        end
        Wait(xtime)
    end
end)