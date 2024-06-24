ESX.RegisterServerCallback('qs-smartphone:server:GetBankData', function(source, cb)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
    if Config.IbanBank and not Config.okokBankingIban then
        cb({bank = xPlayer.getAccount('bank').money, iban = QS.GetPlayerFromId(src).PlayerData.charinfo.account, username = QS.GetPlayerFromId(src).PlayerData.charinfo.firstname .. " " ..QS.GetPlayerFromId(src).PlayerData.charinfo.lastname })
    elseif Config.okokBankingIban then
        MySQL.Async.fetchAll('SELECT iban FROM users WHERE identifier = @identifier', {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if result and result[1] then 
                xPlayer = ESX.GetPlayerFromId(src)
                cb({bank = xPlayer.getAccount('bank').money, iban = result[1].iban, username = QS.GetPlayerFromId(src).PlayerData.charinfo.firstname .. " " ..QS.GetPlayerFromId(src).PlayerData.charinfo.lastname })
            end
        end)
    else 
        cb({bank = xPlayer.getAccount('bank').money, iban = source, username = QS.GetPlayerFromId(src).PlayerData.charinfo.firstname .. " " ..QS.GetPlayerFromId(src).PlayerData.charinfo.lastname })
    end
end)

RegisterServerEvent('qs-smartphone:server:TransferMoney')
AddEventHandler('qs-smartphone:server:TransferMoney', function(iban, amount)
    local src = source
    local sender = ESX.GetPlayerFromId(src)

    if Config.IbanBank and not Config.okokBankingIban then 
        MySQL.Async.fetchAll("SELECT * FROM `users` WHERE charinfo LIKE '%"..iban.."%'", {}, function(result)
            if result[1] ~= nil then
                local recieverSteam = ESX.GetPlayerFromIdentifier(result[1].identifier)
    
                if recieverSteam ~= nil then
                    local PhoneItem = false
                    if Config.RequiredPhone then
                        for k,v in pairs(Config.Phones) do
                            local HasPhone = recieverSteam.getInventoryItem(k)
                            if HasPhone and HasPhone.count > 0 then
                                PhoneItem = HasPhone
                                break
                            end
                        end
                    else 
                        PhoneItem = {}
                        PhoneItem.count = 1
                    end
                    if sender.getAccount('bank').money >= amount then
                        recieverSteam.addAccountMoney('bank', amount)
                        sender.removeAccountMoney('bank', amount)

                        TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                        
                        if PhoneItem and PhoneItem.count > 0 then
                            TriggerClientEvent('qs-smartphone:client:TransferMoney', recieverSteam.source, amount, recieverSteam.getAccount('bank').money)
                            TriggerClientEvent("qs-smartphone:sendMessage", recieverSteam.source, Lang("BANK_RECEIVED") .. amount, 'success')
                        end
                        LogTransferToDiscord()
                    end                
                else
                    if sender.getAccount('bank').money >= amount then
                        sender.removeAccountMoney('bank', amount)
                        local decoded = json.decode(result[1].accounts)
                        decoded.bank = decoded.bank + amount
                        if Config.esxVersion == 'new' then
                            MySQL.Async.execute("UPDATE `users` SET `accounts` = '"..json.encode(decoded).."' WHERE `identifier` = '"..result[1].identifier.."'", {}) 
                            TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                            LogTransferToDiscord()
                        elseif Config.esxVersion == 'old' then
                            MySQL.Async.execute("UPDATE users SET bank = bank + @add WHERE identifier=@identifier",{
                                ['@add'] = tonumber(amount),
                                ['@identifier'] = result[1].identifier
                            })
                            TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                            LogTransferToDiscord()
                        else
                            print('qs-smarthphone: Config.esxVersion should be equal to new or old')
                        end
                    end
                end
            end
        end)
    elseif Config.okokBankingIban then
        MySQL.Async.fetchAll("SELECT * FROM `users` WHERE iban = @iban", { ['@iban'] = iban }, function(result)
            if result[1] and result[1] then
                local recieverSteam = ESX.GetPlayerFromIdentifier(result[1].identifier)
    
                if recieverSteam ~= nil then
                    local PhoneItem = false
                    if Config.RequiredPhone then
                        for k,v in pairs(Config.Phones) do
                            local HasPhone = recieverSteam.getInventoryItem(k)
                            if HasPhone and HasPhone.count > 0 then
                                PhoneItem = HasPhone
                                break
                            end
                        end
                    else 
                        PhoneItem = {}
                        PhoneItem.count = 1
                    end
                    if sender.getAccount('bank').money >= amount then
                        recieverSteam.addAccountMoney('bank', amount)
                        sender.removeAccountMoney('bank', amount)
    
                        TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                        
                        if PhoneItem and PhoneItem.count > 0 then
                            TriggerClientEvent('qs-smartphone:client:TransferMoney', recieverSteam.source, amount, recieverSteam.getAccount('bank').money)
                            TriggerClientEvent("qs-smartphone:sendMessage", recieverSteam.source, Lang("BANK_RECEIVED") .. amount, 'success')
                        end
                        LogTransferToDiscord()
                    end                
                else
                    if sender.getAccount('bank').money >= amount then
                        sender.removeAccountMoney('bank', amount)
                        local decoded = json.decode(result[1].accounts)
                        decoded.bank = decoded.bank + amount
                        if Config.esxVersion == 'new' then
                            MySQL.Async.execute("UPDATE `users` SET `accounts` = '"..json.encode(decoded).."' WHERE `identifier` = '"..result[1].identifier.."'", {}) 
                            TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                            LogTransferToDiscord()
                        elseif Config.esxVersion == 'old' then
                            MySQL.Async.execute("UPDATE users SET bank = bank + @add WHERE identifier=@identifier",{
                                ['@add'] = tonumber(amount),
                                ['@identifier'] = result[1].identifier
                            })
                            TriggerClientEvent("qs-smartphone:sendMessage", sender.source, Lang("BANK_TRANSFER_SUCCESS"), 'success')
                            LogTransferToDiscord()
                        else
                            print('qs-smarthphone: Config.esxVersion should be equal to new or old')
                        end
                    end
                end
            end
        end)
    else
        if sender then
            iban = tonumber(iban)
            local target = ESX.GetPlayerFromId(iban)
            if target then
                if sender.getAccount('bank').money >= amount then   
                    target.addAccountMoney('bank', amount)
                    sender.removeAccountMoney('bank', amount)

                    TriggerClientEvent("qs-smartphone:sendMessage", src, Lang("BANK_TRANSFER_SUCCESS"), 'success')

                    local PhoneItem = false
                    if Config.RequiredPhone then
                        for k,v in pairs(Config.Phones) do
                            local HasPhone = target.getInventoryItem(k)
                            if HasPhone and HasPhone.count > 0 then
                                PhoneItem = HasPhone
                                break
                            end
                        end
                    else 
                        PhoneItem = {}
                        PhoneItem.count = 1
                    end
                    if PhoneItem and PhoneItem.count > 0 then
                        TriggerClientEvent('qs-smartphone:client:TransferMoney', iban, amount, target.getAccount('bank').money)
                        TriggerClientEvent("qs-smartphone:sendMessage", iban, Lang("BANK_RECEIVED") .. amount, 'success')
                    end
                    LogTransferToDiscord()
                end
            end
        end
    end
end)

local BankWebhook = ''

function LogTransferToDiscord()
    -- Add your own function to log the transfer here
end