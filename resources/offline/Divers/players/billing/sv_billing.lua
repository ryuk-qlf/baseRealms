ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("SendBill")
AddEventHandler("SendBill", function(target, motif, price, type)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

    if targetXPlayer then
        if #(GetEntityCoords(GetPlayerPed(sourceXPlayer.source))-GetEntityCoords(GetPlayerPed(targetXPlayer.source))) < 5 then
            sourceXPlayer.showNotification("~b~Vous avez bien envoyé la demande.")
            TriggerClientEvent('SolutionBill', targetXPlayer.source, motif, price, type, sourceXPlayer.source)
        end
    end
end)

RegisterNetEvent("PayBillsPersonnel")
AddEventHandler("PayBillsPersonnel", function(price, author, motif)
	local xPlayer = ESX.GetPlayerFromId(source)
	local rPlayer = ESX.GetPlayerFromId(author)

    if rPlayer then
        MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE courant = 1 AND license = @license', {
            ['@license'] = xPlayer.identifier
        }, function(result)
            if json.encode(result) ~= "[]" then

                for k, v in pairs(result) do
                    local NumeroxPlayer = v.Numero
                    local ArgentxPlayer = v.balance

                    if tonumber(ArgentxPlayer) >= tonumber(price) then

                        MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE courant = 1 AND license = @license', {
                            ['@license'] = rPlayer.identifier
                        }, function(result2)
                            if json.encode(result2) ~= "[]" then
                                MySQL.Async.execute("UPDATE bank_account SET balance='" .. ArgentxPlayer - tonumber(price) .. "' WHERE Numero ='" .. NumeroxPlayer .. "';", {})
                                MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(-~r~ " .. tonumber(price) .. "~s~) - ~y~".. motif .. "', '" .. 4 .. "', '" .. NumeroxPlayer .. "')", {})
                                TriggerClientEvent('StartAnimation', xPlayer.source)

                                for c, u in pairs(result2) do
                                    local ArgentrPlayer = u.balance
                                    local NumerorPlayer = u.Numero
                                    MySQL.Async.execute("UPDATE bank_account SET balance='" .. ArgentrPlayer + tonumber(price) .. "' WHERE Numero ='" .. NumerorPlayer .. "';", {})
                                    MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(+~r~ " .. tonumber(price) .. "~s~) - ~y~".. motif .. "', '" .. 4 .. "', '" .. NumerorPlayer .. "')", {})
                                end
                                xPlayer.showNotification("Vous avez payé une facture de : ~b~"..price.."$~s~.")
                                rPlayer.showNotification("La personne a payé la facture de : ~b~"..price.."$~s~.")
                            else
                                rPlayer.showNotification("~r~Vous n'avez pas défini de compte courant.")
                                xPlayer.showNotification("~r~La personne n'a pas pas défini de compte courant.")
                            end
                        end)
                    else 
                        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent impossible de payer.")
                        rPlayer.showNotification("~r~La personne n'a pas assez d'argent pour payer la facture.")
                    end
                end
            else
                xPlayer.showNotification("~r~Vous n'avez pas défini de compte courant.")
                rPlayer.showNotification("~r~La personne n'a pas pas défini de compte courant.")
            end
        end)
    end
end)

RegisterNetEvent("PayBillsEntreprise")
AddEventHandler("PayBillsEntreprise", function(price, author, motif)
	local xPlayer = ESX.GetPlayerFromId(source)
	local rPlayer = ESX.GetPlayerFromId(author)

    if rPlayer then
        MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE courant = 1 AND license = @license', {
            ['@license'] = xPlayer.identifier
        }, function(result)
            if json.encode(result) ~= "[]" then

                for k, v in pairs(result) do
                    local NumeroxPlayer = v.Numero
                    local ArgentxPlayer = v.balance

                    if tonumber(ArgentxPlayer) >= tonumber(price) then

                        MySQL.Async.execute("UPDATE bank_account SET balance='" .. ArgentxPlayer - tonumber(price) .. "' WHERE Numero ='" .. NumeroxPlayer .. "';", {})
                        MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(-~r~ " .. tonumber(price) .. "~s~) - ~y~".. motif .. "', '" .. 4 .. "', '" .. NumeroxPlayer .. "')", {})
                        TriggerClientEvent('StartAnimation', xPlayer.source)
                        xPlayer.showNotification("Vous avez payé une facture de : ~b~"..price.."$~s~.")
                        rPlayer.showNotification("La personne a payé la facture de : ~b~"..price.."$~s~.")
                        NumeroxPlayer = nil
                        ArgentxPlayer = nil

                        TriggerEvent("AddMoneySociety", rPlayer.job.name, price)
                    else 
                        xPlayer.showNotification("~r~Vous n'avez pas assez d'argent impossible de payer.")
                        rPlayer.showNotification("~r~La personne n'a pas assez d'argent pour payer la facture.")
                    end
                end
            else
                xPlayer.showNotification("~r~Vous n'avez pas défini de compte courant.")
                rPlayer.showNotification("~r~La personne n'a pas pas défini de compte courant.")
            end
        end)
    end
end)

RegisterNetEvent("AlertBills")
AddEventHandler("AlertBills", function(author, msg)
    local aPlayer = ESX.GetPlayerFromId(author)

    if aPlayer then
        aPlayer.showNotification(msg)
    end
end)