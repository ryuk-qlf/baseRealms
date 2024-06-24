ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

function SpawnVehicle(model, coords, heading, cb)
    if model ~= lastVehicle then
        DeleteVehicle()
        ESX.Streaming.RequestModel(model)
        local vehicle = CreateVehicle(model, coords.x, coords.y, coords.z, heading, false, true)
        SetModelAsNoLongerNeeded(vehicle)
        SetEntityAsMissionEntity(vehicle, true, false)
        SetVehRadioStation(vehicle, 'OFF')
        FreezeEntityPosition(vehicle, true)
        SetVehicleDoorsLocked(vehicle, 2)

        if cb then
            cb(vehicle)
        end
    end
end

local NumberCharset = {}
local Charset = {}

for i = 48,  57 do
    table.insert(NumberCharset, string.char(i))
end
for i = 65,  90 do
    table.insert(Charset, string.char(i))
end
for i = 97, 122 do
    table.insert(Charset, string.char(i))
end

function GeneratePlate()
	local generatedPlate = 'nil'
	local doBreak = false

	while true do
		Citizen.Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))
		if generatedPlate ~= 'nil' then
			doBreak = true
		end
		if doBreak then
			break
		end
	end
	return generatedPlate
end

function GetRandomNumber(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Citizen.Wait(0)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

local Concess = {
    lastVehicle = nil,
    CurrentVehicleData = nil,
    heading = 254.5,
}

Concess.InMenu = false
Concess.menu = RageUI.CreateMenu("", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
Concess.subMenu = RageUI.CreateSubMenu(Concess.menu, "", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
Concess.MenuAchat = RageUI.CreateSubMenu(Concess.subMenu, "", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
Concess.menu:DisplayGlare(false)
Concess.subMenu:DisplayGlare(false)
Concess.MenuAchat:DisplayGlare(false)

function DeleteVehicle()
	ESX.Game.DeleteVehicle(lastVehicle)
    CurrentVehicleData = nil
end

Concess.subMenu.Closed = function()
    DeleteVehicle()
end

Concess.menu.Closed = function()
    DeleteVehicle()
    Concess.InMenu = false
    RageUI.Visible(Concess.menu, false)
end

function MenuConcess()
    RageUI.CloseAll()
    if Concess.InMenu then 
        DeleteVehicle()
        Concess.InMenu = false
        RageUI.Visible(Concess.menu, false)
    else
        Concess.InMenu = true
        RageUI.Visible(Concess.menu, true)
        CreateThread(function()
            while Concess.InMenu do
                if lastVehicle then
                    SetEntityHeading(lastVehicle, Concess.heading)
                    Concess.heading = Concess.heading+0.1
                end
                RageUI.IsVisible(Concess.menu, function()
                    RageUI.Button("Compacts", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Compacts
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Coupes", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Coupes
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Motos", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Motos
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Muscles", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Muscles
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Offroad", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Offroad
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Sportives-Classiques", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.SportivesClassiques
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Sportives", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Sportives
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Super-Sportives", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.SuperSportives
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Vans", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Vans
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("Berlines", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.Berlines
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                    RageUI.Button("SUVs", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.SUVs
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(Concess.subMenu, true)
                        end
                    })
                end)
                RageUI.IsVisible(Concess.subMenu, function()
                    for k, v in pairs(Categorie) do
                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = "~g~"..v.price.."$"}, true , {
                            onActive = function()
                                Model = v.model
                                Prix = v.price
                                PrixSell = v.prix
                                Weight = v.weight/1000 or "Non défini"
                                if Model ~= CurrentVehicleData then
                                    SpawnVehicle(Model, vector3(-783.61, -223.58, 36.68), Concess.heading, function(vehicle)
                                        CurrentVehicleData = Model
                                        lastVehicle = vehicle
                                        VehicleColour = GetVehicleColours(lastVehicle)
                                        VehicleCombination = GetVehicleColourCombination(lastVehicle)
                                        ESX.DrawMissionText(GetLabelText(GetDisplayNameFromVehicleModel(Model)), 1200)
                                    end)
                                end
                            end,
                            onSelected = function()
                                if PlayerData.job.name == 'concess' then
                                    RageUI.Visible(Concess.MenuAchat, true)
                                else
                                    ESX.ShowNotification("~b~Vous devez contacter un concessionaire pour acheter le véhicule.")
                                end
                            end
                        })
                    end 
                end, function()
                    local vehicle = GetHashKey(Model)
                    local speed = GetVehicleModelMaxSpeed(vehicle)*3.1
                    local speed = speed/220
                    local accel = GetVehicleModelAcceleration(vehicle)*3.1
                    local accel = accel/220
                    local seats = GetVehicleModelNumberOfSeats(vehicle)
                    local braking = GetVehicleModelMaxBraking(vehicle)/2
                    local class = GetVehicleClass(lastVehicle)
                    RageUI.StatisticPanel(speed, "Vitesse maximum")
                    RageUI.StatisticPanel(accel*100, "Accélération")
                    RageUI.StatisticPanel(braking, "Freinage")
                    RageUI.BoutonPanel("Nombre de Places", seats)
                    RageUI.BoutonPanel("Stockage", math.floor(Weight).."KG")
                end) 
                RageUI.IsVisible(Concess.MenuAchat, function()
                    RageUI.Button("Prix de vente ("..GetLabelText(GetDisplayNameFromVehicleModel(Model))..") - ~g~"..PrixSell.."$", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                        end
                    })
                    RageUI.Button("Attribuer le véhicule à un joueur", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            if lastVehicle then
                                local target = GetNearbyPlayer(2)
                                if target then
                                    ESX.TriggerServerCallback('GetMoneySociety', function(Argent)
                                        for k, v in pairs(Argent) do 
                                            if v.job == PlayerData.job.name then
                                                if v.money >= PrixSell then
                                                    RageUI.CloseAll()
                                                    local newPlate = GeneratePlate()
                                                    if ESX.Game.IsSpawnPointClear(vector3(-773.48, -233.55, 36.44), 5) then
                                                        ESX.Game.SpawnVehicle(Model, vector3(-773.48, -233.55, 36.44), 206.03, function(vehicle)
                                                            SetVehicleColours(vehicle, VehicleColour)
                                                            SetVehicleColourCombination(vehicle, VehicleCombination)
                                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                                            TriggerEvent("Persistance:addVehicles", vehicle)
                                                            
                                                            ESX.ShowNotification('~b~Concessionnaire~s~\nVous venez d\'attribuer une [~b~'..newPlate..'~s~]')

                                                            local VehProps = ESX.Game.GetVehicleProperties(vehicle)

                                                            TriggerServerEvent('SetVehiclePlayer', GetPlayerServerId(target), VehProps, newPlate, Model, PrixSell)
                                                            TriggerServerEvent('addKeyVehicle', GetPlayerServerId(target), newPlate)
                                                            lastVehicle = nil
                                                        end)
                                                        Concess.InMenu = false
                                                        break
                                                    else
                                                        ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                                    end
                                                else
                                                    ESX.ShowNotification("~r~Le compte de l'entreprise à pas assez d'argent pour vendre le véhicule.")
                                                    break
                                                end
                                            end
                                        end
                                    end)
                                end
                            end
                        end   
                    })

                    RageUI.Button("Attribuer le véhicule à un crew", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            local target = GetNearbyPlayer(2)
                            if target then
                                if lastVehicle then
                                    ESX.TriggerServerCallback('GetMoneySociety', function(Argent)
                                        for k, v in pairs(Argent) do 
                                            if v.job == PlayerData.job.name then
                                                if v.money >= Prix then
                                                    if ESX.Game.IsSpawnPointClear(vector3(-773.48, -233.55, 36.44), 5) then
                                                        RageUI.CloseAll()
                                                        local newPlate = GeneratePlate()
                                                        ESX.Game.SpawnVehicle(Model, vector3(-773.48, -233.55, 36.44), 206.03, function(vehicle)
                                                            SetVehicleColours(vehicle, VehicleColour)
                                                            SetVehicleColourCombination(vehicle, VehicleCombination)
                                                            SetVehicleNumberPlateText(vehicle, newPlate)
                                                            TriggerEvent("Persistance:addVehicles", vehicle)

                                                            ESX.ShowNotification('~b~Concessionnaire~s~\nVous venez d\'attribuer une [~b~'..newPlate..'~s~]')

                                                            local VehProps = ESX.Game.GetVehicleProperties(vehicle)

                                                            TriggerServerEvent('SetVehicleCrew', GetPlayerServerId(target), VehProps, newPlate, Model, Prix)
                                                            lastVehicle = nil
                                                        end)
                                                        Concess.InMenu = false
                                                        break
                                                    else
                                                        ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                                    end
                                                else
                                                    ESX.ShowNotification("~r~Le compte de l'entreprise à pas assez d'argent pour vendre le véhicule.")
                                                    break
                                                end
                                            end
                                        end
                                    end)
                                end
                            end
                        end
                    })
                    RageUI.Button("Attribuer le véhicule à un métier", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            if lastVehicle then
                                local target = GetNearbyPlayer(2)
                                if target then
                                    if lastVehicle then
                                        ESX.TriggerServerCallback('GetMoneySociety', function(Argent)
                                            for k, v in pairs(Argent) do 
                                                if v.job == PlayerData.job.name then
                                                    if v.money >= Prix then
                                                        if ESX.Game.IsSpawnPointClear(vector3(-773.48, -233.55, 36.44), 5) then
                                                            RageUI.CloseAll()
                                                            local newPlate = GeneratePlate()
                                                            ESX.Game.SpawnVehicle(Model, vector3(-773.48, -233.55, 36.44), 206.03, function(vehicle)
                                                                SetVehicleColours(vehicle, VehicleColour)
                                                                SetVehicleColourCombination(vehicle, VehicleCombination)
                                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                                TriggerEvent("Persistance:addVehicles", vehicle)

                                                                ESX.ShowNotification('~b~Concessionnaire~s~\nVous venez d\'attribuer une [~b~'..newPlate..'~s~]')

                                                                local VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                                
                                                                TriggerServerEvent('SetVehicleJob', GetPlayerServerId(target), VehProps, newPlate, Model, Prix)
                                                                lastVehicle = nil
                                                            end)
                                                            Concess.InMenu = false
                                                            break
                                                        else
                                                            ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                                        end
                                                    else
                                                        ESX.ShowNotification("~r~Le compte de l'entreprise à pas assez d'argent pour vendre le véhicule.")
                                                        break
                                                    end
                                                end
                                            end
                                        end)
                                    end
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

Citizen.CreateThread(function()
    while true do
        local attente = 1000
        local pos = Vdist2(GetEntityCoords(PlayerPedId()), -786.48, -229.71, 37.07)

        if pos < 15.5 then 
            attente = 5
            DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~consulter le catalogue~w~.")
            if IsControlJustPressed(1, 51) then
                MenuConcess()
            end
        end
        Wait(attente)
    end
end)

function LockVehicle(vehicle)
    RequestAnimDict("anim@mp_player_intmenu@key_fob@")
    while not HasAnimDictLoaded("anim@mp_player_intmenu@key_fob@") do
        Citizen.Wait(100)
    end
    local locked = GetVehicleDoorLockStatus(vehicle)
    if locked == 1 or locked == 0 then
        SetVehicleDoorsLocked(vehicle, 2)
        PlayVehicleDoorCloseSound(vehicle, 1)
        TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false)
        ESX.Notification("Vous avez ~r~verrouillé~s~ votre véhicule.")
        SetVehicleLights(vehicle, 2)
        Wait(200)
        SetVehicleLights(vehicle, 0)
        Wait(200)
        SetVehicleLights(vehicle, 2)
        Wait(400)
        SetVehicleLights(vehicle, 0)
    elseif locked == 2 then
        SetVehicleDoorsLocked(vehicle, 1)
        PlayVehicleDoorOpenSound(vehicle, 0)
        TaskPlayAnim(GetPlayerPed(-1), "anim@mp_player_intmenu@key_fob@", "fob_click", 8.0, 8.0, -1, 48, 1, false, false, false)
        ESX.Notification("Vous avez ~g~déverrouillé~s~ votre véhicule.")
        SetVehicleLights(vehicle, 2)
        Wait(200)
        SetVehicleLights(vehicle, 0)
        Wait(200)
        SetVehicleLights(vehicle, 2)
        Wait(400)
        SetVehicleLights(vehicle, 0)
    end
end

function OpenCloseVehicle()
	local playerPed = GetPlayerPed(-1)
	local coords = GetEntityCoords(playerPed, true)
	local vehicle, distance = ESX.Game.GetClosestVehicle(coords)

    if distance < 3 then
        ESX.TriggerServerCallback('GetKeyVehicle', function(cb)
            print(cb)
            if cb then
                LockVehicle(vehicle)
            end
        end, GetVehicleNumberPlateText(vehicle))
    else
        ESX.ShowNotification("~r~Il n'y a pas de véhicule près de vous.")
    end
end

RegisterKeyMapping('+lockcar', 'Utiliser les clés de véhicule', 'keyboard', 'U')

RegisterCommand('+lockcar', function()
    OpenCloseVehicle()
end)