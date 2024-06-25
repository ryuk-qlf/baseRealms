local TableSavePlayers = {}

RegisterNetEvent('esx:onPlayerJoined')
AddEventHandler('esx:onPlayerJoined', function()
	if not ESX.Players[source] then
		onPlayerJoined(source)
	end
end)

function onPlayerJoined(playerId)
	local identifier
	local license
	
	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, Config.PrimaryIdentifier) then
			identifier = v
		end
		if string.match(v, 'license:') then
			license = v
		end
	end

	if identifier then
			MySQL.Async.fetchScalar('SELECT 1 FROM users WHERE identifier = @identifier', {
				['@identifier'] = identifier
			}, function(result)
				if result then
					loadESXPlayer(identifier, playerId)
				else
					local accounts = {}

					for account,money in pairs(Config.StartingAccountMoney) do
						accounts[account] = money
					end

					MySQL.Async.execute('INSERT INTO users (accounts, identifier, license) VALUES (@accounts, @identifier, @license)', {
						['@accounts'] = json.encode(accounts),
						['@identifier'] = identifier,
						['@license'] = license,						
					}, function(rowsChanged)
						loadESXPlayer(identifier, playerId)
					end)
				end
			end)
	else
		DropPlayer(playerId, 'Pour vous connecter au serveur vous avez besoin d\'ouvrir steam')
	end
end


function loadESXPlayer(identifier, playerId)
	-- TODO: Implement other loading methods
	
	local userData = {
		accounts = {},
		inventory = {},
		job = {},
		loadout = {},
		playerName = GetPlayerName(playerId),
		weight = 0
	}

	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = identifier
	}, function(result)
		local job, grade, jobObject, gradeObject = result[1].job, tostring(result[1].job_grade)
		local foundAccounts, foundItems = {}, {}
		local Firstname = result[1].firstname
		local Lastname = result[1].lastname
		local IdPerso = result[1].idperso
		local DateBirth = result[1].dateofbirth
		local LieuBirth = result[1].ldn

		-- Accounts
		if result[1].accounts and result[1].accounts ~= '' then
			local accounts = json.decode(result[1].accounts)

			for account,money in pairs(accounts) do
				foundAccounts[account] = money
			end
		end

		for account,label in pairs(Config.Accounts) do
			table.insert(userData.accounts, {
				name = account,
				money = foundAccounts[account] or Config.StartingAccountMoney[account] or 0,
				label = label
			})
		end

		-- Job
		if ESX.DoesJobExist(job, grade) then
			jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
		else
			print(('[lmodeextended] [^3WARNING^7] Ignoring invalid job for %s [job: %s, grade: %s]'):format(identifier, job, grade))
			job, grade = 'unemployed', '0'
			jobObject, gradeObject = ESX.Jobs[job], ESX.Jobs[job].grades[grade]
		end

		userData.job.id = jobObject.id
		userData.job.name = jobObject.name
		userData.job.label = jobObject.label

		userData.job.grade = tonumber(grade)
		userData.job.grade_name = gradeObject.name
		userData.job.grade_label = gradeObject.label
		userData.job.grade_salary = gradeObject.salary

		userData.job.skin_male = {}
		userData.job.skin_female = {}

		if gradeObject.skin_male then userData.job.skin_male = json.decode(gradeObject.skin_male) end
		if gradeObject.skin_female then userData.job.skin_female = json.decode(gradeObject.skin_female) end

		-- Inventory
		if result[1].inventory and result[1].inventory ~= '' then
			local inventory = json.decode(result[1].inventory)

			for name,count in pairs(inventory) do
				local item = ESX.Items[name]

				if item then
					foundItems[name] = count
				else
					print(('[lmodeextended] [^3WARNING^7] Ignoring invalid item "%s" for "%s"'):format(name, identifier))
				end
			end
		end

		for name,item in pairs(ESX.Items) do
			local count = foundItems[name] or 0
			if count > 0 then userData.weight = userData.weight + (item.weight * count) end

			if(count > 0)then
				table.insert(userData.inventory, {
					name = name,
					count = count,
					label = item.label,
					weight = item.weight,
					limit = item.limit,
					usable = ESX.UsableItemsCallbacks[name] ~= nil,
					rare = item.rare,
					canRemove = item.canRemove
				})
			end
		end

		table.sort(userData.inventory, function(a, b)
			return a.label < b.label

			
		end)

		-- Group
		if result[1].group then
			userData.group = result[1].group
		else
			userData.group = 'user'
		end

		-- Loadout
		if result[1].loadout and result[1].loadout ~= '' then
			local loadout = json.decode(result[1].loadout)

			for name,weapon in pairs(loadout) do
				local label = ESX.GetWeaponLabel(name)

				if label then
					if not weapon.components then weapon.components = {} end
					if not weapon.tintIndex then weapon.tintIndex = 0 end

					table.insert(userData.loadout, {
						name = name,
						ammo = weapon.ammo,
						label = label,
						components = weapon.components,
						tintIndex = weapon.tintIndex
					})
				end
			end
		end

		-- Position
		if result[1].position and result[1].position ~= '' then
			userData.coords = json.decode(result[1].position)
		else
			print('[lmodeextended] [^3WARNING^7] Column "position" in "users" table is missing required default value. Using backup coords, fix your database.')
			userData.coords = {x = -269.4, y = -955.3, z = 31.2, heading = 205.8}
		end

		-- Create Extended Player Object
		local xPlayer = CreateExtendedPlayer(playerId, identifier, userData.group, userData.accounts, userData.inventory, userData.weight, userData.job, userData.loadout, userData.playerName, userData.coords, Firstname, Lastname, IdPerso, DateBirth, LieuBirth)
		ESX.Players[playerId] = xPlayer
		TriggerEvent('esx:playerLoaded', playerId, xPlayer)

		xPlayer.triggerEvent('esx:playerLoaded', {
			accounts = xPlayer.getAccounts(),
			coords = xPlayer.getCoords(),
			identifier = xPlayer.getIdentifier(),
			inventory = xPlayer.getInventory(),
			job = xPlayer.getJob(),
			loadout = xPlayer.getLoadout(),
			maxWeight = xPlayer.maxWeight,
			money = xPlayer.getMoney()
		})



		xPlayer.triggerEvent('esx:createMissingPickups', ESX.Pickups)
		xPlayer.triggerEvent('esx:createMissingPickupsClothe', ESX.PickupsClothe)
		xPlayer.triggerEvent('esx:createMissingPickupsCards', ESX.PickupsCards)
		xPlayer.triggerEvent('esx:createMissingPickupsIdCards', ESX.PickupsIdCards)
		
		xPlayer.triggerEvent('esx:registerSuggestions', ESX.RegisteredCommands)
	end)
end

AddEventHandler('playerDropped', function(reason)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(playerId)
	local playername = GetPlayerName(playerId)

	if xPlayer then
		TriggerEvent('esx:playerDropped', playerId, reason)

		ESX.SavePlayer(xPlayer, function()
			ESX.Players[playerId] = nil
		end)

		print("[^2SAVE^7] Le joueur (^4"..playername.."^7) s'est déconnecté")
	end
end)

RegisterNetEvent('removePlayersCoords')
AddEventHandler('removePlayersCoords', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	TableSavePlayers[xPlayer.source] = nil
end)

RegisterNetEvent('addPlayersCoords')
AddEventHandler('addPlayersCoords', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if not TableSavePlayers[xPlayer.source] then
		TableSavePlayers[xPlayer.source] = xPlayer.source
	end
end)

RegisterNetEvent('esx:updateCoords')
AddEventHandler('esx:updateCoords', function(coords)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		if not TableSavePlayers[xPlayer.source] then
			xPlayer.updateCoords(coords)
		end
	end
end)

RegisterNetEvent('esx:updateWeaponAmmo')
AddEventHandler('esx:updateWeaponAmmo', function(weaponName, ammoCount)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		xPlayer.updateWeaponAmmo(weaponName, ammoCount)
	end
end)

RegisterNetEvent('esx:giveInventoryItem')
AddEventHandler('esx:giveInventoryItem', function(target, type, itemName, itemCount)
	local playerId = source
	local sourceXPlayer = ESX.GetPlayerFromId(playerId)
	local targetXPlayer = ESX.GetPlayerFromId(target)

	if type == 'item_standard' then
		local sourceItem = sourceXPlayer.getInventoryItem(itemName)
		local targetItem = targetXPlayer.getInventoryItem(itemName)

		if itemCount > 0 and sourceItem.count >= itemCount then
			if targetXPlayer.canCarryItem(itemName, itemCount) then
				sourceXPlayer.removeInventoryItem(itemName, itemCount)
				targetXPlayer.addInventoryItem   (itemName, itemCount)

				sourceXPlayer.showNotification(_U('gave_item', itemCount, sourceItem.label, targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_item', itemCount, sourceItem.label, sourceXPlayer.name))
			else
				sourceXPlayer.showNotification(_U('ex_inv_lim', targetXPlayer.name))
			end
		else
			sourceXPlayer.showNotification(_U('imp_invalid_quantity'))
		end
	elseif type == 'item_account' then
		if itemCount > 0 and sourceXPlayer.getAccount(itemName).money >= itemCount then
			sourceXPlayer.removeAccountMoney(itemName, itemCount)
			targetXPlayer.addAccountMoney   (itemName, itemCount)

			sourceXPlayer.showNotification(_U('gave_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], targetXPlayer.name))
			targetXPlayer.showNotification(_U('received_account_money', ESX.Math.GroupDigits(itemCount), Config.Accounts[itemName], sourceXPlayer.name))
		else
			sourceXPlayer.showNotification(_U('imp_invalid_amount'))
		end
	elseif type == 'item_weapon' then
		if sourceXPlayer.hasWeapon(itemName) then
			local weaponLabel = ESX.GetWeaponLabel(itemName)

			if not targetXPlayer.hasWeapon(itemName) then
				local _, weapon = sourceXPlayer.getWeapon(itemName)
				local _, weaponObject = ESX.GetWeapon(itemName)
				itemCount = weapon.ammo

				sourceXPlayer.removeWeapon(itemName)
				targetXPlayer.addWeapon(itemName, itemCount)

				if weaponObject.ammo and itemCount > 0 then
					local ammoLabel = weaponObject.ammo.label
					sourceXPlayer.showNotification(_U('gave_weapon_withammo', weaponLabel, itemCount, ammoLabel, targetXPlayer.name))
					targetXPlayer.showNotification(_U('received_weapon_withammo', weaponLabel, itemCount, ammoLabel, sourceXPlayer.name))
				else
					sourceXPlayer.showNotification(_U('gave_weapon', weaponLabel, targetXPlayer.name))
					targetXPlayer.showNotification(_U('received_weapon', weaponLabel, sourceXPlayer.name))
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_hasalready', targetXPlayer.name, weaponLabel))
				targetXPlayer.showNotification(_U('received_weapon_hasalready', sourceXPlayer.name, weaponLabel))
			end
		end
	elseif type == 'item_ammo' then
		if sourceXPlayer.hasWeapon(itemName) then
			local weaponNum, weapon = sourceXPlayer.getWeapon(itemName)

			if targetXPlayer.hasWeapon(itemName) then
				local _, weaponObject = ESX.GetWeapon(itemName)

				if weaponObject.ammo then
					local ammoLabel = weaponObject.ammo.label

					if weapon.ammo >= itemCount then
						sourceXPlayer.removeWeaponAmmo(itemName, itemCount)
						targetXPlayer.addWeaponAmmo(itemName, itemCount)

						sourceXPlayer.showNotification(_U('gave_weapon_ammo', itemCount, ammoLabel, weapon.label, targetXPlayer.name))
						targetXPlayer.showNotification(_U('received_weapon_ammo', itemCount, ammoLabel, weapon.label, sourceXPlayer.name))
					end
				end
			else
				sourceXPlayer.showNotification(_U('gave_weapon_noweapon', targetXPlayer.name))
				targetXPlayer.showNotification(_U('received_weapon_noweapon', sourceXPlayer.name, weapon.label))
			end
		end
	end
end)


RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(type, itemName, itemCount, coords, clotheId)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == "item_weapon" then return end

	if type == 'item_standard' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_quantity'))
		else
			local xItem = xPlayer.getInventoryItem(itemName)

			if (itemCount > xItem.count or xItem.count < 1) then
				xPlayer.showNotification(_U('imp_invalid_quantity'))
			else
				local model = 'v_serv_abox_02'
				for _,v in pairs(Config.Item) do
					if xItem.name == v[1] then
						model = v[2]
					end
				end
				xPlayer.removeInventoryItem(itemName, itemCount)
				local pickupLabel = ('x(~b~%s~s~)~b~ %s~s~'):format(itemCount, xItem.label)
				ESX.CreatePickup('item_standard', itemName, itemCount, pickupLabel, playerId, coords, model)
				xPlayer.showNotification(_U('threw_standard', itemCount, xItem.label))
			end
		end
	elseif type == 'item_account' then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local account = xPlayer.getAccount(itemName)
			if (itemCount > account.money or account.money < 1) then
				xPlayer.showNotification(_U('imp_invalid_amount'))
			else
				xPlayer.removeAccountMoney(itemName, itemCount)
				local pickupLabel = "~g~"..ESX.Math.GroupDigits(itemCount).."$~s~"
				ESX.CreatePickup('item_account', itemName, itemCount, pickupLabel, playerId, coords, "bkr_prop_moneypack_01a")
			end
		end
	end
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

RegisterNetEvent('esx:removeInventoryItemClothe')
AddEventHandler('esx:removeInventoryItemClothe', function(type, itemName, itemCount, coords, clotheId)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == "item_weapon" then return end

	if type == "item_tenue" or type == "item_kevlar" or type == "item_gant" or type == "item_tshirt" or type == "item_haut" or type == "item_chaussures" or type == "item_lunettes" or type == "item_calque" or type == "item_chaine" or type == "item_masque" or type == "item_pantalon" or type == "item_chapeau" or type == "item_sac" or type == "item_montre" or type == "item_bracelet" or type == "item_oreille" then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local model = 'prop_cs_box_clothes'
			for _,v in pairs(Config.ItemClothes) do
				if type == v[1] then
					model = v[2]
				end
			end
			local pickupLabel = "Vêtement"
			ESX.CreatePickupClothes(type, itemName, pickupLabel, clotheId, coords, model)
			TriggerEvent("VetementPickupOn", clotheId)
			identifiers = GetNumPlayerIdentifiers(xPlayer.source)
			for i = 0, identifiers + 1 do
				if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
					if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
						discord = GetPlayerIdentifier(xPlayer.source, i)
					end
				end
			end
			sendToDiscordWithSpecialURL("offline Logger","Utilisateur **"..xPlayer.getIdentity().."**\nsID: "..xPlayer.source.."\n[DiscordId: "..discord.."]\nAction : a jeté son vêtement "..itemName, 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItemCards')
AddEventHandler('esx:removeInventoryItemCards', function(type, infos, itemCount, coords)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == "item_weapon" then return end

	if type == "item_card" then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local model = 'ch_prop_swipe_card_01c'
			local pickupLabel = "Carte banquaire"
			ESX.CreatePickupCards(type, infos, pickupLabel, coords, model)
			MySQL.Async.execute("UPDATE card_account SET porteur = @porteur WHERE id = @id", {
				["@porteur"] = "",
				["@id"] = infos
			})
			identifiers = GetNumPlayerIdentifiers(xPlayer.source)
			for i = 0, identifiers + 1 do
				if GetPlayerIdentifier(xPlayer.source, i) ~= nil then
					if string.match(GetPlayerIdentifier(xPlayer.source, i), "discord") then
						discord = GetPlayerIdentifier(xPlayer.source, i)
					end
				end
			end
			sendToDiscordWithSpecialURL("offline Logger","Utilisateur **"..xPlayer.getIdentity().."\nsID: "..xPlayer.source.."\ns[DiscordId: "..discord.."]\nAction : a jeté sa carte banquaire associé au compte "..infos, 16711680, "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw")
		end
	end
end)

RegisterNetEvent('esx:removeInventoryItemIdCards')
AddEventHandler('esx:removeInventoryItemIdCards', function(type, infos, itemCount, coords)
	local playerId = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if type == "item_weapon" then return end

	if type == "item_idcard" then
		if itemCount == nil or itemCount < 1 then
			xPlayer.showNotification(_U('imp_invalid_amount'))
		else
			local model = 'ch_prop_swipe_card_01c'
			local pickupLabel = "Carte banquaire"
			ESX.CreatePickupIdCards(type, infos, pickupLabel, coords, model)
			MySQL.Async.execute("UPDATE id_card SET porteur = @porteur WHERE id = @id", {
				["@porteur"] = "",
				["@id"] = infos
			})
		end
	end
end)

RegisterNetEvent('esx:useItem')
AddEventHandler('esx:useItem', function(itemName)
	local xPlayer = ESX.GetPlayerFromId(source)
	local count = xPlayer.getInventoryItem(itemName).count

	if count > 0 then
		ESX.UseItem(source, itemName)
	else
		--xPlayer.showNotification(_U('act_imp'))
	end
end)

RegisterNetEvent('esx:onPickup')
AddEventHandler('esx:onPickup', function(pickupId)
	local pickup, xPlayer, success = ESX.Pickups[""..pickupId..""], ESX.GetPlayerFromId(source)

	if pickup then
		if pickup.type == 'item_standard' then
			if xPlayer.canCarryItem(pickup.name, pickup.count) then
				xPlayer.addInventoryItem(pickup.name, pickup.count)
				success = true
			else
				xPlayer.showNotification(_U('threw_cannot_pickup'))
			end
		elseif pickup.type == 'item_account' then
			success = true
			xPlayer.addAccountMoney(pickup.name, pickup.count)
		elseif pickup.type == 'item_weapon' then
			if xPlayer.hasWeapon(pickup.name) then
				xPlayer.showNotification(_U('threw_weapon_already'))
			else
				success = true
				xPlayer.addWeapon(pickup.name, pickup.count)
				xPlayer.setWeaponTint(pickup.name, pickup.tintIndex)

				for k,v in ipairs(pickup.components) do
					xPlayer.addWeaponComponent(pickup.name, v)
				end
			end
		end

		if success then
			ESX.Pickups[""..pickupId..""] = nil
			TriggerClientEvent('esx:removePickup', -1, ""..pickupId.."")
		end
	end
end)

RegisterNetEvent('esx:onPickupClothe')
AddEventHandler('esx:onPickupClothe', function(pickupId, ply)
	local pickup, xPlayer, success = ESX.PickupsClothe[""..pickupId..""], ESX.GetPlayerFromId(ply)

	if pickup then
		if pickup.type == "item_tenue" or pickup.type == "item_kevlar" or pickup.type == "item_gant" or pickup.type == "item_tshirt" or pickup.type == "item_haut" or pickup.type == "item_chaussures" or pickup.type == "item_lunettes" or pickup.type == "item_calque" or pickup.type == "item_chaine" or pickup.type == "item_masque" or pickup.type == "item_pantalon" or pickup.type == "item_chapeau" or pickup.type == "item_sac" or pickup.type == "item_montre" or pickup.type == "item_bracelet" or pickup.type == "item_oreille" then
			TriggerEvent("VetementPickupOff", pickup.id)
			TriggerEvent("VetementPickupIdentifier", pickup.id, xPlayer.identifier)
			success = true
		end

		if success then
			ESX.PickupsClothe[""..pickupId..""] = nil
			TriggerClientEvent('esx:removePickupClothe', -1, ""..pickupId.."")
		end
	end
end)

RegisterNetEvent('esx:onPickupCards')
AddEventHandler('esx:onPickupCards', function(pickupId, ply)
	local pickup, xPlayer, success = ESX.PickupsCards[""..pickupId..""], ESX.GetPlayerFromId(ply)

	if pickup then
		if pickup.type == "item_card" then
			MySQL.Async.execute("UPDATE card_account SET porteur = @porteur WHERE id = @id", {
				["@porteur"] = xPlayer.identifier,
				['@id'] = pickup.id
			})
			success = true
		end

		if success then
			ESX.PickupsCards[""..pickupId..""] = nil
			TriggerClientEvent('esx:removePickupCards', -1, ""..pickupId.."")
		end
	end
end)

RegisterNetEvent('esx:onPickupIdCards')
AddEventHandler('esx:onPickupIdCards', function(pickupId, ply)
	local pickup = ESX.PickupsIdCards[""..pickupId..""]
	local xPlayer = ESX.GetPlayerFromId(ply)

	if pickup then
		if pickup.type == "item_idcard" then
			MySQL.Async.execute("UPDATE id_card SET porteur = @porteur WHERE id = @id", {
				["@porteur"] = xPlayer.identifier,
				['@id'] = pickup.id
			})
			success = true
		end

		if success then
			ESX.PickupsIdCards[""..pickupId..""] = nil
			TriggerClientEvent('esx:removePickupIdCards', -1, ""..pickupId.."")
		end
	end
end)

ESX.RegisterServerCallback('esx:getPlayerData', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		loadout      = xPlayer.getLoadout(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getOtherPlayerData', function(source, cb, target)
	local xPlayer = ESX.GetPlayerFromId(target)

	cb({
		identifier   = xPlayer.identifier,
		accounts     = xPlayer.getAccounts(),
		inventory    = xPlayer.getInventory(),
		job          = xPlayer.getJob(),
		loadout      = xPlayer.getLoadout(),
		money        = xPlayer.getMoney()
	})
end)

ESX.RegisterServerCallback('esx:getPlayerNames', function(source, cb, players)
	players[source] = nil

	for playerId,v in pairs(players) do
		local xPlayer = ESX.GetPlayerFromId(playerId)

		if xPlayer then
			players[playerId] = xPlayer.getName()
		else
			players[playerId] = nil
		end
	end

	cb(players)
end)

-- Add support for EssentialMode >6.4.x
AddEventHandler("es:setMoney", function(user, value) 
	ESX.GetPlayerFromId(user).setMoney(value, true) 
end)

AddEventHandler("es:addMoney", function(user, value) 
	ESX.GetPlayerFromId(user).addMoney(value, true) 
end)

AddEventHandler("es:removeMoney", function(user, value) 
	ESX.GetPlayerFromId(user).removeMoney(value, true) 
end)
AddEventHandler("es:set", function(user, key, value) 
	ESX.GetPlayerFromId(user).set(key, value, true) 
end)

AddEventHandler("es_db:doesUserExist", function(identifier, cb)
	cb(true)
end)

AddEventHandler('es_db:retrieveUser', function(identifier, cb, tries)
	tries = tries or 0

	if(tries < 500)then
		tries = tries + 1
		local player = ESX.GetPlayerFromIdentifier(identifier)

		if player then
			cb({permission_level = 0, money = player.getMoney(), bank = 0, identifier = player.identifier, license = player.get("license"), group = player.group, roles = ""}, false, true)
		else
			Citizen.SetTimeout(100, function()
				TriggerEvent("es_db:retrieveUser", identifier, cb, tries)
			end)
		end
	end
end)

ESX.RegisterServerCallback('GetEntityPosition', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local TableTarace = {}
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {["@identifier"] = xPlayer.identifier}, function(result)
		TriggerClientEvent('GetEntityPosition', source, json.decode(result[1].position), result[1].vie)
	end)
end)

ESX.RegisterServerCallback('cash:scaleformMoney', function(src, cb)
    local xPlayer = ESX.GetPlayerFromId(src)
    local money = xPlayer.getAccount("money").money
    local bank = xPlayer.getAccount("bank").money

    cb({cash = money, bank = bank})
end)