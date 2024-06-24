function sendToDiscordWithSpecialURL(name, message, color, url)
    local DiscordWebHook = 'https://discord.com/api/webhooks/1015438984085766194/KDILCeItq_4zfP1VyXk30R2xL6lPxNCl-Eb1glhHOHLwAQHRvXyDX0Az3tLDIFT8_MRe'
    -- Modify here your discordWebHook username = name, content = message,embeds = embeds
  
  local embeds = {
      {
		["color"] = color,
		["title"] = name,
		["description"] = message,
		["footer"] = {["text"] = os.date("%Y/%m/%d %H:%M:%S")}, 
      }
  }
    if message == nil or message == '' then
		return
	end
    PerformHttpRequest(DiscordWebHook, function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

ESX = nil

TriggerEvent("LandLife:GetSharedObject", function(obj) ESX = obj end)

ESX.RegisterServerCallback("esx_inventoryhud:getPlayerInventory", function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if targetXPlayer ~= nil then
		MySQL.Async.fetchAll("SELECT * FROM card_account WHERE porteur = '" .. targetXPlayer.identifier .. "'", {}, function(result)
			MySQL.Async.fetchAll("SELECT * FROM id_card WHERE porteur = '" .. targetXPlayer.identifier .. "'", {}, function(result2)
				if targetXPlayer ~= nil then
					cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout, weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight, cards = result, idcard = result2})
				else
					cb(nil)
				end
			end)
		end)
	end
end)

ESX.RegisterServerCallback("esx_inventoryhud:othersPlayerInventory", function(source, cb, target)
	local targetXPlayer = ESX.GetPlayerFromId(target)
	if targetXPlayer ~= nil then
		MySQL.Async.fetchAll("SELECT * FROM card_account WHERE porteur = '" .. targetXPlayer.identifier .. "'", {}, function(result)
			MySQL.Async.fetchAll("SELECT * FROM id_card WHERE porteur = '" .. targetXPlayer.identifier .. "'", {}, function(result2)
				MySQL.Async.fetchAll("SELECT * FROM vetement WHERE identifier = '" .. targetXPlayer.identifier .. "'", {}, function(result3)
					if targetXPlayer ~= nil then
						cb({inventory = targetXPlayer.inventory, money = targetXPlayer.getMoney(), accounts = targetXPlayer.accounts, weapons = targetXPlayer.loadout, weight = targetXPlayer.getWeight(), maxWeight = targetXPlayer.maxWeight, cards = result, idcard = result2, kevlar = result3})
					else
						cb(nil)
					end
				end)
			end)
		end)
	end
end)

RegisterNetEvent("ChangePorteurCard")
AddEventHandler("ChangePorteurCard", function(player, account, name)
	local xTarget = ESX.GetPlayerFromId(player)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE card_account SET porteur = @porteur WHERE account = @account", {
		["@porteur"] = xTarget.identifier,
		["@account"] = account
	})

	xTarget.MissionText("+ 1 "..name, 3000)
	identifiers = GetNumPlayerIdentifiers(source)
	for i = 0, identifiers + 1 do
		if GetPlayerIdentifier(source, i) ~= nil then
			if string.match(GetPlayerIdentifier(source, i), "discord") then
				discord = GetPlayerIdentifier(source, i)
			end
		end
	end
	sendToDiscordWithSpecialURL("Offline Logger","Utilisateur **"..xPlayer.getIdentity().."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : a donné sa carte bleue associé au compte banquaire : "..account.." à "..xTarget.getIdentity(), 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
end)

RegisterNetEvent("ChangePorteurIdCard")
AddEventHandler("ChangePorteurIdCard", function(player, id, name)
	local xTarget = ESX.GetPlayerFromId(player)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE id_card SET porteur = @porteur WHERE id = @id", {
		["@porteur"] = xTarget.identifier,
		["@id"] = id
	})

	local type = nil
	MySQL.Async.fetchAll("SELECT * FROM id_card WHERE id = @id", {
		["@id"] = id
	}, function(result)
		if result[1] then
			if result[1].type == "permis" then
				type = "Permis"
			else
				type = "Carte d'identité"
			end
		end
	end)
	Wait(500)
	xTarget.MissionText("+ 1 "..name, 3000)
	identifiers = GetNumPlayerIdentifiers(source)
	for i = 0, identifiers + 1 do
		if GetPlayerIdentifier(source, i) ~= nil then
			if string.match(GetPlayerIdentifier(source, i), "discord") then
				discord = GetPlayerIdentifier(source, i)
			end
		end
	end
	sendToDiscordWithSpecialURL("Offline Logger","Utilisateur **"..xPlayer.getIdentity().."\n**sID: "..xPlayer.source.."**\n[DiscordId: "..discord.."]\nAction : a donné sa/son "..type.." à "..xTarget.getIdentity(), 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
end)

RegisterNetEvent("esx_inventoryhud:tradePlayerItem")
AddEventHandler("esx_inventoryhud:tradePlayerItem",	function(from, target, type, itemName, itemCount)
	local _source = from

	local sourceXPlayer = ESX.GetPlayerFromId(_source)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == "item_standard" then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then

				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem(itemName, itemCount)
			else
				sourceXPlayer.showNotification('~r~Impossible~s~~n~l\'inventaire de l\'individu est plein.')
			end
		end
	elseif type == "item_money" then
		if itemCount > 0 and sourceXPlayer.getMoney() >= itemCount then
			sourceXPlayer.removeMoney(itemCount)
			targetXPlayer.addMoney(itemCount)
			sourceXPlayer.showNotification('Vous venez de donner ~g~'..itemCount.."$~s~.")
			targetXPlayer.showNotification('Vous avez reçu ~g~'..itemCount.."$~s~.")
		end
	elseif type == "item_account" then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney(itemName, itemCount)
		end
	elseif type == "item_weapon" then
		if not targetXPlayer.hasWeapon(itemName) then
			sourceXPlayer.removeWeapon(itemName)
			targetXPlayer.addWeapon(itemName, itemCount)
		end
	end
end)

RegisterNetEvent('getgps')
AddEventHandler('getgps', function()
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
    local getgpsinventory = 0

	for i=1, #xPlayer.inventory, 1 do
		local item = xPlayer.inventory[i]

		if item.name == "gps" then
            getgpsinventory = item.count
		end
	end
    
    if getgpsinventory > 0 then
		TriggerClientEvent('addgps', _source)
    end
end)

----- Vetement -----

ESX.RegisterServerCallback('AltixGetType', function(source, cb)
	local identifier = GetPlayerIdentifier(source)
	local masque = {}
	MySQL.Async.fetchAll('SELECT * FROM vetement WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result) 
		for i = 1, #result, 1 do  
			table.insert(masque, {      
                type      = result[i].type,  
				clothe      = result[i].clothe,
				id      = result[i].id,
				nom      = result[i].nom,
				vie      = result[i].vie,
				onPickup = result[i].onPickup
			})
		end  
		cb(masque) 
	end)  
end)

RegisterNetEvent('InsertVetement')
AddEventHandler('InsertVetement', function(type, name, Nom1, lunettes, Nom2, variation)
  local ident = GetPlayerIdentifier(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  maskx = {[Nom1]=tonumber(lunettes),[Nom2]=tonumber(variation)} 
	MySQL.Async.execute('INSERT INTO vetement (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)', { 
		['@identifier']   = ident,
    	['@type']   = type,
    	['@nom']   = name,
    	['@clothe'] = json.encode(maskx)
	})
	identifiers = GetNumPlayerIdentifiers(source)
	for i = 0, identifiers + 1 do
		if GetPlayerIdentifier(source, i) ~= nil then
			if string.match(GetPlayerIdentifier(source, i), "discord") then
				discord = GetPlayerIdentifier(source, i)
			end
		end
	end
	sendToDiscordWithSpecialURL("Offline Logger","Utilisateur **"..xPlayer.getIdentity().."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : a acheté le vêtement "..name, 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
end)

RegisterNetEvent('InsertTenue')
AddEventHandler('InsertTenue', function(type, name, clothe)
  local ident = GetPlayerIdentifier(source)
	MySQL.Async.execute('INSERT INTO vetement (identifier, type, nom, clothe) VALUES (@identifier, @type, @nom, @clothe)',
	{
		['@identifier'] = ident,
    	['@type'] = type,
    	['@nom'] = name,
    	['@clothe'] = json.encode(clothe)
		}, function(rowsChanged) 
	end)
end)

RegisterNetEvent('DeleteVetement')
AddEventHandler('DeleteVetement', function(supprimer)
    MySQL.Async.execute('DELETE FROM vetement WHERE id = @id', { 
        ['@id'] = supprimer 
    }) 
end)

RegisterNetEvent('VetementPickupOn')
AddEventHandler('VetementPickupOn', function(supprimer)
    MySQL.Async.execute('UPDATE vetement SET onPickup = @onPickup WHERE id = @id', { 
        ['@id'] = supprimer,
		['@onPickup'] = true 
    }) 
end)

RegisterNetEvent('VetementPickupOff')
AddEventHandler('VetementPickupOff', function(supprimer)
    MySQL.Async.execute('UPDATE vetement SET onPickup = @onPickup WHERE id = @id', { 
        ['@id'] = supprimer,
		['@onPickup'] = false 
    }) 
end)


RegisterNetEvent('VetementPickupIdentifier')
AddEventHandler('VetementPickupIdentifier', function(supprimer, identifier)
    MySQL.Async.execute('UPDATE vetement SET identifier = @identifier WHERE id = @id', { 
        ['@id'] = supprimer,
		['@identifier'] = identifier 
    }) 
end)

RegisterNetEvent('ModifNom')
AddEventHandler('ModifNom', function(id, Actif)   
	MySQL.Sync.execute('UPDATE vetement SET nom = @nom WHERE id = @id', {
		['@id'] = id,   
		['@nom'] = Actif        
	})
end)

RegisterNetEvent('Vetement:giveitem')
AddEventHandler('Vetement:giveitem', function(id, personne, name)   
	local xPlayer = ESX.GetPlayerFromId(source)
	local xPlayerT = ESX.GetPlayerFromId(personne)
	MySQL.Sync.execute('UPDATE vetement SET identifier = @identifier WHERE id = @id', {
		['@id'] = id,   
		['@identifier'] = xPlayerT.identifier     
	})
	xPlayerT.showNotification("Vous avez reçu un(e) ~b~"..name)
	identifiers = GetNumPlayerIdentifiers(xPlayer.source)
	for i = 0, identifiers + 1 do
		if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
			if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
				discord = GetPlayerIdentifier(xPlayer.source, i)
			end
		end
	end
	sendToDiscordWithSpecialURL("Offline Logger","Utilisateur **"..xPlayer.getIdentity().."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : a donné un vêtement à "..xPlayerT.getIdentity(), 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
end)

RegisterNetEvent('UpdateVieKevlar')
AddEventHandler('UpdateVieKevlar', function(id, vie)
    MySQL.Async.execute('UPDATE vetement SET vie = @vie WHERE id = @id', { 
        ['@id'] = id,
		['@vie'] = vie 
    }) 
end)

RegisterNetEvent('Malette')
AddEventHandler('Malette', function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local defaultMaxWeight = ESX.GetConfig().MaxWeight
	if type == 1 then
		xPlayer.setMaxWeight(defaultMaxWeight + 2000)
		xPlayer.showNotification("~r~Informations~s~\nVous avez maintenant une capacité en plus de : "..(math.floor(2000/1000)).."KG")
	elseif type == 2 then
		xPlayer.setMaxWeight(defaultMaxWeight + 3000)
		xPlayer.showNotification("~r~Informations~s~\nVous avez maintenant une capacité en plus de : "..(math.floor(3000/1000)).."KG")
	elseif type == 3 then
		xPlayer.setMaxWeight(defaultMaxWeight)
	end
end)