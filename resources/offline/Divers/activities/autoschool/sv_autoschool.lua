ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('GiveCode')
AddEventHandler('GiveCode', function()
    local xPlayer = ESX.GetPlayerFromId(source)
        MySQL.Async.execute("UPDATE users SET code=1 WHERE identifier='"..xPlayer.identifier.."'", {}, function() 
    end)
end)

RegisterNetEvent('GivePermis')
AddEventHandler('GivePermis', function(permis)
    local xPlayer = ESX.GetPlayerFromId(source)
    if permis == 'car' then
        MySQL.Async.execute("UPDATE id_card SET permisCar=1 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
        MySQL.Async.execute("UPDATE id_card SET pointCar=12 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
    elseif permis == 'motor' then 
        MySQL.Async.execute("UPDATE id_card SET permisMoto=1 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
        MySQL.Async.execute("UPDATE id_card SET pointMoto=12 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
    elseif permis == 'heavycar' then 
        MySQL.Async.execute("UPDATE id_card SET permisCamion=1 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
        MySQL.Async.execute("UPDATE id_card SET pointCamion=12 WHERE identifier='"..xPlayer.identifier.."'", {}, function()end)
    end
end)

ESX.RegisterServerCallback("getInfoAutoEcole", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT code FROM users WHERE identifier=@identifier", { 
        ["@identifier"] = xPlayer.identifier,
    }, function(result)
        cb(result[1].code)
    end)
end)