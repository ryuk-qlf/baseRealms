ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('moteur', function(source)
	TriggerClientEvent('UseMoteur', source)
end)

ESX.RegisterUsableItem('carrosserie', function(source)
	TriggerClientEvent('UseCarrosserie', source)
end)

ESX.RegisterUsableItem('chiffon', function(source)
	TriggerClientEvent('UseChiffon', source)
end)

ESX.RegisterUsableItem('lockpick', function(source)
	TriggerClientEvent('UseLockpick', source)
end)

RegisterNetEvent('RemoveItemMecano')
AddEventHandler('RemoveItemMecano', function(item, nombre)
	local xPlayer = ESX.GetPlayerFromId(source)

    xPlayer.removeInventoryItem(item, nombre)
end)


MySQL.ready(function()
	MySQL.Async.execute('UPDATE crew_vehicles SET pound = 1 WHERE pound = 0', {})
	MySQL.Async.execute('UPDATE vehicle_owner SET pound = 1 WHERE pound = 0', {})
    MySQL.Async.execute('UPDATE jobs_vehicles SET pound = 1 WHERE pound = 0', {})
end)

RegisterNetEvent('UpdateFourriereCrew')
AddEventHandler('UpdateFourriereCrew', function(plate)
    MySQL.Async.execute("UPDATE crew_vehicles SET pound = @pound WHERE plate = @plate", {
		["@pound"] = 0,
        ["@plate"] = plate
    })
end)

RegisterNetEvent('UpdateFourriereCivils')
AddEventHandler('UpdateFourriereCivils', function(plate)
    MySQL.Async.execute("UPDATE vehicle_owner SET pound = @pound WHERE plate = @plate", {
		["@pound"] = 0,
        ["@plate"] = plate
    })
end)

RegisterNetEvent('UpdateFourriereJobs')
AddEventHandler('UpdateFourriereJobs', function(plate)
    MySQL.Async.execute("UPDATE jobs_vehicles SET pound = @pound WHERE plate = @plate", {
		["@pound"] = 0,
        ["@plate"] = plate
    })
end)

ESX.RegisterServerCallback("GetCrewList", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM crew_liste', {
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback("GetJobsList", function(source, cb)
    MySQL.Async.fetchAll('SELECT name, label FROM jobs', {
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('GetVehicleCrew', function(source, cb, idcrew)
	MySQL.Async.fetchAll('SELECT * FROM crew_vehicles WHERE crew = @crew', {
		['@crew'] = idcrew
	}, function(result)
		cb(result)  
	end)  
end)

ESX.RegisterServerCallback("GetPlyCrew", function(source, cb, Target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(Target)

    MySQL.Async.fetchAll('SELECT * FROM crew_membres WHERE identifier = @identifier', {
        ["@identifier"] = xTarget.identifier
    }, function(result)
        if result[1] ~= nil then
            cb({id_crew = result[1].id_crew})
        else
            xPlayer.showNotification("~r~La personne n'appartient à aucun crew.")
        end
    end)
end)

ESX.RegisterServerCallback('GetVehicleJobs', function(source, cb, jobname)
	MySQL.Async.fetchAll('SELECT * FROM jobs_vehicles WHERE job = @job', {
		['@job'] = jobname
	}, function(result)
		cb(result)  
	end)  
end)

ESX.RegisterServerCallback("FourriereGetPlyJob", function(source, cb, Target)
    local xTarget = ESX.GetPlayerFromId(Target)

    cb(xTarget.getJob().name)
end)

ESX.RegisterServerCallback('GetVehicleCivils', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

    MySQL.Async.fetchAll('SELECT * FROM vehicle_owner WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('GetPlateVehicleInPound')
AddEventHandler('GetPlateVehicleInPound', function(plaque, status)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll("SELECT plate FROM vehicle_owner WHERE plate = @plate", {
		['@plate'] = plaque
	}, function(result)
		if result[1] ~= nil then
            MySQL.Async.execute("UPDATE vehicle_owner SET pound = @pound WHERE plate = @plate", {
                ["@pound"] = status,
                ["@plate"] = plaque
            })
        else
            MySQL.Async.fetchAll("SELECT plate FROM crew_vehicles WHERE plate = @plate", {
                ['@plate'] = plaque
            }, function(result)
                if result[1] ~= nil then
                    MySQL.Async.execute("UPDATE crew_vehicles SET pound = @pound WHERE plate = @plate", {
                        ["@pound"] = status,
                        ["@plate"] = plaque
                    })
                else
                    MySQL.Async.fetchAll("SELECT plate FROM jobs_vehicles WHERE plate = @plate", {
                        ['@plate'] = plaque
                    }, function(result)
                        if result[1] ~= nil then
                            MySQL.Async.execute("UPDATE jobs_vehicles SET pound = @pound WHERE plate = @plate", {
                                ["@pound"] = status,
                                ["@plate"] = plaque
                            })
                        end
                    end)
                end
            end)
		end
	end)
end)

RegisterNetEvent('SetPropsVehiclePlate')
AddEventHandler('SetPropsVehiclePlate', function(plaque, props)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll("SELECT plate FROM vehicle_owner WHERE plate = @plate", {
		['@plate'] = plaque
	}, function(result)
		if result[1] ~= nil then
            MySQL.Async.execute("UPDATE vehicle_owner SET custom = @custom WHERE plate = @plate", {
                ["@custom"] = json.encode(props),
                ["@plate"] = plaque
            })
        else
            MySQL.Async.fetchAll("SELECT plate FROM crew_vehicles WHERE plate = @plate", {
                ['@plate'] = plaque
            }, function(result)
                if result[1] ~= nil then
                    MySQL.Async.execute("UPDATE crew_vehicles SET custom = @custom WHERE plate = @plate", {
                        ["@custom"] = json.encode(props),
                        ["@plate"] = plaque
                    })
                else
                    MySQL.Async.fetchAll("SELECT plate FROM jobs_vehicles WHERE plate = @plate", {
                        ['@plate'] = plaque
                    }, function(result)
                        if result[1] ~= nil then
                            MySQL.Async.execute("UPDATE jobs_vehicles SET custom = @custom WHERE plate = @plate", {
                                ["@custom"] = json.encode(props),
                                ["@plate"] = plaque
                            })
                        end
                    end)
                end
            end)
		end
	end)
end)

local JobMecano = {
    ['grimmotors'] = true,
    ['harmonyrepair'] = true,
    ['mayansmotors'] = true,
    ['bennys'] = true,
    ['fdmotors'] = true,
    ['cayom'] = true,
    ['sandybennys'] = true,
    ['lscustoms'] = true,
}

RegisterNetEvent("annonceMec")
AddEventHandler("annonceMec", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if JobMecano[xPlayer.job.name] then
        TriggerClientEvent('esx:showAdvancedNotification', -1, xPlayer.job.label, "~b~Annonce", input, 'CHAR_CARSITE3', 1)
    else
        DropPlayer(source, "cheat AnnonceMec")
    end
end)