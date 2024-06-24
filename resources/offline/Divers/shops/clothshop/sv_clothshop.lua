ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("IfHasMoney",function(source, cb, price)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        cb(true)
    else
        cb(false)
    end
end)