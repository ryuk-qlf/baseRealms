ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

function GetAllPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetAllPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

function GetNearbyPlayer(distance)
    local Timer = GetGameTimer() + 10000
    local oPlayer = GetNearbyPlayers(distance)

    if #oPlayer == 0 then
        ESX.ShowNotification("~r~Il n'y a aucune personne aux alentours de vous.")
        return false
    end

    if #oPlayer == 1 then
        return oPlayer[1]
    end

    ESX.ShowNotification("Appuyer sur ~g~E~s~ pour valider~n~Appuyer sur ~b~A~s~ pour changer de cible~n~Appuyer sur ~r~X~s~ pour annuler")
    Citizen.Wait(100)
    local aBase = 1
    while GetGameTimer() <= Timer do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            return oPlayer[aBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ESX.ShowNotification("Vous avez ~r~annulé~s~ cette ~r~action~s~")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            aBase = (aBase == #oPlayer) and 1 or (aBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[aBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    return false
end

local showMenu = false                    
local toggleCoffre = 0
local toggleCapot = 0

RegisterNUICallback('disablenuifocus', function(data)
  showMenu = data.nuifocus
  SetNuiFocus(data.nuifocus, data.nuifocus)
  SetKeepInputMode(false)
end)

RegisterNUICallback('openCoffre', function(data)
  local vehicle, distance = ESX.Game.GetClosestVehicle()

  if distance ~= -1 and distance <= 3.5 then
    if(toggleCoffre == 0)then
      SetVehicleDoorOpen(vehicle, 5, false)
      toggleCoffre = 1
    else
      SetVehicleDoorShut(vehicle, 5, false)
      toggleCoffre = 0
    end
  else
    ESX.ShowNotification("~r~Vous devez être proche du véhicule.")
  end
  TriggerEvent('CloseMenuRoue')
end)

RegisterNUICallback('openCapot', function(data)
  local vehicle, distance = ESX.Game.GetClosestVehicle()

  if distance ~= -1 and distance <= 3.5 then
    if(toggleCapot == 0)then
      SetVehicleDoorOpen(vehicle, 4, false)
      toggleCapot = 1
    else
      SetVehicleDoorShut(vehicle, 4, false)
      toggleCapot = 0
    end
  else
    ESX.ShowNotification("~r~Vous devez être proche du véhicule.")
  end
  TriggerEvent('CloseMenuRoue')
end)

RegisterNUICallback('UseKey', function(data)
  ExecuteCommand('+lockcar')
  TriggerEvent('CloseMenuRoue')
end)

RegisterNUICallback('EtatVehicle', function(data)
  local vehicle, distance = ESX.Game.GetClosestVehicle()
  local essence = math.floor(GetVehicleFuelLevel(vehicle))
  local carosserie = math.floor(GetVehicleBodyHealth(vehicle) / 10, 2)
  local moteur =  math.floor(GetVehicleEngineHealth(vehicle) / 10, 2)

  if distance ~= -1 and distance <= 3.5 then
    ESX.ShowNotification("Réservoir : ~b~"..essence.."%\n~s~Carosserie : ~b~"..carosserie.."%\n~s~Moteur : ~b~"..moteur.."%")
  else
    ESX.ShowNotification("~r~Vous devez être proche du véhicule.")
  end
  TriggerEvent('CloseMenuRoue')
end)

RegisterNUICallback('TrainerJoueur', function(data)
  TriggerEvent('CloseMenuRoue')
  local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

  if closestPlayer ~= -1 and closestDistance <= 3.0 then
      TriggerServerEvent('EntitydragStatus', GetPlayerServerId(closestPlayer))
  else
      ESX.Notification('~r~Action impossible personne à proximité de vous.')
  end
end)
--

RegisterNetEvent('putInVehicle')
AddEventHandler('putInVehicle', function()
	local playerPed = PlayerPedId()
  local vehicle, distance = ESX.Game.GetClosestVehicle()

  if distance ~= -1 and distance <= 5.5 then
    for i = -2, GetVehicleMaxNumberOfPassengers(vehicle) do
        TaskWarpPedIntoVehicle(playerPed, vehicle, i)
    end
  end
end)

RegisterNetEvent('OutVehicle')
AddEventHandler('OutVehicle', function()
	local playerPed = PlayerPedId()

	if not IsPedSittingInAnyVehicle(playerPed) then
		return
	end

	local vehicle = GetVehiclePedIsIn(playerPed, false)
	TaskLeaveVehicle(playerPed, vehicle, 16)
end)

RegisterNUICallback('ReportPlayer', function(data)
  TriggerEvent('CloseMenuRoue')
  local index = ESX.KeyboardInput("Message", 150)
  if index ~= nil and #index > 4 then
    ExecuteCommand("report à report le joueur ("..data.idply..") "..index)
  end
end)

RegisterNUICallback('IdPlayer', function(data)
  TriggerEvent('CloseMenuRoue')
  ESX.ShowNotification("ID du Joueur : ~g~"..data.idply)
end)

RegisterNUICallback('MettreDansVeh', function(data)
  local Target = GetNearbyPlayer(3)
  if Target then
    if IsPedCuffed(GetPlayerPed(Target)) or IsPedRagdoll(GetPlayerPed(Target)) or IsEntityAttached(GetPlayerPed(Target)) then
      TriggerServerEvent('putInVehicle', GetPlayerServerId(Target))
    else
      ESX.Notification("~r~Impossible l'individu doit être menotté.")
    end
  end
end)

RegisterKeyMapping('+interaction', 'Ouvrir le menu intéraction', 'keyboard', 'G')

RegisterCommand('+interaction', function()
  local pPed = PlayerPedId()
  local coords GetEntityCoords(pPed)

  local joueur, distjoueur = ESX.Game.GetClosestPlayer(coords)
    if distjoueur ~= -1 and distjoueur <= 2.5 then
      showMenu = not showMenu
      if showMenu then
          TriggerEvent('OpenMenuRoue', 'joueur')
      else
          TriggerEvent('CloseMenuRoue')
      end
    end
end)

RegisterNetEvent('EntitydragStatus')
AddEventHandler('EntitydragStatus', function(copId)
    local playerPed = PlayerPedId()
    dragStatus = not dragStatus

    if dragStatus then
      targetPed = GetPlayerPed(GetPlayerFromServerId(copId))

        if IsPedCuffed(playerPed) or IsPedRagdoll(playerPed) then
            AttachEntityToEntity(playerPed, targetPed, 11816, 0, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
            while dragStatus do
                Wait(50)
                if IsPedInAnyVehicle(targetPed, false) then
                    DetachEntity(playerPed, true, false)
                    dragStatus = false
                end
            end
        else
            TriggerServerEvent('NotificationdragStatus', copId)
        end
    else
        DetachEntity(playerPed, true, false)
    end
end)

RegisterNUICallback('FouillerJoueur', function(data)
  ExecuteCommand('fouiller')
  TriggerEvent('CloseMenuRoue')
end)

local velo = {
  'bmx',
  'cruiser',
  'fixter',
  'scorcher',
  'tribike',
  'tribike2',
  'tribike3',
}

RegisterNUICallback('RamasserBmx', function(data)
  TriggerEvent('CloseMenuRoue')
  if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
    local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
    if math.ceil(GetEntitySpeed(vehicle) * 3.6) <= 5.0 then
      for k, v in pairs(velo) do
        if GetEntityModel(vehicle) == GetHashKey(v) then
          ESX.TriggerServerCallback("AddBmxToPly", function(result) 
            if result then
              ESX.Game.DeleteVehicle(vehicle)
            end
          end, v)
          break
        end
      end
    else
      ESX.ShowNotification("~r~Vous devez être à l'arrêt pour ramasser le vélo.")
    end
  else
    ESX.ShowNotification("~r~Vous devez être sur le vélo pour le ramasser.")
  end
end)

RegisterNetEvent("CloseMenuRoue")
AddEventHandler("CloseMenuRoue", function()
  SetKeepInputMode(false)
  SendNUIMessage({crosshair = false})
  showMenu = false
  SetNuiFocus(false, false)
  SendNUIMessage({menu = false})
end)

RegisterNetEvent("SpawnVelo")
AddEventHandler("SpawnVelo", function(car)
  local playerPed = GetPlayerPed(-1)
  ESX.Streaming.RequestAnimDict("pickup_object")
  TaskPlayAnim(playerPed, "pickup_object", "pickup_low", 8.0, 8.0, -1, 0, 1, 0, 0, 0)
  Wait(1000)
  StopAnimTask(playerPed, "pickup_object", "pickup_low", 0.9)
  local car = GetHashKey(car)
  RequestModel(car)
  while not HasModelLoaded(car) do
      RequestModel(car)
      Citizen.Wait(0)
  end
  local pos = GetEntityCoords(playerPed)
  local heading = GetEntityHeading(playerPed)
  local vehicle = CreateVehicle(car, pos.x, pos.y+1.2, pos.z, heading, true, false)
  SetEntityAsMissionEntity(vehicle, true, false)
  SetVehicleModColor_1(vehicle, 0)
  SetVehicleModColor_2(vehicle, 0)
  SetVehicleOnGroundProperly(vehicle)
end)

RegisterNetEvent("OpenMenuRoue")
AddEventHandler("OpenMenuRoue", function(Menu)
  SetKeepInputMode(true)
	SendNUIMessage({crosshair = true})
	showMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({menu = Menu})
end)

KEEP_FOCUS = false
local threadCreated = false
local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 69, 70, 111, 117, 118, 182, 199, 200, 257}

function SetKeepInputMode(bool)
    if SetNuiFocusKeepInput then
        SetNuiFocusKeepInput(bool)
    end

    KEEP_FOCUS = bool

    if not threadCreated and bool then
        threadCreated = true

        Citizen.CreateThread(function()
            while KEEP_FOCUS do
                Wait(0)

                for _,v in pairs(controlDisabled) do
                    DisableControlAction(0, v, true)
                end
            end

            threadCreated = false
        end)
    end
end

-- RegisterCommand('test', function()
--     showMenu = not showMenu
--     if showMenu then
--         TriggerEvent('OpenMenuRoue', 'paiement')
--         local cards = {}
--         ESX.TriggerServerCallback('esx_inventoryhud:getPlayerInventory', function(data)
--           cards = data.cards
--         end, GetPlayerServerId(PlayerId()))
--         Wait(500)
--         print(json.encode(cards))
--         SendNUIMessage({action = "setItems", itemList = cards})
--     else
--         TriggerEvent('CloseMenuRoue')
--     end
-- end)

RegisterNUICallback('Cartes', function(data)
  TriggerEvent('CloseMenuRoue')
  TriggerEvent('OpenMenuRoue', 'cartes')
end)

RegisterNUICallback('UseCard', function(data)
  print(json.encode(data))
  TriggerEvent('CloseMenuRoue')
end)