RegisterNetEvent("buyBike")
AddEventHandler("buyBike", function(price, itemSelect, itemLabelSelect)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
		if xPlayer.canCarryItem(itemSelect, 1) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemSelect, 1)
            xPlayer.showNotification('Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~'..price..'$~s~ pour '..itemLabelSelect..'')
        else
            xPlayer.showNotification('~r~Vous n\'avez pas assez de place.')
        end
    else
       xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..price..'$)')
    end
end)