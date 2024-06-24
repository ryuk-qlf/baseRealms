ESX = nil

local Police = {
    ObjectListingIndex = 1,
    HistoriqueCall = {},
}
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

RegisterNetEvent("AnimMenotte")
AddEventHandler("AnimMenotte", function()
    RequestAnimDict('mp_arrest_paired') 
    while not HasAnimDictLoaded('mp_arrest_paired') do 
        Citizen.Wait(50)
    end
    TaskPlayAnim(GetPlayerPed(-1), 'mp_arrest_paired', 'cop_p2_back_right', 8.0, -8, 3750, 2, 0, 0, 0, 0)
end)

RegisterNetEvent("MenotterPlayer")
AddEventHandler("MenotterPlayer", function()
    local Target = GetNearbyPlayer(2)
    if Target then
        TriggerServerEvent("MenotterPly", GetPlayerServerId(Target))
    end
end)

RegisterNetEvent("HandCuffUse")
AddEventHandler("HandCuffUse", function(author)
    IsHandcuffed = not IsHandcuffed
	playerPed = PlayerPedId()

    if IsHandcuffed then
        TriggerServerEvent("AnimMenotte", author)
        Citizen.Wait(2500)
        RequestAnimDict('mp_arresting')
        while not HasAnimDictLoaded('mp_arresting') do
            Citizen.Wait(100)
        end
        TaskPlayAnim(playerPed, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)

        SetEnableHandcuffs(playerPed, true)
        DisablePlayerFiring(playerPed, true)
        SetCurrentPedWeapon(playerPed, GetHashKey('WEAPON_UNARMED'), true)
        SetPedCanPlayGestureAnims(playerPed, false)

        local plyCoords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
        HandCuffObj = CreateObject(GetHashKey("p_cs_cuffs_02_s"), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        AttachEntityToEntity(HandCuffObj, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), -0.04, 0.06, 0.02, -90.0, -25.0, 80.0, 1, 0, 0, 0, 0, 1)

        while IsHandcuffed do
            DisableControlAction(0, 24, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack 2
            DisableControlAction(0, 25, true) -- Aim
            DisableControlAction(0, 263, true) -- Melee Attack 1
            DisableControlAction(0, 45, true) -- Reload
            DisableControlAction(0, 140, true)
            if not IsEntityPlayingAnim(PlayerPedId(), 'mp_arresting', 'idle', 3) then
                TaskPlayAnim(PlayerPedId(), 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
            end
            Wait(5)
        end
    else
        DeleteEntity(HandCuffObj)
        ClearPedSecondaryTask(playerPed)
        SetEnableHandcuffs(playerPed, false)
        DisablePlayerFiring(playerPed, false)
        SetPedCanPlayGestureAnims(playerPed, true)
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
        local closestDistance = -1
        local object = GetClosestObjectOfType(coords, 3.0, GetHashKey("p_ld_stinger_s"), false, false, false)

        if DoesEntityExist(object) then
            local objCoords = GetEntityCoords(object)

            if GetDistanceBetweenCoords(coords, objCoords, true) <= 1.5 then 
                local playerPed = PlayerPedId()
                if GetEntityModel(object) == GetHashKey('p_ld_stinger_s') then
                    local playerPed = PlayerPedId()
                    local coords = GetEntityCoords(playerPed)

                    if IsPedInAnyVehicle(playerPed, false) then
                    local vehicle = GetVehiclePedIsIn(playerPed)
                        if GetTyreHealth(vehicle) ~= 0 then
                            for i = 0, 7, 1 do
                                SetVehicleTyreBurst(vehicle, i, true, 1000)
                            end
                        end
                    end
                end
            end
        end
	end
end)

Police.openedMenu = false 
Police.mainMenu = RageUI.CreateMenu("Police", "Police")
Police.subMenuRenfort = RageUI.CreateSubMenu(Police.mainMenu, "Renfort", "Renfort")
Police.subMenuCivil = RageUI.CreateSubMenu(Police.mainMenu, "Civil", "Civil")
Police.subMenuVehicle = RageUI.CreateSubMenu(Police.mainMenu, "Véhicule", "Véhicule")
Police.subMenuPoint = RageUI.CreateSubMenu(Police.subMenuCivil, "Permis", "Permis")
Police.subMenuHistorique = RageUI.CreateSubMenu(Police.mainMenu, "Renfort", "Renfort")
Police.mainMenu.Closed = function()
    Police.openedMenu = false 
end

function openPolice()
    if Police.openedMenu then
        Police.openedMenu = false
        RageUI.Visible(Police.mainMenu, false)
    else
        Police.openedMenu = true
        RageUI.Visible(Police.mainMenu, true)
            CreateThread(function()
                while Police.openedMenu do
                    RageUI.IsVisible(Police.mainMenu, function()
                        Police.mainMenu:SetTitle(PlayerData.job.label)
                        Police.mainMenu:SetSubtitle(PlayerData.job.label)
                        if PlayerData.job.grade_name == "sergent" or PlayerData.job.grade_name == "sergentt" or PlayerData.job.grade_name == "lieutenant" or PlayerData.job.grade_name == "boss" then
                            RageUI.Button("Annonce", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("Annonce", 50)
                                    if input ~= nil and #input > 5 then
                                        TriggerServerEvent("AnnoncePolice", input)
                                    end
                                end
                            })
                        end
                        RageUI.Button("Demande de renforts", nil, {RightLabel = "→"}, true, {}, Police.subMenuRenfort)
                        RageUI.Button("Historique des appel", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('HistoriqueCall', function(cb)
                                    Police.HistoriqueCall = cb
                                end, PlayerData.job.name)
                                Wait(550)
                                RageUI.CloseAll()
                                RageUI.Visible(Police.subMenuHistorique, true)
                            end
                        })
                        RageUI.Button("Gestion Civil", nil, {RightLabel = "→"}, true, {}, Police.subMenuCivil)
                        RageUI.Button("Gestion Véhicule", nil, {RightLabel = "→"}, true, {}, Police.subMenuVehicle)
                        RageUI.Button("Annuler l'appel", nil, {}, true, {
                            onSelected = function()
                                ExecuteCommand("annulerappel")

                                if Police.blip then
                                    RemoveBlip(Police.blip)
                                    Police.blip = nil
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Police.subMenuCivil, function()
                        if PlayerData.job.name == 'police' then
                            RageUI.Button("Voir les points de la personne", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                    if target then 
                                        TriggerServerEvent("pointPly", GetPlayerServerId(target))
                                    end
                                end
                            })
                            --RageUI.Button("Retirer des points sur le permis", nil, {RightLabel = "→"}, true, {}, Police.subMenuPoint)
                        end
                        RageUI.Button("Réanimer un individu", nil, {}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('JobInService', function(count)
                                    if count <= 1 then
                                        local target = GetNearbyPlayer(2)

                                        if target then
                                            if GetEntityHealth(GetPlayerPed(target)) <= 125 then
                                                RageUI.CloseAll()
                                                Police.openedMenu = false
                                                ESX.Streaming.RequestAnimDict("missheistfbi3b_ig8_2")
                                                TaskPlayAnim(PlayerPedId(), "missheistfbi3b_ig8_2", "cpr_loop_paramedic", 8.0, 8.0, -1, 0, 1, 0, 0, 0)
                                                AddProgressBar("Réanimation en cours", 90, 150, 90, 200, 8000)
                                                Wait(8000)
                                                TriggerServerEvent('ReanimationPlayerComa', GetPlayerServerId(target))
                                                ClearPedTasks(PlayerPedId())
                                            else
                                                ESX.ShowNotification("~r~Impossible la personne n'est pas inconsciente.")
                                            end
                                        end
                                    else
                                        ESX.ShowNotification("~r~Impossible un médecin est en service.")
                                    end
                             end, 'ems')
                         end
                        })
                    end)
                    RageUI.IsVisible(Police.subMenuPoint, function()
                        RageUI.Button("Permis voiture", nil, {}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                                if target then 
                                    input = ESX.KeyboardInput("", 2)
                                    if input ~= nil and tonumber(input) then
                                        TriggerServerEvent("withrowPoint", "pointCar", input, GetPlayerServerId(target))
                                    end
                                end
                            end
                        })
                        RageUI.Button("Permis moto", nil, {}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                                if target then 
                                    input = ESX.KeyboardInput("", 2)
                                    if input ~= nil and tonumber(input) then
                                        TriggerServerEvent("withrowPoint", "pointMoto", input, GetPlayerServerId(target))
                                    end
                                end
                            end
                        })
                        RageUI.Button("Permis camion", nil, {}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                                if target then 
                                    input = ESX.KeyboardInput("", 2)
                                    if input ~= nil and tonumber(input) then
                                        TriggerServerEvent("withrowPoint", "pointCamion", input, GetPlayerServerId(target))
                                    end
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Police.subMenuVehicle, function()
                        RageUI.Button("Mettre en fourrière", nil, {}, true, {
                            onSelected = function()
                                TriggerEvent('AddVehicleInPound')
                            end
                        })
                        RageUI.Button("Crocheter un véhicule", nil, {}, true, {
                            onSelected = function()
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

                                        SetVehicleAlarm(vehicle, true)
                                        SetVehicleAlarmTimeLeft(vehicle, 15 * 1000)
                                        SetVehicleDoorsLocked(vehicle, 1)
                                        SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                        ClearPedTasksImmediately(playerPed)
                                        ESX.ShowNotification("Vous avez ~g~déverrouillé~w~ le véhicule.")

                                    else
                                        ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
                                    end
                                else
                                    ESX.ShowNotification("~r~Rapprochez vous d'un véhicule.")
                                end
                            end
                        })
                        RageUI.Button("Verifier le propriétaire d'un véhicule", nil, {}, true, {
                            onSelected = function()
                                local index = ESX.KeyboardInput("Plaque du véhicule", 30)
                                if index ~= nil and #index > 3 then
                                    TriggerServerEvent("GetOwnerPlate", index)
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Police.subMenuRenfort, function()
                        RageUI.Button("Demande de renforts", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("call:makeCallSpecial", PlayerData.job.name, GetEntityCoords(GetPlayerPed(-1)),"Demande de renfort")
                                ExecuteCommand("me demande des renforts")
                            end
                        })
                        RageUI.Button("Code 99", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("call:makeCallSpecial", PlayerData.job.name, GetEntityCoords(GetPlayerPed(-1)), "~r~Code 99~s~", "code99")
                                ExecuteCommand("me demande des renforts")
                            end
                        })
                    end)
                    RageUI.IsVisible(Police.subMenuHistorique, function()
                        for k, v in pairs(Police.HistoriqueCall) do
                            RageUI.Button(v.message, nil, {}, true, {
                                onSelected = function()
                                    if v.pos ~= nil then
                                        if Police.blip then
                                            RemoveBlip(Police.blip)
                                            Police.blip = nil
                                        end
                                        Police.posBlips = vector3(v.pos.x, v.pos.y, v.pos.z)
                                        Police.blip = AddBlipForCoord(Police.posBlips)
                                        SetBlipRoute(Police.blip, true)

                                        Citizen.CreateThread(function()
                                            while Police.blip ~= nil do
                                                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), Police.posBlips, false) < 20 then
                                                    RemoveBlip(Police.blip)
                                                    Police.blip = nil
                                                end
                                                Citizen.Wait(1000)
                                            end
                                        end)
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

RegisterNetEvent("policeMenu")
AddEventHandler("policeMenu", function()
    openPolice()
end)


local pos = {
    {x= -1096.64, y = -849.99, z = 38.24, name = "6ème étage"},
    {x= -1096.64, y = -849.99, z = 34.37, name = "5ème étage"},
    {x= -1096.64, y = -849.99, z = 30.76, name = "4ème étage"},
    {x= -1096.64, y = -849.99, z = 26.82, name = "3ème étage"},
    {x= -1096.64, y = -849.99, z = 23.04, name = "2ème étage"},
    {x= -1096.64, y = -849.99, z = 19.0, name = "1er étage"},
    {x= -1096.64, y = -849.99, z = 13.69, name = "-3"},
    {x= -1096.64, y = -849.99, z = 10.27, name = "-2"},
    {x= -1096.64, y = -849.99, z = 4.88, name = "-1"}
}

Police.openedMenuA = false 
Police.mainAscenseur = RageUI.CreateMenu("Ascenseur", "Vespucci")
Police.mainAscenseur.Closed = function()
    Police.openedMenuA = false
    RageUI.Visible(Police.mainAscenseur, false)
end

function OpenMenuAscenseurPolice()
    if Police.openedMenuA then
        Police.openedMenuA = false
        RageUI.Visible(Police.mainAscenseur, false)
    else
        Police.openedMenuA = true
        RageUI.Visible(Police.mainAscenseur, true)
            CreateThread(function()
                while Police.openedMenuA do
                    RageUI.IsVisible(Police.mainAscenseur, function()
                        for k,v in pairs(pos) do
                            RageUI.Button(v.name, nil, {}, true, {
                                onSelected = function()
                                    DoScreenFadeOut(1000)
                                    Wait(1000)
                                    FreezeEntityPosition(PlayerPedId(), true)
                                    tp(v.x, v.y, v.z)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                    Wait(900)
                                    DoScreenFadeIn(1000)
                                    ESX.DrawMissionText("~g~Vous êtes arrivé", 1000)
                                end
                            })
                        end
                    end)   
                Wait(1)
            end
        end)
    end
end

function tp(x,y,z)
	SetEntityCoords(PlayerPedId(), x, y, z - 0.9)
end

Citizen.CreateThread(function ()
    while true do
        local time = 1000
        for k, v in pairs(pos) do
            local plyCoords = GetEntityCoords(PlayerPedId(), false)
            local coords = vector3(v.x, v.y, v.z)
            local dist = GetDistanceBetweenCoords(plyCoords, coords, true)

            if dist <= 1.5 then
                time = 5
                DisplayNotification("Appuyer sur ~INPUT_TALK~ pour choisir votre ~b~étage~s~.")
                if IsControlJustPressed(1, 51) then
                    OpenMenuAscenseurPolice()
                end
            end   
        end 
        Wait(time)
    end
end)

local items = {
    {Label = "Barrière", Id = "prop_barrier_work05", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Herse", Id = "p_ld_stinger_s", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Cône", Id = "prop_roadcone02a", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
}

Police.openedMenuArmory = false
Police.armoryMenu = RageUI.CreateMenu("Stockage", "LSPD")
Police.armoryMenu:SetRectangleBanner(255, 83, 46, 125)
Police.armoryMenu:DisplayGlare(false)
Police.armoryMenu.Closed = function()
    Police.openedMenuArmory = false 
end

function OpenMenuArmoryPolice()
    if Police.openedMenuArmory then
        Police.openedMenuArmory = false
        RageUI.Visible(Police.armoryMenu, false)
    else
        Police.openedMenuArmory = true
        RageUI.Visible(Police.armoryMenu, true)
            CreateThread(function()
                while Police.openedMenuArmory do
                    RageUI.IsVisible(Police.armoryMenu, function()
                        for k,v in pairs(items) do
                            RageUI.List(""..v.Label, v.List, v.Index, nil, {}, true, {
                                onListChange = function(Index, Button)
                                    v.Index = Index
                                end,
                                onSelected = function()
                                    TriggerServerEvent("armoryTake", v.Id, v.Label, v.List[v.Index])
                                end
                            })
                        end
                    end)   
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while true do
        local wait = 1000
        local playerPed = PlayerPedId()
		local plyCoords = GetEntityCoords(playerPed)
        local dist = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1102.84, -829.45, 14.28, true)

        if not IsPedInAnyVehicle(playerPed, false) then
            if dist <= 1.0 then
                wait = 10
                if PlayerData.job.name == 'police' then
                    DisplayNotification("Appuyer sur ~INPUT_TALK~ pour parler à ~o~Jane")
                    if IsControlJustPressed(1, 51) then
                        OpenMenuArmoryPolice()
                    end
                end
            else
                wait = 1000
            end
        end

		if IsPedShooting(playerPed) and not IsPedCurrentWeaponSilenced(playerPed) then
            wait = 10
			TriggerServerEvent("call:makeCallFire")
		end
        Wait(wait)
    end
end)

RegisterNetEvent('CallFire')
AddEventHandler('CallFire', function()
    TriggerServerEvent("call:makeCallSpecial", 'police', GetEntityCoords(PlayerPedId()), "Tirs d'arme à feu", "fire")
end)