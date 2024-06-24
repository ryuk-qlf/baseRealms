ESX = nil

TriggerEvent("LandLife:GetSharedObject",function(obj) ESX = obj end)

RegisterNetEvent("RefreshPropChest")
AddEventHandler("RefreshPropChest", function(plate, max)
  OpenChestInventoryMenu(plate, max)
end)

RegisterNetEvent("OpenPropChest")
AddEventHandler("OpenPropChest", function(plate, max)
  OpenChestInventoryMenu(plate, max)
end)

function OpenChestInventoryMenu(plate, max)
  DisplayRadar(false)
  TriggerEvent('esx_status:setDisplay', 0.0)
  ESX.TriggerServerCallback("property:getInventoryV", function(inventory)
      text = (inventory.weight/1000).." / "..(max).."KG"
      data = {plate = plate, max = max, text = text}
      TriggerEvent("esx_inventoryhud:openPropertyInventory", data, inventory.blackMoney, inventory.cashMoney, inventory.items, inventory.weapons, inventory.cards, inventory.idcard, inventory.vetement)
    end, plate)
end