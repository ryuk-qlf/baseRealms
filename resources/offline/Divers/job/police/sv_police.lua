ESX = nil

TriggerEvent("LandLife:GetSharedObject", function(obj) ESX = obj end)

ESX.RegisterUsableItem('handcuff', function(source)
    TriggerClientEvent('MenotterPlayer', source)
end)

RegisterNetEvent("MenotterPly")
AddEventHandler("MenotterPly", function(Target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(Target)

    if xPlayer.job.name == "police" or xPlayer.job.name == "lssd" or xPlayer.job.name == "usss" then
        if xPlayer.getInventoryItem("handcuff").count > 0 then
            if xTarget then
                if #(GetEntityCoords(GetPlayerPed(xPlayer.source))-GetEntityCoords(GetPlayerPed(xTarget.source))) < 5 then
                    TriggerClientEvent('HandCuffUse', xTarget.source, source)
                end
            end
        end
    end
end)

RegisterNetEvent("AnimMenotte")
AddEventHandler("AnimMenotte", function(author)
    TriggerClientEvent('AnimMenotte', author)
end)

local CallFire = true

RegisterNetEvent("call:makeCallFire")
AddEventHandler("call:makeCallFire", function()
    if CallFire then
        CallFire = false
        TriggerClientEvent('CallFire', source)
        Wait(8000)
        CallFire = true
    end
end)

RegisterNetEvent("GetOwnerPlate")
AddEventHandler("GetOwnerPlate", function(plate)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll("SELECT * FROM vehicle_owner WHERE plate = @plate", {
        ["@plate"] = plate
    }, function(result)
        if result[1] then
            local identifier = result[1].owner
            MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
                ["@identifier"] = result[1].owner
            }, function(result2)
                TargetName = result2[1].firstname .. " " .. result2[1].lastname
                
                xPlayer.showNotification("Plaque : ~g~"..plate.."~s~\nPropriétaire : ~o~"..TargetName)
            end)
        else
            xPlayer.showNotification("Plaque : ~g~"..plate.."~s~\nPropriétaire : ~o~Inconnue")
        end
    end)
end)

RegisterNetEvent("withrowPoint")
AddEventHandler("withrowPoint", function(type, input, target)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    if type == 'pointCar' then 
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xTarget.identifier
        }, function(result)
            local pointvoiture = result[1].pointCar
            if pointvoiture >= 0 and pointvoiture-input >= 0 then
                MySQL.Async.execute("UPDATE users SET pointCar = @point WHERE identifier = @identifier", {
                    ["@identifier"] = xTarget.identifier,
                    ["@point"] = pointvoiture-input
                })
                if pointvoiture-input == 0 then 
                    MySQL.Async.execute("UPDATE users SET permisCar = 0 WHERE identifier = @identifier", {
                        ["@identifier"] = xTarget.identifier,
                    })
                end
            end
            xTarget.showNotification("Vous avez dès maintenant ~b~"..math.floor(pointvoiture-input).." ~s~point(s) sur votre permis voiture.")
            xPlayer.showNotification("La personne a dès maintenant ~b~"..math.floor(pointvoiture-input).." ~s~point(s) sur son permis voiture.")
        end)

    elseif type == 'pointMoto' then 
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xTarget.identifier
        }, function(result)
            local pointmoto = result[1].pointMoto
            if pointmoto >= 0 and pointmoto-input >= 0 then
                MySQL.Async.execute("UPDATE users SET pointMoto = @point WHERE identifier = @identifier", {
                    ["@identifier"] = xTarget.identifier,
                    ["@point"] = pointmoto-input
                })
                if pointmoto-input == 0 then 
                    MySQL.Async.execute("UPDATE users SET permisMoto = 0 WHERE identifier = @identifier", {
                        ["@identifier"] = xTarget.identifier,
                    })
                end
            end
            xTarget.showNotification("Vous avez dès maintenant ~b~"..math.floor(pointmoto-input).." ~s~point(s) sur votre permis moto.")
            xPlayer.showNotification("La personne a dès maintenant ~b~"..math.floor(pointmoto-input).." ~s~point(s) sur son permis moto.")
        end)

    elseif type == 'pointCamion' then 
        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xTarget.identifier
        }, function(result)
            local pointcamion = result[1].pointCamion
            if pointcamion >= 0 and pointcamion-input >= 0 then
                MySQL.Async.execute("UPDATE users SET pointCamion = @point WHERE identifier = @identifier", {
                    ["@identifier"] = xTarget.identifier,
                    ["@point"] = pointcamion-input
                })
                if pointcamion-input == 0 then 
                    MySQL.Async.execute("UPDATE users SET permisCamion = 0 WHERE identifier = @identifier", {
                        ["@identifier"] = xTarget.identifier,
                    })
                end
            end
            xTarget.showNotification("Vous avez dès maintenant ~b~"..math.floor(pointcamion-input).." ~s~point(s) sur votre permis camion.")
            xPlayer.showNotification("La personne a dès maintenant ~b~"..math.floor(pointcamion-input).." ~s~point(s) sur son permis camion.")
        end)
    end
end)

RegisterNetEvent("pointPly")
AddEventHandler("pointPly", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)
    
    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xTarget.identifier
    }, function(result)
    
    xPlayer.showNotification("Point(s) permis voiture : ~b~"..result[1].pointCar.."\n~s~Point(s) permis moto : ~o~"..result[1].pointMoto.."\n~s~Point(s) permis camion : ~g~"..result[1].pointCamion)
    end)
end)

ESX.RegisterServerCallback("GetPointPly", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent("armoryTake")
AddEventHandler("armoryTake", function(itemSelect, itemLabelSelect, quantity)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.canCarryItem(itemSelect, quantity) then
        xPlayer.addInventoryItem(itemSelect, quantity)
    else
        xPlayer.showNotification('Vous n\'avez pas assez de place.')
    end
end)

RegisterNetEvent("AnnoncePolice")
AddEventHandler("AnnoncePolice", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "police" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "LSPD", "~b~Annonce", input, 'CHAR_CALL911', 1)
    else 
        DropPlayer(source, "cheat AnnoncePolice")
    end
end)