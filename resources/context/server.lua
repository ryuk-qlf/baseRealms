ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

velo = {'bmx', 'cruiser', 'fixter', 'scorcher', 'tribike', 'tribike2', 'tribike3'}

Citizen.CreateThread(function()
    for k, v in pairs(velo) do
        ESX.RegisterUsableItem(v, function(source)
          local xPlayer = ESX.GetPlayerFromId(source)
          TriggerClientEvent('SpawnVelo', source, v)
          xPlayer.removeInventoryItem(v, 1)
        end)
    end
end)

ESX.RegisterServerCallback("AddBmxToPly", function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem(item, 1) then
		xPlayer.addInventoryItem(item, 1)
		cb(true)
	else
    	xPlayer.showNotification("~r~Vous n'avez pas assez de place pour porter cette charge.")
		cb(false)
	end
end)

RegisterServerEvent('EntitydragStatus')
AddEventHandler('EntitydragStatus', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerClientEvent('EntitydragStatus', target, xPlayer.source)
end)

RegisterServerEvent('NotificationdragStatus')
AddEventHandler('NotificationdragStatus', function(player)
	local xPlayer = ESX.GetPlayerFromId(player)

	xPlayer.showNotification('~r~Action impossible l\'individu doit être au sol.')
end)

RegisterServerEvent('putInVehicle')
AddEventHandler('putInVehicle', function(target)
	TriggerClientEvent('putInVehicle', target)
end)

RegisterServerEvent('OutVehicle')
AddEventHandler('OutVehicle', function(target)
	TriggerClientEvent('OutVehicle', target)
end)