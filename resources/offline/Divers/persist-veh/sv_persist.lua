ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local VehicleList = {}

Citizen.CreateThread(function()
    while true do
        Wait(10000)
        CreateAllVehicleDelete()
    end
end)

function GetVehicleEntityFromNetId(netId)
    local vehicles = GetAllVehicles()
    for i = 1, #vehicles do
        if NetworkGetNetworkIdFromEntity(vehicles[i]) == netId then
            return vehicles[i]
        end
    end
    return false
end

function GetClosestPlayerToCoords(coords, distance)
    local closestPlayerId = nil

    for k, v in pairs(ESX.GetPlayers()) do
        local pId = v
        local dist = #(GetEntityCoords(GetPlayerPed(pId))-coords)

        if dist < distance then
            closestPlayerId = pId
        end
    end
    return closestPlayerId
end

RegisterNetEvent("AddTableVehicle")
AddEventHandler("AddTableVehicle", function(props)
    for k, index in pairs(VehicleList) do
        if index.entity == props.entity then
            return
        end
    end
    table.insert(VehicleList, props)
    for k, v in pairs(VehicleList) do
        if v.entity == props.entity then
            v.entity = GetVehicleEntityFromNetId(v.entity)
            v.pos = GetEntityCoords(v.entity)
            v.heading = GetEntityHeading(v.entity)
            print('add table')
            break
        end
    end
end)

RegisterNetEvent("RemoveTableVehicle")
AddEventHandler("RemoveTableVehicle", function(netId)
    for i = 1, #VehicleList do    
        if VehicleList[i].entity == GetVehicleEntityFromNetId(netId) then
            table.remove(VehicleList, i)
            print('remove table')
            break
        end
    end
end)

function CreateAllVehicleDelete()
    for i = 1, #VehicleList do
        if VehicleList[i] ~= nil then
            if DoesEntityExist(VehicleList[i].entity) then
                VehicleList[i].pos = GetEntityCoords(VehicleList[i].entity)
                VehicleList[i].heading = GetEntityHeading(VehicleList[i].entity)

                VehicleList[i].props.bodyHealth = GetVehicleBodyHealth(VehicleList[i].entity)
                VehicleList[i].props.engineHealth = GetVehicleEngineHealth(VehicleList[i].entity)
                VehicleList[i].props.dirtLevel = GetVehicleDirtLevel(VehicleList[i].entity)
                VehicleList[i].props.locked = GetVehicleDoorLockStatus(VehicleList[i].entity)
                VehicleList[i].props.engine = GetIsVehicleEngineRunning(VehicleList[i].entity)
            else
                if VehicleList[i].pos ~= vector3(0, 0, 0) then
                    local closestPlayerId = GetClosestPlayerToCoords(VehicleList[i].pos, 500)
                    if closestPlayerId ~= nil then
                        print('create veh delete')
                        TriggerClientEvent("Persistance:SpawnVehicles", closestPlayerId, VehicleList[i])
                        table.remove(VehicleList, i)
                    else
                        print('joueur trop loin')
                    end
                end
            end
        end
    end
end