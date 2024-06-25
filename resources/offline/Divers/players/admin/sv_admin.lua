ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('GetGroup', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local group = xPlayer.getGroup()
    cb(group)
end)

function sendToDiscordWithSpecialURL(name,message,color,url)
    local DiscordWebHook = 'https://discord.com/api/webhooks/1015438984085766194/KDILCeItq_4zfP1VyXk30R2xL6lPxNCl-Eb1glhHOHLwAQHRvXyDX0Az3tLDIFT8_MRe'
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
      {
          ["title"]=message,
          ["type"]="rich",
          ["color"]=color,
          ["footer"]={
          ["text"]=os.date("%Y/%m/%d %H:%M:%S"),
         },
      }
  }
  
    if message == nil or message == '' then return FALSE end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function getInfosPlayer(source)
	local identifier = GetPlayerIdentifiers(source)[1]
	local result = MySQL.Sync.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {['@identifier'] = identifier})
	if result[1] ~= nil then
		local infos = result[1]

		return {
			identifier = infos['identifier'],
            diamond = infos['diamond'],
            ata = infos['ata'],
		}
	else
		return nil
	end
end

function GetDiamondPlayer(src)
    local identifier = GetPlayerIdentifiers(src)[1]
    local xPlayer = ESX.GetPlayerFromId(src)
    if xPlayer == nil then
        return false
    end
    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        return true
    else
        local result = MySQL.Sync.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {['@identifier'] = identifier})
        if result[1] ~= nil then
            return true
        else
            return false
        end
    end
end

local FormattedToken = "Bot " .. "OTIyMjU5OTA4NTc2MDIyNTc4.Yb-3eA.9Oi3x8Eii7467VbjDD2NfPAOUdc"

function DiscordRequest(method, endpoint, jsondata)
    local data = nil
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and json.encode(jsondata) or "", {["Content-Type"] = "application/json", ["Authorization"] = FormattedToken})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

function GetDiscordName(user) 
    local discordId = nil
    local nameData = nil;
    for _, id in ipairs(GetPlayerIdentifiers(user)) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    if discordId then 
        local endpoint = ("users/%s"):format(discordId)
        local member = DiscordRequest("GET", endpoint, {})
        if member.code == 200 then
            local data = json.decode(member.data)
            if data ~= nil then 
                nameData = data.username .. "#" .. data.discriminator;
            end
        else 
        	print("[Badger_Perms] ERROR: Code 200 was not reached. DETAILS: " .. error_codes_defined[member.code])
        end
    end
    return nameData
end

function GetPermDiscord(src, idrole)
    local role = "non"

    for k, v in pairs(GetDiscordRoles(src)) do
        if v == idrole then
            role = true
        end
    end

    return role
end

function GetDiscordRoles(src)
	local discordId = nil
	for _, id in ipairs(GetPlayerIdentifiers(src)) do
		if string.match(id, "discord:") then
			discordId = string.gsub(id, "discord:", "")
			break
		end
	end

	if discordId then
		local endpoint = ("guilds/%s/members/%s"):format('930595342683078717', discordId)
		local member = DiscordRequest("GET", endpoint, {})
		if member.code == 200 then
			local data = json.decode(member.data)
			local roles = data.roles
			return roles
		end
    end
end

RegisterCommand("dis", function(source, args, rawCommand)
    print(json.encode(GetDiscordRoles(source)))
end)

RegisterCommand("dis2", function(source, args, rawCommand)
    local _src = source

    if GetPermDiscord(_src, '965239999337496577') then -- superadmin
        print('superadmin')
    elseif GetPermDiscord(_src, '965252570283118682') then -- dev
        print('dev')
    elseif GetPermDiscord(_src, '965241550814732329') then -- modo
        print('modo')
    end
end)

local AllPlayers = {}

RegisterNetEvent('UpdateAdminList')
AddEventHandler('UpdateAdminList', function()
    local v = source
    local xTarget = ESX.GetPlayerFromId(v)

    AllPlayers[v] = nil

    if getInfosPlayer(v) ~= nil then
        AllPlayers[v] = {
            name = xTarget.getIdentity() or GetPlayerName(v),
            dateofbirth = xTarget.getDateBirth() or "27/02/2000",
            ldn = xTarget.getLieuBirth() or "Los Santos",
            id = v,
            idperso = xTarget.getIdPerso(),
            diamond = GetDiamondPlayer(v),
            ata = getInfosPlayer(v).ata,
            group = xTarget.getGroup()
            --discordname = GetDiscordName(v)
        }
    end
end)

RegisterNetEvent('AddPlayerInAta')
AddEventHandler('AddPlayerInAta', function(target, index)
    local v = target
	local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)
	local date = {
		year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
	}

	MySQL.Sync.execute('UPDATE users SET timeata = @timeata, ata = @ata, diffata = @diffata WHERE identifier = @identifier', {
		['@identifier'] = xTarget.identifier,
		['@ata'] = 1,
		['@diffata'] = index,
		['@timeata'] = json.encode(date)
	})

    xPlayer.showNotification("~g~"..xTarget.getIdentity().."~s~ a été mit en ATA pour une durée de : ~o~"..index.."min")

    Wait(250)

    if getInfosPlayer(v) ~= nil then
        AllPlayers[v] = {
            name = xTarget.getIdentity() or GetPlayerName(v),
            dateofbirth = xTarget.getDateBirth() or "27/02/2000",
            ldn = xTarget.getLieuBirth() or "Los Santos",
            id = v,
            idperso = xTarget.getIdPerso(),
            diamond = GetDiamondPlayer(v),
            ata = getInfosPlayer(v).ata,
            group = xTarget.getGroup()
            --discordname = GetDiscordName(v)
        }
    end
end)

RegisterNetEvent('addListAdminMenu')
AddEventHandler('addListAdminMenu', function()
    local xPlayers 	= ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        local v = xTarget.source
    
        if not AllPlayers[v] then
            if getInfosPlayer(v) ~= nil then
                AllPlayers[v] = {
                    name = xTarget.getIdentity() or GetPlayerName(v),
                    dateofbirth = xTarget.getDateBirth() or "27/02/2000",
                    ldn = xTarget.getLieuBirth() or "Los Santos",
                    id = v,
                    idperso = xTarget.getIdPerso(),
                    diamond = GetDiamondPlayer(v),
                    ata = getInfosPlayer(v).ata,
                    group = xTarget.getGroup()
                    --discordname = GetDiscordName(v)
                }
            end
        end
    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local v = source
    local ids = ESX.ExtractIdentifiers(v)
    local xPlayer = ESX.GetPlayerFromId(v)

    if not AllPlayers[v] then
        ESX.SendWebhook("Connexion", "**ID in game :** "..v.."\n**Discord ID :** <@"..ids.discord:gsub("discord:", "")..">\n**License :** license:"..ids.license:gsub("license2:", "").."\n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(ids.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
        if getInfosPlayer(v) ~= nil then
            AllPlayers[v] = {
                name = xPlayer.getIdentity() or GetPlayerName(v),
                dateofbirth = xPlayer.getDateBirth() or "27/02/2000",
                ldn = xPlayer.getLieuBirth() or "Los Santos",
                id = v,
                idperso = xPlayer.getIdPerso(),
                diamond = GetDiamondPlayer(v),
                ata = getInfosPlayer(v).ata,
                group = xPlayer.getGroup()
                --discordname = GetDiscordName(v)
            }
        end
    end

    while true do
        Wait(900000)
        local aPlayer = ESX.GetPlayerFromId(v)
        local playername = GetPlayerName(v)

        if aPlayer then
            ESX.SavePlayer(aPlayer, function()
            end)
            xPlayer.showNotification("~g~Personnage~s~\nSynchronisation automatique.")
            print("[^2SAVE^7] Le joueur (^4"..playername.."^7) à été sauvegarder automatiquement")
        end
    end
end)

AddEventHandler("playerDropped", function(reason)
    local source = source
    AllPlayers[source] = nil
end)

ESX.RegisterServerCallback("GetAllPlayers",function(source, cb)
    cb(AllPlayers or {})
end)

RegisterNetEvent('LogsKilled')
AddEventHandler('LogsKilled', function(Type, idkiller)
    local _src = source
	local xPlayer = ESX.GetPlayerFromId(_src)
    local ids = ESX.ExtractIdentifiers(_src)
    local ids2 = ESX.ExtractIdentifiers(idkiller)
    local srcName = AllPlayers[_src].name
    
    if idkiller ~= nil then
        killerName = AllPlayers[idkiller].name
    else
        killerName = "Aucun"
    end

	if Type == "KO" then
		webhook = "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw"
	elseif Type == "Coma" then
		webhook = "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw"
	end

	if idkiller == "Aucun" then
		ESX.SendWebhook("Logs kill", "<@"..ids.discord:gsub("discord:", "").."> ("..srcName..") s'est suicidé", webhook, '3863105')
	else
        ESX.SendWebhook("Logs kill", "**Joueur Tué :** <@"..ids.discord:gsub("discord:", "").."> ("..srcName..")\n**Joueur Tueur :** <@"..ids2.discord:gsub("discord:", "").."> ("..killerName..")\n**ID ig tué :** ".._src.."\n**ID ig Tueur :** "..idkiller, webhook, '3863105')
	end
end)

RegisterNetEvent("MessageAdmin")
AddEventHandler("MessageAdmin", function(PlayerSelected, msg)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetXPlayer = ESX.GetPlayerFromId(PlayerSelected)
    
    if targetXPlayer ~= nil and xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        TriggerClientEvent('esx:showNotification', targetXPlayer.source, msg)
    else
        DropPlayer(source, "cheat MessageAdmin")
    end
end)

RegisterNetEvent("AnnonceAdmin")
AddEventHandler("AnnonceAdmin", function(msg)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        TriggerClientEvent('esx:showNotification', -1, "~b~Annonce Serveur~s~\n"..msg)
    else
        DropPlayer(source, "cheat AnnonceAdmin")
    end
end)

RegisterNetEvent('GotoPlayers')
AddEventHandler('GotoPlayers', function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if xTarget then
            local TargetCoords = xTarget.getCoords()
            TriggerClientEvent('GotoPlayers', source, TargetCoords)
        end
    else
        DropPlayer(source, "cheat GotoPlayers")
    end
end)

RegisterNetEvent("BringPlayers")
AddEventHandler("BringPlayers", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if xTarget then
            local xPlayerCoords = xPlayer.getCoords()
            xTarget.setCoords(xPlayerCoords)
        end
    end
end)

RegisterNetEvent("freezePly")
AddEventHandler("freezePly", function(src, state)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        TriggerClientEvent("freezePlys", src, state)
    end
end)

RegisterNetEvent("ScreenshotAdmin")
AddEventHandler("ScreenshotAdmin", function(PlayerSelected)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        local targetXPlayer = ESX.GetPlayerFromId(PlayerSelected)

        TriggerClientEvent('ScreenshotAdmin', targetXPlayer.source, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
    end
end)

RegisterNetEvent("KickPlayer")
AddEventHandler("KickPlayer", function(PlayerSelected, raison)
	local targetXPlayer = ESX.GetPlayerFromId(PlayerSelected)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if targetXPlayer ~= nil then
            DropPlayer(targetXPlayer.source, raison.." ("..GetPlayerName(source)..")")
        end
    end
end)

RegisterNetEvent("CreatePersoUser")
AddEventHandler("CreatePersoUser", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if xTarget then
            TriggerClientEvent('CreatePerso', xTarget.source)
        end
    else
        DropPlayer(xPlayer.source, "cheat CreatePerso")
    end
end)

RegisterNetEvent("GetInfosPlayers")
AddEventHandler("GetInfosPlayers", function(IdPlayer, Type)
	local sourceXPlayer = ESX.GetPlayerFromId(source)
	local targetXPlayer = ESX.GetPlayerFromId(IdPlayer)
    local discord = ""
    local id = ""

    if sourceXPlayer.getGroup() == 'superadmin' or sourceXPlayer.getGroup() == 'admin' or sourceXPlayer.getGroup() == 'moderator' then

        if Type == "Steamhex" then
            TriggerClientEvent('esx:Notification', sourceXPlayer.source, "Steam(hex)\n~b~"..targetXPlayer.identifier)
        elseif Type == "Discord" or Type == "Tout" then
            identifiers = GetNumPlayerIdentifiers(IdPlayer)
            for i = 0, identifiers + 1 do
                if GetPlayerIdentifier(IdPlayer, i) ~= nil then
                    if string.match(GetPlayerIdentifier(IdPlayer, i), "discord") then
                        discord = GetPlayerIdentifier(IdPlayer, i)
                        id = string.sub(discord, 9, -1)
                    elseif Type == "Discord" then
                        TriggerClientEvent('esx:Notification', sourceXPlayer.source, "ID Discord\n~o~"..id)
                    elseif Type == "Tout" then
                        if targetXPlayer.getGroup() == "user" then
                            TriggerClientEvent('esx:Notification', sourceXPlayer.source, "Steam(hex)\n~b~"..targetXPlayer.identifier.."~s~\nID Discord\n~o~"..id)
                        else
                            TriggerClientEvent('esx:Notification', source, "~r~Impossible de récupérer les infos d'un administrateur.")
                        end
                    end
                end
            end
        end
    end
end)

ESX.RegisterServerCallback('GetSanction', function(source, cb, ply)
	local xPlayer = ESX.GetPlayerFromId(ply)

	MySQL.Async.fetchAll('SELECT * FROM sanction WHERE have = @have', {
		['@have'] = xPlayer.identifier
	}, function(result) 
		cb(result)  
	end)  
end)

RegisterNetEvent('SetSanction')
AddEventHandler('SetSanction', function(id, sanction)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        sendToDiscordWithSpecialURL("Sanction Ajouter", "**"..GetPlayerName(source).."** à ajouté la sanction **"..sanction.."** au joueur **"..GetPlayerName(id).."**", 2, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
        MySQL.Async.execute('INSERT INTO sanction (have, give, raison, date) VALUES (@have, @give, @raison, @date)', {
            ['@have']   = GetPlayerIdentifier(id), 
            ['@give']   = GetPlayerName(source),
            ['@raison']   = sanction,
            ['@date']   = os.date("*t").day.."/"..os.date("*t").month,
        })
    end
end)

RegisterNetEvent('DeleteSanction')
AddEventHandler('DeleteSanction', function(id, raison, plysanction)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        sendToDiscordWithSpecialURL("Sanction Delete", "**"..GetPlayerName(source).."** à supprimé la sanction **"..raison.."** du joueur **"..GetPlayerName(plysanction).."**", 14177041, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
        MySQL.Async.execute('DELETE FROM sanction WHERE id = @id', {
            ['@id'] = id 
        })
    end
end)

ESX.RegisterServerCallback('GetJobs', function(source, cb)
    MySQL.Async.fetchAll('SELECT name, label FROM jobs', {}, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('GetJobsGrades', function(source, cb, job)
    MySQL.Async.fetchAll('SELECT id, name, label, grade FROM job_grades WHERE job_name = @job_name', {
        ['@job_name'] = job
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback('GetListeItem', function(source, cb)
	MySQL.Async.fetchAll('SELECT label, name FROM items', {}, function(result)    
		cb(result)     
	end)    
end)

ESX.RegisterServerCallback("GetCrewGrade", function(source, cb, crew)
    MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_crew = @id_crew', {
        ['@id_crew'] = crew
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('EditOwnerCrew')
AddEventHandler('EditOwnerCrew', function(id_grade, IdCrew, IdJoueur, NameJoueur)
    sendToDiscordWithSpecialURL(GetPlayerName(source).."** à supprimé le crew **"..name, 14177041, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")

end)

RegisterNetEvent('DeleteCrew')
AddEventHandler('DeleteCrew', function(id, name)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        sendToDiscordWithSpecialURL("Crew delete", "**"..GetPlayerName(source).."** à supprimé le crew **"..name, 14177041, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")

        MySQL.Async.execute('DELETE FROM crew_liste WHERE id_crew = @id_crew', {
            ['@id_crew'] = id 
        })
        MySQL.Async.execute('DELETE FROM crew_membres WHERE id_crew = @id_crew', {
            ['@id_crew'] = id 
        })
        MySQL.Async.execute('DELETE FROM crew_vehicles WHERE crew = @crew', {
            ['@crew'] = id 
        })
        MySQL.Async.execute('DELETE FROM crew_grades WHERE id_crew = @id_crew', {
            ['@id_crew'] = id 
        })
    end
end)

RegisterCommand("tp", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    if args[1] then
        if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
            if tonumber(args[1]) then
                local xTarget = ESX.GetPlayerFromId(args[1])
                if xTarget then
                    local targetCoords = xTarget.getCoords()
                    TriggerClientEvent("GotoPlayers", xPlayer.source, targetCoords)
                end
            end
        end
    end
end, false)

RegisterCommand("dv", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        TriggerClientEvent('esx:deleteVehicle', xPlayer.source, args[1])
    end
end, false)

RegisterCommand("giveitem", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' then
        if tonumber(args[1]) and args[2] ~= nil and tonumber(args[3]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                xTarget.addInventoryItem(args[2], args[3])

                identifiers = GetNumPlayerIdentifiers(xPlayer.source)
                for i = 0, identifiers + 1 do
                    if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
                        if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
                            discord = GetPlayerIdentifier(xPlayer.source, i)
                        end
                    end
                end
      
                sendToDiscordWithSpecialURL("offline Logger","Utilisateur **"..xPlayer.getIdentity().."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : give l'item "..args[2].." à "..xTarget.getIdentity(), 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
            end
        end
    end
end, false)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {} ; i = 1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

RegisterCommand("dm", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if tonumber(args[1])  then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                sm = stringsplit(rawCommand, " ")
                message = ""
                for i = 3, #sm do
                    message = message ..sm[i].. " "
                end
                xTarget.showNotification("~r~Modération~s~\n"..message)
            end
        end
    end
end, false)

RegisterCommand("kick", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if tonumber(args[1])  then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                sm = stringsplit(rawCommand, " ")
                message = ""
                for i = 3, #sm do
                    message = message ..sm[i].. " "
                end
                DropPlayer(xTarget.source, message.." ("..GetPlayerName(xPlayer.source)..")")
            end
        end
    end
end, false)

RegisterCommand("setjob", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
        if tonumber(args[1]) and args[2] ~= nil and tonumber(args[3]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                if ESX.DoesJobExist(args[2], args[3]) then
                    xTarget.setJob(args[2], args[3])
                end            
            end
        end
    end
end, false)

RegisterCommand("bring", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if tonumber(args[1]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
                local xPlayerCoords = xPlayer.getCoords()
                local idsSource = ESX.ExtractIdentifiers(xPlayer.source)
				local idsXTarget = ESX.ExtractIdentifiers(xTarget.source)

                xTarget.setCoords(xPlayerCoords)
                TriggerClientEvent('RevivePlayerId', xTarget.source)
				ESX.SendWebhook("Bring Staff", "**Modérateur :** <@"..idsSource.discord:gsub("discord:", "")..">\n**Joueur :** <@"..idsXTarget.discord:gsub("discord:", "")..">\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsXTarget.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
            end
        end
        if tonumber(args[2]) then
            local xTarget = ESX.GetPlayerFromId(args[2])
            if xTarget then
                local xPlayerCoords = xPlayer.getCoords()

                xTarget.setCoords(xPlayerCoords)
            end
        end
        if tonumber(args[3]) then
            local xTarget = ESX.GetPlayerFromId(args[3])
            if xTarget then
                local xPlayerCoords = xPlayer.getCoords()

                xTarget.setCoords(xPlayerCoords)
            end
        end
        if tonumber(args[4]) then
            local xTarget = ESX.GetPlayerFromId(args[4])
            if xTarget then
                local xPlayerCoords = xPlayer.getCoords()

                xTarget.setCoords(xPlayerCoords)
            end
        end
        if tonumber(args[5]) then
            local xTarget = ESX.GetPlayerFromId(args[5])
            if xTarget then
                local xPlayerCoords = xPlayer.getCoords()

                xTarget.setCoords(xPlayerCoords)
            end
        end
    end
end, false)

local reports = {}
local cvc = {}

RegisterCommand("report", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers = ESX.GetPlayers()

    if (#args > 0) then
        TriggerClientEvent("chat:addMessage", xPlayer.source, { args = {"^1SYSTEM", "Votre rapport a été envoyé"}})

        local reportReason = table.concat(args, " ")
        local report = {
            id = #reports + 1,
            playerName = xPlayer.getName(),
            playerId = xPlayer.source,
            reason = reportReason,
            date = os.date("%Y-%m-%d %H:%M:%S")
        }
        table.insert(reports, report)

        for i = 1, #xPlayers, 1 do
            local xAdmin = ESX.GetPlayerFromId(xPlayers[i])
            if xAdmin.getGroup() == 'superadmin' or xAdmin.getGroup() == 'admin' or xAdmin.getGroup() == 'moderator' then
                TriggerClientEvent("chat:addMessage", xAdmin.source, { args = {"^6REPORT", "(^6".. xPlayer.source .."^0) ^6" .. xPlayer.getName() .."^0 : " .. reportReason}})
            end
        end
    else
        TriggerClientEvent("chat:addMessage", xPlayer.source, { args = {"^1SYSTEM", "Assurez-vous de suivre le format d'un report"}})
    end
end)

ESX.RegisterServerCallback('GetReports', function(source, cb)
    cb(reports)
end)

RegisterServerEvent('DeleteReport')
AddEventHandler('DeleteReport', function(reportId)
    for i = #reports, 1, -1 do
        if reports[i].id == reportId then
            table.remove(reports, i)
            break
        end
    end
end)




RegisterServerEvent('getAllCVC')
AddEventHandler('getAllCVC', function(cb)
    cb(cvc)
end)

RegisterServerEvent('addCVC')
AddEventHandler('addCVC', function(name, equipe1, equipe2)
    local newCVC = {
        id = #cvc + 1,
        name = name,
        equipe1 = equipe1,
        equipe2 = equipe2,
        date = os.date("%Y-%m-%d %H:%M:%S")
    }
    table.insert(cvc, newCVC)
    TriggerClientEvent('updateCVC', -1, cvc)  -- Met à jour tous les clients avec la nouvelle liste de CVC
end)

RegisterServerEvent('getPlayerByIdcrew')
AddEventHandler('getPlayerByIdcrew', function(id_crew)
    MySQL.Async.fetchAll('SELECT identifier FROM crew_membres WHERE id_crew = @id_crew', {
		['@id_crew'] = id_crew
	}, function(result) 
        local positions = {}
        
        -- Boucle à travers chaque membre pour récupérer sa position
        for _, data in ipairs(result) do
            local player = ESX.GetPlayerFromIdentifier(data.identifier)
            if player then
                local playerPed = GetPlayerPed(player.source)
                local playerCoords = GetEntityCoords(playerPed)
                table.insert(positions, playerCoords)
            end
        end

        -- Envoyer les positions au client
        TriggerClientEvent('receivePlayerPositions', -1, positions)
	end)
end)

RegisterServerEvent('getPlayerByIdcrew2')
AddEventHandler('getPlayerByIdcrew2', function(id_crew)
    MySQL.Async.fetchAll('SELECT identifier FROM crew_membres WHERE id_crew = @id_crew', {
		['@id_crew'] = id_crew
	}, function(result) 
        local positions = {}
        
        -- Boucle à travers chaque membre pour récupérer sa position
        for _, data in ipairs(result) do
            local player = ESX.GetPlayerFromIdentifier(data.identifier)
            if player then
                local playerPed = GetPlayerPed(player.source)
                local playerCoords = GetEntityCoords(playerPed)
                table.insert(positions, playerCoords)
            end
        end

        -- Envoyer les positions au client
        TriggerClientEvent('receivePlayerPositions2', -1, positions)
	end)
end)



RegisterCommand("md", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers 	= ESX.GetPlayers()

    if (#args > 0) then
        local reportreason = ""
        for x=1,#args do
            reportreason = reportreason .. " " .. args[x]
        end

        NamePly = GetPlayerName(source)

        for i = 1, #xPlayers, 1 do
            local xAdmin = ESX.GetPlayerFromId(xPlayers[i])
            if xAdmin.getGroup() == 'superadmin' or xAdmin.getGroup() == 'admin' or xAdmin.getGroup() == 'moderator' then
                TriggerClientEvent("chat:addMessage", xAdmin.source,  "(^1"..xPlayer.source.."^0 | ^1".. NamePly .."^0) : " .. reportreason)
            end
        end
    else
        TriggerClientEvent("chat:addMessage", xPlayer.source, "Assurez-vous de suivre le format")
    end
end)

RegisterCommand("car", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' then
        if args[1] ~= nil then
            TriggerClientEvent('esx:spawnVehicle', xPlayer.source, args[1])
        end
    end
end, false)