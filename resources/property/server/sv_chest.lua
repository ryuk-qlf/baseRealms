ESX = nil
local WeightItemList = {}

MySQL.Async.fetchAll('SELECT * FROM items', {}, function(result)
  for k,v in pairs(result) do
    WeightItemList[v.name] = {
      weight = v.weight
    }
  end
end)

TriggerEvent(
  "LandLife:GetSharedObject",
  function(obj)
    ESX = obj
  end
)

MySQL.ready(function()
    MySQL.Async.execute("DELETE FROM `data_inventory` WHERE `owned` = 0", {})
end)

function getItemChestWeight2(item)
  if item ~= nil then
    if WeightItemList[item] ~= nil then
      itemWeight = WeightItemList[item].weight
    end
  end
  return itemWeight
end

function getItemChestWeight(item)
  local weight = 0
  local itemWeight = 0
  if item ~= nil then
    itemWeight = Config.DefaultWeight
    if WeightItemList[item] ~= nil then
      itemWeight = WeightItemList[item].weight
    end
  end
  return itemWeight
end

function getInventoryWeightChest(inventory)
  local weight = 0
  local itemWeight = 0
  if inventory ~= nil then
    for i = 1, #inventory, 1 do
      if inventory[i] ~= nil then
        itemWeight = Config.DefaultWeight
        if WeightItemList[inventory[i].name] ~= nil then
          itemWeight = WeightItemList[inventory[i].name].weight
        end
        weight = weight + (itemWeight * (inventory[i].count or 1))
      end
    end
  end
  return weight
end

function getTotalWeightChest2(plate)
  TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
    local Chest = getInventoryWeightChest(store.get("coffre") or {})

    total = Chest
  end)
  return total
end

local InChestProperty = {}

RegisterNetEvent("OpenPropChest")
AddEventHandler("OpenPropChest", function(plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

  if InChestProperty[plate] == nil then
    TriggerClientEvent("OpenPropChest", source, plate, max)
    if not InChestProperty[plate] then
      InChestProperty[plate] = xPlayer.source
    end
  else
    local xTarget = ESX.GetPlayerFromId(InChestProperty[plate])
    if xTarget then
      xPlayer.showNotification("~r~Impossible une personne est déjà dans le coffre.")
    else
      InChestProperty[plate] = xPlayer.source
      TriggerClientEvent("OpenPropChest", source, plate, max)
    end
  end
end)

RegisterNetEvent("ResetPropChest")
AddEventHandler("ResetPropChest", function(plate)
  local xPlayer = ESX.GetPlayerFromId(source)

  if InChestProperty[plate] == xPlayer.source then
    InChestProperty[plate] = nil
  end
end)

ESX.RegisterServerCallback("property:getInventoryV", function(source, cb, plate)
    TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
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

        local weights = getTotalWeightChest2(plate)
        
        MySQL.Async.fetchAll("SELECT * FROM card_account WHERE propchest = '" .. plate .. "'", {}, function(result)
          MySQL.Async.fetchAll("SELECT * FROM id_card WHERE propchest = '" .. plate .. "'", {}, function(result2)
            MySQL.Async.fetchAll("SELECT * FROM vetement WHERE propchest = '" .. plate .. "'", {}, function(result3)
              cb({blackMoney = blackMoney, cashMoney = cashMoney, items = items, weapons = weapons, weight = weights, cards = result, idcard = result2, vetement = result3})
            end)
          end)
        end)
      end
    )
end)

RegisterServerEvent("property:getItem")
AddEventHandler("property:getItem", function(plate, type, item, count, max, owned)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if type == "item_standard" then
      local targetItem = xPlayer.getInventoryItem(item)
      if targetItem.weight == -1 or ((targetItem.count + count)) then
        TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
            local coffre = (store.get("coffre") or {})
            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                if (coffre[i].count >= count and count > 0) then
                  if xPlayer.canCarryItem(item, count) then
                    xPlayer.addInventoryItem(item, count)
                    TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez retiré ~g~' .. count .. ' ' .. targetItem.label..'~s~ du coffre.')

                    local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
                    local xPlayerCoords = xPlayer.getCoords()
                    ESX.SendWebhook("Retrait coffre", "**Item :** "..ESX.GetItemLabel(item).."\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

                    if (coffre[i].count - count) == 0 then
                      table.remove(coffre, i)
                    else
                      coffre[i].count = coffre[i].count - count
                    end

                  break
                else
                  TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez plus de place sur vous.")
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

            TriggerClientEvent("RefreshPropChest", xPlayer.source, plate, max)
          end
        )
      end
    end

    if type == "item_account" then
      TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
          local blackMoney = store.get("black_money")
          if (blackMoney[1].amount >= count and count > 0) then
            blackMoney[1].amount = blackMoney[1].amount - count
            store.set("black_money", blackMoney)
            xPlayer.addAccountMoney(item, count)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Retrait coffre", "**Item :** Argent Sale\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

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

            TriggerClientEvent("RefreshPropChest", xPlayer.source, plate, max)
          end
        end
      )
    end
	
	if type == "item_money" then
      TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
          local cashMoney = store.get("money")
          if (cashMoney[1].amount >= count and count > 0) then
            cashMoney[1].amount = cashMoney[1].amount - count
            store.set("money", cashMoney)
            xPlayer.addMoney(count)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Retrait coffre", "**Item :** Argent\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')

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

            TriggerClientEvent("RefreshPropChest", xPlayer.source, plate, max)
          end
      end)
    end
end)

RegisterServerEvent("property:putItem")
AddEventHandler("property:putItem", function(plate, type, item, count, max, owned, label)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local xPlayerOwner = ESX.GetPlayerFromIdentifier(owner)

    if type == "item_standard" then
      local playerItemCount = xPlayer.getInventoryItem(item).count

      if (playerItemCount >= count and count > 0) then
        TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
            local found = false
            local coffre = (store.get("coffre") or {})

            for i = 1, #coffre, 1 do
              if coffre[i].name == item then
                coffre[i].count = coffre[i].count + count
                found = true
              end
            end
            if not found then
              table.insert(coffre, {name = item, count = count})
            end

            if getTotalWeightChest2(plate) + getItemChestWeight2(item) * count <= max*1000 then
              store.set("coffre", coffre)
              xPlayer.removeInventoryItem(item, count)
              TriggerClientEvent('esx:showNotification', xPlayer.source, 'Vous avez déposé ~g~' .. count .. ' ' ..ESX.GetItemLabel(item)..'~s~ dans le coffre.')

              local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
              local xPlayerCoords = xPlayer.getCoords()
              ESX.SendWebhook("Dépot coffre", "**Item :** "..ESX.GetItemLabel(item).."\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
          else
            TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Impossible le coffre est plein ou l'objet est trop lourd.")
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
        TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
            local blackMoney = (store.get("black_money") or nil)
            if blackMoney ~= nil then
              blackMoney[1].amount = blackMoney[1].amount + count
            else
              blackMoney = {}
              table.insert(blackMoney, {amount = count})
            end

            xPlayer.removeAccountMoney(item, count)
            store.set("black_money", blackMoney)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Dépot coffre", "**Item :** Argent Sale\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
          end
        )
      end
    end
	
	if type == "item_money" then
      local playerAccountMoney = xPlayer.getMoney()

      if (playerAccountMoney >= count and count > 0) then
        TriggerEvent("dataproperty:getSharedDataStore", plate, function(store)
            local cashMoney = (store.get("money") or nil)
            if cashMoney ~= nil then
              cashMoney[1].amount = cashMoney[1].amount + count
            else
              cashMoney = {}
              table.insert(cashMoney, {amount = count})
            end

            xPlayer.removeMoney(count)
            store.set("money", cashMoney)

            local idsSrc = ESX.ExtractIdentifiers(xPlayer.source)
            local xPlayerCoords = xPlayer.getCoords()
            ESX.SendWebhook("Dépot coffre", "**Item :** Argent\n**Montant :** "..count.."\n**Joueur :** ("..xPlayer.getIdentity()..") <@"..idsSrc.discord:gsub("discord:", "")..">\n**ID Propriété :** "..plate:gsub("property_", "").."\n**Position Joueur : **"..xPlayerCoords.x..", "..xPlayerCoords.y..", "..xPlayerCoords.z.." \n**Steam Url :** https://steamcommunity.com/profiles/" ..tonumber(idsSrc.steam:gsub("steam:", ""), 16), "https://discord.com/api/webhooks/968616814517055518/E6J4phA7AAWoeY7taV-WgrwE4Q1lsH5_Y2nfRedw5bmBwstwOpU8ARP4tYectKnypGGw", '3863105')
          end
        )
      end
    end

    TriggerClientEvent("RefreshPropChest", source, plate, max)
end)

RegisterNetEvent("putItemIdCardPropChest")
AddEventHandler("putItemIdCardPropChest", function(idcard, plate, max)
	MySQL.Async.execute("UPDATE id_card SET porteur = @porteur, propchest = @propchest WHERE id = @id", {
		["@porteur"] = nil,
    ["@propchest"] = plate,
		["@id"] = idcard
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
end)

RegisterNetEvent("receiveIdCardPropChest")
AddEventHandler("receiveIdCardPropChest", function(idcard, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE id_card SET porteur = @porteur, propchest = @propchest WHERE id = @id", {
		["@porteur"] = xPlayer.identifier,
    ["@propchest"] = nil,
		["@id"] = idcard
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
end)

RegisterNetEvent("putItemCardBankPropChest")
AddEventHandler("putItemCardBankPropChest", function(id, plate, max)
	MySQL.Async.execute("UPDATE card_account SET porteur = @porteur, propchest = @propchest WHERE id = @id", {
		["@porteur"] = nil,
    ["@propchest"] = plate,
		["@id"] = id
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
end)

RegisterNetEvent("receiveCardBankPropChest")
AddEventHandler("receiveCardBankPropChest", function(id, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE card_account SET porteur = @porteur, propchest = @propchest WHERE id = @id", {
		["@porteur"] = xPlayer.identifier,
    ["@propchest"] = nil,
		["@id"] = id
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
end)

RegisterNetEvent("putItemVetementPropChest")
AddEventHandler("putItemVetementPropChest", function(id, plate, max)
	MySQL.Async.execute("UPDATE vetement SET identifier = @identifier, propchest = @propchest WHERE id = @id", {
		["@identifier"] = nil,
    ["@propchest"] = plate,
		["@id"] = id
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
  TriggerClientEvent("esx_inventoryhud:refreshInventory", source)
end)

RegisterNetEvent("receiveVetementPropChest")
AddEventHandler("receiveVetementPropChest", function(id, plate, max)
  local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute("UPDATE vetement SET identifier = @identifier, propchest = @propchest WHERE id = @id", {
		["@identifier"] = xPlayer.identifier,
    ["@propchest"] = nil,
		["@id"] = id
	})

  TriggerClientEvent("RefreshPropChest", source, plate, max)
  TriggerClientEvent("esx_inventoryhud:refreshInventory", source)
end)