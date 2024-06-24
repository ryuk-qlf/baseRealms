ESX = nil

TriggerEvent("LandLife:GetSharedObject",function(obj) ESX = obj end)

local InfoVeh = {}

RegisterNetEvent("RefreshVehChest")
AddEventHandler("RefreshVehChest", function(plate, max)
  OpenCoffreInventoryMenu(plate, max)
  DisplayRadar(false)
  TriggerEvent('esx_status:setDisplay', 0.0)
end)

RegisterNetEvent("ResetVehChest")
AddEventHandler("ResetVehChest", function()
      TriggerServerEvent("ResetVehChest", InfoVeh.Plate)
end)

function OpenCoffreInventoryMenu(plate, max)
  ESX.TriggerServerCallback("esx_trunk:getInventoryV", function(inventory)
      text = (inventory.weight/1000).." / "..(max/1000).."KG"
      data = {plate = plate, max = max, text = text}
      TriggerEvent("esx_inventoryhud:openTrunkInventory", data, inventory.blackMoney, inventory.cashMoney, inventory.items, inventory.weapons, inventory.cards, inventory.idcard, inventory.vetement)
    end, plate)
end

function openmenuvehicle()
  local playerPed	= PlayerPedId()
  local coords	= GetEntityCoords(playerPed)
  local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
  local locked = GetVehicleDoorLockStatus(vehicle)
  local class = GetVehicleClass(vehicle)
  local max = nil

  if distance ~= -1 and distance <= 3.0 then
    if locked == 1 or class == 15 or class == 16 or class == 14 then
      local props = ESX.Game.GetVehicleProperties(vehicle)
      Wait(250)
      for k,v in pairs(Config.Vehicule) do
        for i=1, #v, 1 do 
          if props.model == GetHashKey(v[i].model) then
            max = v[i].weight
          end
        end
      end
      if max ~= nil then
        ExecuteCommand('me ouvre le coffre du véhicule')
        InfoVeh.Plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("OpenVehChest", GetVehicleNumberPlateText(vehicle), max)
      else
        max = Config.Weight
        ExecuteCommand('me ouvre le coffre du véhicule')
        InfoVeh.Plate = GetVehicleNumberPlateText(vehicle)
        TriggerServerEvent("OpenVehChest", GetVehicleNumberPlateText(vehicle), max)
      end
    else
      ESX.ShowNotification("~r~Impossible le véhicule est vérouillé.")
    end
  else
    ESX.ShowNotification("~r~Il n'y a pas de véhicule près de vous.")
  end
end

RegisterKeyMapping('opencoffre', 'Ouvrir le Coffre (Véhicule)', 'keyboard', 'K')

RegisterCommand('opencoffre', function()
    openmenuvehicle()
end)