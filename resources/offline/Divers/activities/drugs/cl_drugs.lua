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

local SellActived = false
local InSell = false

-- RegisterCommand('zone', function()
--     local pos = GetEntityCoords(PlayerPedId())
--     local zone = GetNameOfZone(pos.x, pos.y, pos.z)

--     print(GetLabelText(zone))
-- end)

-- RegisterCommand('zone2', function()
--     local pos = GetEntityCoords(PlayerPedId())
    
--     print(GetNameOfZone(pos.x, pos.y, pos.z))
-- end)

RegisterNetEvent("ResellDrugs")
AddEventHandler("ResellDrugs", function()
    ESX.TriggerServerCallback('JobInService', function(count)
        if count >= 3 then
            SellActived = true
            selldrugs()
        end
    end, 'police')
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
    if not SellActived then
        if item == "coke" or item == "weed" or item == "meth" then

            if PlayerData.job.name == 'police' or PlayerData.job.name == 'ems' then
                return
            end

            for k, v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == item then
                    if v.count > 0 then
                        ESX.TriggerServerCallback('JobInService', function(count)
                            if count >= 0 then
                                SellActived = true
                                selldrugs()
                            else
                                ESX.DrawMissionText("~r~Impossible aucun clients..", 5000)
                            end
                        end, 'police')
                    end
                end
            end
        end
    end
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
    if SellActived then
        if item == "coke" or item == "weed" or item == "meth" then

            if PlayerData.job.name == 'police' or PlayerData.job.name == 'ems' then
                return
            end

            for k,v in pairs(ESX.GetPlayerData().inventory) do
                if v.name == item then
                    if v.count < 1 then
                        SellActived = false
                        InSell = false

                        if DoesBlipExist(Packet) then
                            RemoveBlip(Packet)
                        end
                    end
                end
            end
        end
    end
end)

function selldrugs()
    local InVeh = false
    local notSell = true
    local DistPos = 40
    local RandomTime = math.random(10000, 13000)
    local endTime = GetGameTimer() + RandomTime
    ESX.DrawMissionText("~r~Vous êtes à la recherche de clients..", RandomTime+250)

    while GetGameTimer() < endTime do
        Wait(0)
        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            if DoesBlipExist(Packet) then
                RemoveBlip(Packet)
            end
            outPosition = nil
            retval = nil
            InVeh = true
            ESX.DrawMissionText(" ", 500)
        else
            if InVeh then
                outPosition = nil
                retval = nil
                InSell = false
                SellActived = false
                InVeh = false
                selldrugs()
            end
        end
    end

    local PlyCoords = GetEntityCoords(PlayerPedId(), false)
    local retval, outPosition = GetSafeCoordForPed(PlyCoords.x + GetRandomIntInRange(-DistPos, DistPos), PlyCoords.y + GetRandomIntInRange(-DistPos, DistPos), PlyCoords.z, true, 0, 16)
    local xtime = RandomTime -100
    if outPosition == vector3(0, 0, 0) then
        while outPosition == vector3(0, 0, 0) do
            print('oo')
            Wait(50)
            ESX.DrawMissionText("~r~Vous êtes à la recherche de clients..", 150)
            pPos = GetEntityCoords(PlayerPedId(), false)
            xtime = xtime -100

            retval, outPosition = GetSafeCoordForPed(pPos.x + GetRandomIntInRange(-DistPos, DistPos), pPos.y + GetRandomIntInRange(-DistPos, DistPos), pPos.z, true, 0, 16)

            if xtime < 0 then
                outPosition = nil
                retval = nil
                InSell = false
                SellActived = false
                selldrugs()
                break
            end
        end
    end

    if not DoesBlipExist(Packet) then
        if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            ESX.DrawMissionText("Un point de livraison a été marqué dans la zone", 3000)
            Packet = AddBlipForCoord(outPosition)
            SetBlipSprite(Packet, 501)
            SetBlipDisplay(Packet, 4)
            SetBlipScale(Packet, 0.85)
            SetBlipColour(Packet, 2)
            SetBlipAsShortRange(Packet, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Client")
            EndTextCommandSetBlipName(Packet)
        end

        Wait(1000)

        InSell = true
        while InSell do
            Wait(0)

            if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                if DoesBlipExist(Packet) then
                    RemoveBlip(Packet)
                end
                outPosition = nil
                retval = nil
                InVeh = true
                ESX.DrawMissionText(" ", 500)
            else
                if InVeh then
                    outPosition = nil
                    retval = nil
                    InSell = false
                    SellActived = false
                    InVeh = false
                    selldrugs()
                end
            end
            
            if outPosition ~= nil then
                DrawMarker(1, outPosition-1.0, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.0, 1.0, 1.0, 240, 200, 80, 100, false, false, 2, false, false, false, false)
                if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), false), outPosition, true) <= 1.8 then
                    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~déposer votre drogue~s~.")
                        if IsControlJustPressed(1, 51) then
                            if math.random(0, 6) == 1 then
                                TriggerServerEvent("call:makeCallSpecial", "police", GetEntityCoords(PlayerPedId()), "Vente de drogue.")
                            end
                            ESX.Streaming.RequestAnimDict("pickup_object")
                            TaskPlayAnim(GetPlayerPed(-1), "pickup_object", "pickup_low", 8.0, 8.0, -1, 0, 1, 0, 0, 0)
                            if DoesBlipExist(Packet) then
                                RemoveBlip(Packet)
                            end
                            TriggerServerEvent('VenteDeDrogue')
                            outPosition = nil
                            retval = nil
                            InSell = false
                            SellActived = false
                            notSell = false
                        end
                    end
                end

                if notSell then
                    if GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1), false), outPosition, true) >= 250 then
                        if DoesBlipExist(Packet) then
                            RemoveBlip(Packet)
                        end
                        outPosition = nil
                        retval = nil
                        InSell = false
                        SellActived = false
                        selldrugs()
                    end
                end
            end
        end
    end
end