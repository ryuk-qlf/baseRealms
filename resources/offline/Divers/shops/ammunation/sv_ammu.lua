ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end) 

RegisterNetEvent('22ZDQDp_çéç232EppùDEQ2*p3ZDQ')
AddEventHandler('22ZDQDp_çéç232EppùDEQ2*p3ZDQ', function(price, itemSelect, itemLabelSelect, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)

   if xPlayer.getMoney() >= price then
		if xPlayer.canCarryItem(itemSelect, quantity) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemSelect, quantity)
            xPlayer.showNotification('Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~'..price..'$~s~ pour '..quantity..' ~b~'..itemLabelSelect..'')  			
        else
            xPlayer.showNotification('~r~Vous n\'avez pas assez de place.')
        end
    else
       xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..price..'$)')
    end
end)

ESX.RegisterServerCallback("GetTonCrewAmmu", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if result[1] ~= nil then
            cb(result[1].id_crew)
        else
            cb(nil)
        end
    end)
end)