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

local ConcessService = {
    lastVehicle = nil,
    CurrentVehicleData = nil,

    VehicleLimit = {
        [0] = 30, --Compact
        [1] = 40, --Sedan
        [2] = 70, --SUV
        [3] = 25, --Coupes
        [4] = 30, --Muscle
        [5] = 10, --Sports Classics
        [6] = 5, --Sports
        [7] = 5, --Super
        [8] = 1, --Motorcycles
        [9] = 18, --Off-road
        [10] = 300, --Industrial
        [11] = 70, --Utility
        [12] = 100, --Vans
        [13] = 0, --Cycles
        [14] = 5, --Boats
        [15] = 20, --Helicopters
        [16] = 0, --Planes
        [17] = 40, --Service
        [18] = 40, --Emergency
        [19] = 0, --Military
        [20] = 300, --Commercial
    },

    heading = 254.5,
}

ConcessService.InMenu = false
ConcessService.menu = RageUI.CreateMenu("", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
ConcessService.subMenu = RageUI.CreateSubMenu(ConcessService.menu, "", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
ConcessService.MenuAchat = RageUI.CreateSubMenu(ConcessService.subMenu, "", "Intéraction", nil, 0, "shopui_title_ie_modgarage", "shopui_title_ie_modgarage")
ConcessService.menu:DisplayGlare(false)
ConcessService.subMenu:DisplayGlare(false)
ConcessService.MenuAchat:DisplayGlare(false)

ConcessService.subMenu.Closed = function()
    DeleteVehicle()
end

ConcessService.menu.Closed = function()
    DeleteVehicle()
    ConcessService.InMenu = false
    RageUI.Visible(ConcessService.menu, false)
end

function MenuConcessService()
    RageUI.CloseAll()
    if ConcessService.InMenu then 
        DeleteVehicle()
        ConcessService.InMenu = false
        RageUI.Visible(ConcessService.menu, false)
    else
        ConcessService.InMenu = true
        RageUI.Visible(ConcessService.menu, true)
        CreateThread(function()
            while ConcessService.InMenu do
                if lastVehicle then
                    SetEntityHeading(lastVehicle, ConcessService.heading)
                    ConcessService.heading = ConcessService.heading+0.1
                end
                RageUI.IsVisible(ConcessService.menu, function()
                    RageUI.Button("LSPD", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.LSPD
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                    RageUI.Button("LSSD", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.LSSD
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                    RageUI.Button("LSFD", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.LSFD
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                    RageUI.Button("USSS", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.USSS
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                    RageUI.Button("SERVICE", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.SERVICE
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                    RageUI.Button("Camion", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            Categorie = Config.Vehicule.CAMION
                            Wait(100)
                            RageUI.CloseAll()
                            RageUI.Visible(ConcessService.subMenu, true)
                        end
                    })
                end)
                RageUI.IsVisible(ConcessService.subMenu, function()
                    for k, v in pairs(Categorie) do
                        RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = "~g~"..v.price.."$"}, true , {
                            onActive = function()
                                Model = v.model
                                Prix = v.price
                                PrixSell = v.prix
                                Weight = v.weight/1000 or "Non défini"

                                if Model ~= CurrentVehicleData then
                                    SpawnVehicle(Model, vector3(-962.17, -1963.66, 13.19), ConcessService.heading, function(vehicle)
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
                                    RageUI.Visible(ConcessService.MenuAchat, true)
                                else
                                    ESX.ShowNotification("~b~Vous devez contacter un concessionnaire pour acheter le véhicule.")
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
                RageUI.IsVisible(ConcessService.MenuAchat, function()
                    RageUI.Button("Prix de vente ("..GetLabelText(GetDisplayNameFromVehicleModel(Model))..") - ~g~"..PrixSell.."$", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
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
                                                    if v.money >= PrixSell then
                                                        if ESX.Game.IsSpawnPointClear(vector3(-951.27, -1973.79, 13.19), 5) then
                                                            RageUI.CloseAll()
                                                            local newPlate = GeneratePlate()

                                                            ESX.Game.SpawnVehicle(Model, vector3(-951.27, -1973.79, 13.19), 45.54, function(vehicle)
                                                                SetVehicleColours(vehicle, VehicleColour)
                                                                SetVehicleColourCombination(vehicle, VehicleCombination)
                                                                SetVehicleNumberPlateText(vehicle, newPlate)
                                                                TriggerEvent("Persistance:addVehicles", vehicle)

                                                                ESX.ShowNotification('~b~Concessionnaire~s~\nVous venez d\'attribuer une [~b~'..newPlate..'~s~]')

                                                                local VehProps = ESX.Game.GetVehicleProperties(vehicle)
                                                                
                                                                TriggerServerEvent('SetVehicleJob', GetPlayerServerId(target), VehProps, newPlate, Model, PrixSell)
                                                                lastVehicle = nil
                                                            end)
                                                            ConcessService.InMenu = false
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

CreateThread(function()
    while true do
        local time = 500
        local plyCoord = GetEntityCoords(PlayerPedId())
        local distance = GetDistanceBetweenCoords(plyCoord, -956.20, -1969.20, 12.17)
        if distance < 1.4 then
            time = 1
            DisplayNotification("Appuyez sur ~INPUT_PICKUP~ pour ~b~accéder au catalogue")
            if IsControlJustPressed(0, 38) then
                MenuConcessService()
            end
        elseif distance < 8.0 then
            time = 1
            DrawMarker(25, -956.20, -1969.20, 12.17, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8, 46, 134, 193, 178, false, false, false, false)
        end
        Wait(time)
    end
end)