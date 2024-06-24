ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('InfoPerso')
AddEventHandler('InfoPerso', function()
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("chat:addMessage", xPlayer.source, "[^1Offline^0] Identité : "..xPlayer.getIdentity().." ID : "..xPlayer.getIdPerso())  
end)

RegisterNetEvent('WipePersoAdmin')
AddEventHandler('WipePersoAdmin', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        MySQL.Async.fetchAll('SELECT * FROM users WHERE idperso = @idperso', {
            ['@idperso'] = target
        }, function(result)
            if result[1] then
                local identifier = result[1].identifier
                local xTarget = ESX.GetPlayerFromIdentifier(identifier)

                if xTarget.source then
                    DropPlayer(xTarget.source, "OFFLINE : Vous venez d'être wipe !")
                end

                MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                })
                MySQL.Async.execute('DELETE FROM vetement WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                })
                MySQL.Async.execute('DELETE FROM crew_membres WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                })
                MySQL.Async.execute('DELETE FROM id_card WHERE porteur = @porteur', {
                    ['@porteur'] = identifier
                })
                MySQL.Async.execute('DELETE FROM bank_account WHERE license = @license', {
                    ['@license'] = identifier
                })
                MySQL.Async.execute('DELETE FROM card_account WHERE porteur = @porteur', {
                    ['@porteur'] = identifier
                })
                MySQL.Async.execute('DELETE FROM properties_access WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                })
                MySQL.Async.execute('DELETE FROM vehicle_owner WHERE owner = @owner', {
                    ['@owner'] = identifier
                })
                MySQL.Async.execute('DELETE FROM vehicle_key WHERE identifier = @identifier', {
                    ['@identifier'] = identifier
                })
                MySQL.Async.execute("UPDATE properties_list SET property_owner = @edit WHERE property_owner = @owner", {
                    ['@edit'] = "wipe",
                    ['@owner'] = identifier
                })
            end
        end)
    end
end)

RegisterNetEvent('WipePerso')
AddEventHandler('WipePerso', function(args)
    local xPlayer = ESX.GetPlayerFromId(source)
    local date = {year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec}

    if tonumber(args) == tonumber(xPlayer.getIdPerso()) then
        MySQL.Async.fetchAll("SELECT * FROM wipe WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result)
            if not result[1] then
                MySQL.Async.execute("INSERT INTO wipe (date, identifier) VALUES (@date, @identifier)", {
                    ["@date"] = json.encode(date),
                    ["@identifier"] = xPlayer.identifier
                })
                DropPlayer(xPlayer.source, "OFFLINE : Vous venez d'être wipe !")
                MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM vetement WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM crew_membres WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM id_card WHERE porteur = @porteur', {
                    ['@porteur'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM bank_account WHERE license = @license', {
                    ['@license'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM card_account WHERE porteur = @porteur', {
                    ['@porteur'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM properties_access WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM vehicle_owner WHERE owner = @owner', {
                    ['@owner'] = xPlayer.identifier
                })
                MySQL.Async.execute('DELETE FROM vehicle_key WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier
                })
                MySQL.Async.execute("UPDATE properties_list SET property_owner = @edit WHERE property_owner = @owner", {
                    ['@edit'] = "wipe",
                    ['@owner'] = xPlayer.identifier
                })
            else
                local dateWipe = result[1].date
                local TimeStart = json.decode(dateWipe)
                local test = os.difftime(os.time(), os.time{year = TimeStart.year, month = TimeStart.month, day = TimeStart.day, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec}) / 60

                if (10080-math.floor(test)) <= 0 then
                    DropPlayer(xPlayer.source, "OFFLINE : Vous venez d'être wipe !")
                    MySQL.Async.execute('DELETE FROM users WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM vetement WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM crew_membres WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM id_card WHERE porteur = @porteur', {
                        ['@porteur'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM bank_account WHERE license = @license', {
                        ['@license'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM card_account WHERE porteur = @porteur', {
                        ['@porteur'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM properties_access WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM vehicle_owner WHERE owner = @owner', {
                        ['@owner'] = xPlayer.identifier
                    })
                    MySQL.Async.execute('DELETE FROM vehicle_key WHERE identifier = @identifier', {
                        ['@identifier'] = xPlayer.identifier
                    })
                    MySQL.Async.execute("UPDATE properties_list SET property_owner = @edit WHERE property_owner = @owner", {
                        ['@edit'] = "wipe",
                        ['@owner'] = xPlayer.identifier
                    })
                    MySQL.Async.execute("UPDATE wipe SET date = @date WHERE identifier = @identifier", {
                        ['@date'] = json.encode(date),
                        ['@identifier'] = xPlayer.identifier
                    })
                    xPlayer.showNotification("~b~Vous venez d'être wipe.")
                else
                    local endtime = os.time({year = TimeStart.year, month = TimeStart.month, day = TimeStart.day + 7, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec})
                    xPlayer.showNotification("Votre prochaine possibilité de wipe sera le ~b~"..os.date("%d", endtime).."-"..os.date("%m", endtime).."-"..os.date("%Y", endtime).." "..os.date("%H", endtime)..":"..os.date("%M", endtime))
                end
            end
        end)
    else
        xPlayer.showNotification("~r~L'id que vous avez mis ne correspond pas à votre id.")
    end
end)