
ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterCommand("revive", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if tonumber(args[1]) then
            local xTarget = ESX.GetPlayerFromId(args[1])
            if xTarget then
				local idsSource = ESX.ExtractIdentifiers(xPlayer.source)
				local idsXTarget = ESX.ExtractIdentifiers(xTarget.source)
				local coords = xTarget.getCoords()
	
                TriggerClientEvent('RevivePlayerId', xTarget.source)
				ESX.SendWebhook("Revive Staff", "**Modérateur :** <@"..idsSource.discord:gsub("discord:", "")..">\n**Joueur :** <@"..idsXTarget.discord:gsub("discord:", "")..">\n**Position Joueur : **"..coords.x..", "..coords.y..", "..coords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsXTarget.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
            end
        end
    end
end, false)

RegisterNetEvent('AnnonceEMS')
AddEventHandler('AnnonceEMS', function(AnnoncesEMS)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "ems" then
		TriggerClientEvent('esx:showAdvancedNotification', -1, 'Pillbox Hill', '~b~Annonce', AnnoncesEMS, 'CHAR_CALL911', 1) 
	else
		DropPlayer(source, "cheat AnnonceEMS") 
	end
end)

ESX.RegisterServerCallback('GetDeathStatus', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchScalar('SELECT coma FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(row)
		if row == 1 then
			print(json.encode(row))
		end
		cb(row)
	end)
end)

RegisterNetEvent('SetDeathStatus')
AddEventHandler('SetDeathStatus', function(value)
	local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Sync.execute('UPDATE users SET coma = @coma WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier,
        ['@coma'] = value
    })
end)

RegisterNetEvent('ReanimationPlayerComa')
AddEventHandler('ReanimationPlayerComa', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "ems" or xPlayer.job.name == "police" then
		if #(GetEntityCoords(GetPlayerPed(source))-GetEntityCoords(GetPlayerPed(target))) < 15 then
    		TriggerClientEvent("ReanimationComa", target)
		else
			DropPlayer(source, "cheat reanimation")
		end
	else
		DropPlayer(source, "cheat reanimation")
	end
end)

RegisterNetEvent('HealJoueur')
AddEventHandler('HealJoueur', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == "ems" then
		if #(GetEntityCoords(GetPlayerPed(source))-GetEntityCoords(GetPlayerPed(target))) < 15 then
    		TriggerClientEvent("HealJoueur", target)
		else
			DropPlayer(source, "cheat Heal")
		end
	else
		DropPlayer(source, "cheat Heal")
	end
end)

RegisterNetEvent('SuccesMission')
AddEventHandler('SuccesMission', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.job.name == "ems" then
		xPlayer.addMoney(15)
	else
		DropPlayer(source, "cheat SuccesMission")
	end
end)

RegisterNetEvent('RemoveWeaponDeath')
AddEventHandler('RemoveWeaponDeath', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local listWeapon = {"coke", "meth", "weed", "45acp_ammo", "762mm_ammo", "9mm_ammo", "12_ammo", "WEAPON_PISTOL", "WEAPON_BAT","WEAPON_COMBATPISTOL", "WEAPON_STUNGUN", "WEAPON_PISTOL50", "WEAPON_SNSPISTOL", "WEAPON_HEAVYPISTOL", "WEAPON_VINTAGEPISTOL", "WEAPON_FLAREGUN", "WEAPON_MARKSMANPISTOL", "WEAPON_REVOLVER", "WEAPON_DOUBLEACTION", "WEAPON_CERAMICPISTOL", "WEAPON_NAVYREVOLVER", "WEAPON_GADGETPISTOL", "WEAPON_MICROSMG", "WEAPON_SMG", "WEAPON_ASSAULTSMG", "WEAPON_COMBATPDW", "WEAPON_MACHINEPISTOL", "WEAPON_MINISMG", "WEAPON_PUMPSHOTGUN", "WEAPON_SAWNOFFSHOTGUN", "WEAPON_ASSAULTSHOTGUN", "WEAPON_BULLPUPSHOTGUN", "WEAPON_MUSKET", "WEAPON_HEAVYSHOTGUN", "WEAPON_DBSHOTGUN", "WEAPON_AUTOSHOTGUN", "WEAPON_COMBATSHOTGUN", "WEAPON_ASSAULTRIFLE", "WEAPON_CARBINERIFLE", "WEAPON_ADVANCEDRIFLE", "WEAPON_SPECIALCARBINE", "WEAPON_BULLPUPRIFLE", "WEAPON_COMPACTRIFLE", "WEAPON_MILITARYRIFLE", "WEAPON_RIFLE", "WEAPON_MG", "WEAPON_COMBATMG", "WEAPON_GUSENBERG", "WEAPON_SNIPERRIFLE", "WEAPON_HEAVYSNIPER", "WEAPON_MARKSMANRIFLE", "WEAPON_RPG", "WEAPON_GRENADELAUNCHER", "WEAPON_FIREWORK", "WEAPON_COMPACTLAUNCHER"}

	for k,v in pairs(listWeapon) do
		if xPlayer.getInventoryItem(v) ~= nil then
			if xPlayer.getInventoryItem(v).count >= 1 then
				xPlayer.removeInventoryItem(v, xPlayer.getInventoryItem(v).count)
			end
		end
	end
end)

-- Citizen.CreateThread(function()
-- 	local xPlayers 	= ESX.GetPlayers()

-- 	while true do
-- 		Wait(35000)
-- 		print('refresh ata 1')
-- 		for i = 1, #xPlayers, 1 do
-- 			local xTarget = ESX.GetPlayerFromId(xPlayers[i])

-- 			MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
-- 				["@identifier"] = xTarget.identifier
-- 			}, function(result)
-- 				print('ata 1')
-- 				if result[1] then	
-- 					print('ata 2')
-- 					local AtaPlayer = result[1].ata
-- 					local TimeAta = result[1].timeata

-- 					if AtaPlayer == 1 then
-- 						print('ata 3')
-- 						local TimeDiffAta = result[1].diffata
-- 						local TimeStart = json.decode(TimeAta)
-- 						local test = os.difftime(os.time(), os.time{year = TimeStart.year, month = TimeStart.month, day = TimeStart.day, hour = TimeStart.hour, min = TimeStart.min, sec = TimeStart.sec}) / 60

-- 						local temps = (TimeDiffAta-math.floor(test))
-- 						print(temps)
-- 						if temps > 0 then
-- 							print('ata 5')
-- 							MySQL.Sync.execute('UPDATE users SET ata = @ata, timeata = @ata2, diffata = @ata3 WHERE identifier = @identifier', {
-- 								['@identifier'] = xTarget.identifier,
-- 								['@ata'] = 0,
-- 								['@ata2'] = nil,
-- 								['@ata3'] = nil
-- 							})
-- 						end
-- 					end
-- 				end
-- 			end)
-- 		end
-- 	end
-- end)

local playersHealing = {}

ESX.RegisterUsableItem('medikit', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('medikit', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('UseItemSoins', source, 'medikit')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)

ESX.RegisterUsableItem('bandage', function(source)
	if not playersHealing[source] then
		local xPlayer = ESX.GetPlayerFromId(source)
		xPlayer.removeInventoryItem('bandage', 1)
	
		playersHealing[source] = true
		TriggerClientEvent('UseItemSoins', source, 'bandage')

		Citizen.Wait(10000)
		playersHealing[source] = nil
	end
end)