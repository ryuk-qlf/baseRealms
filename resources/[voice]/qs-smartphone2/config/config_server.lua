ESX.RegisterServerCallback('qs-smartphone:server:HasPhone', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local phone = false
    if xPlayer ~= nil then
        if Config.RequiredPhone then
            for k,v in pairs(Config.Phones) do
                local HasPhone = xPlayer.getInventoryItem(k)
                if HasPhone and HasPhone.count > 0 then
                    phone = v
                    break
                end
            end
        else 
            phone = 1
        end
    end
    cb(phone)
end)

for k,v in pairs(Config.Phones) do
    if Config.RequiredPhone then
        ESX.RegisterUsableItem(k, function(source, item)
            TriggerClientEvent('qs-smartphone:openPhone', source)
        end)
    end
end