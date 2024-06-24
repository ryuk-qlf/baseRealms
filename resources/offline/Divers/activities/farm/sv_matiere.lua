local inFarm = {}
local MatiereListe = {
    ['cannabis_graine'] = {position = vector3(-298.33, 2526.82, 74.58)},
    ['coca'] = {position = vector3(2664.55, 3283.56, 55.24)},
    ['sodium_hydroxide'] = {position = vector3(959.53, -1144.75, 26.45)},
    ['acide'] = {position = vector3(2940.57, 4622.27, 48.72)},
    ['red_phosphore'] = {position = vector3(-685.46, 5793.67, 17.33)},
    ['planche'] = {position = vector3(1202.16, -1318.03, 35.22)},
    ['raisin'] = {position = vector3(-1867.461, 2235.968, 87.566)},
    ['fer'] = {position = vector3(2052.66, 3192.07, 45.18)},
    ['traitementConforama'] = {position = vector3(-108.61, -1060.16, 27.27)},
    ['traitementVigne'] = {position = vector3(612.97, 2794.14, 42.07)},
    ['traitementMatière'] = {position = vector3(-3112.82, 307.36, 3.77)},
    ['traitementFer'] = {position = vector3(135.40, -375.03, 43.25)},
    ['meuble'] = {position = vector3(1183.48, -3304.06, 6.91)},
    ['vin'] = {position = vector3(2547.82, 342.42, 108.46)},
}

function GetDiamondPlayer(src)
    local xPlayer = ESX.GetPlayerFromId(src)

    MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if result[1] then
            return true
        else
            if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
                return true
            elseif xPlayer.getGroup() == "user" then
                return false
            end
        end
    end)
end

local LimitFarm = {}
local PlayerDiamond = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _src = source
    
    if not PlayerDiamond[_src] then
        if GetDiamondPlayer(_src) ~= nil then
            PlayerDiamond[_src] = GetDiamondPlayer(_src)
        end
    end
end)

RegisterNetEvent('entreprise:startFarmMatiere')
AddEventHandler('entreprise:startFarmMatiere', function(itemToFarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    inFarm[source] = true

    if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe[itemToFarm].position) < 30 then
        farmItemMatiere(source, itemToFarm)
    else
        DropPlayer(source, "Cheat Farming")
    end
end)

RegisterNetEvent('entreprise:startFarm')
AddEventHandler('entreprise:startFarm', function(itemToFarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    inFarm[source] = true

    if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe[itemToFarm].position) < 30 then
        if PlayerDiamond[source] then
            farmItem(source, itemToFarm)
        else
            if not LimitFarm[xPlayer.identifier] then
                LimitFarm[xPlayer.identifier] = 1
            end
            farmItemNonDiamond(source, itemToFarm)
        end
    else
        DropPlayer(source, "Cheat Farming")
    end
end)

RegisterNetEvent('entreprise:startTrait')
AddEventHandler('entreprise:startTrait', function(itemToFarm, itemToRemove, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    inFarm[source] = true

    if type == 'conforama' then
        if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe['traitementConforama'].position) < 30 then 
            TraitItem(source, itemToFarm, itemToRemove)
        else
            DropPlayer(source, "Cheat Traitement")
        end
    elseif type == "vigne" then
        if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe['traitementVigne'].position) < 30 then 
            TraitItem(source, itemToFarm, itemToRemove)
        else
            DropPlayer(source, "Cheat Traitement")
        end
    elseif type == "motors&co" then
        if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe['traitementFer'].position) < 30 then 
            TraitItem(source, itemToFarm, itemToRemove)
        else
            DropPlayer(source, "Cheat Traitement")
        end
    end
end)

RegisterNetEvent('entreprise:startTraitMatiere')
AddEventHandler('entreprise:startTraitMatiere', function(itemToFarm, itemToRemove, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    inFarm[source] = true

    if type == "matière" then
        if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe['traitementMatière'].position) < 30 then 
            TraitItemMatiere(source, itemToFarm, itemToRemove)
        else
            DropPlayer(source, "Cheat Traitement")
        end
    end
end)

RegisterNetEvent('entreprise:startVente')
AddEventHandler('entreprise:startVente', function(itemToRemove)
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = 7
    inFarm[source] = true

    if #(GetEntityCoords(GetPlayerPed(source))-MatiereListe[itemToRemove].position) < 30 then 
        sellItem(source, itemToRemove, price)
    else
        DropPlayer(source, "Cheat Sell")
    end
end)

function farmItemNonDiamond(source, itemToFarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemToFarm)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if LimitFarm[xPlayer.identifier] < 451 then
                if xPlayer.canCarryItem(itemToFarm, 1) then
                    xPlayer.addInventoryItem(itemToFarm, 1)
                    LimitFarm[xPlayer.identifier] = LimitFarm[xPlayer.identifier] + 1
                    xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemCount.label .. '~s~. (~b~+1~s~)', 1500)
                    farmItemNonDiamond(source, itemToFarm)
                else
                    xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
                    inFarm[source] = false
                    TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
                end
            else
                xPlayer.showNotification("~r~Vous avez atteint la limite de farm.")
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source) 
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

function farmItem(source, itemToFarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemToFarm)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if xPlayer.canCarryItem(itemToFarm, 1) then
                xPlayer.addInventoryItem(itemToFarm, 1)
                xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemCount.label .. '~s~. (~b~+1~s~)', 1500)
                farmItem(source, itemToFarm)
            else
                xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

function farmItemMatiere(source, itemToFarm)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemCount = xPlayer.getInventoryItem(itemToFarm)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if exports["offline"]:GetCountJobInService("police") >= 1 then
                if xPlayer.canCarryItem(itemToFarm, 1) then
                    xPlayer.addInventoryItem(itemToFarm, 1)
                    xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemCount.label .. '~s~. (~b~+1~s~)', 1500)
                    farmItemMatiere(source, itemToFarm)
                else
                    xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
                    inFarm[source] = false
                    TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
                end
            else
                xPlayer.showNotification("~r~Impossible, pas de policier(s) en service.")
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

function TraitItem(source, itemToFarm, itemToRemove)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemToRemoveCount = xPlayer.getInventoryItem(itemToRemove)
    local itemToFarmLabel = xPlayer.getInventoryItem(itemToFarm)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if itemToRemoveCount.count >= 1 then
                if xPlayer.canCarryItem(itemToFarm, 1) then
                    xPlayer.removeInventoryItem(itemToRemove, 1)
                    xPlayer.addInventoryItem(itemToFarm, 1)
                    xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemToFarmLabel.label .. '~s~. (~b~+1~s~)', 1500)
                    TraitItem(source, itemToFarm, itemToRemove)
                else
                    xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
                    inFarm[source] = false
                    TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
                end
            else
                xPlayer.MissionText('~r~Vous n\'avez plus rien à traiter.', 1500)
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

function TraitItemMatiere(source, itemToFarm, itemToRemove)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemToRemoveCount = xPlayer.getInventoryItem(itemToRemove)
    local itemToFarmLabel = xPlayer.getInventoryItem(itemToFarm)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if exports["offline"]:GetCountJobInService("police") >= 1 then
                if itemToRemoveCount.count >= 1 then
                    if xPlayer.canCarryItem(itemToFarm, 1) then
                        xPlayer.removeInventoryItem(itemToRemove, 1)
                        xPlayer.addInventoryItem(itemToFarm, 1)
                        xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemToFarmLabel.label .. '~s~. (~b~+1~s~)', 1500)
                        TraitItemMatiere(source, itemToFarm, itemToRemove)
                    else
                        xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
                        inFarm[source] = false
                        TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
                    end
                else
                    xPlayer.MissionText('~r~Vous n\'avez plus rien à traiter.', 1500)
                    inFarm[source] = false
                    TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
                end
            else
                xPlayer.showNotification("~r~Impossible, pas de policier(s) en service.")
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

function sellItem(source, itemToRemove, price)
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemToRemoveCount = xPlayer.getInventoryItem(itemToRemove)

    SetTimeout(4000, function()
        if inFarm[source] == true then
            if itemToRemoveCount.count > 0 then
                xPlayer.removeInventoryItem(itemToRemove, 1)
                xPlayer.addMoney(price)
                xPlayer.MissionText('Vous avez vendu un(e) ~b~' .. itemToRemoveCount.label .. '~s~. (~g~+'..price..'$~s~)', 1500)
                sellItem(source, itemToRemove, price)
            else
                xPlayer.MissionText("~r~Vous n'avez plus rien à vendre sur vous.", 1500)
                inFarm[source] = false
                TriggerClientEvent("entreprise:stopFarm", xPlayer.source)
            end
        else
            xPlayer.MissionText('~r~Vous avez arreté la recolte.', 2000)
        end
    end)
end

RegisterNetEvent('entreprise:stopFarm')
AddEventHandler('entreprise:stopFarm', function()
    inFarm[source] = false
end)

ESX.RegisterServerCallback("GetPositionDrugs", function(source, cb)
    local pos1 = vector3(-298.33, 2526.82, 74.58)
    local pos2 = vector3(-3112.82, 307.36, 3.77)
    local pos3 = vector3(2664.55, 3283.56, 55.24)
    local pos4 = vector3(959.53, -1144.75, 26.45)
    local pos5 = vector3(2940.57, 4622.27, 48.72)
    local pos6 = vector3(-685.46, 5793.67, 17.33)

    cb({recGrainecanna = pos1, traitGrainecanna = pos2, recGrainecoca = pos3, recMethylamine = pos4, recAcidesulfurique = pos5, recPhosphorerouge = pos6})
end)