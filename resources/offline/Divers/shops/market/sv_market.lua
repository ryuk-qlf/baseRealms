RegisterNetEvent("marketPaiement")
AddEventHandler("marketPaiement", function(price, itemSelect, itemLabelSelect, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        if xPlayer.canCarryItem(itemSelect, quantity) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemSelect, quantity)
            xPlayer.showNotification('Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~'..price..'$~s~ pour '..quantity..' ~b~'..itemLabelSelect..'')  			
        else
            xPlayer.showNotification('Vous n\'avez pas assez de place.')
        end
    else
        xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..price..'$)')
    end
end)

RegisterNetEvent("marketBuy")
AddEventHandler("marketBuy", function(price, itemSelect, itemLabelSelect, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        if xPlayer.canCarryItem(itemSelect, quantity) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemSelect, quantity)
            xPlayer.showNotification('Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~'..price..'$~s~ pour '..quantity..' ~b~'..itemLabelSelect..'')  			
        else
            xPlayer.showNotification('Vous n\'avez pas assez de place.')
        end
    else
        xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..price..'$)')
    end
end)

RegisterNetEvent("shopBuy")
AddEventHandler("shopBuy", function(price, itemSelect, itemLabelSelect, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getMoney() >= price then
        if xPlayer.canCarryItem(itemSelect, quantity) then
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(itemSelect, quantity)
            xPlayer.showNotification('Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~'..price..'$~s~ pour '..quantity..' ~b~'..itemLabelSelect..'')  			
        else
            xPlayer.showNotification('Vous n\'avez pas assez de place.')
        end
    else
        xPlayer.showNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..price..'$)')
    end
end)