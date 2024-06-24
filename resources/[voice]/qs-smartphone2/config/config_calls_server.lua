RegisterServerEvent('qs-smartphone:server:CancelCall')
AddEventHandler('qs-smartphone:server:CancelCall', function(ContactData)
     local src = source
     local Ply = QS.GetPlayerFromPhone(ContactData.TargetData.number)

    if Config.Voice == 'salty' then
        if Ply ~= nil then
            TriggerClientEvent('qs-smartphone:client:CancelCall', Ply.PlayerData.source)
            exports['saltychat']:EndCall(Ply.PlayerData.source, src)
            exports['saltychat']:EndCall(src, Ply.PlayerData.source)
        end
    else
        if Ply ~= nil then
            TriggerClientEvent('qs-smartphone:client:CancelCall', Ply.PlayerData.source)
        end
    end
end)

RegisterServerEvent('qs-smartphone:server:AnswerCall')
AddEventHandler('qs-smartphone:server:AnswerCall', function(CallData)
    local src = source
    local Ply = QS.GetPlayerFromPhone(CallData.TargetData.number)

    if Config.Voice == 'salty' then
        if Ply ~= nil then
            exports['saltychat']:EstablishCall(Ply.PlayerData.source, src)
            exports['saltychat']:EstablishCall(src, Ply.PlayerData.source)
            TriggerClientEvent('qs-smartphone:client:AnswerCall', Ply.PlayerData.source)
        end
    else
        if Ply ~= nil then
            TriggerClientEvent('qs-smartphone:client:AnswerCall', Ply.PlayerData.source)
        end
    end
end)