ESX = nil
TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

-- Partie event
RegisterNetEvent("CreateAccount")
AddEventHandler("CreateAccount", function(Type)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("INSERT INTO bank_account (license, identite, type) VALUES (@license, @identite, @type)", {
        ["@license"] = xPlayer.identifier,
        ["@identite"] = xPlayer.getIdentity(),
        ["@type"] = Type,
    })
end)

RegisterNetEvent("CreateCardByAccount")
AddEventHandler("CreateCardByAccount", function(Account)
    local xPlayer = ESX.GetPlayerFromId(source) 
    local idCard = math.random(1111, 9999) .. " " .. math.random(1111, 9999) .. " " .. math.random(1111, 9999) .. " " .. math.random(1111, 9999)
    local EXP = math.random(1, 25) .. "/25"
    local code = math.random(1111, 9999)
    MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier=@identifier', {['@identifier'] = xPlayer.identifier}, function(Call)
        if Call[1] ~= nil then
            MySQL.Async.execute("INSERT INTO card_account (license, account, identite, exp, code, Numero, porteur) VALUES ('" .. xPlayer.identifier .."', '" .. Account .."', '" .. xPlayer.getFirstname() .. " - " .. xPlayer.getLastname() .."', '" .. EXP .."', '" .. code .."', '" .. idCard .."', '"..xPlayer.identifier.."')", {})
        end
    end)
    xPlayer.MissionText('+ 1 Compte N°'..Account)
end) 

RegisterNetEvent("WithdrawMoney")
AddEventHandler("WithdrawMoney", function(Somme, Numero)
    local xPlayer = ESX.GetPlayerFromId(source) 
        MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE Numero=@Numero', {['@Numero'] = Numero}, function(result)
            for k, v in pairs(result) do
                if v.balance >= tonumber(Somme) then
                    xPlayer.addMoney(tonumber(Somme))
                    MySQL.Async.execute("UPDATE bank_account SET balance='" .. v.balance - tonumber(Somme) .. "' WHERE Numero ='" .. Numero .. "';", {})
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "Type : ~y~Retrait~s~ - Somme : ~g~" .. tonumber(Somme) .. "$")
                    MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(-~r~ " .. tonumber(Somme) .. "~s~) - ~y~Compte N°" .. Numero .. "~s~" .. "', '" .. 1 .. "', '" .. Numero .. "')", {})
                else 
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\nType : ~y~Retrait~s~ - Somme : ~g~" .. tonumber(Somme) .. "$")
                end
            end
        end)    
    end)

RegisterNetEvent("DepositMoney")
AddEventHandler("DepositMoney", function(Somme, Numero)
    local xPlayer = ESX.GetPlayerFromId(source) 
        MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE Numero=@Numero', {
            ['@Numero'] = Numero
        }, function(result)
            for k, v in pairs(result) do
                if xPlayer.getMoney() >= tonumber(Somme) and tonumber(Somme) > 0 then
                    xPlayer.removeMoney(Somme)
                    MySQL.Async.execute("UPDATE bank_account SET balance='" .. v.balance + tonumber(Somme) .. "' WHERE Numero ='" .. Numero .. "';", {})
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "Type : ~b~Dépot~s~ - Somme : ~g~" .. tonumber(Somme) .. "$")
                    MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(+~g~ " .. tonumber(Somme) .. "~s~) - ~y~Compte N°" .. Numero .. "~s~" .. "', '" .. 0 .. "', '" .. Numero .. "')", {})
                else 
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\nType : ~b~Dépot~s~ - Somme : ~g~" .. tonumber(Somme) .. "$")
                end
            end
        end)
    end) 

function ConvertToBool(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end

function ConvertToNum(bool)
    if bool then return 1 else return 0 end
end

RegisterNetEvent("DestroyCard")
AddEventHandler("DestroyCard", function(ID, status)
    MySQL.Async.execute("UPDATE card_account SET locked = @locked WHERE account = @id", {['@id'] = ID, ['@locked'] = ConvertToNum(status)})
end) 

RegisterNetEvent("StatusCourantCompte")
AddEventHandler("StatusCourantCompte", function(ID, courant)
    MySQL.Async.execute("UPDATE bank_account SET courant = @courant WHERE Numero = @id", {
        ['@id'] = ID,
        ['@courant'] = ConvertToNum(courant)
    })
end) 

RegisterNetEvent("UpdateCodeCarte")
AddEventHandler("UpdateCodeCarte", function(newcode, account)
    MySQL.Async.execute("UPDATE card_account SET code = @code WHERE account = @account", {
        ['@account'] = account,
        ['@code'] = newcode
    })
end) 

RegisterNetEvent("DestroyAccount")
AddEventHandler("DestroyAccount", function(idaccount)
    MySQL.Async.execute("DELETE FROM bank_account WHERE Numero = @Numero",{
        ['@Numero'] = idaccount
    })
end) 

RegisterNetEvent("depositSociety")
AddEventHandler("depositSociety", function(job, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
        if xPlayer.getMoney() >= tonumber(amount) and tonumber(amount) > 0 then
            TriggerEvent("AddMoneySociety", job, amount)
            xPlayer.showNotification("Vous avez ~b~déposé~w~ ~g~"..amount.."$~w~ sur votre compte entreprise.")
            xPlayer.removeMoney(amount)
        else
            xPlayer.showNotification("~r~Vous n'avez pas assez d'argent.")
        end
    end
end) 

RegisterNetEvent("withdrawSociety")
AddEventHandler("withdrawSociety", function(job, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == job and xPlayer.job.grade_name == 'boss' then
        TriggerEvent('GetMoneySv', job, function(account2)
            local societyAccount2 = account2

            if tonumber(societyAccount2) >= tonumber(amount) then
                TriggerEvent("RemoveMoneySociety", job, amount)
                xPlayer.addMoney(amount)
            else
                xPlayer.showNotification("~r~Impossible~w~, il n'y a pas (assez) d'argent dans l'entreprise.")
            end
        end)
    end
end) 

-- Partie callback
ESX.RegisterServerCallback('GetAccountListByOwner', function(source, cb) -- S'il as un compte ou pas
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM bank_account WHERE license = '" .. xPlayer.identifier .. "'", {}, function(Call)
        cb(Call)  
    end)
end)

ESX.RegisterServerCallback('GetCardListByOwner', function(source, cb, Numero) -- Toutes les cartes du compte
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM card_account WHERE account = '" .. Numero .. "'", {}, function(Call)
        cb(Call)  
    end)
end)

ESX.RegisterServerCallback('GetTransacListByOwner', function(source, cb, Numero) -- Liste des transactions perçues
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM transaction_account WHERE account = '" .. Numero .. "'", {}, function(Call)
        cb(Call)  
    end)
end)

ESX.RegisterServerCallback('GetInfosCard', function(source, cb, Numero, account) -- Locked
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM card_account WHERE numero = '" .. Numero .. "'", {}, function(Call)
        MySQL.Async.fetchAll("SELECT * FROM bank_account WHERE Numero = '" .. account .. "'", {}, function(Call2)
            if json.encode(Call2) == "[]" then
                cb(nil)
                xPlayer.showNotification("~r~Erreur~s~\nLe compte associé à la carte n'existe plus !")
            else
                cb(Call)
            end
        end)
    end)
end)

ESX.RegisterServerCallback('GetListeCard', function(source, cb, Numero) -- Toutes ces carte
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM card_account WHERE porteur = '" .. xPlayer.identifier .. "'", {}, function(Call)
        cb(Call)  
    end)
end)

ESX.RegisterServerCallback('GetInfosCardAccount', function(source, cb, Account) -- Infos du compte par rapport à la carte
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll("SELECT * FROM bank_account WHERE Numero = '" .. Account .. "'", {}, function(Call)
        cb(Call)  
    end)
end)

ESX.RegisterServerCallback('GetCodeCard', function(source, cb, Code, Account) -- Get le code de la carte
    MySQL.Async.fetchAll("SELECT * FROM card_account WHERE code = '" .. Code .."' AND account = '" .. Account .."'", {}, function(Call)
        if Call[1] ~= nil then
            cb(false)
        else
            cb(true)
        end
    end)
end)

RegisterNetEvent("WithdrawCash")
AddEventHandler("WithdrawCash", function(money)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeAccountMoney('money', money)
end)

ESX.RegisterServerCallback('WithDrawBankPayment', function(source, cb, money, numero, TransacMessage)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE Numero=@Numero', {['@Numero'] = numero}, function(result)
        if json.encode(result) ~= "[]" then
            for k,v in pairs(result) do
                if tonumber(v.balance) >= tonumber(money) then
                    MySQL.Async.execute("UPDATE bank_account SET balance='" .. v.balance - tonumber(money) .. "' WHERE Numero ='" .. numero .. "';", {})
                    cb(true)
                    MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(-~r~ " .. tonumber(money) .. "~s~) - ~y~".. TransacMessage .. "', '" .. 3 .. "', '" .. numero .. "')", {})
                else 
                    cb(false)
                    TriggerClientEvent("esx:showNotification", xPlayer.source, "- ~r~Erreur~s~\nType : ~y~Paiement~s~ - Somme : ~g~" .. tonumber(money) .. "$")
                end
            end
        else
            cb(nil)
            xPlayer.showNotification("~r~Erreur~s~\nLe compte associé à la carte n'existe plus !")
        end
    end)    
end)