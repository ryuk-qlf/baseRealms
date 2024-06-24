ESX = nil
local arrayWeight = {}
local VehicleList = {}
local VehicleInventory = {}

MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
  for k,v in pairs(result) do
    arrayWeight[v.name] = {
      weight = v.weight
    }
  end
end)

TriggerEvent("LandLife:GetSharedObject", function(obj) ESX = obj end)

MySQL.ready(function()
    MySQL.Async.execute("DELETE FROM `trunk_inventory` WHERE `owned` = 0", {})
end)

function getItemWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = Config.DefaultWeight
    if arrayWeight[item] ~= nil then
      itemWeight = arrayWeight[item].weight
    end
  end
  return itemWeight
end

function getInventoryWeight(inventory)
  local weight = 0
  local itemWeight = 0
  if inventory ~= nil then
    for i = 1, #inventory, 1 do
      if inventory[i] ~= nil then
        itemWeight = Config.DefaultWeight
        if arrayWeight[inventory[i].name] ~= nil then
          itemWeight = arrayWeight[inventory[i].name].weight
        end
        weight = weight + (itemWeight * (inventory[i].count or 1))
      end
    end
  end
  return weight
end

function getTotalInventoryWeight(plate)
  local total
  TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
      local CarChest = getInventoryWeight(store.get("coffre") or {})

      total = CarChest
    end
  )
  return total
end

local InChestVehicle = {}

RegisterNetEvent("OpenVehChest")
AddEventHandler("OpenVehChest", function(plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

  if InChestVehicle[plate] == nil then
    TriggerClientEvent("RefreshVehChest", source, plate, max)
    if not InChestVehicle[plate] then
      InChestVehicle[plate] = xPlayer.source
    end
  else
    local xTarget = ESX.GetPlayerFromId(InChestVehicle[plate])
    if xTarget then
      xPlayer.showNotification("~r~Impossible une personne est déjà dans le coffre.")
    else
      InChestVehicle[plate] = xPlayer.source
      TriggerClientEvent("RefreshVehChest", source, plate, max)
    end
  end
end)

RegisterNetEvent("ResetVehChest")
AddEventHandler("ResetVehChest", function(plate)
  local xPlayer = ESX.GetPlayerFromId(source)

  if InChestVehicle[plate] == xPlayer.source then
    InChestVehicle[plate] = nil
  end
end)

ESX.RegisterServerCallback("esx_trunk:getInventoryV", function(source, cb, plate)
    TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
        local blackMoney = 0
		    local cashMoney = 0
        local items = {}
        local weapons = {}
        weapons = (store.get("weapons") or {})

        local blackAccount = (store.get("black_money")) or 0
        if blackAccount ~= 0 then
          blackMoney = blackAccount[1].amount
        end

		    local cashAccount = (store.get("money")) or 0
        if cashAccount ~= 0 then
          cashMoney = cashAccount[1].amount
        end

        local coffre = (store.get("coffre") or {})
        for i = 1, #coffre, 1 do
          table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
        end

        local weight = getTotalInventoryWeight(plate)
        
        MySQL.Async.fetchAll("SELECT * FROM card_account WHERE vehchest = '" .. plate .. "'", {}, function(result)
          MySQL.Async.fetchAll("SELECT * FROM id_card WHERE vehchest = '" .. plate .. "'", {}, function(result2)
            MySQL.Async.fetchAll("SELECT * FROM vetement WHERE vehchest = '" .. plate .. "'", {}, function(result3)
              cb({blackMoney = blackMoney, cashMoney = cashMoney, items = items, weapons = weapons, weight = weight, cards = result, idcard = result2, vetement = result3})
            end)
          end)
        end)
      end
    )
end)

RegisterServerEvent("esx_trunk:getItem")
AddEventHandler("esx_trunk:getItem", function(plate, type, item, count, max, owned)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
      local targetItem = xPlayer.getInventoryItem(item)
      --if targetItem.weight == -1 or ((targetItem.count + count) <= 50) then
        TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                if (coffre[i].count >= count and count > 0) then
                  if xPlayer.canCarryItem(item, count) then
                  xPlayer.addInventoryItem(item, count)
                  TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré ~g~' .. count .. ' ' .. targetItem.label..'~s~ du coffre.')

                  local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
                  local xPlayerCoords = xPlayer.getCoords()
                  ESX.SendWebhook("Retrait coffre", "**Item :** "..ESX.GetItemLabel(item).."\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')       

                  if (coffre[i].count - count) == 0 then
                    table.remove(coffre, i)
                  else
                    coffre[i].count = coffre[i].count - count
                  end

                  break
                else
                
				        TriggerClientEvent('b1g_notify:client:Notify', _source, { type = 'true', text = _U("invalid_quantity") })
                end
              end
            end
          end
            store.set("coffre", coffre)

            local blackMoney = 0
			local cashMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
              blackMoney = blackAccount[1].amount
            end
			
			      local cashAccount = (store.get("money")) or 0
            if cashAccount ~= 0 then
              cashMoney = cashAccount[1].amount
            end

            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end

            TriggerClientEvent("RefreshVehChest", xPlayer.source, plate, max)
          end
        )
      --end
    end

    if type == "item_account" then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
          local blackMoney = store.get("black_money")
          if (blackMoney[1].amount >= count and count > 0) then
            blackMoney[1].amount = blackMoney[1].amount - count
            store.set("black_money", blackMoney)
            xPlayer.addAccountMoney(item, count)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Retrait coffre", "**Item :** Argent Sale\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')  

            local blackMoney = 0
			      local cashMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
              blackMoney = blackAccount[1].amount
            end
			
            local cashAccount = (store.get("money")) or 0
            if cashAccount ~= 0 then
              cashMoney = cashAccount[1].amount
            end

            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
            end

            TriggerClientEvent("RefreshVehChest", xPlayer.source, plate, max)
          end
        end
      )
    end
	
	if type == "item_money" then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
          local cashMoney = store.get("money")
          if (cashMoney[1].amount >= count and count > 0) then
            cashMoney[1].amount = cashMoney[1].amount - count
            store.set("money", cashMoney)
            xPlayer.addMoney(count)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Retrait coffre", "**Item :** Argent\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')  

            local blackMoney = 0
			      local cashMoney = 0
            local items = {}
            local weapons = {}
            weapons = (store.get("weapons") or {})

            local blackAccount = (store.get("black_money")) or 0
            if blackAccount ~= 0 then
              blackMoney = blackAccount[1].amount
            end
            
            local cashAccount = (store.get("money")) or 0
            if cashAccount ~= 0 then
              cashMoney = cashAccount[1].amount
            end

            local coffres = (store.get("coffres") or {})
            for i = 1, #coffres, 1 do
              table.insert(items, {name = coffres[i].name, count = coffres[i].count, label = ESX.GetItemLabel(coffres[i].name)})
            end

            TriggerClientEvent("RefreshVehChest", xPlayer.source, plate, max)
          end
        end
      )
    end

    if type == "item_weapon" then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
          local storeWeapons = store.get("weapons")

          if storeWeapons == nil then
            storeWeapons = {}
          end

          local weaponName = nil
          local ammo = nil

          for i = 1, #storeWeapons, 1 do
            if storeWeapons[i].name == item then
              weaponName = storeWeapons[i].name
              ammo = storeWeapons[i].ammo

              table.remove(storeWeapons, i)

              break
            end
          end

          store.set("weapons", storeWeapons)

          xPlayer.addWeapon(weaponName, ammo)

          local blackMoney = 0
		  local cashMoney = 0
          local items = {}
          local weapons = {}
          weapons = (store.get("weapons") or {})

          local blackAccount = (store.get("black_money")) or 0
          if blackAccount ~= 0 then
            blackMoney = blackAccount[1].amount
          end
		  
		  local cashAccount = (store.get("money")) or 0
		  if cashAccount ~= 0 then
		    cashMoney = cashAccount[1].amount
		  end

          local coffre = (store.get("coffre") or {})
          for i = 1, #coffre, 1 do
            table.insert(items, {name = coffre[i].name, count = coffre[i].count, label = ESX.GetItemLabel(coffre[i].name)})
          end

          TriggerClientEvent("RefreshVehChest", xPlayer.source, plate, max)
        end
      )
    end
  end
)

RegisterServerEvent("esx_trunk:putItem")
AddEventHandler("esx_trunk:putItem", function(plate, type, item, count, max, owned, label)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

    if type == "item_standard" then
      local playerItemCount = xPlayer.getInventoryItem(item).count

      if (playerItemCount >= count and count > 0) then
        TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local found = false
            local coffre = (store.get("coffre") or {})

            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                coffre[i].count = coffre[i].count + count
                found = true
              end
            end
            if not found then
              table.insert(
                coffre,
                {
                  name = item,
                  count = count
                }
              )
            end
            if (getTotalInventoryWeight(plate) + (getItemWeight(item) * count)) > max then

            else
              store.set("coffre", coffre)
              xPlayer.removeInventoryItem(item, count)
              TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ~g~' .. count .. ' ' ..ESX.GetItemLabel(item)..'~s~ dans le coffre.')

              local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
              local xPlayerCoords = xPlayer.getCoords()
              ESX.SendWebhook("Dépot coffre", "**Item :** "..ESX.GetItemLabel(item).."\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

              MySQL.Async.execute("UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate", {
                  ["@plate"] = plate,
                  ["@owned"] = 1
                }
              )
            end
          end
        )
      else
         xPlayer.showNotification("~r~Quantité invalide.")
      end
    end

    if type == "item_account" then
      local playerAccountMoney = xPlayer.getAccount(item).money

      if (playerAccountMoney >= count and count > 0) then
        TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local blackMoney = (store.get("black_money") or nil)
            if blackMoney ~= nil then
              blackMoney[1].amount = blackMoney[1].amount + count
            else
              blackMoney = {}
              table.insert(blackMoney, {amount = count})
            end

            if (getTotalInventoryWeight(plate) + blackMoney[1].amount / 10) > max then
   
          else
              -- Checks passed. Storing the item.
              xPlayer.removeAccountMoney(item, count)
              store.set("black_money", blackMoney)

              local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
              local xPlayerCoords = xPlayer.getCoords()
              ESX.SendWebhook("Dépot coffre", "**Item :** Argent Sale\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

              MySQL.Async.execute(
                "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
                {
                  ["@plate"] = plate,
                  ["@owned"] = 1
                }
              )
            end
          end
        )
      end
    end
	
	if type == "item_money" then
      local playerAccountMoney = xPlayer.getMoney()

      if (playerAccountMoney >= count and count > 0) then
        TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
            local cashMoney = (store.get("money") or nil)
            if cashMoney ~= nil then
              cashMoney[1].amount = cashMoney[1].amount + count
            else
              cashMoney = {}
              table.insert(cashMoney, {amount = count})
            end

            if (getTotalInventoryWeight(plate) + cashMoney[1].amount / 10) > max then

            else
              -- Checks passed. Storing the item.
              xPlayer.removeMoney(count)
              store.set("money", cashMoney)

              local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
              local xPlayerCoords = xPlayer.getCoords()
              ESX.SendWebhook("Dépot coffre", "**Item :** Argent\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**Plaque :** "..plate.."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

              MySQL.Async.execute(
                "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
                {
                  ["@plate"] = plate,
                  ["@owned"] = 1
                }
              )
            end
          end
        )
      end
    end

    if type == "item_weapon" then
      TriggerEvent("esx_trunk:getSharedDataStore", plate, function(store)
          local storeWeapons = store.get("weapons")

          if storeWeapons == nil then
            storeWeapons = {}
          end

          table.insert(
            storeWeapons,
            {
              name = item,
              label = label,
              ammo = count
            }
          )
          if (getTotalInventoryWeight(plate) + (getItemWeight(item))) > max then

          else
            store.set("weapons", storeWeapons)
            xPlayer.removeWeapon(item)

            MySQL.Async.execute(
              "UPDATE trunk_inventory SET owned = @owned WHERE plate = @plate",
              {
                ["@plate"] = plate,
                ["@owned"] = 1
              }
            )
          end
        end
      )
    end

    TriggerClientEvent("RefreshVehChest", source, plate, max)
end)

RegisterNetEvent("putItemIdCardVehChest")
AddEventHandler("putItemIdCardVehChest", function(idcard, plate, max)
	MySQL.Async.execute("UPDATE id_card SET porteur = @porteur, vehchest = @vehchest WHERE id = @id", {
		["@porteur"] = nil,
    ["@vehchest"] = plate,
		["@id"] = idcard
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
end)

RegisterNetEvent("receiveIdCardVehChest")
AddEventHandler("receiveIdCardVehChest", function(idcard, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE id_card SET porteur = @porteur, vehchest = @vehchest WHERE id = @id", {
		["@porteur"] = xPlayer.identifier,
    ["@vehchest"] = nil,
		["@id"] = idcard
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
end)

RegisterNetEvent("putItemCardBankVehChest")
AddEventHandler("putItemCardBankVehChest", function(id, plate, max)
	MySQL.Async.execute("UPDATE card_account SET porteur = @porteur, vehchest = @vehchest WHERE id = @id", {
		["@porteur"] = nil,
    ["@vehchest"] = plate,
		["@id"] = id
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
end)

RegisterNetEvent("receiveCardBankVehChest")
AddEventHandler("receiveCardBankVehChest", function(id, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE card_account SET porteur = @porteur, vehchest = @vehchest WHERE id = @id", {
		["@porteur"] = xPlayer.identifier,
    ["@vehchest"] = nil,
		["@id"] = id
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
end)

RegisterNetEvent("putItemVetementVehChest")
AddEventHandler("putItemVetementVehChest", function(id, plate, max)
	MySQL.Async.execute("UPDATE vetement SET identifier = @identifier, vehchest = @vehchest WHERE id = @id", {
		["@identifier"] = nil,
    ["@vehchest"] = plate,
		["@id"] = id
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
  TriggerClientEvent("esx_inventoryhud:refreshInventory", source)
end)

RegisterNetEvent("receiveVetementVehChest")
AddEventHandler("receiveVetementVehChest", function(id, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE vetement SET identifier = @identifier, vehchest = @vehchest WHERE id = @id", {
		["@identifier"] = xPlayer.identifier,
    ["@vehchest"] = nil,
		["@id"] = id
	})

  TriggerClientEvent("RefreshVehChest", source, plate, max)
  TriggerClientEvent("esx_inventoryhud:refreshInventory", source)
end)