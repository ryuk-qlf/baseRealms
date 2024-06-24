ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

function ConvertToBool(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end

function ConvertToNum(bool)
    if bool then return 1 else return 0 end
end

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

RegisterCommand("stuck", function()
    TriggerServerEvent("SetBucket", 0)
end)

PropertyAccess = {}

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

function DisplayNotification(txt, beep)
	SetTextComponentFormat("jamyfafi")
	AddTextComponentString(txt)
	if string.len(txt) > 99 and AddLongString then AddLongString(txt) end
	DisplayHelpTextFromStringLabel(0, 0, beep, -1)
end

function CanAccess(propId)
    local found = false

    for k, v in pairs(Properties.Access) do
        if v == propId then
            found = true
            break
        end
    end
    Wait(550)
    return found
end

RegisterNetEvent("Property:ActualizeProperties")
AddEventHandler("Property:ActualizeProperties", function(result)
    Properties.List = result
    if  Properties.Access == nil then
        Properties.Access = {}
    end
end)

RegisterNetEvent("Property:ActualizePropertiesPerso")
AddEventHandler("Property:ActualizePropertiesPerso", function(result, access, blips)
    Properties.List = result
    Properties.Access = access
    Properties.AccessBlips = blips

    Wait(350)
    RefreshBlips()
end)

RegisterNetEvent("AccessActualize")
AddEventHandler("AccessActualize", function(access, blips)
    Properties.Access = access
    Properties.AccessBlips = blips
    Property.Current.Access = nil

    RefreshBlips()
end)

function Property:GetEnterFromType(interior)
    for k, v in pairs(Properties.Interiors) do 
        if v.name == interior then
            return v.enter 
        end
    end
end

function Property:GetChestFromType(interior)
    for k, v in pairs(Properties.Interiors) do 
        if v.name == interior then
            return v.chest 
        end
    end
end

function Property:GetInteriorPrice(interior)
    for k, v in pairs(Properties.Interiors) do 
        if v.name == interior then
            return v.price 
        end
    end
end

function Property:GetEnterFromGarage(max)
    for k, v in pairs(Properties.Garages) do
        if v.Space == max then
            return v.Enter
        end
    end
end

function Property:GetGestionFromGarage(max)
    for k, v in pairs(Properties.Garages) do
        if v.Space == max then
            return v.Gestion or nil
        end
    end
end

function Property:GetSpacesFromGarage(max)
    for k, v in pairs(Properties.Garages) do
        if v.Space == max then
            return v.Spaces
        end
    end
end

function GetAccess(idProp)
    accessList = {}
    ESX.TriggerServerCallback("ESX:getAccess", function(cb) 
        accessList = cb
    end, idProp)
    Wait(500)
    return accessList or {}
end

function GetAccessRing()
    local idcrew = Property.Current.Id_Crew
    local metier = Property.Current.Jobs_Id
    local idprop = Property.Current.Id

    if idcrew ~= nil then
        ESX.TriggerServerCallback("ESX:ringPropertyCrew", function(cb) 
            accessRing = cb
        end, idcrew)
    elseif metier ~= nil then
        ESX.TriggerServerCallback("ESX:ringPropertyJob", function(cb) 
            accessRing = cb
        end, metier)
    else
        ESX.TriggerServerCallback("ESX:getAccess", function(cb) 
            accessRing = cb
        end, idprop)
    end
    Wait(500)
    return accessRing or {}
end


function Property:GetVehicles(name)
    ESX.TriggerServerCallback("ESX:getVehicles", function(cb) 
        vehiclesList = cb
    end, name)

    Wait(50)
    
    return vehiclesList
end

function CreateEffect(style, default, time) -- Créer un effet
    Citizen.CreateThread(function()
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DisplayRadar(false)
        SetTimecycleModifier(style or "drug_flying_base")
        RequestAnimSet("move_m@drunk@slightlydrunk")
        
        SetPedMovementClipset(GetPlayerPed(-1), "move_m@drunk@slightlydrunk", true)
        if default then 
            SetCamEffect(2)
        end
        DoScreenFadeIn(1000)
        Citizen.Wait(time or 20000)
        local pPed = GetPlayerPed(-1)
        DoScreenFadeOut(1000)
        Citizen.Wait(1000)
        DoScreenFadeIn(1000)
        ClearTimecycleModifier()
        ResetScenarioTypesEnabled()
        SetPedIsDrunk(pPed,false)
		SetCamEffect(0)
        ResetPedMovementClipset(GetPlayerPed(-1))
        ResetPedWeaponMovementClipset(GetPlayerPed(-1))
        ResetPedStrafeClipset(GetPlayerPed(-1))
        DisplayRadar(true)
    end)
end

Property.ObjectsDetails = {
    bong = {
        pretime = 300,
        anim = {"anim@safehouse@bong", "bong_stage1"},
        txt = "pour ~b~utiliser le bang~s~",
        time = 8000,
        func = CreateEffect,
        dynamic = true
    },
    wine = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~p~boire du vin~s~",
        func = CreateEffect,
        time = 8000
    },
    whiskey = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~o~boire du whisky~s~",
        func = CreateEffect,
        time = 8000
    },
    apple = {
        pretime = 300,
        anim = {"mp_safehousewheatgrass@", "ig_2_wheatgrassdrink_michael"},
        txt = "pour ~g~boire du jus de pomme~s~",
        func = CreateEffect,
        time = 8000
    }
}
Property.PropsInteract = {
    ["prop_bong_01"] = "bong",
    ["prop_bong_02"] = "bong",
    ["prop_sh_bong_01"] = "bong",
    ["hei_heist_sh_bong_01"] = "bong",

    ["p_wine_glass_s"] = "wine",
    ["prop_drink_champ"] = "wine",
    ["prop_drink_redwine"] = "wine",

    ["prop_drink_whtwine"] = "whiskey",
    ["prop_drink_whisky"] = "whiskey",
    ["prop_whiskey_01"] = "whiskey",
    ["p_whiskey_bottle_s"] = "whiskey",
    ["prop_whiskey_bottle"] = "whiskey",
    ["p_whiskey_notop_empty"] = "whiskey",
    ["prop_cs_whiskey_bottle"] = "whiskey",

    ["p_w_grass_gls_s"] = "apple",
    ["prop_wheat_grass_glass"] = "apple",
    ["prop_wheat_grass_half"] = "apple",
}

function AttachObjectToHandsPeds(ped, hash, timer, rot, bone, dynamic) -- Attach un props sur la main d'un ped
    if props and DoesEntityExist(props)then 
        DeleteEntity(props)
    end
    props = CreateObject(GetHashKey(hash), GetEntityCoords(ped), not dynamic)
    AttachEntityToEntity(props, ped, GetPedBoneIndex(ped, bone and 60309 or 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, not rot)
    if timer then 
        Citizen.Wait(timer)
        if props and DoesEntityExist(props)then 
            DeleteEntity(props)
        end
    	ClearPedTasks(ped)
    end
    return props
end

Property.isInAnim = fasle

function Property:UseProps(k, table, obj)
    local pPed = PlayerPedId()
    if table.anim then
        Property.isInAnim = true
        RequestAnimDict(table.anim[1])
        while not HasAnimDictLoaded(table.anim[1]) do
            Citizen.Wait(10)
        end
        TaskPlayAnim(GetPlayerPed(-1), table.anim[1], table.anim[2], 8.0, -8.0, -1, 0, 1, 0, 0, 0, 0)
        FreezeEntityPosition(pPed, true)
        local ObjectAttach
        Citizen.Wait(table.pretime or 0)
        SetEntityVisible(obj, false)
        if k then
            ObjectAttach = AttachObjectToHandsPeds(pPed, k, nil, nil, table.dynamic)
        end
        Citizen.Wait(table.time or 5000)
        if table.func then
            table.func()
        end
        if ObjectAttach and DoesEntityExist(ObjectAttach) then
            DeleteEntity(ObjectAttach)
        end
        FreezeEntityPosition(pPed, false)
        SetEntityVisible(obj, true)
        Property.isInAnim = false 
    else
        if table.func then
            table.func()
        end
    end
end

function Property:Visit()
    local Player = PlayerPedId()
    if Property.Current.Pos then
        Property.LastPos = Property.Current.Pos
    elseif Property.Current.PosG then
        Property.LastPos = Property.Current.PosG
    end
    Property.Current.Enter = Property:GetEnterFromType(Property.Current.Interior)
    Property.Current.Chest = Property:GetChestFromType(Property.Current.Interior)

    Property.Current.Ipl = GetInteriorAtCoords(Property.Current.Enter)
    if Property.Current.Ipl then LoadInterior(Property.Current.Ipl) end

    DoScreenFadeOut(1000)
    Wait(900)
    TriggerServerEvent('addPlayersCoords')
    Property:TeleportCoords(Property.Current.Enter, Player)
    Wait(900)
    DoScreenFadeIn(1000)
    Property:StartInstance()
    Property.IsInProperty = true

    while Property.IsInProperty do
        local time = 1000

        if IsPedFatallyInjured(PlayerPedId()) then
            Property:Exit()
        end

        if Property.Current.Enter ~= nil then
            if GetDistanceBetweenCoords(GetEntityCoords(Player), vector3(Property.Current.Enter.x, Property.Current.Enter.y, Property.Current.Enter.z), true) <= 1.2 then
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir de la propriété~s~.")

                if IsControlJustReleased(0, 51) then
                    RageUI.CloseAll()
                    HouseMenu.InMenu = false
                    Property:Exit()
                    Wait(200)
                end
                time = 5
            end
        end

        for k, v in pairs(Property.PropsInteract) do
            local object = GetClosestObjectOfType(GetEntityCoords(Player), 1.0, GetHashKey(k), false, true, true)
            if object and DoesEntityExist(object) and GetDistanceBetweenCoords(GetEntityCoords(Player), GetEntityCoords(object), true) < 1.0 and Property.ObjectsDetails[v] and not Property.isInAnim then
                time = 5 
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ ~s~"..Property.ObjectsDetails[v].txt.."~s~.")
                if IsControlJustPressed(0, 51) then 
                    RequestControl(object)
                    Property:UseProps(k, Property.ObjectsDetails[v], object)
                end
            end
        end

        Wait(time)
    end
end

function Property:VisitGarage()
    local Player = PlayerPedId()
    if Property.Current.Pos then
        Property.LastPos = Property.Current.Pos
    elseif Property.Current.PosG then
        Property.LastPos = Property.Current.PosG
    end
    Property.Current.Ipl = GetInteriorAtCoords(Property.Current.Garage.Enter)
    if Property.Current.Ipl then LoadInterior(Property.Current.Ipl) end

    DoScreenFadeOut(1000)
    Wait(900)
    TriggerServerEvent('addPlayersCoords')
    Property:TeleportCoords(Property.Current.Garage.Enter, Player)
    Wait(900)
    DoScreenFadeIn(1000)
    Property:StartInstance()
    Property.IsInProperty = true

    while Property.IsInProperty do
        local time = 1000

        if IsPedFatallyInjured(PlayerPedId()) then
            Property:Exit()
        end

        if Property.Current.Garage.Enter ~= nil then
            if GetDistanceBetweenCoords(GetEntityCoords(Player), vector3(Property.Current.Garage.Enter.x, Property.Current.Garage.Enter.y, Property.Current.Garage.Enter.z), true) <= 1.2 then
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir du garage~s~.")

                if IsControlJustReleased(0, 51) then
                    RageUI.CloseAll()
                    GarageMenu.InMenu = false
                    Property:Exit()
                    Wait(200)
                end
                time = 5
            end
        end
        Wait(time)
    end
end

function Property:Enter()
    local Player = PlayerPedId()
    if Property.Current.Pos then
        Property.LastPos = Property.Current.Pos
    elseif Property.Current.PosG then
        Property.LastPos = Property.Current.PosG
    end
    Property.Current.Enter = Property:GetEnterFromType(Property.Current.Interior)
    Property.Current.Chest = Property:GetChestFromType(Property.Current.Interior)
    if Property.Current.Interior == "Labo1" then
        TriggerEvent("EnterLaboWeed")
    elseif Property.Current.Interior == "Labo2" then
        TriggerEvent("EnterLaboCoke")
    elseif Property.Current.Interior == "Labo3" then
        TriggerEvent("EnterLaboMeth")
    end
    TriggerServerEvent('addPlayersCoords')
    Wait(150)
    Property:TeleportCoords(Property.Current.Enter, Player)
    Property.IsInProperty = true
    Property:StartInstance()
    Wait(50)
    DoScreenFadeIn(1000)

    Citizen.CreateThread(function()
        while Property.IsInProperty do
            local time = 1000

            if Property.Current.Enter ~= nil then
                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Enter.x, Property.Current.Enter.y, Property.Current.Enter.z)) <= 5 then
                    DrawMarker(25, Property.Current.Enter.x, Property.Current.Enter.y, Property.Current.Enter.z-0.98, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                    time = 5
                end

                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Enter.x, Property.Current.Enter.y, Property.Current.Enter.z)) <= 1.2 then
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir de la propriété~s~.")
                    if IsControlJustReleased(0, 51) then   
                        Property:Exit()
                        RageUI.CloseAll()
                        HouseMenu.InMenu = false
                        Wait(200)
                    end
                end
            end

            if Property.Current.Chest ~= nil then
                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Chest.x, Property.Current.Chest.y, Property.Current.Chest.z)) <= 5 then
                    DrawMarker(25, Property.Current.Chest.x, Property.Current.Chest.y, Property.Current.Chest.z-0.98, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                    time = 5
                end

                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Chest.x, Property.Current.Chest.y, Property.Current.Chest.z+1)) <= 1.2 then
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accéder au coffre~s~.")

                    if IsControlJustReleased(0, 51) then
                        if Property.Current.CanAccess then
                            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                            if closestPlayer == -1 or closestDistance >= 3.0 then
                                Property:OpenChest()
                            else
                                ESX.ShowNotification("~r~Impossible d'ouvrir le coffre, quelqu'un est trop près.")
                            end
                            Wait(200)
                        else
                            ESX.ShowNotification("~r~Vous n'avez pas accès au coffre de la propriété.")
                        end
                    end
                end
            end

            for k, v in pairs(Property.PropsInteract) do
                local object = GetClosestObjectOfType(GetEntityCoords(Player), 1.0, GetHashKey(k), false, true, true)
                if object and DoesEntityExist(object) and GetDistanceBetweenCoords(GetEntityCoords(Player), GetEntityCoords(object), true) < 1.0 and Property.ObjectsDetails[v] and not Property.isInAnim then
                    time = 5 
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ ~s~"..Property.ObjectsDetails[v].txt.."~s~.")

                    if IsControlJustPressed(0, 51) then 
                        RequestControl(object)
                        Property:UseProps(k, Property.ObjectsDetails[v], object)
                    end
                end
            end
    
            Wait(time)
        end    
    end)
end

function Property:OpenChest()
    TriggerServerEvent("OpenPropChest", "property_"..Property.Current.Id, Property.Current.ChestMax)
end

function Property:EnterGarage()
    local Player = PlayerPedId()
    if Property.Current.Pos then
        Property.LastPos = Property.Current.Pos
    elseif Property.Current.PosG then
        Property.LastPos = Property.Current.PosG
    end
    TriggerServerEvent('addPlayersCoords')
    Property:TeleportCoords(Property.Current.Garage.Enter, Player)
    Property.IsInGarage = true
    Property.Current.Garage.Vehicles = Property:GetVehicles(Property.Current.Id)
    Wait(50)
    Property.Current.Garage.Vehicles = Property:GetVehicles(Property.Current.Id)
    Property:StartInstance()
    DoScreenFadeIn(1000)
    Wait(500)
    Citizen.CreateThread(function()
        Property.Current.Garage.SpawnedVehicles = {}
        Property.Current.Garage.Vehicle = {}
        if Property.Current.Garage.Spaces ~= nil then
            for k, v in pairs(Property.Current.Garage.Spaces) do
                if Property.Current.Garage.Vehicles ~= nil then
                    if Property.Current.Garage.Vehicles[k] then
                        Property:SpawnVehicles(k, v)
                    end
                end
            end
        end

        while Property.IsInGarage do
            local time = 1000

            if Property.Current.Garage.Enter ~= nil then
                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Garage.Enter.x, Property.Current.Garage.Enter.y, Property.Current.Garage.Enter.z)) <= 10 then
                    DrawMarker(25, Property.Current.Garage.Enter.x, Property.Current.Garage.Enter.y, Property.Current.Garage.Enter.z-0.98, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                    time = 5
                end

                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Garage.Enter.x, Property.Current.Garage.Enter.y, Property.Current.Garage.Enter.z)) <= 2 then
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir du garage~s~.")
                    if IsControlJustReleased(0, 51) then
                        Property:Exit()
                    end
                    time = 5
                end
            end

            if Property.Current.Garage.Gestion ~= nil then
                if Vdist(GetEntityCoords(Player), vector3(Property.Current.Garage.Gestion.x, Property.Current.Garage.Gestion.y, Property.Current.Garage.Gestion.z)) <= 2 then
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accéder à la gestion véhicule~s~.")
                    if IsControlJustReleased(0, 51) then
                        Property:OpenGestionGarageMenu()
                    end
                    time = 5
                else
                    if GarageMenu.InMenu then
                        RageUI.CloseAll()
                    end
                end
            end

            local playerPed = PlayerPedId()
            local vehicle = GetVehiclePedIsUsing(playerPed)

            if Property.Current.Garage.Spaces ~= nil then
                for k, v in pairs(Property.Current.Garage.Spaces) do
                    if GetDistanceBetweenCoords(GetEntityCoords(Player), vector3(v.x, v.y, v.z), true) <= 3.0 then
                        if Property.Current.Garage.Vehicles ~= nil then
                            if Property.Current.Garage.Vehicles[k] then
                                Property:DrawVehicleDatas(Property.Current.Garage.Vehicle[k], k)
                                FreezeEntityPosition(Property.Current.Garage.Vehicle[k], k, true)
                                SetVehicleDoorsLocked(Property.Current.Garage.Vehicle[k], 2)
                                if IsPedInAnyVehicle(playerPed, true) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
                                   SetVehicleEngineOn(GetVehiclePedIsIn(GetPlayerPed(-1), false), false, false, true)
                                   SetVehicleUndriveable(GetVehiclePedIsIn(GetPlayerPed(-1), false), true)
                                end
                            end
                        end
                        time = 1
                    else
                        if Property.ScalformGarage[k] then 
                            if HasScaleformMovieLoaded(Property.ScalformGarage[k]) then
                                SetScaleformMovieAsNoLongerNeeded(Property.ScalformGarage[k])
                                Property.ScalformGarage[k] = nil
                            end
                        end
                    end
                end
            end
            Wait(time)
        end
    end)
end

function Property:CreateVehicle(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	if not IsModelValid(model) or not IsModelInCdimage(model) then
        ESX.ShowNotification("~r~Ce modèle de véhicule n'éxiste pas ("..modev.." / "..modelName..")")
        return
    end

	local ped = PlayerPedId()

    ESX.Game.SpawnVehicle(model, coords, heading, function(vehicle) 
        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetVehicleOnGroundProperly(vehicle)
        SetVehicleRadioLoud(vehicle, true)
        SetDisableVehiclePetrolTankFires(vehicle, true)
        SetVehicleCanLeakOil(vehicle, true)
        SetVehicleCanLeakPetrol(vehicle, true)
        SetEntityAsMissionEntity(vehicle, true, false)

        local has, wep = GetCurrentPedVehicleWeapon(ped)
        if has then DisableVehicleWeapon(true, wep, vehicle, ped) end
        RequestCollisionAtCoord(coords.x, coords.y, coords.z)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            RequestCollisionAtCoord(coords.x, coords.y, coords.z)
            Citizen.Wait(0)
        end

        if cb ~= nil then
            cb(vehicle)
        end
    end)
end

function Property:DeleteVehicle(vehicle)
    while not NetworkHasControlOfEntity(vehicle) and DoesEntityExist(vehicle) do
        Wait(100)
        NetworkRequestControlOfEntity(vehicle)
    end

    if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
        ESX.Game.DeleteVehicle(vehicle)
    end
end

function Property:Exit(vehProps)
    if Property.Current.Interior == "Labo2" then
        TriggerEvent('DeleteObjCoke')
    elseif Property.Current.Interior == "Labo1" then
        TriggerEvent('DeleteObjWeed')
    end
    DoScreenFadeOut(1000)
    Wait(1000)   
    Property:StopInstance()
    if Property.Current.Garage.SpawnedVehicles then
        for k, v in pairs(Property.Current.Garage.SpawnedVehicles) do
            Property:DeleteVehicle(v)
        end
    end
    Property.IsInProperty = false
    Property.IsInGarage = false
    local Player = PlayerPedId()
    Property:TeleportCoords(Property.LastPos, Player)
    TriggerServerEvent('removePlayersCoords')
    Wait(150)
    if vehProps then
        Property:CreateVehicle(vehProps.model, vector3(Property.LastPos.x, Property.LastPos.y, Property.LastPos.z), GetEntityHeading(Player), function(vehicle)
            Property:SetVehicleProperties(vehicle, vehProps)
            TriggerServerEvent("GetPlateVehicleInPound", vehProps.plate, 0)
            TaskWarpPedIntoVehicle(Player, vehicle, -1)
        end)
        Wait(150)
        TriggerEvent("Persistance:addVehicles", GetVehiclePedIsIn(PlayerPedId(), false))
        DoScreenFadeIn(1000)
    else
        Wait(150)
        DoScreenFadeIn(1000)
    end
end

function SetScaleformParams(scaleform, data)
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end
function CreateScaleform(name, data)
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

function GetVehicleHealth(entityVeh)
	return math.floor( math.max(0, math.min(100, GetVehicleEngineHealth(entityVeh) / 10 ) ) )
end

function CreateVehicleStatsScaleformLsCustoms(cars)
    local VehicleModel = GetEntityModel(cars)
    local VehicleSpeed = GetVehicleEstimatedMaxSpeed(cars) * 1.25
    local VehicleAcceleration = GetVehicleAcceleration(cars) * 200
    local VehicleBraking = GetVehicleMaxBraking(cars) * 100
    local VehicleTraction = GetVehicleMaxTraction(cars) * 25
    local VehicleHealth = GetVehicleHealth(cars)
    return CreateScaleform("mp_car_stats_01", {{
        name = "SET_VEHICLE_INFOR_AND_STATS",
        param = {GetLabelText(GetDisplayNameFromVehicleModel(VehicleModel)), "État du véhicule "..VehicleHealth.."%", "MPCarHUD","Annis", "Vitesse max", "Accélération", "Frein", "Suspension", VehicleSpeed, VehicleAcceleration, VehicleBraking, VehicleTraction}
    }})
end

function Property:SpawnLocalVehicle(modelName, coords, heading, cb)
	local model = (type(modelName) == 'number' and modelName or GetHashKey(modelName))

	Citizen.CreateThread(function()
		ESX.Streaming.RequestModel(model)

		local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, false)

		SetEntityAsMissionEntity(vehicle, true, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetModelAsNoLongerNeeded(model)
		RequestCollisionAtCoord(coords.x, coords.y, coords.z)

		while not HasCollisionLoadedAroundEntity(vehicle) do
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			Citizen.Wait(100) --base 0
		end

		SetVehRadioStation(vehicle, 'OFF')

		if cb ~= nil then
			cb(vehicle)
		end
	end)
end

function Property:SpawnVehicles(k, v)
    local vehProps = json.decode(Property.Current.Garage.Vehicles[k].vehicle_property)
    Property:SpawnLocalVehicle(vehProps.model, vector3(v.x, v.y, v.z+1), v.w, function(vehicle)
        Property:SetVehicleProperties(vehicle, vehProps)
        table.insert(Property.Current.Garage.SpawnedVehicles, vehicle)
        Property.Current.Garage.Vehicle[k] = vehicle
    end)
end

function Property:DrawVehicleDatas(vehicle, k)
    local vehProps = json.decode(Property.Current.Garage.Vehicles[k].vehicle_property)
    local vehName = GetLabelText(GetDisplayNameFromVehicleModel(vehProps.model))
    if not Property.ScalformGarage[k] then 
        Property.ScalformGarage[k] = CreateVehicleStatsScaleformLsCustoms(vehicle)
    end
    local vPos = GetEntityCoords(vehicle)
    local vHeight = GetEntityHeight(vehicle, vPos.x, vPos.y, vPos.z, true, false)
    if Property.ScalformGarage[k] and HasScaleformMovieLoaded(Property.ScalformGarage[k]) then
        DrawScaleformMovie_3dNonAdditive(Property.ScalformGarage[k], vPos.x, vPos.y, vPos.z + 2.4 + vHeight, GetGameplayCamRot(0), 0.0,1.0, 0.0, (10 * 0.8) * 0.9, (6 * 0.8) * 0.9, 1 * 0.9, 0)
    end
end

function Property:VehicleOut(k)
    local vehProps = json.decode(Property.Current.Garage.Vehicles[k].vehicle_property)
    if not ESX.Game.IsSpawnPointClear(vector3(Property.LastPos.x, Property.LastPos.y, Property.LastPos.z), 5) then
        ESX.ShowNotification("Un ~b~vehicule~s~ bloque la ~b~sortie~s~ du garage.") 
    else
        Wait(1000)
        print(vehProps.plate)
        TriggerServerEvent("ESX:vehicleOutGarage", Property.Current.Garage.Vehicles[k].id_vehicle, Property.Current.Id)
        Property:Exit(vehProps)
    end 
end

function Property:StartInstance()
    TriggerServerEvent("ESX:initInstance", Property.Current.Id)
end

function Property:StopInstance()
    TriggerServerEvent("ESX:outInstance", Property.Current.Id)
end

MenuVisite = {}
MenuVisite.InMenu = false
MenuVisite.menu = RageUI.CreateMenu("Habitation", "Habitation")
MenuVisite.menu.Closed = function()
    MenuVisite.InMenu = false
end

function OpenVisitMenu()
    RageUI.CloseAll()
    if MenuVisite.InMenu then
        MenuVisite.InMenu = false
        RageUI.Visible(MenuVisite.menu, false)
    else
        MenuVisite.InMenu = true
        RageUI.Visible(MenuVisite.menu, true)
            CreateThread(function()
                while MenuVisite.InMenu do
                    RageUI.IsVisible(MenuVisite.menu, function()
                        RageUI.Button("Visiter", nil, {}, true, {
                            onSelected = function()
                                MenuVisite.InMenu = false
                                RageUI.CloseAll()
                                Property:Visit()
                            end
                        })
                        if ESX.PlayerData.job and ESX.PlayerData.job.name == "realestateagent" then
                            RageUI.Button("Louer la propriété", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                onSelected = function()
                                    local Target = GetNearbyPlayer(3)
                                    if Target then
                                        TriggerServerEvent("ESX:updateProperty", Property.Current.Id, "rented", GetPlayerServerId(Target)) 
                                        RageUI.CloseAll()
                                        MenuVisite.InMenu = false
                                    end
                                end
                            })
                            RageUI.Button("Vendre la propriété", nil, {RightLabel = "~g~"..(Property.Current.Price * 40).."$"}, true, {
                                onSelected = function()
                                    local Target = GetNearbyPlayer(3)
                                    if Target then
                                        TriggerServerEvent("ESX:updateProperty", Property.Current.Id, "bought", GetPlayerServerId(Target)) -- bought = acheté
                                        RageUI.CloseAll()
                                        MenuVisite.InMenu = false
                                    end    
                                end
                            })
                            RageUI.Button("~r~Supprimer cette propriété", nil, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("ESX:deleteProperty", Property.Current.Id)
                                    RageUI.CloseAll()
                                    MenuVisite.InMenu = false
                                end
                            })
                        end
                    end)            
                Wait(1)
            end
        end)
    end
end

MenuVisiteVeh = {}
MenuVisiteVeh.InMenu = false
MenuVisiteVeh.menu = RageUI.CreateMenu("Garage", "Garage")
MenuVisiteVeh.menu.Closed = function()
    MenuVisiteVeh.InMenu = false
end

function OpenVisitMenuVeh()
    RageUI.CloseAll()
    if MenuVisiteVeh.InMenu then
        MenuVisiteVeh.InMenu = false
        RageUI.Visible(MenuVisiteVeh.menu, false)
    else
        MenuVisiteVeh.InMenu = true
        RageUI.Visible(MenuVisiteVeh.menu, true)
            CreateThread(function()
                while MenuVisiteVeh.InMenu do
                    RageUI.IsVisible(MenuVisiteVeh.menu, function()
                        RageUI.Button("Visiter", nil, {}, true, {
                            onSelected = function()
                                MenuVisiteVeh.InMenu = false
                                RageUI.CloseAll()
                                Property:VisitGarage()
                            end
                        }) 
                        if ESX.PlayerData.job and ESX.PlayerData.job.name == "realestateagent" then
                            RageUI.Button("Louer la propriété", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                onSelected = function()
                                    local Target = GetNearbyPlayer(3)
                                    if Target then
                                        TriggerServerEvent("ESX:updateProperty", Property.Current.Id, "rented", GetPlayerServerId(Target)) 
                                        RageUI.CloseAll()
                                        MenuVisiteVeh.InMenu = false
                                    end
                                end
                            })
                            RageUI.Button("Vendre la propriété", nil, {RightLabel = "~g~"..(Property.Current.Price * 40).."$"}, true, {
                                onSelected = function()
                                    local Target = GetNearbyPlayer(3)
                                    if Target then
                                        TriggerServerEvent("ESX:updateProperty", Property.Current.Id, "bought", GetPlayerServerId(Target)) -- bought = acheté
                                        RageUI.CloseAll()
                                        MenuOwned.openedMenu = false
                                    end
                                end
                            })
                            RageUI.Button("~r~Supprimer cette propriété", nil, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("ESX:deleteProperty", Property.Current.Id)
                                    RageUI.CloseAll()
                                    MenuOwned.openedMenu = false
                                end
                            })
                        end
                    end)            
                Wait(1)
            end
        end)
    end
end

MenuOwned = {}
MenuOwned.openedMenu = false
MenuOwned.menu = RageUI.CreateMenu("Habitation", "Habitation")
MenuOwned.menu.Closed = function()
    MenuOwned.openedMenu = false
end

GetDateExp = {}

GetDateExp.Jours = "Loading"
GetDateExp.Mois = "Loading"
GetDateExp.Annee = "Loading"
GetDateExp.Heures = "Loading"
GetDateExp.Minutes = "Loading"

function OpenOwnedMenu()
    RageUI.CloseAll()
    if MenuOwned.openedMenu then
        MenuOwned.openedMenu = false
        RageUI.Visible(MenuOwned.menu, false)
    else
        if Property.Current.Status == "rented" then
            ESX.TriggerServerCallback("GetDimandPlayer", function(result)
                MenuOwned.Diamond = result
            end)
            ESX.TriggerServerCallback("GetTimeFortable", function(result)
                local temps = (10080-result)
                if temps >= 0 then
                    MenuOwned.openedMenu = true
                    ESX.TriggerServerCallback("GetDayLocation", function(results)
                        GetDateExp.Jours = results.day
                        GetDateExp.Mois = results.month
                        GetDateExp.Annee = results.year
                        GetDateExp.Heures = results.hour
                        GetDateExp.Minutes = results.min

                    end, Property.Current.Exp, 7)
                else
                    TriggerServerEvent("ESX:FinContractLocation", Property.Current.Id)
                    MenuOwned.openedMenu = false
                    OpenVisitMenu()
                end
            end, json.encode(Property.Current.Exp))
        else
            MenuOwned.openedMenu = true
        end
        Wait(150)
        if MenuOwned.openedMenu then
            RageUI.Visible(MenuOwned.menu, true)
                CreateThread(function()
                    while MenuOwned.openedMenu do
                        RageUI.IsVisible(MenuOwned.menu, function()
                            if Property.Current.CanAccess then
                                RageUI.Button("Entrer dans la propriété", nil, {}, true, {
                                    onSelected = function()
                                        RageUI.CloseAll()
                                        MenuOwned.openedMenu = false
                                        DoScreenFadeOut(1000)
                                        Wait(1000)
                                        Property:Enter()
                                    end
                                })
                                if Property.Current.Status == "rented" then
                                    RageUI.Button("Fin de la location", nil, {RightLabel = "~b~"..GetDateExp.Jours.."-"..GetDateExp.Mois.."-"..GetDateExp.Annee.." "..GetDateExp.Heures..":"..GetDateExp.Minutes}, true, {})
                                    if MenuOwned.Diamond then
                                        RageUI.Button("Prolonger la location", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                            onSelected = function()
                                                TriggerServerEvent("ESX:ProlongerLocationDiamond", Property.Current.Id, Property.Current.Name, Property.Current.Price)
                                                RageUI.CloseAll()
                                                MenuOwned.openedMenu = false
                                            end
                                        })
                                    end
                                end
                                MenuOwned.menu:SetTitle(Property.Current.Name)
                            else
                                RageUI.Button("Sonner à la propriété", nil, {}, true, {
                                    onSelected = function()
                                        RageUI.CloseAll()
                                        MenuOwned.openedMenu = false
                                        Property.Ringed = Property.Current
                                        TriggerServerEvent("ESX:ringProperty", GetAccessRing(), Property.Current.Owner, Property.Current.Name, "prop")
                                    end
                                })
                                MenuOwned.menu:SetTitle("Habitation")
                            end
                            if ESX.PlayerData.job and ESX.PlayerData.job.name == "realestateagent" then
                                RageUI.Separator("Actions")
                                if Property.Current.Status == "rented" then
                                    RageUI.Button("Prolonger la location", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                        onSelected = function()
                                            TriggerServerEvent("ESX:ProlongerLocation", Property.Current.Id)
                                            ESX.ShowNotification("Vous avez ~b~prolonger~s~ la ~g~location~s~.")
                                            RageUI.CloseAll()
                                            MenuOwned.openedMenu = false
                                        end
                                    })
                                    RageUI.Button("Acheter", nil, {RightLabel = "~g~"..(Property.Current.Price * 40).."$"}, true, {
                                        onSelected = function()
                                            TriggerServerEvent("ESX:PassezEnAchat", Property.Current.Id)
                                        end
                                    })
                                end
                                RageUI.Button("~r~Supprimer cette propriété", nil, {}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("ESX:deleteProperty", Property.Current.Id)
                                        RageUI.CloseAll()
                                        MenuOwned.openedMenu = false
                                    end
                                })
                            end
                        end)            
                    Wait(1)
                end
            end)
        end
    end
end

---

MenuOwnedVeh = {}
MenuOwnedVeh.openedMenu = false
MenuOwnedVeh.menu = RageUI.CreateMenu("Garage", "Garage")
MenuOwnedVeh.menu.Closed = function()
    MenuOwnedVeh.openedMenu = false
end

GetDateExp = {}

GetDateExp.Jours = "Loading"
GetDateExp.Mois = "Loading"
GetDateExp.Annee = "Loading"
GetDateExp.Heures = "Loading"
GetDateExp.Minutes = "Loading"

function OpenOwnedMenuVeh()
    RageUI.CloseAll()
    if MenuOwnedVeh.openedMenu then
        MenuOwnedVeh.openedMenu = false
        RageUI.Visible(MenuOwnedVeh.menu, false)
    else
        if Property.Current.Status == "rented" then
            ESX.TriggerServerCallback("GetDimandPlayer", function(result)
                MenuOwnedVeh.Diamond = result
            end)
            ESX.TriggerServerCallback("GetTimeFortable", function(result)
                local temps = (10080-result)
                if temps >= 0 then
                    MenuOwnedVeh.openedMenu = true
                    ESX.TriggerServerCallback("GetDayLocation", function(results)
                        GetDateExp.Jours = results.day
                        GetDateExp.Mois = results.month
                        GetDateExp.Annee = results.year
                        GetDateExp.Heures = results.hour
                        GetDateExp.Minutes = results.min

                    end, Property.Current.Exp, 7)
                else
                    TriggerServerEvent("ESX:FinContractLocation", Property.Current.Id)
                    MenuOwnedVeh.openedMenu = false
                    OpenVisitMenu()
                end
            end, json.encode(Property.Current.Exp))
        else
            MenuOwnedVeh.openedMenu = true
        end
        Wait(150)
        if MenuOwnedVeh.openedMenu then
            RageUI.Visible(MenuOwnedVeh.menu, true)
                CreateThread(function()
                    while MenuOwnedVeh.openedMenu do
                        RageUI.IsVisible(MenuOwnedVeh.menu, function()
                            if Property.Current.CanAccess then
                                RageUI.Button("Entrer dans le garage", nil, {}, true, {
                                    onSelected = function()
                                        RageUI.CloseAll()
                                        MenuOwnedVeh.openedMenu = false
                                        DoScreenFadeOut(1000)
                                        Wait(1000)
                                        Property:EnterGarage()
                                    end
                                })
                                if Property.Current.Status == "rented" then
                                    RageUI.Button("Fin de la location", nil, {RightLabel = "~b~"..GetDateExp.Jours.."-"..GetDateExp.Mois.."-"..GetDateExp.Annee.." "..GetDateExp.Heures..":"..GetDateExp.Minutes}, true, {})
                                    if MenuOwnedVeh.Diamond then
                                        RageUI.Button("Prolonger la location", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                            onSelected = function()
                                                TriggerServerEvent("ESX:ProlongerLocationDiamond", Property.Current.Id, Property.Current.Name, Property.Current.Price)
                                                RageUI.CloseAll()
                                                MenuOwnedVeh.openedMenu = false
                                            end
                                        })
                                    end
                                end
                                MenuOwnedVeh.menu:SetTitle(Property.Current.Name)
                            else
                                RageUI.Button("Sonner au garage", nil, {}, true, {
                                    onSelected = function()
                                        RageUI.CloseAll()
                                        MenuOwnedVeh.openedMenu = false
                                        Property.Ringed = Property.Current
                                        TriggerServerEvent("ESX:ringProperty", GetAccessRing(), Property.Current.Owner, Property.Current.Name, "garage")
                                    end
                                })
                                MenuOwnedVeh.menu:SetTitle("Garage")
                            end
                            if ESX.PlayerData.job and ESX.PlayerData.job.name == "realestateagent" then
                                RageUI.Separator("Actions")
                                if Property.Current.Status == "rented" then
                                    RageUI.Button("Prolonger la location", nil, {RightLabel = "~g~"..Property.Current.Price.."$"}, true, {
                                        onSelected = function()
                                            TriggerServerEvent("ESX:ProlongerLocation", Property.Current.Id)
                                            ESX.ShowNotification("Vous avez ~b~prolonger~s~ la ~g~location~s~ de 7 jours.")
                                            RageUI.CloseAll()
                                            MenuOwnedVeh.openedMenu = false
                                        end
                                    })
                                    RageUI.Button("Acheter", nil, {RightLabel = "~g~"..(Property.Current.Price * 40).."$"}, true, {
                                        onSelected = function()
                                            TriggerServerEvent("ESX:PassezEnAchat", Property.Current.Id)
                                        end
                                    })
                                end
                                RageUI.Button("~r~Supprimer cette propriété", nil, {}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("ESX:deleteProperty", Property.Current.Id)
                                        RageUI.CloseAll()
                                        MenuOwnedVeh.openedMenu = false
                                    end
                                })
                            end
                        end)            
                    Wait(1)
                end
            end)
        end
    end
end

---

HouseMenu = {
    Index = 1,
    List = {"Crew", "Métier", "Mettre Propriétaire"},
}

HouseMenu.InMenu = false
HouseMenu.menu = RageUI.CreateMenu("Habitation", "Habitation")
HouseMenu.subMenu = RageUI.CreateSubMenu(HouseMenu.menu, "Locataires", "Locataires")
HouseMenu.subMenu2 = RageUI.CreateSubMenu(HouseMenu.menu, "Options", "Options")
HouseMenu.menu.Closed = function()
    HouseMenu.InMenu = false
end

function OpenHouseMenu()
    RageUI.CloseAll()
    if not HouseMenu.InMenu then
        if HouseMenu.InMenu then
            HouseMenu.InMenu = false
            RageUI.Visible(HouseMenu.menu, false)
        else
            HouseMenu.InMenu = true
            RageUI.Visible(HouseMenu.menu, true)
                CreateThread(function()
                    while HouseMenu.InMenu do
                        RageUI.IsVisible(HouseMenu.menu, function()
                            HouseMenu.menu:SetTitle(Property.Current.Name)
                            RageUI.Button("Habitation", nil, {RightLabel = Property.Current.Name}, true, {
                                onSelected = function()
                                    local result = ESX.KeyboardInput('Nouveau Nom', 20)
                                    if result ~= nil then
                                        TriggerServerEvent("ESX:updatePropertyName", Property.Current.Id, result)
                                        Property.Current.Name = result
                                    end
                                end
                            })
                            RageUI.Button("Options", nil, {RightLabel = "→"}, true, {}, HouseMenu.subMenu2)
                            RageUI.Button("Ajouter un locataire", nil, {}, true, {
                                onSelected = function()
                                    local closestPly = ESX.Game.GetClosestPlayer()
                                    if closestPly and closestPly ~= -1 then
                                        TriggerServerEvent("ESX:addAccess", Property.Current.Id, GetPlayerServerId(closestPly), Property.Current.Name)
                                    else
                                        ESX.ShowNotification("~r~Il n'y a personne a proximité de vous.")
                                    end    
                                end
                            })
                            RageUI.Button("Locataires", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    Property.Current.Access = GetAccess(Property.Current.Id)
                                    Wait(550)
                                    RageUI.CloseAll()
                                    RageUI.Visible(HouseMenu.subMenu, true)
                                end
                            })
                        end)
                        RageUI.IsVisible(HouseMenu.subMenu, function()
                            for k, v in pairs(Property.Current.Access) do
                                RageUI.Button(v.player_name, nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("ESX:deleteAccess", v.player_identifier, Property.Current.Id)
                                        ESX.ShowNotification("~r~Vous avez supprimé " .. v.player_name .. " de votre propriété.")
                                        RageUI.GoBack()
                                        Wait(350)
                                        Property.Current.Access = GetAccess(Property.Current.Id)
                                    end
                                })
                            end
                        end)
                        RageUI.IsVisible(HouseMenu.subMenu2, function()
                            RageUI.List("Attribuer", HouseMenu.List, HouseMenu.Index, nil, {}, true, {
                                onListChange = function(Index)
                                    HouseMenu.Index = Index
                                end,
                                onSelected = function(Index)
                                    if Index == 1 then
                                        TriggerServerEvent("ESX:attributePropertyToCrew", Property.Current.Name)
                                    elseif Index == 2 then
                                        if ESX.PlayerData.job and ESX.PlayerData.job.name ~= "unemployed" then
                                            TriggerServerEvent("ESX:attributePropertyToJob", Property.Current.Name, ESX.PlayerData.job and ESX.PlayerData.job.name)
                                        else
                                            ESX.ShowNotification("Vous ne ~r~pouvez pas~s~ attribuer cette ~r~propriété~s~ a votre ~r~métier~s~.")
                                        end
                                    elseif Index == 3 then
                                        local closestPly = ESX.Game.GetClosestPlayer()
                                        if closestPly and closestPly ~= -1 then
                                            TriggerServerEvent("ESX:updateProperty", Property.Current.Id, Property.Current.Status, GetPlayerServerId(closestPly))
                                            HouseMenu.InMenu = false
                                            RageUI.CloseAll()
                                        else
                                            ESX.ShowNotification("~r~Il n'y a personne a proximité de vous.")
                                        end
                                    end
                                end
                            })
                        end)
                    Wait(1)
                end
            end)
        end
    end
end

GarageMenu = {}

GarageMenu.InMenu = false
GarageMenu.menu = RageUI.CreateMenu(" ", " ", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
GarageMenu.menu.Closed = function()
    GarageMenu.InMenu = false
end

GarageMenu.menu:DisplayGlare(false)
GarageMenu.menu:AcceptFilter(true)

function Property:OpenGestionGarageMenu()
    RageUI.CloseAll()
    if GarageMenu.InMenu then
        GarageMenu.InMenu = false
        RageUI.Visible(GarageMenu.menu, false)
    else
        GarageMenu.InMenu = true
        RageUI.Visible(GarageMenu.menu, true)
            CreateThread(function()
                while GarageMenu.InMenu do
                    RageUI.IsVisible(GarageMenu.menu, function()
                        if Property.Current.Garage.Max and Property.Current.Garage.Vehicles then
                            RageUI.Separator("Places disponibles : "..Property.Current.Garage.Max - #Property.Current.Garage.Vehicles .. "/" .. Property.Current.Garage.Max)
                        end
                        for k, v in pairs(Property.Current.Garage.Vehicles) do
                            local vehProps = json.decode(v.vehicle_property)
                            RageUI.Button(v.label, nil, {RightLabel = vehProps.plate}, true, {
                                onSelected = function()
                                    RageUI.ResetFiltre()
                                    if Property.Current.CanAccess then
                                        RageUI.CloseAll()
                                        GarageMenu.InMenu = false
                                        local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
                                        if closestPlayer == -1 or closestDistance >= 3.0 then
                                            sortie = true
                                            Property:VehicleOut(k)
                                            Citizen.SetTimeout(10000, function()
                                                sortie = false
                                            end)
                                        else
                                            ESX.ShowNotification("~r~Impossible de sortir le véhicule une personne est trop proche de vous.")
                                            sortie = true
                                            Citizen.SetTimeout(10000, function()
                                                sortie = false
                                            end)
                                        end
                                    else
                                        ESX.ShowNotification("~r~Vous ne pouvez pas sortir le véhicule.")
                                    end
                                end
                            })
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

function RequestControl(entity)
	local start = GetGameTimer()
	local entityId = tonumber(entity)
	if not DoesEntityExist(entityId) then
        return
    end
	if not NetworkHasControlOfEntity(entityId) then		
		NetworkRequestControlOfEntity(entityId)
		while not NetworkHasControlOfEntity(entityId) do
			Citizen.Wait(10)
			if GetGameTimer() - start > 5000 then
                return
            end
		end
	end
	return entityId
end

function Property:SetVehicleProperties(vehicle, vehicleProps)
    ESX.Game.SetVehicleProperties(vehicle, vehicleProps)
    if vehicleProps["windows"] then
        for windowId = 1, 9, 1 do
            if vehicleProps["windows"][windowId] == false then
                SmashVehicleWindow(vehicle, windowId)
            end
        end
    end
    if vehicleProps["tyres"] then
        for tyreId = 1, 7, 1 do
            if vehicleProps["tyres"][tyreId] ~= false then
                SetVehicleTyreBurst(vehicle, tyreId, true, 1000)
            end
        end
    end
    if vehicleProps["doors"] then
        for doorId = 0, 5, 1 do
            if vehicleProps["doors"][doorId] ~= false then
                SetVehicleDoorBroken(vehicle, doorId - 1, true)
            end
        end
    end
	if vehicleProps["vehicleHeadLight"] then 
        SetVehicleHeadlightsColour(vehicle, vehicleProps["vehicleHeadLight"]) 
    end
    if vehicleProps["vehicleEngine"] then 
        SetVehicleEngineHealth(vehicle, tonumber(vehicleProps["vehicleEngine"])) 
    end
end

function Property:TeleportCoords(vector, peds)
	if not vector or not peds then return end
	local x, y, z = vector.x, vector.y, vector.z + 0.98
	peds = peds or PlayerPedId()

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local TimerToGetGround = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(peds, x, y, z)

	TimerToGetGround = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(peds) do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	local retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
	TimerToGetGround = GetGameTimer()
	while not retval do
		z = z + 5.0
		retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
		Wait(0)

		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
	end

	SetEntityCoordsNoOffset(peds, x, y, retval and GroundPosZ or z)
	NewLoadSceneStop()
	return true
end

local HaveStartedAttack = false

RegisterNetEvent('ChangeHaveStartedAttack')
AddEventHandler('ChangeHaveStartedAttack', function(status)
    HaveStartedAttack = status
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        local Player = PlayerPedId()
        local pPed = Player
        local pPos = GetEntityCoords(Player)
        for k, v in pairs(Properties.List) do

            if v.property_pos ~= "null" then
                local propPos = json.decode(v.property_pos)
                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(propPos.x, propPos.y, propPos.z), true)
                if dist <= 10.0 then
                    time = 5
                    DrawMarker(25, propPos.x, propPos.y, propPos.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                end
                if dist <= 1.7 then
                    time = 5
                    Property.Current = v
                    Property.Current.Id = v.id_property
                    Property.Current.Exp = json.decode(v.expiration)
                    Property.Current.Pos = json.decode(v.property_pos)
                    Property.Current.Enter = Property:GetEnterFromType(Property.Current.Interior)
                    Property.Current.Chest = Property:GetChestFromType(Property.Current.Interior)          
                    Property.Current.ChestMax = v.property_chest            
                    Property.Current.Name = v.property_name    
                    Property.Current.Status = v.property_status
                    Property.Current.Interior = v.property_type 
                    Property.Current.Price = v.property_price
                    Property.Current.Owner = v.property_owner
                    Property.Current.Jobs_Id = v.jobs
                    Property.Current.Id_Crew = v.id_crew
                    Property.Current.Garage = {}
                    Property.Current.Garage.Max = v.garage_max

                    if PropertyAccess[Property.Current.Id] == nil or Property.Current.CanAccess == nil then
                        PropertyAccess[Property.Current.Id] = true
                        Property.Current.CanAccess = CanAccess(Property.Current.Id)
                    end

                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accéder à la propriété~s~.")
                    if IsControlJustPressed(0, 51) then
                        ESX.DrawMissionText(Property.Current.Id, 3000)
                        if v.property_owner ~= nil then
                            OpenOwnedMenu()
                        else
                            OpenVisitMenu()
                        end
                    end
                end

                if dist <= 45 then
                    if Property.Current.Interior == "Labo1" or Property.Current.Interior == "Labo2" or Property.Current.Interior == "Labo3" then
                        time = 5
                        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_molotov") and IsPedShooting(PlayerPedId()) then
                            if IsProjectileTypeWithinDistance(Property.Current.Pos.x, Property.Current.Pos.y, Property.Current.Pos.z, GetHashKey("weapon_molotov"), 10.0, true) then
                                if not Property.Current.CanAccess then
                                    if Property.Current.Id_Crew ~= nil then
                                        if not HaveStartedAttack then
                                            TriggerServerEvent("StartAttackLabo", Property.Current.Id_Crew, Property.Current.Name, Property.Current.Id, Property.Current.Pos.x, Property.Current.Pos.y, Property.Current.Pos.z)
                                        else
                                            ESX.Notification('~r~Une attaque est déjà en cours !')
                                        end
                                    end
                                else
                                    ESX.ShowNotification("~r~Impossible d'attaquer votre propriété.")
                                end
                            end
                        end
                    end
                end
            end

            if v.garage_pos ~= "null" then
                local garagePos = json.decode(v.garage_pos)
                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(garagePos.x, garagePos.y, garagePos.z), true)
                if dist <= 10.0 then
                    time = 5
                    DrawMarker(25, garagePos.x, garagePos.y, garagePos.z-0.98, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                end
                if dist <= 1.5 then
                    time = 5
                    Property.Current = v
                    Property.Current.Pos = json.decode(v.property_pos)
                    Property.Current.PosG = json.decode(v.garage_pos)
                    Property.Current.Id = v.id_property
                    Property.Current.Exp = json.decode(v.expiration)
                    Property.Current.Name = v.property_name    
                    Property.Current.Status = v.property_status
                    Property.Current.Type = "garage"
                    Property.Current.Price = v.property_price
                    Property.Current.Owner = v.property_owner
                    Property.Current.Jobs_Id = v.jobs
                    Property.Current.Id_Crew = v.id_crew
                    Property.Current.Garage = {}
                    Property.Current.Garage.Pos = json.decode(v.garage_pos)
                    Property.Current.Garage.Max = v.garage_max
                    Property.Current.Garage.Enter = Property:GetEnterFromGarage(Property.Current.Garage.Max)
                    Property.Current.Garage.Gestion = Property:GetGestionFromGarage(Property.Current.Garage.Max)
                    Property.Current.Garage.Spaces = Property:GetSpacesFromGarage(Property.Current.Garage.Max)

                    if PropertyAccess[Property.Current.Id] == nil or Property.Current.CanAccess == nil then
                        PropertyAccess[Property.Current.Id] = true
                        Property.Current.CanAccess = CanAccess(Property.Current.Id)
                    end

                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accéder au garage~s~.")

                    if IsControlJustPressed(0, 51) then
                        ESX.DrawMissionText(Property.Current.Id, 3000)
                        if Property.Current.Owner ~= nil then
                            if Property.Current.CanAccess then
                                local VehicleProperty = ESX.Game.GetVehicleProperties(GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) and GetPedInVehicleSeat(GetVehiclePedIsIn(PlayerPedId()), -1) == PlayerPedId() then
                                    TriggerServerEvent("ESX:stockVehicleInProperty", Property.Current.Id, Property.Current.Garage.Max, VehicleProperty, Property.Current.Id, GetLabelText(GetDisplayNameFromVehicleModel(VehicleProperty.model)), GetVehiclePedIsIn(GetPlayerPed(-1), false))
                                    Wait(5000)
                                elseif not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    OpenOwnedMenuVeh()
                                else
                                    ESX.ShowNotification("~r~Vous ne pouvez pas rentrer le véhicule.")
                                end
                            else
                                OpenOwnedMenuVeh()
                            end
                        else
                            OpenVisitMenuVeh()
                        end
                    end
                end
            end
        end
        Wait(time)
    end
end)

RegisterNetEvent("ESX:stockVehicleInProperty")
AddEventHandler("ESX:stockVehicleInProperty", function(model)
    DoScreenFadeOut(1000)
    Wait(1000)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    TriggerEvent('Persistance:removeVehicles', vehicle)
    Property:DeleteVehicle(vehicle)
    Wait(500)
    ESX.ShowNotification("Vous avez rangé votre ~b~" .. GetLabelText(GetDisplayNameFromVehicleModel(model)))
    Property:EnterGarage()
end)

RegisterNetEvent("ESX:ringProperty")
AddEventHandler("ESX:ringProperty", function(pName, target, type)
    Citizen.CreateThread(function()
        local timer = 1100
        
        ESX.ShowNotification("Quelqu'un souhaite rentrer dans votre propriété ~b~" .. pName)
        ESX.ShowNotification("Appuyez sur vos touches ~b~(Y/X)")
        while true do
            timer = timer - 1
            Wait(1)
    
            if timer <= 0 then
                TriggerServerEvent("ESX:refuseEnterProperty", pName, target)
                ESX.ShowNotification("~r~Vous avez refusé l'accès à la personne qui sonnait.")
                break
            end
    
            if IsControlJustPressed(1, 252) then
                TriggerServerEvent("ESX:refuseEnterProperty", pName, target)
                ESX.ShowNotification("~r~Vous avez refusé l'accès à la personne qui sonnait.")
                break
            end
    
            if IsControlJustPressed(1, 246) then 
                if type == "prop" then
                    TriggerServerEvent("ESX:acceptEnterProperty", pName, target, "prop")
                end
                if type == "garage" then
                    TriggerServerEvent("ESX:acceptEnterProperty", pName, target, "garage")
                end
                ESX.ShowNotification("~g~Vous avez autorisé l'accès à la personne qui sonnait.")
                break
            end
        end    
    end)
end)

RegisterNetEvent("ESX:enterRingedProperty")
AddEventHandler("ESX:enterRingedProperty", function(type)
    if not Property.IsInProperty and not Property.IsInGarage then
        if not Property.Ringed then
            return ESX.ShowNotification("~r~Erreur")
        end
        Property.Current = Property.Ringed
        DoScreenFadeOut(1000)
        Wait(1000)
        if type =="prop" then
            Property:Enter()
        end
        if type == "garage" then
            Property:EnterGarage()
        end
    end
end)

RegisterNetEvent("ESX:refreshGarage")
AddEventHandler("ESX:refreshGarage", function() 
    Property:Exit()
    Property:EnterGarage()
end)

RegisterNetEvent("ResetPropChest")
AddEventHandler("ResetPropChest", function()
    if Property.IsInProperty then
        TriggerServerEvent("ResetPropChest", "property_"..Property.Current.Id)
    end
end)

RegisterKeyMapping("MenuProperty", "Ouvrir la Gestion Propriété", "keyboard", "H")

RegisterCommand("MenuProperty", function()
    local IdPlayer = GetPlayerPed(-1)

    if Property.IsInProperty or Property.IsInGarage then
        if Property.Current.Owner == ESX.PlayerData.identifier then
            OpenHouseMenu()
        end
    end
end)

function GetIsInProperty()
    if Property.IsInProperty == nil then
        status = false
    else
        status = Property.IsInProperty
    end

    return status
end

function GetIsInGarage()
    if Property.IsInGarage == nil then
        status = false
    else
        status = Property.IsInGarage
    end
    
    return status
end

local coords = {}
local crewIdOfAttack = nil
local Pourcent = 0
local CaptureBar = nil
local inAttack = true
local IdOfProperty = nil
local inEvent = true

RegisterNetEvent("AddPourcentageCl")
AddEventHandler("AddPourcentageCl", function()
    while inAttack do
        if inEvent then
            local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(coords.x, coords.y, coords.z), true)
            if Pourcent <= 1 then
                if dist <= 10.0 then
                    Pourcent = Pourcent + 0.000010
                elseif dist >= 10.0 and dist <= 45.0 then
                    Pourcent = Pourcent + 0.0000010
                elseif dist >= 45.0 and dist <= 60.0 then
                    Pourcent = Pourcent + 0.00000010
                elseif dist >= 55.0 then
                    break
                end
                UpdateTimerBar(CaptureBar, {percentage = Pourcent})
            else
                TriggerServerEvent('WinPropertyAttack', crewIdOfAttack, IdOfProperty)
                ESX.ShowNotification("Vous avez ~g~réussi~s~ l'attaque de la ~g~propriété~s~.")
                RemoveTimerBar()
                inAttack = false
                inEvent = false
                break
            end
        end
        Wait(1)
    end
end)

RegisterNetEvent("AttackLaboCount")
AddEventHandler("AttackLaboCount", function(x, y, z, crewId, id)
    local timeRemaining = 1500000
    local addTimerBar = false
    local RealTime = GetGameTimer()
    crewIdOfAttack = crewId
    coords = {}
    CaptureBar = nil
    inAttack = true
    IdOfProperty = nil
    inEvent = true
    inAttack = true
    coords = {
        x = x,
        y = y,
        z = z
    }
    Pourcent = 0
    IdOfProperty = id
    while inAttack do
        timeRemaining = timeRemaining - 1
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(x, y, z), true) <= 60.0 then
            if not addTimerBar then
                addTimerBar = true
                CaptureBar = AddTimerBar("CAPTURE ", {percentage = Pourcent, bg = {100, 100, 100, 255}, fg = {200, 200, 200, 255}})
                local timerBar = AddTimerBar("TEMPS RESTANT ", {endTime = RealTime + timeRemaining})
                TriggerServerEvent('AddPourcentageSv', crewId)
                inEvent = true
            end
            ESX.DrawMissionText("Vous êtes entrain de capturer la zone.")
        else
            inEvent = false
            RemoveTimerBar()
            addTimerBar = false
        end

        if timeRemaining == 0 then 
            RemoveTimerBar()
            inAttack = false
        end

        if IsEntityDead(PlayerPedId()) then
            RemoveTimerBar()
            inAttack = false
        end
        Wait(1)
    end
end)

RegisterNetEvent('StopAttack')
AddEventHandler('StopAttack', function()
    inAttack = false
    RemoveTimerBar()
    HaveStartedAttack = false
end)