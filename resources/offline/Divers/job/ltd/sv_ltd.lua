ESX = nil

TriggerEvent("LandLife:GetSharedObject", function(obj) ESX = obj end)

local JobLtd = {
    ['ltd'] = true,
    ['ltdgs'] = true,
    ['ltdfd'] = true,
    ['ltdnord'] = true,
}

RegisterNetEvent("AnnonceLtd")
AddEventHandler("AnnonceLtd", function(input, job)
    local xPlayer = ESX.GetPlayerFromId(source)

    if JobLtd[xPlayer.job.name] then
        TriggerClientEvent('esx:showAdvancedNotification', -1, job, "~b~Annonce", input, 'CHAR_CHAT_CALL', 1)
    else
        DropPlayer(source, "cheat AnnonceLtd")
    end
end)

RegisterNetEvent("LtdDecelerItem")
AddEventHandler("LtdDecelerItem", function(removeitem, additem, montant)
    print(removeitem, additem, montant)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem(removeitem).count >= montant then
        xPlayer.removeInventoryItem(removeitem, montant)
        xPlayer.addInventoryItem(additem, montant)
    else 
        xPlayer.showNotification("~r~Vous ne possédez pas cet objet.")
    end
end)