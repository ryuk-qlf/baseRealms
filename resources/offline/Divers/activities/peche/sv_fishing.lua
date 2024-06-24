ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('cannepeche', function(source)
	TriggerClientEvent("usecanne", source)
end)

RegisterServerEvent("PechePoisson")
AddEventHandler("PechePoisson", function()
    local chance = math.random(0, 70)
    local xPlayer = ESX.GetPlayerFromId(source)

    local coords = GetEntityCoords(GetPlayerPed(source))

    for k, v in pairs(Fishing.FishingZone) do
        local distance = #(coords-v.pos)
        if distance <= 50 then 
            if chance >= 0 and chance <= 10 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Truite Arc-en-Ciel.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[1], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[1], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 10 and chance <= 15 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché un ~g~Kokanee.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[2], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[2], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 15 and chance <= 16 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Ombre de l\'artique.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[3], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[3], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 16 and chance <= 20 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~ Perche Roock.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[4], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[4], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 20 and chance <= 26 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Petite Bouche.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[5], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[5], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 26 and chance <= 30 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Grande Bouche.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[6], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[6], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 30 and chance <= 37 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Truite Bull.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[7], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[7], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 37 and chance <= 40 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Truite de Lac.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[8], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[8], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 40 and chance <= 46 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché un ~g~Chinook.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[9], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[9], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 46 and chance <= 56 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché un ~g~Esturgeon Pâle.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[10], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[10], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 56 and chance <= 62 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché une ~g~Spatules.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[11], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[11], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            elseif chance >= 62 and chance <= 70 then
                TriggerClientEvent('esx:DrawMissionText', source, 'Vous avez pêché un ~g~Gardon.~g~ +1', 4500)
                if xPlayer.canCarryItem(Fishing.Peche.item[12], 1) then
                    xPlayer.addInventoryItem(Fishing.Peche.item[12], 1)
                else
                    xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
                end
            end 
        end
    end
end)


local MyItemFishing = {
    ['truitearc'] = {price = 12},
    ['kokanee'] = {price = 15},
    ['ombrearctique'] = {price = 168},
    ['percherock'] = {price = 41},
    ['petitebouche'] = {price = 20},
    ['grandbouche'] = {price = 47},
    ['truitebull'] = {price = 15},
    ['truitelac'] = {price = 62},
    ['chinook'] = {price = 23},
    ['esturgeonpale'] = {price = 11},
    ['spatules'] = {price = 17},
    ['gardon'] = {price = 26},
}

RegisterNetEvent("fishingSell")
AddEventHandler("fishingSell", function(itemSelect, itemLabelSelect, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local item = xPlayer.getInventoryItem(itemSelect).count
    
    if MyItemFishing[itemSelect] then 
        if MyItemFishing[itemSelect].price == price then 
            if tonumber(item) > 0 then 
                xPlayer.removeInventoryItem(itemSelect, 1)
                xPlayer.addMoney(price)
                xPlayer.showNotification("~r~Vous avez vendu ~b~"..itemLabelSelect.."~s~ à ~g~"..price.."$~s~.")
            else 
                xPlayer.showNotification("~r~Vous ne possédez pas ce poisson.")
            end
        else
            DropPlayer(source, 'Cheateur')
        end
    else
        DropPlayer(source, 'Cheateur')
    end
end)