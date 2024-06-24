RegisterNetEvent('CreateLaboWeed')
AddEventHandler('CreateLaboWeed', function(PropId)
	MySQL.Async.execute('INSERT INTO labo_weed (id_prop) VALUES (@id_prop)', {
		['@id_prop'] = PropId
	})
end)

RegisterNetEvent('UpdateStatusWeed')
AddEventHandler('UpdateStatusWeed', function(idprop, bache, value, idlabo)
    local date = {
        year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
    }
    if value == 1 then
        MySQL.Async.execute("UPDATE labo_weed SET "..bache.." ='" .. value .. "', "..bache.."date ='" .. json.encode(date) .. "' WHERE id_labo ='" .. idlabo .. "';", {})
    else
        MySQL.Async.execute("UPDATE labo_weed SET "..bache.." ='" .. value .. "' WHERE id_labo =" .. idlabo .. "", {})
    end

    Wait(2550)

    TriggerClientEvent("ClRefreshLaboWeed", -1, idprop)
end)

ESX.RegisterServerCallback('GetInfoLaboWeed', function(source, cb, PropId)
    local xPlayer = ESX.GetPlayerFromId(source)    
  
    MySQL.Async.fetchAll('SELECT * FROM labo_weed WHERE id_prop = @id_prop', {
        ['@id_prop'] = PropId
      }, function(results)
		cb(results)
    end)
end)

local removeitemweed = {}
local additemweed = {}

ESX.RegisterServerCallback('getItemWeed', function(source, cb, idprop)
	local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getInventoryItem("terre").count >= 12 and xPlayer.getInventoryItem("cannabis_plant").count >= 25 then
        if not removeitemweed[idprop] then
            removeitemweed[idprop] = true
            xPlayer.removeInventoryItem("terre", 12)
            xPlayer.removeInventoryItem("cannabis_plant", 25)
	        cb(true)
            Wait(550)
            removeitemweed[idprop] = false
        end
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback("AddWeedToPlayer", function(source, cb, idlabo, idprop, bache)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem("weed", 25) then
        if not additemweed[idprop] then
            additemweed[idprop] = true
		    xPlayer.addInventoryItem("weed", 25)
        end

        MySQL.Async.execute("UPDATE labo_weed SET "..bache.." = @value, "..bache.."date = @datefinish WHERE id_labo = @id_labo", {
            ['@id_labo'] = idlabo,
            ['@value'] = 0,
            ['@datefinish'] = nil  
        })

        Wait(550)
        TriggerClientEvent("ClRefreshLaboWeed", -1, idprop)
		cb(true)
        Wait(580)
        additemweed[idprop] = false
	else
		cb(false)
	end
end)