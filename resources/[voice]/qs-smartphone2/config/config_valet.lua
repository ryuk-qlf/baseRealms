ESX.RegisterServerCallback("qs-smartphone:getCars", function(a, b)
    local c = ESX.GetPlayerFromId(a)
    if not c then
        return
    end;
    MySQL.Async.execute("SELECT plate, vehicle, stored FROM owned_vehicles WHERE `owner` = @cid and `type` = @type", {["@cid"] = c.identifier, ["@type"] = "car"}, function(d)
        local e = {} for f, g in ipairs(d) do
            table.insert(e, {["garage"] = g["stored"], ["plate"] = g["plate"], ["props"] = json.decode(g["vehicle"])})
        end;
        b(e)
    end)
end)

RegisterServerEvent("qs-smartphone:finish")
AddEventHandler("qs-smartphone:finish", function(a)
    local b = source;
    local c = ESX.GetPlayerFromId(b)
    if c.getAccount('bank').money >= Config.ValetPrice then
        TriggerClientEvent("qs-smartphone:sendMessage", b,  Config.ValetPrice .. Lang("GARAGE_PAY"), 'error')
        c.removeAccountMoney("bank", Config.ValetPrice)
    end
end)

RegisterServerEvent("qs-smartphone:valet-car-set-outside")
AddEventHandler("qs-smartphone:valet-car-set-outside", function(a)
    local b = source;
    local c = ESX.GetPlayerFromId(b)
    if c then
        MySQL.Async.execute("UPDATE owned_vehicles SET `stored` = @stored WHERE `plate` = @plate", {["@plate"] = a, ["@stored"] = 0})
    end
end)

RegisterServerEvent("qs-smartphone:getInfoPlate")
AddEventHandler("qs-smartphone:getInfoPlate", function(plaka)
  local src = source;
  local xPlayer = ESX.GetPlayerFromId(src)
  local arac_datastore = MySQL.Sync.fetchAll("SELECT vehicle FROM owned_vehicles WHERE `owner` ='"..xPlayer.identifier.."' AND `plate` ='"..plaka.."' ", {})
  TriggerClientEvent("qs-smartphone:AracSpawn", src, arac_datastore[1].vehicle)
end)