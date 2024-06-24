ESX = nil
TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("ShowIdCardOfPlayer")
AddEventHandler("ShowIdCardOfPlayer", function(target, cartename, dateofbirth, ldn)
    TriggerClientEvent("ShowIdCardOfPlayer", target, cartename, dateofbirth, ldn)
end)

RegisterNetEvent("showPermisOfPlayer")
AddEventHandler("showPermisOfPlayer", function(target, permisCar, pointCar, permisMoto, pointMoto, permisCamion, pointCamion, permisBoat, permisAirplanes)
    TriggerClientEvent("showPermisOfPlayer", target, permisCar, pointCar, permisMoto, pointMoto, permisCamion, pointCamion, permisBoat, permisAirplanes)
end)

RegisterNetEvent("AddIdCard")
AddEventHandler("AddIdCard", function(price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        MySQL.Async.execute('INSERT INTO id_card (identifier, porteur, type, name, dateofbirth, ldn) VALUES (@identifier, @porteur, @type, @name, @dateofbirth, @ldn)', { 
            ['@identifier'] = xPlayer.identifier,
            ['@porteur'] = xPlayer.identifier,
            ['@type'] = "idcard",
            ['@name'] = xPlayer.getIdentity(),
            ['@dateofbirth'] = xPlayer.getDateBirth(),
            ['@ldn'] = xPlayer.getLieuBirth()
        })
        xPlayer.showNotification("Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~"..price.."$~s~ pour une ~b~carte d'identité~s~.")
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent ~g~("..price.."$)")
    end
end)

RegisterNetEvent("AddPermisCard")
AddEventHandler("AddPermisCard", function(price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        MySQL.Async.fetchAll("SELECT * FROM id_card WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result2)
            if not result2[1] then
                MySQL.Async.execute('INSERT INTO id_card (identifier, porteur, type, name, dateofbirth, ldn) VALUES (@identifier, @porteur, @type, @name, @dateofbirth, @ldn)', { 
                    ['@identifier'] = xPlayer.identifier,
                    ['@porteur'] = xPlayer.identifier,
                    ['@type'] = "permis",
                    ['@name'] = xPlayer.getIdentity(),
                    ['@dateofbirth'] = xPlayer.getDateBirth(),
                    ['@ldn'] = xPlayer.getLieuBirth()
                })
            else
                local permisCar = result2[1].permisCar
                local pointCar = result2[1].pointCar
                local permisMoto = result2[1].permisMoto
                local pointMoto = result2[1].pointMoto
                local permisCamion = result2[1].permisCamion
                local pointCamion = result2[1].pointCamion
                local permisBoat = result2[1].permisBoat
                local permisAirplanes = result2[1].permisAirplanes

                MySQL.Async.execute('INSERT INTO id_card (identifier, porteur, type, name, dateofbirth, ldn, permisCar, pointCar, permisMoto, pointMoto, permisCamion, pointCamion, permisBoat, permisAirplanes) VALUES (@identifier, @porteur, @type, @name, @dateofbirth, @ldn, @permisCar, @pointCar, @permisMoto, @pointMoto, @permisCamion, @pointCamion, @permisBoat, @permisAirplanes)', { 
                    ['@identifier'] = xPlayer.identifier,
                    ['@porteur'] = xPlayer.identifier,
                    ['@type'] = "permis",
                    ['@name'] = PlayerName,
                    ['@dateofbirth'] = PlayerAge,
                    ['@ldn'] = PlayerLieu,
                    ['@permisCar'] = permisCar,
                    ['@pointCar'] = pointCar,
                    ['@permisMoto'] = permisMoto,
                    ['@pointMoto'] = pointMoto,
                    ['@permisCamion'] = permisCamion,
                    ['@pointCamion'] = pointCamion,
                    ['@permisBoat'] = permisBoat,
                    ['@permisAirplanes'] = permisAirplanes
                })
            end
        end)
        xPlayer.showNotification("Vous avez ~g~effectué~s~ un ~g~paiement~s~ de ~g~"..price.."$~s~ pour un ~b~permis~s~.")
    else
        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent ~g~("..price.."$)")
    end
end)