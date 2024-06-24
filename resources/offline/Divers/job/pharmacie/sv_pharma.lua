ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("annoncePharma")
AddEventHandler("annoncePharma", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "pharma" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "Pharmacie", "~b~Annonce ", input, 'CHAR_MP_MORS_MUTUAL', 1)
    else
        DropPlayer(source, "cheat annoncePharma")
    end
end)