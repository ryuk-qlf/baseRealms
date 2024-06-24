RegisterNetEvent("pawnshopSell")
AddEventHandler("pawnshopSell", function(itemSelect, itemLabelSelect, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "pawnshop" or xPlayer.job.name == "pawnnord" then
        if xPlayer.getInventoryItem(itemSelect).count > 0 then
            xPlayer.removeInventoryItem(itemSelect, 1)
            xPlayer.addMoney(price)
        else 
            xPlayer.showNotification("~r~Vous ne possédez pas cet objet.")
        end
    else 
        DropPlayer(source, "cheat pawnshopSell")
    end
end)