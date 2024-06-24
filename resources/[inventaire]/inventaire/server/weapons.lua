ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    MySQL.Async.fetchAll('SELECT * FROM items WHERE LCASE(name) LIKE \'%weapon_%\'', {}, function(results)
        for k, v in pairs(results) do
            ESX.RegisterUsableItem(v.name, function(source)
                TriggerClientEvent('WeaponItem:useWeapon', source, v.name)
            end)
        end
    end)
end)

RegisterNetEvent('WeaponItem:removeItem')
AddEventHandler('WeaponItem:removeItem', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(item, 1)
end)

ESX.RegisterUsableItem('flashlight', function(source)
    TriggerClientEvent('WeaponItem:useWeaponFlashlight', source)
end)

ESX.RegisterUsableItem('camera', function(source)
    TriggerClientEvent('ToggleCamWeazel', source)
end)

ESX.RegisterUsableItem('micro', function(source)
    TriggerClientEvent('ToggleMicroWeazel', source)
end)

ESX.RegisterUsableItem('microperche', function(source)
    TriggerClientEvent('ToggleMicroPercheWeazel', source)
end)