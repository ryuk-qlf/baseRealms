local isLoadoutLoaded, isPaused, isDead, isFirstSpawn, pickups, pickupsclothe, pickupscards, pickupsidcards = false, false, false, true, {}, {}, {}, {}
local HasSpawned = false

CreateThread(function()
	while true do
		Wait(0)
		if NetworkIsPlayerActive(PlayerId()) then
			TriggerServerEvent('esx:onPlayerJoined')
			break
		end
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData
	
	local playerPed = PlayerPedId()

	SetCanAttackFriendly(playerPed, true, false)
	NetworkSetFriendlyFireOption(true)

	FreezeEntityPosition(PlayerPedId(), true)

	ClearPlayerWantedLevel(PlayerId())
	SetMaxWantedLevel(0)

	EnableDispatchService(1, false)
	EnableDispatchService(2, false)
	EnableDispatchService(3, true)
	EnableDispatchService(4, false)
	EnableDispatchService(5, false)
	EnableDispatchService(6, false)
	EnableDispatchService(7, false)
	EnableDispatchService(8, false)
	EnableDispatchService(9, false)
	EnableDispatchService(10, false)
	EnableDispatchService(11, true)
	EnableDispatchService(12, false)
	EnableDispatchService(13, false)
	EnableDispatchService(14, false)
	EnableDispatchService(15, true)


	ESX.Game.Teleport(PlayerPedId(), {
		x = playerData.coords.x,
		y = playerData.coords.y,
		z = playerData.coords.z + 0.25,
		heading = playerData.coords.heading,
		model = "mp_m_freemode_01",
		skipFade = false
	}, function()
		isLoadoutLoaded = true
		TriggerServerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:onPlayerSpawn')
		TriggerEvent('esx:restoreLoadout')
		StartServerSyncLoops()
	end)
end)

RegisterNetEvent('es:activateMoney')
AddEventHandler('es:activateMoney', function(money)
	ESX.PlayerData.money = money
end)

RegisterNetEvent('esx:setMaxWeight')
AddEventHandler('esx:setMaxWeight', function(newMaxWeight)
	ESX.PlayerData.maxWeight = newMaxWeight
end)

AddEventHandler('esx:onPlayerSpawn', function()
	isDead = false
end)

AddEventHandler('esx:onPlayerDeath', function()
	isDead = true
end)

AddEventHandler('skinchanger:loadDefaultModel', function()
	isLoadoutLoaded = false
end)

AddEventHandler('skinchanger:modelLoaded', function()
	while not ESX.PlayerLoaded do
		Wait(100)
	end

	TriggerEvent('esx:restoreLoadout')
end)

AddEventHandler('esx:restoreLoadout', function()
	local playerPed = PlayerPedId()
	local ammoTypes = {}

	RemoveAllPedWeapons(playerPed, true)

	for k,v in ipairs(ESX.PlayerData.loadout) do
		local weaponName = v.name

		GiveWeaponToPed(playerPed, weaponName, 0, false, false)
		SetPedWeaponTintIndex(playerPed, weaponName, v.tintIndex)

		local ammoType = GetPedAmmoTypeFromWeapon(playerPed, weaponName)

		for k2,v2 in ipairs(v.components) do
			local componentHash = ESX.GetWeaponComponent(weaponName, v2).hash

			GiveWeaponComponentToPed(playerPed, weaponName, componentHash)
		end

		if not ammoTypes[ammoType] then
			AddAmmoToPed(playerPed, weaponName, v.ammo)
			ammoTypes[ammoType] = true
		end
	end

	isLoadoutLoaded = true
end)

AddEventHandler('playerSpawned', function()
    ESX.TriggerServerCallback("cash:scaleformMoney", function(accounts) 
        if accounts ~= nil then
            SetMultiplayerWalletCash()

			SetMultiplayerHudCash(accounts.cash, 0)
			StatSetInt(GetHashKey("MP0_WALLET_BALANCE"), accounts.cash)

            Citizen.SetTimeout(6500, function()
                RemoveMultiplayerWalletCash()
            end)
        end
    end)
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
	for k,v in ipairs(ESX.PlayerData.accounts) do
		if v.name == account.name then
			ESX.PlayerData.accounts[k] = account
			break
		end
	end

	TriggerEvent('esx:ReloadInventory')

	if not ESX.IsPlayerLoaded() then
        return
    end

    ESX.TriggerServerCallback("cash:scaleformMoney", function(accounts) 
        if accounts ~= nil then
			SetMultiplayerHudCash(accounts.cash, 0)
			StatSetInt(GetHashKey("MP0_WALLET_BALANCE"), accounts.cash)
        end
    end)
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count, showNotification, newItem)
	local found = false

	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			-- ESX.ShowInventoryItemNotification(true, v.label, count - v.count, item)
			ESX.PlayerData.inventory[k].count = count

			found = true
			break
		end
	end

	-- If the item wasn't found in your inventory -> run
	if(found == false and newItem --[[Just a check if there is a newItem]])then
		-- Add item newItem to the players inventory
		ESX.PlayerData.inventory[#ESX.PlayerData.inventory + 1] = {
			name = newItem.name,
			count = count,
			label = newItem.label,
			weight = newItem.weight,
			limit = newItem.limit,
			usable = newItem.usable,
			rare = newItem.rare,
			canRemove = newItem.canRemove
		}

		-- Show a notification that a new item was added
		-- ESX.ShowInventoryItemNotification(true, newItem.label, count, newItem.name)
	else
		-- Don't show this error for now
		-- print("^1[lmodeextended]^7 Error: there is an error while trying to add an item to the inventory, item name: " .. item)
	end

	-- if showNotification then
	-- 	ESX.ShowInventoryItemNotification(true, item.label, count, name)
	-- end
	TriggerEvent("UpdateTotal")
	TriggerEvent('esx:ReloadInventory')
end)

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count, showNotification)
	for k,v in ipairs(ESX.PlayerData.inventory) do
		if v.name == item then
			-- ESX.ShowInventoryItemNotification(false, v.label, v.count - count, item)
			ESX.PlayerData.inventory[k].count = count
			break
		end
	end

	-- if showNotification then
	-- 	ESX.ShowInventoryItemNotification(false, item, count)
	-- end
	TriggerEvent("UpdateTotal")
	TriggerEvent('esx:ReloadInventory')
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

RegisterNetEvent('esx:addWeapon')
AddEventHandler('esx:addWeapon', function(weaponName, ammo)
	-- Removed PlayerPedId() from being stored in a variable, not needed
	-- when it's only being used once, also doing it in a few
	-- functions below this one
	GiveWeaponToPed(PlayerPedId(), weaponName, ammo, false, false)
end)

RegisterNetEvent('esx:addWeaponComponent')
AddEventHandler('esx:addWeaponComponent', function(weaponName, weaponComponent)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	GiveWeaponComponentToPed(PlayerPedId(), weaponName, componentHash)
end)

RegisterNetEvent('esx:setWeaponAmmo')
AddEventHandler('esx:setWeaponAmmo', function(weaponName, weaponAmmo)
	SetPedAmmo(PlayerPedId(), weaponName, weaponAmmo)
end)

RegisterNetEvent('esx:setWeaponTint')
AddEventHandler('esx:setWeaponTint', function(weaponName, weaponTintIndex)
	SetPedWeaponTintIndex(PlayerPedId(), weaponName, weaponTintIndex)
end)

RegisterNetEvent('esx:removeWeapon')
AddEventHandler('esx:removeWeapon', function(weaponName)
	local playerPed = PlayerPedId()
	RemoveWeaponFromPed(playerPed, weaponName)
	SetPedAmmo(playerPed, weaponName, 0) -- remove leftover ammo
end)

RegisterNetEvent('esx:removeWeaponComponent')
AddEventHandler('esx:removeWeaponComponent', function(weaponName, weaponComponent)
	local componentHash = ESX.GetWeaponComponent(weaponName, weaponComponent).hash
	RemoveWeaponComponentFromPed(PlayerPedId(), weaponName, componentHash)
end)

RegisterNetEvent('esx:teleport')
AddEventHandler('esx:teleport', function(coords)
	local playerPed = PlayerPedId()

	-- ensure decmial number
	coords.x = coords.x + 0.0
	coords.y = coords.y + 0.0
	coords.z = coords.z + 0.0

	ESX.Game.Teleport(playerPed, coords)
end)

RegisterNetEvent('esx:spawnVehicle')
AddEventHandler('esx:spawnVehicle', function(model)
	local playerPed = PlayerPedId()
	local coords    = GetEntityCoords(playerPed)

	ESX.Game.SpawnVehicle(model, coords, 90.0, function(vehicle)
		TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
		TriggerEvent("Persistance:addVehicles", vehicle)
	end)
end)

local ModelCollision = {
	["p_ld_stinger_s"] = true,
	["prop_barrier_work05"] = true,
	["prop_mp_cone_02"] = true
}

RegisterNetEvent('esx:createPickup')
AddEventHandler('esx:createPickup', function(pickupId, label, coords, type, name, model)
	local x, y, z, w = table.unpack(coords)
	ESX.Game.SpawnLocalObject(model or 'v_serv_abox_02', {
		x = x,
		y = y,
		z = z,
	}, function(object)
		SetEntityHeading(object, w)
		SetEntityAsMissionEntity(object, true, false)
		if ModelCollision[model] then
			SetEntityLodDist(object, 250)
		else
			SetEntityLodDist(object, 20)
			SetEntityCollision(object, false, false)
		end

		FreezeEntityPosition(object, true)
		
		pickups[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = coords
		}
	end)
end)

RegisterNetEvent('esx:createPickupClothe')
AddEventHandler('esx:createPickupClothe', function(pickupId, label, coords, type, clothe, model)
	local x, y, z, w = table.unpack(coords)
	ESX.Game.SpawnLocalObject(model or 'v_serv_abox_02', {
		x = x,
		y = y,
		z = z,
	}, function(object)
		SetEntityHeading(object, w)
		SetEntityAsMissionEntity(object, true, false)
		if ModelCollision[model] then
			SetEntityLodDist(object, 250)
		else
			SetEntityLodDist(object, 20)
			SetEntityCollision(object, false, false)
		end

		FreezeEntityPosition(object, true)
		
		pickupsclothe[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = coords
		}
	end)
end)

RegisterNetEvent('esx:createPickupCards')
AddEventHandler('esx:createPickupCards', function(pickupId, label, coords, type, infos, model)
	local x, y, z, w = table.unpack(coords)
	ESX.Game.SpawnLocalObject(model or 'ch_prop_swipe_card_01c', {
		x = x,
		y = y,
		z = z,
	}, function(object)
		SetEntityHeading(object, w)
		SetEntityAsMissionEntity(object, true, false)
		if ModelCollision[model] then
			SetEntityLodDist(object, 250)
		else
			SetEntityLodDist(object, 20)
			SetEntityCollision(object, false, false)
		end

		FreezeEntityPosition(object, true)
		
		pickupscards[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = coords
		}
	end)
end)

RegisterNetEvent('esx:createPickupIdCards')
AddEventHandler('esx:createPickupIdCards', function(pickupId, label, coords, type, infos, model)
	local x, y, z, w = table.unpack(coords)
	ESX.Game.SpawnLocalObject(model or 'ch_prop_swipe_card_01c', {
		x = x,
		y = y,
		z = z,
	}, function(object)
		SetEntityHeading(object, w)
		SetEntityAsMissionEntity(object, true, false)
		if ModelCollision[model] then
			SetEntityLodDist(object, 250)
		else
			SetEntityLodDist(object, 20)
			SetEntityCollision(object, false, false)
		end

		FreezeEntityPosition(object, true)
		
		pickupsidcards[pickupId] = {
			obj = object,
			label = label,
			inRange = false,
			coords = coords
		}
	end)
end)

RegisterNetEvent('esx:createMissingPickups')
AddEventHandler('esx:createMissingPickups', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickup', ""..pickupId.."", pickup.label, pickup.coords, pickup.type, pickup.name, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:createMissingPickupsClothe')
AddEventHandler('esx:createMissingPickupsClothe', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickupClothe', ""..pickupId.."", pickup.label, pickup.coords, pickup.type, pickup.clothe, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:createMissingPickupsCards')
AddEventHandler('esx:createMissingPickupsCards', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickupCards', ""..pickupId.."", pickup.label, pickup.coords, pickup.type, pickup.infos, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:createMissingPickupsIdCards')
AddEventHandler('esx:createMissingPickupsIdCards', function(missingPickups)
	for pickupId,pickup in pairs(missingPickups) do
		TriggerEvent('esx:createPickupIdCards', ""..pickupId.."", pickup.label, pickup.coords, pickup.type, pickup.infos, pickup.components, pickup.tintIndex)
	end
end)

RegisterNetEvent('esx:removePickup')
AddEventHandler('esx:removePickup', function(pickupId)
	if pickups[pickupId] and pickups[pickupId].obj then
		ESX.Game.DeleteObject(pickups[pickupId].obj)
		pickups[pickupId] = nil
	end
end)

RegisterNetEvent('esx:removePickupClothe')
AddEventHandler('esx:removePickupClothe', function(pickupId)
	if pickupsclothe[pickupId] and pickupsclothe[pickupId].obj then
		ESX.Game.DeleteObject(pickupsclothe[pickupId].obj)
		pickupsclothe[pickupId] = nil
	end
end)

RegisterNetEvent('esx:removePickupCards')
AddEventHandler('esx:removePickupCards', function(pickupId)
	if pickupscards[pickupId] and pickupscards[pickupId].obj then
		ESX.Game.DeleteObject(pickupscards[pickupId].obj)
		pickupscards[pickupId] = nil
	end
end)

RegisterNetEvent('esx:removePickupIdCards')
AddEventHandler('esx:removePickupIdCards', function(pickupId)
	if pickupsidcards[pickupId] and pickupsidcards[pickupId].obj then
		ESX.Game.DeleteObject(pickupsidcards[pickupId].obj)
		pickupsidcards[pickupId] = nil
	end
end)

RegisterNetEvent('esx:pickupWeapon')
AddEventHandler('esx:pickupWeapon', function(weaponPickup, weaponName, ammo)
	local playerPed = PlayerPedId()
	local pickupCoords = GetOffsetFromEntityInWorldCoords(playerPed, 2.0, 0.0, 0.5)
	local weaponHash = GetHashKey(weaponPickup)

	CreateAmbientPickup(weaponHash, pickupCoords, 0, ammo, 1, false, true)
end)

RegisterNetEvent('esx:deleteVehicle')
AddEventHandler('esx:deleteVehicle', function(radius)
	local playerPed = PlayerPedId()

	if radius and tonumber(radius) then
		radius = tonumber(radius) + 0.01
		local vehicles = ESX.Game.GetVehiclesInArea(GetEntityCoords(playerPed), radius)

		for k,entity in ipairs(vehicles) do
			local attempt = 0

			while not NetworkHasControlOfEntity(entity) and attempt < 100 and DoesEntityExist(entity) do
				Wait(100)
				NetworkRequestControlOfEntity(entity)
				attempt = attempt + 1
			end

			if DoesEntityExist(entity) and NetworkHasControlOfEntity(entity) then
				TriggerEvent('Persistance:removeVehicles', entity)
				ESX.Game.DeleteVehicle(entity)
			end
		end
	else
		local vehicle, attempt = ESX.Game.GetVehicleInDirection(), 0

		if IsPedInAnyVehicle(playerPed, true) then
			vehicle = GetVehiclePedIsIn(playerPed, false)
		end

		while not NetworkHasControlOfEntity(vehicle) and attempt < 100 and DoesEntityExist(vehicle) do
			Wait(100)
			NetworkRequestControlOfEntity(vehicle)
			attempt = attempt + 1
		end

		if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
			TriggerEvent('Persistance:removeVehicles', vehicle)
			ESX.Game.DeleteVehicle(vehicle)
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 750
		local pPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(pPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for k,v in pairs(pickupsclothe) do
			local distance = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if distance <= 5.0 then 
				letSleep = false
				wait = 5
				ESX.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.1, "Appuyez sur ~b~E~s~ pour ramasser", 5)
				if IsControlJustReleased(0, 38) and distance < 1.5 and not IsPedInAnyVehicle(playerPed, false) and (closestDistance == -1 or closestDistance > 3.5) then 
					if IsPedOnFoot(pPed) and (closestDistance == -1 or closestDistance > 1) and not v.inRange and not IsPedCuffed(pPed) then

						local dict, anim = 'random@domestic', 'pickup_low'
						ESX.Streaming.RequestAnimDict(dict)
						TaskPlayAnim(pPed, dict, anim, 8.0, 8.0, -1, 0, 1, 0, 0, 0)

						Citizen.Wait(1000)
						TriggerServerEvent('esx:onPickupClothe', k, GetPlayerServerId(PlayerId()))
						PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
						--v.inRange = true
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(750)
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 750
		local pPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(pPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for k,v in pairs(pickupsidcards) do 
			local distance = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if distance <= 5.0 then 
				letSleep = false
				wait = 5
				ESX.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.1, "Appuyez sur ~b~E~s~ pour ramasser", 5)
				if IsControlJustReleased(0, 38) and distance < 1.5 and not IsPedInAnyVehicle(playerPed, false) and (closestDistance == -1 or closestDistance > 3.5) then 
					if IsPedOnFoot(pPed) and (closestDistance == -1 or closestDistance > 1) and not v.inRange and not IsPedCuffed(pPed) then

						local dict, anim = 'random@domestic', 'pickup_low'
						ESX.Streaming.RequestAnimDict(dict)
						TaskPlayAnim(pPed, dict, anim, 8.0, 8.0, -1, 0, 1, 0, 0, 0)

						Citizen.Wait(1000)
						TriggerServerEvent('esx:onPickupIdCards', k, GetPlayerServerId(PlayerId()))
						PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
						--v.inRange = true
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(750)
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 750
		local pPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(pPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for k,v in pairs(pickupscards) do 
			local distance = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if distance <= 5.0 then 
				letSleep = false
				wait = 5
				ESX.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.1, "Appuyez sur ~b~E~s~ pour ramasser", 5)
				if IsControlJustReleased(0, 38) and distance < 1.5 and not IsPedInAnyVehicle(playerPed, false) and (closestDistance == -1 or closestDistance > 3.5) then 
					if IsPedOnFoot(pPed) and (closestDistance == -1 or closestDistance > 1) and not v.inRange and not IsPedCuffed(pPed) then

						local dict, anim = 'random@domestic', 'pickup_low'
						ESX.Streaming.RequestAnimDict(dict)
						TaskPlayAnim(pPed, dict, anim, 8.0, 8.0, -1, 0, 1, 0, 0, 0)

						Citizen.Wait(1000)
						TriggerServerEvent('esx:onPickupCards', k, GetPlayerServerId(PlayerId()))
						PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
						--v.inRange = true
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(750)
		end

		Citizen.Wait(wait)
	end
end)

Citizen.CreateThread(function()
	while true do
		local wait = 750
		local pPed = PlayerPedId()
		local playerCoords, letSleep = GetEntityCoords(pPed), true
		local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer(playerCoords)

		for k,v in pairs(pickups) do
			local distance = Vdist(playerCoords, v.coords.x, v.coords.y, v.coords.z, true)
			local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
			if distance <= 5.0 then 
				letSleep = false
				wait = 5
				ESX.Draw3DText(v.coords.x, v.coords.y, v.coords.z + 0.1, "Appuyez sur ~b~E~s~ pour ramasser", 5)
				if IsControlJustReleased(0, 38) and distance < 1.5 and not IsPedInAnyVehicle(playerPed, false) and (closestDistance == -1 or closestDistance > 3.5) then 
					if IsPedOnFoot(pPed) and (closestDistance == -1 or closestDistance > 1) and not v.inRange and not IsPedCuffed(pPed) then

						local dict, anim = 'random@domestic', 'pickup_low'
						ESX.Streaming.RequestAnimDict(dict)
						TaskPlayAnim(pPed, dict, anim, 8.0, 8.0, -1, 0, 1, 0, 0, 0)

						Citizen.Wait(1000)
						TriggerServerEvent('esx:onPickup', k)
						PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
						--v.inRange = true
					end
				end
			end
		end

		if letSleep then
			Citizen.Wait(750)
		end

		Citizen.Wait(wait)
	end
end)

function StartServerSyncLoops()

	-- keep track of ammo
	Citizen.CreateThread(function()
		while true do
			Wait(0)
	
			if isDead then
				Wait(500)
			else
				local playerPed = PlayerPedId()
	
				if IsPedShooting(playerPed) then
					local _, weaponHash = GetCurrentPedWeapon(playerPed, true)
					local weapon = ESX.GetWeaponFromHash(weaponHash)
	
					if weapon then
						local ammoCount = GetAmmoInPedWeapon(playerPed, weaponHash)
						TriggerServerEvent('esx:updateWeaponAmmo', weapon.name, ammoCount)
					end
				end
			end
		end
	end)

	Citizen.CreateThread(function()
		local previousCoords = vector3(ESX.PlayerData.coords.x, ESX.PlayerData.coords.y, ESX.PlayerData.coords.z)
	
		while true do
			Citizen.Wait(1000)
			local playerPed = PlayerPedId()
	
			if DoesEntityExist(playerPed) then
				local playerCoords = GetEntityCoords(playerPed)
				local distance = #(playerCoords - previousCoords)
	
				if distance > 1 then
					previousCoords = playerCoords
					local playerHeading = ESX.Math.Round(GetEntityHeading(playerPed), 1)
					local formattedCoords = {x = ESX.Math.Round(playerCoords.x, 1), y = ESX.Math.Round(playerCoords.y, 1), z = ESX.Math.Round(playerCoords.z, 1), heading = playerHeading}
					TriggerServerEvent('esx:updateCoords', formattedCoords)
				end
			end
		end
	end)
end

AddEventHandler('playerSpawned', function()
	ESX.TriggerServerCallback('GetEntityPosition', function()
		print('Dernière position')
	end)
end)

RegisterNetEvent('GetEntityPosition')
AddEventHandler('GetEntityPosition', function(position, vie)
    if position then
        pos = position
    end
    SetEntityCoords(GetPlayerPed(-1), pos.x, pos.y, pos.z, 0.0, 0.0, 0.0, true)
    Wait(500)
end)