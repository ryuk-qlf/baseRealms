ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('UseChiffon')
AddEventHandler('UseChiffon', function()
    local playerPed	= PlayerPedId()
    local plyCoords = GetEntityCoords(playerPed)
    local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)

    if not IsPedInAnyVehicle(playerPed, false) then
        if not LookProgressBar() then
            if distance ~= -1 and distance <= 5.0 then
                TriggerServerEvent('RemoveItemMecano', 'chiffon', 1)
                RequestAnimDict("timetable@floyd@clean_kitchen@base")
                while not HasAnimDictLoaded("timetable@floyd@clean_kitchen@base") do Citizen.Wait(0) end
                TaskPlayAnim(playerPed, "timetable@floyd@clean_kitchen@base", "base", 8.0, -4.0, -1, 1, 0, 0, 0, 0);
                AddProgressBar("Nettoyage en cours", 255,201,0,255, 10000)
                Citizen.Wait(10000)
                ClearPedTasksImmediately(playerPed)
                SetVehicleDirtLevel(vehicle)
                ESX.ShowNotification("~g~Vous avez lavé le véhicule.")
            else
                ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le nettoyer.")
            end
        end
    end
end)

RegisterNetEvent('UseMoteur')
AddEventHandler('UseMoteur', function()
    local playerPed	= PlayerPedId()
    local plyCoords = GetEntityCoords(playerPed)
    local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)

    if not IsPedInAnyVehicle(playerPed, false) then
        if not LookProgressBar() then
            if distance ~= -1 and distance <= 5.0 then
                RequestAnimDict("mini@repair")
                while not HasAnimDictLoaded("mini@repair") do Citizen.Wait(0) end
                TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -4.0, -1, 1, 0, 0, 0, 0)
                AddProgressBar("Réparation en cours",90, 150, 90, 200, 20000)
                TriggerServerEvent('RemoveItemMecano', 'moteur', 1)
                SetVehicleDoorOpen(vehicle, 4, false, false)
                Citizen.Wait(20000)
                SetVehicleEngineHealth(vehicle, 1000.0)
                ClearPedTasksImmediately(playerPed)
                SetVehicleDoorShut(vehicle, 4, false, false)
                ESX.ShowNotification("~g~Vous avez fini l'installation du kit moteur.")
            else
                ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le réparer.")
            end
        else
            ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
        end
    end
end)

RegisterNetEvent('UseCarrosserie')
AddEventHandler('UseCarrosserie', function()
    local playerPed	= PlayerPedId()
    local plyCoords = GetEntityCoords(playerPed)
    local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)

    if not IsPedInAnyVehicle(playerPed, false) then
        if not LookProgressBar() then
            if distance ~= -1 and distance <= 5.0 then
                SetEntityHeading(playerPed, GetEntityHeading(playerPed)-180.0)
                TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_VEHICLE_MECHANIC", 0, false)
                AddProgressBar("Réparation en cours", 0, 151, 255, 200, 20000)
                TriggerServerEvent('RemoveItemMecano', 'carrosserie', 1)
                Citizen.Wait(20000)
                local levelmoteur = GetVehicleEngineHealth(vehicle)
                ClearPedTasksImmediately(playerPed)
                SetVehicleFixed(vehicle)
                SetVehicleEngineHealth(vehicle, levelmoteur)
                SetVehicleEngineOn(vehicle, true, false)
                SetVehicleBodyHealth(vehicle, 1000.0)
                ESX.ShowNotification("~g~Vous avez fini l'installation du kit carrosserie.")
            else
                ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le réparer.")
            end
        else
            ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
        end
    end
end)

RegisterNetEvent('UseLockpick')
AddEventHandler('UseLockpick', function()
    local playerPed	= PlayerPedId()
    local plyCoords = GetEntityCoords(playerPed)
    local vehicle = GetClosestVehicle(plyCoords.x, plyCoords.y, plyCoords.z, 3.0, 0, 71)

    if IsAnyVehicleNearPoint(plyCoords.x, plyCoords.y, plyCoords.z, 3.0) then
        if not LookProgressBar() then
            RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
            while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
                Citizen.Wait(0)
            end
            TaskPlayAnim(playerPed, 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@' , 'machinic_loop_mechandplayer', 8.0, -4.0, -1, 1, 0, 0, 0, 0)
            
            AddProgressBar("Crochetage en cours", 0, 151, 255, 200, 20000)
            Citizen.Wait(20000)
            TriggerServerEvent('RemoveItemMecano', 'lockpick', 1)
            if math.random(1, 4) == 1 then
                SetVehicleAlarm(vehicle, true)
                SetVehicleAlarmTimeLeft(vehicle, 15 * 1000)
                SetVehicleDoorsLocked(vehicle, 1)
                SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                ClearPedTasksImmediately(playerPed)
                ESX.ShowNotification("Vous avez ~g~déverrouillé~w~ le véhicule.")
            else
                ESX.ShowNotification("~r~Vous avez pas reussi le crochetage.")
                ClearPedTasksImmediately(playerPed)
            end
        else
            ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
        end
    else
        ESX.ShowNotification("~r~Rapprochez vous d'un véhicule.")
    end
end)

----------

local Fourriere = {
    GetAllCrew = {},
    VehicleCrew = {},
    GetAllJobs = {},
    GetVehicleJob = {},
    VehicleCivil = {},
    GetAllCivils = {},
    GetCrewPly = {},
}

Fourriere.OpenedMenu = false
Fourriere.menu = RageUI.CreateMenu(" ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu2 = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu3 = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu4 = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu5 = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Fourriere.subMenu6 = RageUI.CreateSubMenu(Fourriere.menu, " ", "Fourrière", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")

Fourriere.menu:DisplayGlare(false)
Fourriere.subMenu:DisplayGlare(false)
Fourriere.subMenu2:DisplayGlare(false)
Fourriere.subMenu3:DisplayGlare(false)
Fourriere.subMenu4:DisplayGlare(false)
Fourriere.subMenu5:DisplayGlare(false)
Fourriere.subMenu6:DisplayGlare(false)
Fourriere.subMenu:AcceptFilter(true)
Fourriere.subMenu2:AcceptFilter(true)
Fourriere.subMenu3:AcceptFilter(true)

Fourriere.menu.Closed = function()
    Fourriere.OpenedMenu = false
    RageUI.Visible(Fourriere.menu, false)
end

function MenuFourriere(PositionSpawnVeh, HeadingSpawnVeh, JobMecano)
    if Fourriere.OpenedMenu then
        Fourriere.OpenedMenu = false
        RageUI.Visible(Fourriere.menu, false)
    else
        Fourriere.OpenedMenu = true
        RageUI.Visible(Fourriere.menu, true)
        resultFiltre = nil
        CreateThread(function()
            while Fourriere.OpenedMenu do
                RageUI.IsVisible(Fourriere.menu, function()
                    RageUI.Button("Crew", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('GetCrewList', function(cb)
                                Fourriere.GetAllCrew = cb
                            end)
                            Wait(50)
                            resultFiltre = nil
                            RageUI.CloseAll()
                            RageUI.Visible(Fourriere.subMenu, true)
                        end
                    })
                    RageUI.Button("Métiers", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback('GetJobsList', function(cb)
                                Fourriere.GetAllJobs = cb
                            end)
                            Wait(50)
                            resultFiltre = nil
                            RageUI.CloseAll()
                            RageUI.Visible(Fourriere.subMenu2, true)
                        end
                    })
                    RageUI.Button("Civils", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            ESX.TriggerServerCallback("GetAllPlayers", function(cb)
                                Fourriere.GetAllCivils = cb
                            end)
                            Wait(50)
                            resultFiltre = nil
                            RageUI.CloseAll()
                            RageUI.Visible(Fourriere.subMenu3, true)
                        end
                    })
                end)
                RageUI.IsVisible(Fourriere.subMenu, function()
                    for k, v in pairs(Fourriere.GetAllCrew) do
                        RageUI.Button(v.name, nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                RageUI.ResetFiltre()
                                CrewID = v.id_crew
                                ESX.TriggerServerCallback('GetVehicleCrew', function(cb)
                                    Fourriere.VehicleCrew = cb
                                end, CrewID)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Fourriere.subMenu4, true)
                            end
                        })
                    end
                end)
                RageUI.IsVisible(Fourriere.subMenu2, function()
                    for k, v in pairs(Fourriere.GetAllJobs) do
                        RageUI.Button(v.label, nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                RageUI.ResetFiltre()
                                JobName = v.name
                                ESX.TriggerServerCallback('GetVehicleJobs', function(cb)
                                    Fourriere.GetVehicleJob = cb
                                end, JobName)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Fourriere.subMenu5, true)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(Fourriere.subMenu3, function()
                    for k, v in pairs(Fourriere.GetAllCivils) do
                        RageUI.Button(v.name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                IdPly = v.id
                                ESX.TriggerServerCallback('GetVehicleCivils', function(cb)
                                    Fourriere.VehicleCivil = cb
                                end, IdPly)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Fourriere.subMenu6, true)
                            end
                        })
                    end
                end)

                RageUI.IsVisible(Fourriere.subMenu6, function()
                    if #Fourriere.VehicleCivil >= 1 then
                        for k, v in pairs(Fourriere.VehicleCivil) do
                            if v.pound == 1 then
                                if PlayerData.job and PlayerData.job.name == JobMecano then
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                        onSelected = function()
                                            if ESX.Game.IsSpawnPointClear(PositionSpawnVeh, 5) then
                                                ESX.Game.SpawnVehicle(v.model, PositionSpawnVeh, HeadingSpawnVeh, function(vehicle)
                                                    ESX.Game.SetVehicleProperties(vehicle, json.decode(v.custom))
                                                    SetVehicleNumberPlateText(vehicle, v.plate)
                                                    TriggerEvent("Persistance:addVehicles", vehicle)
                                                end)
                                                ESX.ShowNotification("Vous avez sortie le véhicule ~g~"..GetLabelText(GetDisplayNameFromVehicleModel(v.model)).."~s~ de la fourrière.")
                                                TriggerServerEvent('UpdateFourriereCivils', v.plate)
                                                RageUI.CloseAll()
                                                Fourriere.OpenedMenu = false
                                            else
                                                ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                            end
                                        end
                                    })
                                else
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {}, true, {
                                        onSelected = function()     
                                            ESX.ShowNotification('~r~Vous devez contacter un mécano pour sortir le véhicule.')
                                        end
                                    })
                                end
                            end
                        end
                    end
                end)

                RageUI.IsVisible(Fourriere.subMenu4, function()
                    if #Fourriere.VehicleCrew >= 1 then
                        for k, v in pairs(Fourriere.VehicleCrew) do
                            if v.pound == 1 then
                                if PlayerData.job and PlayerData.job.name == JobMecano then
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                        onSelected = function()
                                            local Target, TargetDist = ESX.Game.GetClosestPlayer()
                                            if TargetDist ~= -1 and TargetDist <= 3 then
                                                ESX.TriggerServerCallback("GetPlyCrew", function(result)
                                                    if result.id_crew ~= nil then
                                                        if result.id_crew == CrewID then
                                                            if ESX.Game.IsSpawnPointClear(PositionSpawnVeh, 5) then
                                                                ESX.Game.SpawnVehicle(v.model, PositionSpawnVeh, HeadingSpawnVeh, function(vehicle)
                                                                    ESX.Game.SetVehicleProperties(vehicle, json.decode(v.custom))
                                                                    SetVehicleNumberPlateText(vehicle, v.plate)
                                                                    TriggerEvent("Persistance:addVehicles", vehicle)
                                                                end)
                                                                ESX.ShowNotification("Vous avez sortie le véhicule ~g~"..GetLabelText(GetDisplayNameFromVehicleModel(v.model)).."~s~ de la fourrière.")
                                                                TriggerServerEvent('UpdateFourriereCrew', v.plate)
                                                                RageUI.CloseAll()
                                                                Fourriere.OpenedMenu = false
                                                            else
                                                                ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                                            end
                                                        else
                                                            ESX.ShowNotification("~r~Le crew de la personne ne correspond pas.")
                                                        end
                                                    end
                                                end, GetPlayerServerId(Target))
                                            else
                                                ESX.ShowNotification('~r~Auncun joueur à proximité de vous.')
                                            end                  
                                        end
                                    })
                                else
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {}, true, {
                                        onSelected = function()     
                                            ESX.ShowNotification('~r~Vous devez contacter un mécano pour sortir le véhicule.')
                                        end
                                    })
                                end
                            end
                        end
                    end
                end)

                RageUI.IsVisible(Fourriere.subMenu5, function()
                    if #Fourriere.GetVehicleJob >= 1 then
                        for k, v in pairs(Fourriere.GetVehicleJob) do
                            if v.pound == 1 then
                                if PlayerData.job and PlayerData.job.name == JobMecano then
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {RightLabel = v.plate}, true, {
                                        onSelected = function()
                                            if PlayerData.job and PlayerData.job.name == JobMecano then
                                                local Target, TargetDist = ESX.Game.GetClosestPlayer()
                                                if TargetDist ~= -1 and TargetDist <= 3 then
                                                    ESX.TriggerServerCallback("FourriereGetPlyJob", function(result)
                                                        if result then
                                                            if result ~= nil then
                                                                if result == JobName then
                                                                    if ESX.Game.IsSpawnPointClear(PositionSpawnVeh, 5) then
                                                                        ESX.Game.SpawnVehicle(v.model, PositionSpawnVeh, HeadingSpawnVeh, function(vehicle)
                                                                            ESX.Game.SetVehicleProperties(vehicle, json.decode(v.custom))
                                                                            SetVehicleNumberPlateText(vehicle, v.plate)
                                                                            TriggerEvent("Persistance:addVehicles", vehicle)
                                                                        end)
                                                                        ESX.ShowNotification("Vous avez sortie le véhicule ~g~"..GetLabelText(GetDisplayNameFromVehicleModel(v.model)).."~s~ de la fourrière.")
                                                                        TriggerServerEvent('UpdateFourriereJobs', v.plate)
                                                                        RageUI.CloseAll()
                                                                        Fourriere.OpenedMenu = false
                                                                    else
                                                                        ESX.ShowNotification("~r~Impossible il y a un vehicule sur la position de sortie.")
                                                                    end
                                                                else
                                                                    ESX.ShowNotification("~r~Le métier de la personne ne correspond pas.")
                                                                end
                                                            end
                                                        else
                                                            ESX.ShowNotification("~r~La personne n'appartient à aucun métier.")
                                                        end
                                                    end, GetPlayerServerId(Target))
                                                else
                                                    ESX.ShowNotification('~r~Auncun joueur à proximité de vous.')
                                                end  
                                            else
                                                ESX.ShowNotification('~r~Vous devez contacter un mécano pour sortir le véhicule.')
                                            end                    
                                        end
                                    })
                                else
                                    RageUI.Button(GetLabelText(GetDisplayNameFromVehicleModel(v.model)), nil, {}, true, {
                                        onSelected = function()     
                                            ESX.ShowNotification('~r~Vous devez contacter un mécano pour sortir le véhicule.')
                                        end
                                    })
                                end
                            end
                        end
                    end
                end)
                Wait(1)
            end
        end)
    end
end

local PositionFourriere = {
	{pos = vector3(115.01, 277.52, 109.0), spawn = vector3(115.29, 281.37, 109.68), heading = 68.77, job = "mayansmotors"},
    {pos = vector3(-190.68, -1290.18, 30.30), spawn = vector3(-189.52, -1284.42, 30.95), heading = 270.07, job = "bennys"},
    {pos = vector3(25.11, 6439.89, 30.45), spawn = vector3(29.83, 6435.03, 31.36), heading = 68.77, job = "grimmotors"},
    {pos = vector3(1169.01, 2639.64, 36.79), spawn = vector3(1164.74, 2639.02, 37.95), heading = 270.07, job = "harmonyrepair"},
    {pos = vector3(-3.35, -1398.84, 28.29), spawn = vector3(5.05, -1405.51, 28.61), heading = 88.52, job = "fdmotors"},
    {pos = vector3(4973.73, -5107.62, 2.14), spawn = vector3(4971.20, -5115.38, 3.09), heading = 155.19, job = "cayom"},
    {pos = vector3(-358.28, -109.14, 37.69), spawn = vector3(-356.02, -115.81, 38.08), heading = 161.37, job = "lscustoms"},
    {pos = vector3(1984.24, 3786.28, 31.18), spawn = vector3(1982.46, 3783.50, 31.57), heading = 209.08, job = "sandybennys"},
}

Citizen.CreateThread(function()
    while true do 
        local wait = 1000
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            for k, v in pairs(PositionFourriere) do 
                local dist = Vdist(GetEntityCoords(PlayerPedId()), v.pos)

                if dist <= 15 then
                    wait = 5
                    DrawMarker(25, v.pos, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.3, 1.3, 1.3, 46, 134, 193, 178, false, false, false, false)
                end
                if dist <= 3 then 
                    wait = 5
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accédez a la fourrière~s~.")
                    if IsControlJustPressed(0, 51) then
                        MenuFourriere(v.spawn, v.heading, v.job)
                    end
                end
            end 
        end
        Wait(wait)
    end
end)

RegisterNetEvent('AddVehicleInPound')
AddEventHandler('AddVehicleInPound', function()
    local coords = GetEntityCoords(PlayerPedId())
    local vehicle, distance = ESX.Game.GetClosestVehicle(coords)
    local plate = GetVehicleNumberPlateText(vehicle)

    if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
        if distance < 3 then
            TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
            AddProgressBar("Mise en fourrière", 90, 150, 90, 200, 8600)
            Wait(8600)
            ESX.Game.DeleteVehicle(vehicle)
            ClearPedTasksImmediately(PlayerPedId())
            TriggerServerEvent("GetPlateVehicleInPound", plate, 1)
        else
            ESX.ShowNotification("~r~Il n'y a pas de véhicule près de vous.")
        end
    end
end)

local Mecano = {}

Mecano.OpenedMenu = false
Mecano.mainMenu = RageUI.CreateMenu(" ", "Mécano", nil, 100, "shopui_title_carmod2", "shopui_title_carmod2")
Mecano.mainMenu:DisplayGlare(false)

Mecano.mainMenu.Closed = function()
    Mecano.OpenedMenu = false
    RageUI.Visible(Mecano.mainMenu, false)
end

function MenuMecano(notif)
    if Mecano.OpenedMenu then
        Mecano.OpenedMenu = false
        RageUI.Visible(Mecano.mainMenu, false)
    else
        Mecano.OpenedMenu = true
        RageUI.Visible(Mecano.mainMenu, true)
        resultFiltre = nil
        CreateThread(function()
            while Mecano.OpenedMenu do
                if PlayerData.job and PlayerData.job.name == "mayansmotors" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(113.26, 290.65, 109.97), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "harmonyrepair" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1176.50, 2659.25, 38.02), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "fdmotors" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-3.35, -1398.84, 28.29), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "cayom" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(4959.18, -5114.25, 2.89), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "lscustoms" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-358.28, -109.14, 37.69), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "sandybennys" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1984.24, 3786.28, 31.18), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                elseif PlayerData.job and PlayerData.job.name == "grimmotors" then
                    if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(29.83, 6435.03, 31.36), true) > 50 then
                        Mecano.OpenedMenu = false
                        RageUI.Visible(Mecano.mainMenu, false)
                        ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
                    end
                end
                RageUI.IsVisible(Mecano.mainMenu, function()
                    RageUI.Button("Réparer le moteur", nil, {}, true, {
                        onSelected = function()
                            local playerPed	= PlayerPedId()
                            local plyCoords = GetEntityCoords(playerPed)
                            local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)
                        
                            if not IsPedInAnyVehicle(playerPed, false) then
                                if not LookProgressBar() then
                                    if distance ~= -1 and distance <= 5.0 then
                                        RequestAnimDict("mini@repair")
                                        while not HasAnimDictLoaded("mini@repair") do Citizen.Wait(0) end
                                        TaskPlayAnim(playerPed, "mini@repair", "fixing_a_ped", 8.0, -4.0, -1, 1, 0, 0, 0, 0)
                                        AddProgressBar("Réparation en cours",90, 150, 90, 200, 20000)
                                        SetVehicleDoorOpen(vehicle, 4, false, false)
                                        Citizen.Wait(20000)
                                        SetVehicleEngineHealth(vehicle, 1000.0)
                                        ClearPedTasksImmediately(playerPed)
                                        SetVehicleDoorShut(vehicle, 4, false, false)
                                        ESX.ShowNotification("~g~Vous avez fini l'installation du kit moteur.")
                                    else
                                        ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le réparer.")
                                    end
                                else
                                    ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
                                end
                            end
                        end
                    })
                    RageUI.Button("Réparer la carrosserie", nil, {}, true, {
                        onSelected = function()
                            local playerPed	= PlayerPedId()
                            local plyCoords = GetEntityCoords(playerPed)
                            local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)
                        
                            if not IsPedInAnyVehicle(playerPed, false) then
                                if not LookProgressBar() then
                                    if distance ~= -1 and distance <= 5.0 then
                                        SetEntityHeading(playerPed, GetEntityHeading(playerPed)-180.0)
                                        TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_VEHICLE_MECHANIC", 0, false)
                                        AddProgressBar("Réparation en cours", 0, 151, 255, 200, 20000)
                                        Citizen.Wait(20000)
                                        local levelmoteur = GetVehicleEngineHealth(vehicle)
                                        ClearPedTasksImmediately(playerPed)
                                        SetVehicleFixed(vehicle)
                                        SetVehicleEngineHealth(vehicle, levelmoteur)
                                        SetVehicleEngineOn(vehicle, true, false)
                                        SetVehicleBodyHealth(vehicle, 1000.0)
                                        ESX.ShowNotification("~g~Vous avez fini l'installation du kit carrosserie.")
                                    else
                                        ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le réparer.")
                                    end
                                else
                                    ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
                                end
                            end
                        end
                    })
                    RageUI.Button("Nettoyer le véhicule", nil, {}, true, {
                        onSelected = function()
                            local playerPed	= PlayerPedId()
                            local plyCoords = GetEntityCoords(playerPed)
                            local vehicle, distance = ESX.Game.GetClosestVehicle(plyCoords)
                        
                            if not IsPedInAnyVehicle(playerPed, false) then
                                if not LookProgressBar() then
                                    if distance ~= -1 and distance <= 5.0 then
                                        RequestAnimDict("timetable@floyd@clean_kitchen@base")
                                        while not HasAnimDictLoaded("timetable@floyd@clean_kitchen@base") do Citizen.Wait(0) end
                                        TaskPlayAnim(playerPed, "timetable@floyd@clean_kitchen@base", "base", 8.0, -4.0, -1, 1, 0, 0, 0, 0);
                                        AddProgressBar("Nettoyage en cours", 255,201,0,255, 10000)
                                        Citizen.Wait(10000)
                                        ClearPedTasksImmediately(playerPed)
                                        SetVehicleDirtLevel(vehicle)
                                        ESX.ShowNotification("~g~Vous avez lavé le véhicule.")
                                    else
                                        ESX.ShowNotification("~r~Vous devez être proche d'un véhicule pour le nettoyer.")
                                    end
                                end
                            end
                        end
                    })
                    RageUI.Button("Mettre le véhicule en fourrière", nil, {}, true, {
                        onSelected = function()
                            TriggerEvent('AddVehicleInPound')
                        end
                    })
                    RageUI.Button("Annonce", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local input = ESX.KeyboardInput("Annonce", 50)
                            if input ~= nil and #input > 5 then
                                TriggerServerEvent("annonceMec", input)
                            else 
                                ESX.ShowNotification("~r~Vous devez insérer plus de caractères~w~ (~o~5mininum~w~)~r~.")
                            end
                        end
                    })
                end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent('MenuRepaMecano')
AddEventHandler('MenuRepaMecano', function()
    if PlayerData.job and PlayerData.job.name == "mayansmotors" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(113.26, 290.65, 109.97), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "harmonyrepair" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1176.50, 2659.25, 38.02), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "fdmotors" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-3.35, -1398.84, 28.29), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "cayom" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(4959.18, -5114.25, 2.89), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "lscustoms" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-358.28, -109.14, 37.69), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "sandybennys" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1984.24, 3786.28, 31.18), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "grimmotors" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(29.83, 6435.03, 31.36), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    elseif PlayerData.job and PlayerData.job.name == "bennys" then
        if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(-212.11, -1323.61, 30.89), true) < 50 then
            MenuMecano()
        else
            ESX.ShowNotification("~r~Vous devez être dans la zone de votre entreprise.")
        end
    end
end)