RegisterNetEvent('CreateLaboMeth')
AddEventHandler('CreateLaboMeth', function(Id)
    MySQL.Async.execute('INSERT INTO labo_meth (id_prop) VALUES (@id_prop)', {
		['@id_prop'] = Id
	})
end)

ESX.RegisterServerCallback('GetInfoLaboM', function(source, cb, PropId)
    local xPlayer = ESX.GetPlayerFromId(source)    
  
    MySQL.Async.fetchAll('SELECT * FROM labo_meth WHERE id_prop = @id_prop', {
        ['@id_prop'] = PropId
      }, function(result)
		cb(result)
    end)
end)

ESX.RegisterServerCallback('HaveEnoughItemsMeth', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)    
  
    if xPlayer.getInventoryItem('acide').count >= 12 and xPlayer.getInventoryItem('red_phosphore').count >= 12 and xPlayer.getInventoryItem('sodium_hydroxide').count >= 12 then
        cb(true)
        xPlayer.removeInventoryItem('acide', 12)
        xPlayer.removeInventoryItem('red_phosphore', 12)
        xPlayer.removeInventoryItem('sodium_hydroxide', 12)
    else
        cb(false)
    end
end)


RegisterNetEvent('SvRefreshLaboM')
AddEventHandler("SvRefreshLaboM", function(id)
    TriggerClientEvent("ClRefreshLaboM", -1, id)
end)

RegisterNetEvent('DoAnimForAll')
AddEventHandler("DoAnimForAll", function(id, state)
    TriggerClientEvent("DoAnimForAll", -1, id, state)
end)

ESX.RegisterServerCallback("CanCarryItem", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    cb(xPlayer.canCarryItem("meth", 40))
end)

RegisterNetEvent('UpdateServLaboMeth')
AddEventHandler('UpdateServLaboMeth', function(IdProp, Id, type, arg, arg2, arg3)
    if type == "Machine" then
        MySQL.Async.execute('UPDATE `labo_meth` SET `HaveMachineOn` = @HaveMachineOn WHERE id_labo = @id_labo', {
            ['@id_labo'] = Id,
            ['@HaveMachineOn'] = arg
        })
    elseif type == "Cuve" then
        MySQL.Async.execute('UPDATE `labo_meth` SET `HaveDisposedInCuve` = @HaveDisposedInCuve WHERE id_labo = @id_labo', {
            ['@id_labo'] = Id,
            ['@HaveDisposedInCuve'] = arg
        })
    elseif type == 'Table' then
        MySQL.Async.execute('UPDATE `labo_meth` SET `HavePreparedTable` = @HavePreparedTable WHERE id_labo = @id_labo', {
            ['@id_labo'] = Id,
            ['@HavePreparedTable'] = arg
        })
    elseif type == 'Date' then
        local date = {
            year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
        }
        MySQL.Async.execute('UPDATE `labo_meth` SET `DateTable` = @DateTable WHERE id_labo = @id_labo', {
            ['@id_labo'] = Id,
            ['@DateTable'] = json.encode(date)
        })
        if json.encode(arg) == '[]' then
            MySQL.Async.execute('UPDATE `labo_meth` SET `DateTable` = @DateTable WHERE id_labo = @id_labo', {
                ['@id_labo'] = Id,
                ['@DateTable'] = nil
            })
            local xPlayer = ESX.GetPlayerFromId(source)
        
            if xPlayer.canCarryItem("meth", 40) then
                if not additem then
                    additem = true
                    xPlayer.addInventoryItem("meth", 40)
                    Wait(750)
                    additem = false
                end
            else
                xPlayer.showNotification("~r~Vous n'avez pas assez de place pour porter cette charge.")
            end
        end
    end

    Wait(450)
    TriggerClientEvent("ClRefreshLaboM", -1, IdProp)
end)