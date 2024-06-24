ESX = nil
TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterCommand('me', function(source, args)
    local text = "L'individu "..table.concat(args, " ")
    TriggerClientEvent('3dme:shareDisplay', -1, text, source)
end)

RegisterCommand("heal", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if tonumber(args[1]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                TriggerClientEvent('healPlayer', xTarget.source)
            end
        end
    end
end, false)

ESX.RegisterUsableItem("box", function(source)
    TriggerClientEvent('useGantsBox', source)
end)

ESX.RegisterUsableItem('jumelle', function(source)
    TriggerClientEvent('useJumelle', source)
end)

ESX.RegisterUsableItem('parapluie', function(source)
    TriggerClientEvent('useParapluie', source)
end)

ESX.RegisterServerCallback("GetPlayers", function(source, cb)
    cb(ESX.GetPlayers())
end)

SetRoutingBucketPopulationEnabled(0, false)

ESX.RegisterUsableItem("ciseaux", function(source)
    TriggerClientEvent("useCiseaux", source)
end)

RegisterNetEvent("HairCut")
AddEventHandler("HairCut", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if target == -1 then return end

    if not target then
        DropPlayer(source, 'Tentative de couper les cheveux sur un id qui n\'existe pas')
    end

    if #(GetEntityCoords(GetPlayerPed(source))-GetEntityCoords(GetPlayerPed(target))) < 15 and xPlayer.getInventoryItem("ciseaux").count then 
        TriggerClientEvent("HairCut", target)
    else
        DropPlayer(source,'Cheat haircut')
    end
end)

RegisterCommand('activateDiamond', function(source, args)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    if args then
        MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
            ['@identifier'] = xPlayer.identifier
        }, function(result)
            if not result[1] then 
                MySQL.Async.fetchAll("SELECT * FROM diamond WHERE transaction = @transaction", {
                    ['@transaction'] = args[1]
                }, function(result)
                    if result[1] then
                        if result[1].identifier == nil then
                            if tostring(result[1].transaction) == tostring(args[1]) then
                                local date = {
                                    year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
                                }
                                MySQL.Async.execute('UPDATE diamond SET identifier = @identifier, date = @date WHERE transaction = @transaction',{
                                    ['@transaction'] = args[1],
                                    ['@date'] = json.encode(date),
                                    ['@identifier'] = xPlayer.identifier
                                })
                                xPlayer.showNotification("~g~Vous avez activé votre Diamond ! Bon jeu sur Offline")
                                TriggerClientEvent('RefreshDiamond', xPlayer.source)
                            else
                                xPlayer.showNotification("~r~Erreur, Vérifiez que le numéro de la transaction est correct !")
                            end
                        else
                            xPlayer.showNotification("~r~Erreur, Vous avez déjà activé votre Diamond !")
                        end
                    else
                        xPlayer.showNotification("~r~Erreur, Vérifiez que le numéro de la transaction est correct !")
                    end
                end)
            else
                xPlayer.showNotification("~r~Erreur, Impossible vous avez déjà le diamond.")
            end
        end)
    else
        xPlayer.showNotification("~r~Erreur, Vérifiez que le numéro de la transaction est correct !")
    end
end, false)

RegisterCommand('addDiamond', function(source, args)
    if source == nil or source == 0 then
        if args then
            print('Add Diamond : '..args[1])
            local date = {
                year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
            }
            MySQL.Async.execute('INSERT INTO diamond (transaction, date) VALUES (@transaction, @date)',{
                ['@transaction'] = args[1],
                ['@date'] = json.encode(date)
            })
        end
    end
end, true)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)

    MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
        ['@identifier'] = xPlayer.identifier
    }, function(result)
        if result[1] then
            local dateDiamond = json.decode(result[1].date)
            if dateDiamond ~= nil then
                local timeExist = os.difftime(os.time(), os.time{year = dateDiamond.year, month = dateDiamond.month, day = dateDiamond.day, hour = dateDiamond.hour, min = dateDiamond.min, sec = dateDiamond.sec}) / 60
                
                if (43800-math.floor(timeExist)) <= 0 then
                    MySQL.Async.execute('DELETE FROM diamond WHERE identifier = @identifier',{
                        ['@identifier'] = xPlayer.identifier
                    })
                end
            end
        end
    end)

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(result)
		if result[1].ata == 1 then
			local TimeStart = json.decode(result[1].timeata)
			local TempsAta = result[1].diffata
			local difftime = os.difftime(os.time(), os.time{year = TimeStart.year, month = TimeStart.month, day = TimeStart.day, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec}) / 60

			if (TempsAta-math.floor(difftime)) <= 0 then
				
                MySQL.Sync.execute('UPDATE users SET timeata = @timeata, ata = @ata, diffata = @diffata WHERE identifier = @identifier', {
                    ['@identifier'] = xPlayer.identifier,
                    ['@ata'] = 0,
                    ['@diffata'] = nil,
                    ['@timeata'] = nil
                })

                if getInfosPlayer(_src) ~= nil then
                    AllPlayers[_src] = {
                        name = xPlayer.getIdentity() or GetPlayerName(_src),
                        dateofbirth = getInfosPlayer(_src).dateofbirth or "27/02/2000",
                        ldn = getInfosPlayer(_src).ldn or "Los Santos",
                        id = _src,
                        idperso = getInfosPlayer(_src).idperso,
                        diamond = GetDiamondPlayer(_src),
                        ata = getInfosPlayer(_src).ata,
                        group = getInfosPlayer(_src).group,
                        discordname = GetDiscordName(_src)
                    }
                end
			end
		end
	end)
end)

RegisterNetEvent('syncPlayer')
AddEventHandler("syncPlayer", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    ESX.SavePlayer(xPlayer, function(rowsChanged)
        if rowsChanged ~= 0 then
            xPlayer.showNotification("~g~Personnage synchronisé !")
        end
    end)
end)