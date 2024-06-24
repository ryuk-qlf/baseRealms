ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj)
    ESX = obj 
end)

local JobCustoms = {
    ['bennys'] = true,
    ['sandybennys'] = true,
    ['lscustoms'] = true,
}

RegisterServerEvent('BuyLsCustoms')
AddEventHandler('BuyLsCustoms', function(newVehProps, amount)
	local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local job = xPlayer.job.name
	local societyAccount = nil
    local price = tonumber(amount)

    if JobCustoms[job] then
        TriggerEvent('GetMoneySv', job, function(account)
            local societyAccount = account

            if societyAccount ~= nil and tonumber(societyAccount) >= price then
                TriggerEvent("SetPropsVehiclePlate", newVehProps.plate, newVehProps)
                TriggerEvent("RemoveMoneySociety", job, price)
        
                xPlayer.showNotification("Vous avez ~g~installé~s~ toutes ~g~les modifications~s~.")
                xPlayer.showNotification("Vous avez modifier le véhicule ~g~"..price.."$~s~ on été retiré de l\'entreprise.")
            else
                TriggerClientEvent('CancelLsCustoms', _src)
            end
        end)
    end
end)