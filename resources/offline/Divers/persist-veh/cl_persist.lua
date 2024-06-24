ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

-- RegisterCommand('ap', function()
	-- TriggerEvent("Persistance:addVehicles", GetVehiclePedIsIn(PlayerPedId(), false))
	-- print('add persistance véhicule')
-- end)

RegisterNetEvent('Persistance:addVehicles')
AddEventHandler('Persistance:addVehicles', function(vehicle)
    local vehProp = ESX.Game.GetVehicleProperties(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local table = {
        entity = netId,
        props = vehProp
    }
    TriggerServerEvent("AddTableVehicle", table)
end)

RegisterNetEvent('Persistance:removeVehicles')
AddEventHandler('Persistance:removeVehicles', function(vehicle)
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    
    TriggerServerEvent("RemoveTableVehicle", netId)
end)

RegisterNetEvent('Persistance:SpawnVehicles')
AddEventHandler('Persistance:SpawnVehicles', function(data)
    if data.props ~= nil then
        local vehicle = CreateVehiclePersist(data.props.model, data.pos, data.heading, data.props)
        TriggerEvent("Persistance:addVehicles", vehicle)
    end
end)

function CreateVehiclePersist(model, pos, heading, props)
	if not HasModelLoaded(model) and IsModelInCdimage(model) then
		RequestModel(model)
		while not HasModelLoaded(model) do
			Wait(0)
		end
	end

	local vehicle = CreateVehicle(model, pos.x, pos.y, pos.z, heading, true, false)
	local id = NetworkGetNetworkIdFromEntity(vehicle)
	SetNetworkIdCanMigrate(id, true)
	SetEntityAsMissionEntity(vehicle, true, false)
	SetVehicleHasBeenOwnedByPlayer(vehicle, true)
	SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehicleOnGroundProperly(vehicle)
	SetModelAsNoLongerNeeded(model)
	SetVehRadioStation(vehicle, 'OFF')

	if props then
		ESX.Game.SetVehicleProperties(vehicle, props)
        SetVehicleBodyHealth(vehicle, props.bodyHealth + 0.0)
        SetVehicleEngineHealth(vehicle, props.engineHealth + 0.0)
        SetVehicleDirtLevel(vehicle, props.dirtLevel + 0.0)
        if props.tyres then
			for tyreId = 1, 7, 1 do
				if (props.tyres[tyreId] ~= false) then
					SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
				end
			end
		end
        SetVehicleDoorsLocked(vehicle, props.locked)
		SetVehicleEngineOn(vehicle, props.engine, true, false)
	end

	RequestCollisionAtCoord(pos.x, pos.y, pos.z)
	local limit = 1
	while (not HasCollisionLoadedAroundEntity(vehicle) or not IsVehicleModLoadDone(vehicle)) and limit < 4000 do
		Wait(1)
		limit = limit + 1
		if limit == 4000 then
			DeleteEntity(vehicle)
		end
	end

	return vehicle
end