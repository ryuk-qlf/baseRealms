ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('UpdateStatusTable')
AddEventHandler('UpdateStatusTable', function(idprop, table, value, idlabo)

    if table == 1 then
        MySQL.Async.execute('UPDATE labo_coke SET table1 = @table1 WHERE id_labo = @id_labo', {
            ['@table1'] = value,
            ['@id_labo'] = idlabo
        })
    elseif table == 2 then
        MySQL.Async.execute('UPDATE labo_coke SET table2 = @table2 WHERE id_labo = @id_labo', {
            ['@table2'] = value,
            ['@id_labo'] = idlabo
        })
    elseif table == 3 then
        MySQL.Async.execute('UPDATE labo_coke SET table3 = @table3 WHERE id_labo = @id_labo', {
            ['@table3'] = value,
            ['@id_labo'] = idlabo
        })
    end

    Wait(250)
    TriggerClientEvent("ClRefreshLabo", -1, idprop)
end)

RegisterNetEvent('StartProcessusLabo')
AddEventHandler("StartProcessusLabo", function(id_labo, type)
	local date = {
        year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
	}
	if type == 1 then
		MySQL.Async.execute('UPDATE labo_coke SET table1date = @table1date WHERE id_labo = @id_labo', {
			['@id_labo'] = tonumber(id_labo),
			['@table1date'] = json.encode(date)
		})
	end
	if type == 2 then
		MySQL.Async.execute('UPDATE labo_coke SET table2date = @table2date WHERE id_labo = @id_labo', {
			['@id_labo'] = tonumber(id_labo),
			['@table2date'] = json.encode(date)
		})
	end
	if type == 3 then
		MySQL.Async.execute('UPDATE labo_coke SET table3date = @table3date WHERE id_labo = @id_labo', {
			['@id_labo'] = tonumber(id_labo),
			['@table3date'] = json.encode(date)
		})
	end

    Wait(250)
    TriggerClientEvent("ClRefreshLabo", -1, idprop)
end)

RegisterNetEvent('SvRefreshLabo')
AddEventHandler("SvRefreshLabo", function(id)
    TriggerClientEvent("ClRefreshLabo", -1, id)
end)

ESX.RegisterServerCallback('GetInfoLabo', function(source, cb, PropId)
    local xPlayer = ESX.GetPlayerFromId(source)    
  
    MySQL.Async.fetchAll('SELECT * FROM labo_coke WHERE id_prop = @id_prop', {
        ['@id_prop'] = PropId
      }, function(results)
		cb(results)
    end)
end)

local removeitem = {}
local additem = {}

ESX.RegisterServerCallback('getItemLabo', function(source, cb, idprop)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem("acide").count >= 12 and xPlayer.getInventoryItem("coca").count >= 25 then
        if not removeitem[idprop] then
            removeitem[idprop] = true
            xPlayer.removeInventoryItem("acide", 12)
            xPlayer.removeInventoryItem("coca", 25)
	        cb(true)
            Wait(550)
            removeitem[idprop] = false
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("GetTimeFortable", function(source, cb, start)
	local TimeStart = json.decode(start)
	local test = os.difftime(os.time(), os.time{year = TimeStart.year, month = TimeStart.month, day = TimeStart.day, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec}) / 60
	cb(math.floor(test))
end)

ESX.RegisterServerCallback("GetMsOfProd", function(source, cb, start)
	local TimeStart = json.decode(start)
	local test = os.difftime(os.time(), os.time{year = TimeStart.year, month = TimeStart.month, day = TimeStart.day, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec})
	cb(test)
end)

ESX.RegisterServerCallback("AddCokeToPlayer", function(source, cb, id, idprop, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem("coke", 25) then
        if not additem[idprop] then
            additem[idprop] = true
		    xPlayer.addInventoryItem("coke", 25)
        end

        if type == 1 then
            MySQL.Async.execute('UPDATE labo_coke SET table1date = @table1date, table1 = @table1 WHERE id_labo = @id_labo', {
                ['@id_labo'] = tonumber(id),
                ['@table1'] = 0,
                ['@table1date'] = nil
            })
        end
        if type == 2 then
            MySQL.Async.execute('UPDATE labo_coke SET table2date = @table2date, table2 = @table2 WHERE id_labo = @id_labo', {
                ['@id_labo'] = tonumber(id),
                ['@table2'] = 0,
                ['@table2date'] = nil
            })
        end
        if type == 3 then
            MySQL.Async.execute('UPDATE labo_coke SET table3date = @table3date, table3 = @table3 WHERE id_labo = @id_labo', {
                ['@id_labo'] = tonumber(id),
                ['@table3'] = 0,
                ['@table3date'] = nil
            })
        end
    
        Wait(250)
        TriggerClientEvent("ClRefreshLabo", -1, idprop)
		cb(true)
        Wait(580)
        additem[idprop] = false
	else
		cb(false)
	end
end)

RegisterNetEvent('CreateLaboCocaine')
AddEventHandler('CreateLaboCocaine', function(PropId)
	MySQL.Async.execute('INSERT INTO labo_coke (id_prop) VALUES (@id_prop)', {
		['@id_prop'] = PropId
	})
end)