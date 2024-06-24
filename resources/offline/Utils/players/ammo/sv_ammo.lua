ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("removeAmmoBox")
AddEventHandler("removeAmmoBox", function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xItem = xPlayer.getInventoryItem(item)

    if xItem ~= nil then
        if xItem.count > 0 then
            xPlayer.removeInventoryItem(item, count)
        end
    end
end)