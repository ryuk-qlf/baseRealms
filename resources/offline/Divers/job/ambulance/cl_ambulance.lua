local firstSpawn, PlayerLoaded = true, false

ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	PlayerLoaded = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerLoaded = true
end)

AddEventHandler('esx:onPlayerSpawn', function()
	if firstSpawn then
		firstSpawn = false
        while not PlayerLoaded do
            Citizen.Wait(1000)
        end

        ESX.TriggerServerCallback('GetDeathStatus', function(result)
            if result == 1 then
                TriggerServerEvent("RemoveWeaponDeath")
                TriggerEvent("onPlayerComa")
            end
        end)
	end
end)

function SpawnEntity()
    local pPed = PlayerPedId()
    NetworkResurrectLocalPlayer(GetEntityCoords(pPed), GetEntityHeading(pPed), true, true, false)
    DeleteEntity(pPed)
end

function TeleportHopitalCoords()
    local peds = PlayerPedId()
	local x, y, z = 352.19, -567.59, 29.89

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

local Ambulance = {
    deathTime = 0,
    TimeComa = 300 * 1000,
    TimePlayerKnockout = 15 * 1000,
    CallEMS = true,

    PlayerDead = false,
    PlayerKnockout = false,

    Ata = {
        {label = "30 Minutes", time = 30},
        {label = "1 Heures", time = 60},
        {label = "2 Heures", time = 120},
        {label = "3 Heures", time = 180},
        {label = "4 Heures", time = 240},
        {label = "5 Heures", time = 300},
        {label = "6 Heures", time = 360},
        {label = "7 Heures", time = 420},
        {label = "8 Heures", time = 480},
        {label = "9 Heures", time = 540},
        {label = "10 Heures", time = 600},
        {label = "11 Heures", time = 660},
        {label = "12 Heures", time = 720},
        {label = "13 Heures", time = 780},
        {label = "14 Heures", time = 840},
        {label = "15 Heures", time = 900},
        {label = "16 Heures", time = 960},
        {label = "17 Heures", time = 1020},
        {label = "18 Heures", time = 1080},
        {label = "19 Heures", time = 1140},
        {label = "20 Heures", time = 1200},
        {label = "21 Heures", time = 1260},
        {label = "22 Heures", time = 1320},
        {label = "23 Heures", time = 1380},
        {label = "24 Heures", time = 1440},
        {label = "48 Heures", time = 2880}
    }
}

function GetPlayerDead()
    return Ambulance.PlayerDead
end

function GetPlayerKnockout()
    return Ambulance.PlayerKnockout
end

RegisterNetEvent('RevivePlayerId')
AddEventHandler('RevivePlayerId', function()
    Ambulance.PlayerDead = false
    Ambulance.PlayerKnockout = false
    Ambulance.CallEMS = false
    ClearPedBloodDamage(PlayerPedId())
    RemoveTimerBar()
    DeleteProgressBar()
    ClearTimecycleModifier()
    SetEntityInvincible(PlayerPedId(), false)
    TriggerServerEvent("SetDeathStatus", 0)
    Wait(50)
    SetEntityHealth(PlayerPedId(), 200)
end)

RegisterNetEvent('onPlayerComa')
AddEventHandler('onPlayerComa', function()
    if not Ambulance.PlayerDead and not Ambulance.PlayerKnockout then
        Ambulance.PlayerDead = true
        Ambulance.deathTime = GetGameTimer() + Ambulance.TimeComa
        SetEntityInvincible(PlayerPedId(), true)
        ESX.ShowNotification("Voulez-vous contacter les secours.")
        ESX.ShowNotification("Contacter : ~g~E~s~ ou ~r~X")
        SpawnEntity()
        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
        SetTimecycleModifier("rply_vignette")
        AddTimerBar("INCONSCIENT :", { endTime = GetGameTimer() + Ambulance.TimeComa })
        TriggerServerEvent("SetDeathStatus", 1)

        Ambulance.CallEMS = true 

        while Ambulance.PlayerDead do
            Wait(0)
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            SetEntityHealth(PlayerPedId(), 120)
            if IsControlJustPressed(1, 51) and Ambulance.CallEMS then 
                ESX.ShowNotification("Vous avez appelé les ~b~secours~s~.")
                TriggerServerEvent("call:makeCallSpecial", "ems", GetEntityCoords(GetPlayerPed(-1)), "Un individu est inconscient")
                Ambulance.CallEMS = false 
            end
            if GetGameTimer() >= Ambulance.deathTime then
                DisplayNotification('Appuyez sur ~INPUT_MP_TEXT_CHAT_TEAM~ pour ~b~contacter les internes~s~.')
                if IsControlJustPressed(1, 246) then
                    SetEntityInvincible(PlayerPedId(), false)
                    RemoveTimerBar()
                    DoScreenFadeOut(500)
                    Wait(500)
                    TriggerEvent('esx_status:set', 'hunger', 1000000)
                    TriggerEvent('esx_status:set', 'thirst', 1000000)
                    ClearTimecycleModifier()
                    Wait(500)
                    DoScreenFadeIn(500)
                    Ambulance.PlayerDead = false
                    ClearPedBloodDamage(PlayerPedId())
                    PlaySoundFrontend(-1, "1st_Person_Transition", "PLAYER_SWITCH_CUSTOM_SOUNDSET", 0)
                    Citizen.Wait(10)
                    TeleportHopitalCoords()
                    TriggerServerEvent("RemoveWeaponDeath")
                    ClearPedTasksImmediately(PlayerPedId())
                    SetEntityHealth(PlayerPedId(), 130)
                    TriggerServerEvent("SetDeathStatus", 0)
                end
            end
        end
    end
end)

RegisterNetEvent('onPlayerPlayerKnockout')
AddEventHandler('onPlayerPlayerKnockout', function()
    if not Ambulance.PlayerDead and not Ambulance.PlayerKnockout then
        Ambulance.PlayerKnockout = true
        Ambulance.deathTime = GetGameTimer() + Ambulance.TimePlayerKnockout
        SetEntityInvincible(PlayerPedId(), true)
        SpawnEntity()
        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.0)
        SetTimecycleModifier("damage")
        AddProgressBar("Inconscient", 175, 25, 25, 150, Ambulance.TimePlayerKnockout)

        SetPedToRagdollWithFall(PlayerPedId(), 1500, 2000, 0, -GetEntityForwardVector(PlayerPedId()), 1.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)
        Citizen.Wait(1000)
        SetPedToRagdollWithFall(PlayerPedId(), 0, 0, 0, -GetEntityForwardVector(PlayerPedId()), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0)

        while Ambulance.PlayerKnockout do
            Wait(0)
            SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
            SetEntityHealth(PlayerPedId(), 120)
            if GetGameTimer() >= Ambulance.deathTime then
                DisplayNotification('Appuyez sur ~INPUT_CONTEXT~ pour vous ~b~relever~s~.')
                if IsControlJustPressed(1, 51) then
                    SetEntityInvincible(PlayerPedId(), false)
                    DoScreenFadeOut(500)
                    Wait(500)
                    ClearTimecycleModifier()
                    Wait(500)
                    DoScreenFadeIn(500)
                    SetEntityHealth(PlayerPedId(), 130)
                    Ambulance.PlayerKnockout = false
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if IsPedFatallyInjured(PlayerPedId()) then
            SetEntityInvincible(PlayerPedId(), true)
			Citizen.Wait(500)
			local DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())

            if IsMelee(DeathCauseHash) then
                TriggerEvent("onPlayerPlayerKnockout")
            else
                TriggerEvent("onPlayerComa")
            end

			DeathCauseHash = nil
		end
	end
end)

local LogsDeath = false

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(50)
        if IsEntityDead(PlayerPedId()) then
			local PedKiller = GetPedSourceOfDeath(PlayerPedId())
			DeathCauseHash = GetPedCauseOfDeath(PlayerPedId())

			if IsEntityAPed(PedKiller) and IsPedAPlayer(PedKiller) then
				Killer = NetworkGetPlayerIndexFromPed(PedKiller)
			elseif IsEntityAVehicle(PedKiller) and IsEntityAPed(GetPedInVehicleSeat(PedKiller, -1)) and IsPedAPlayer(GetPedInVehicleSeat(PedKiller, -1)) then
                Killer = NetworkGetPlayerIndexFromPed(GetPedInVehicleSeat(PedKiller, -1))
			end

            local IdKiller = GetPlayerServerId(Killer)

            if Killer == nil then
                IdKiller = "Aucun"
            end

            if IsMelee(DeathCauseHash) then
                if not LogsDeath then
                    LogsDeath = true
                    TriggerServerEvent("LogsKilled", "KO", IdKiller)
                end
            else
                if not LogsDeath then
                    LogsDeath = true
                    TriggerServerEvent("LogsKilled", "Coma", IdKiller)
                end
            end

			Killer = nil
			DeathCauseHash = nil
		end
    end
end)
 
function IsMelee(Weapon)
	local Weapons = {'WEAPON_BAT', 'WEAPON_CROWBAR', 'WEAPON_UNARMED', 'WEAPON_FLASHLIGHT', 'WEAPON_GOLFCLUB', 'WEAPON_HAMMER', 'WEAPON_KNUCKLE', 'WEAPON_NIGHTSTICK', 'WEAPON_WRENCH', 'WEAPON_POOLCUE', 'WEAPON_SNOWBALL', 'WEAPON_BALL', 'WEAPON_FLARE', 'WEAPON_FLAREGUN', 'WEAPON_DAGGER', 'WEAPON_BOTTLE', 'WEAPON_HATCHET', 'WEAPON_KNIFE', 'WEAPON_MACHETE', 'WEAPON_SWITCHBLADE', 'WEAPON_BATTLEAXE', 'WEAPON_STONE_HATCHET'}
	for i, CurrentWeapon in ipairs(Weapons) do
		if GetHashKey(CurrentWeapon) == Weapon then
			return true
		end
	end
	return false
end

RegisterNetEvent('ReanimationComa')
AddEventHandler('ReanimationComa', function()
    Ambulance.PlayerDead = false
    Ambulance.PlayerKnockout = false
    Ambulance.CallEMS = false
    ClearPedBloodDamage(PlayerPedId())
    RemoveTimerBar()
    DeleteProgressBar()
    ClearTimecycleModifier()
    SetEntityInvincible(PlayerPedId(), false)
    TriggerServerEvent("SetDeathStatus", 0)
    Wait(150)
    SetEntityHealth(PlayerPedId(), 200)
    ClearPedTasks(playerPed)
    ESX.ShowNotification("~g~Santé~s~\nVous venez d'être réanimé.")
end)

RegisterNetEvent('HealJoueur')
AddEventHandler('HealJoueur', function()
    SetEntityHealth(PlayerPedId(), 200)
    ESX.ShowNotification("~g~Santé~s~\nVous venez d'être soigné.")
end)

local Ems = {
    CheckboxMission = false,
    HistoriqueCall = {},
}

Ems.openedMenu = false 
Ems.mainMenu = RageUI.CreateMenu("Pillbox Hill", "Pillbox Hill")
Ems.subMenu = RageUI.CreateSubMenu(Ems.mainMenu, "Pillbox Hill", "Pillbox Hill")
Ems.subMenu2 = RageUI.CreateSubMenu(Ems.mainMenu, "Pillbox Hill", "Pillbox Hill")
Ems.subMenu3 = RageUI.CreateSubMenu(Ems.mainMenu, "Pillbox Hill", "Pillbox Hill")
Ems.subMenu4 = RageUI.CreateSubMenu(Ems.mainMenu, "Pillbox Hill", "Pillbox Hill")
Ems.mainMenu.Closed = function()
    Ems.openedMenu = false
    RageUI.Visible(Ems.mainMenu, false)
end

function MenuEMS()
    if Ems.openedMenu then
        Ems.openedMenu = false
        RageUI.Visible(Ems.mainMenu, false)
    else
        Ems.openedMenu = true
        RageUI.Visible(Ems.mainMenu, true)
            CreateThread(function()
                while Ems.openedMenu do
                    RageUI.IsVisible(Ems.mainMenu, function()
                        RageUI.Button("Effectuer une annonce", nil, {}, true, {
                            onSelected = function()
                                local input = ESX.KeyboardInput("Annonce", 250)
                                if input ~= nil and #input > 4 then
                                    TriggerServerEvent("AnnonceEMS", input)
                                end
                            end
                        })
                        RageUI.Button("Gestion Civil", nil, {RightLabel = "→"}, true, {}, Ems.subMenu)
                        RageUI.Button("Animations", nil, {RightLabel = "→"}, true, {}, Ems.subMenu2)
                        RageUI.Button("Historique des appel", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('HistoriqueCall', function(cb)
                                    Ems.HistoriqueCall = cb
                                end, ESX.GetPlayerData().job.name)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Ems.subMenu4, true)
                            end
                        })
                        RageUI.Button("Annuler l'appel", nil, {}, true, {
                            onSelected = function()
                                ExecuteCommand("annulerappel")

                                if Ems.blip then
                                    RemoveBlip(Ems.blip)
                                    Ems.blip = nil
                                end
                            end
                        })
                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            RageUI.Checkbox("Mission citoyen", false, Ems.CheckboxMission, {}, {
                                onChecked = function()
                                    StartMissionMolduEMS()
                                end,
                                onUnChecked = function()
                                    StopMissionMolduEMS()
                                end,
                                onSelected = function(Index)
                                    Ems.CheckboxMission = Index
                                end
                            })
                        else
                            RageUI.Button("Mission citoyen", nil, {}, false, {})
                        end
                    end)
                    RageUI.IsVisible(Ems.subMenu4, function()
                        for k, v in pairs(Ems.HistoriqueCall) do
                            local coords = GetEntityCoords(GetPlayerPed(-1), false)
                            local dist = CalculateTravelDistanceBetweenPoints(coords.x, coords.y, coords.z, v.pos.x, v.pos.y, v.pos.z)
                            if dist >= 10000.0 then
                                dist = 'Plus de 10 KM'
                                streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.pos.x, v.pos.y, v.pos.z)) .. " ("..dist..")"
                            else
                                streetname = GetStreetNameFromHashKey(GetStreetNameAtCoord(v.pos.x, v.pos.y, v.pos.z)) .. " ("..math.ceil(dist).."m)"
                            end
                            RageUI.Button(v.message, "Position : "..streetname, {}, true, {
                                onSelected = function()
                                    if Ems.blip then
                                        RemoveBlip(Ems.blip)
                                        Ems.blip = nil
                                    end
                                    Ems.posBlips = vector3(v.pos.x, v.pos.y, v.pos.z)
                                    Ems.blip = AddBlipForCoord(Ems.posBlips)
                                    SetBlipRoute(Ems.blip, true)

                                    Citizen.CreateThread(function()
                                        while Ems.blip ~= nil do
                                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), true), Ems.posBlips, false) < 5 then
                                                RemoveBlip(Ems.blip)
                                                Ems.blip = nil
                                            end
                                            Citizen.Wait(1000)
                                        end
                                    end)
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Ems.subMenu, function()
                        RageUI.Button("Réanimer un individu", nil, {}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                            
                                if target then
                                    if GetEntityHealth(GetPlayerPed(target)) <= 125 then
                                        RageUI.CloseAll()
                                        Ems.openedMenu = false
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
                            end
                        })
                        RageUI.Button("Soigner un individu", nil, {}, true, {
                            onSelected = function()
                                local playerPed = PlayerPedId()
                                local target = GetNearbyPlayer(2)
                            
                                if target then
                                    RageUI.CloseAll()
                                    Ems.openedMenu = false
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                                    AddProgressBar("Soins en cours", 90, 150, 90, 200, 12000)
                                    Wait(12000)
                                    ClearPedTasksImmediately(playerPed)
                                    TriggerServerEvent("HealJoueur", GetPlayerServerId(target))
                                end
                            end
                        })
                        RageUI.Button("Mettre en ATA", nil, {RightLabel = "→"}, true, {}, Ems.subMenu3)
                    end)
                    RageUI.IsVisible(Ems.subMenu3, function()
                        for k, v in pairs(Ambulance.Ata) do
                            RageUI.Button(v.label, nil, {}, true, {
                                onSelected = function()
                                    local target = GetNearbyPlayer(2)
                                
                                    if target then
                                        TriggerServerEvent("AddPlayerInAta", GetPlayerServerId(target), v.time)
                                    end
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Ems.subMenu2, function()
                        RageUI.Button("Prendre des notes", nil, {}, true, {
                            onSelected = function()
                                TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_TIME_OF_DEATH', 0, true)
                            end
                        })
                        RageUI.Button("Ausculter", nil, {}, true, {
                            onSelected = function()
                                TaskStartScenarioInPlace(PlayerPedId(), 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                            end
                        })
                        RageUI.Button("Prendre des photos", nil, {}, true, {
                            onSelected = function()
                                TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_PAPARAZZI', 0, true)
                            end
                        })
                        RageUI.Button("Massage cardiaque", nil, {}, true, {
                            onSelected = function()
                                ESX.Streaming.RequestAnimDict("missheistfbi3b_ig8_2")
                                TaskPlayAnim(PlayerPedId(), "missheistfbi3b_ig8_2", "cpr_loop_paramedic", 8.0, 8.0, -1, 0, 1, 0, 0, 0)
                            end
                        })
                        RageUI.Button("~r~Arrêter l'animation", nil, {}, true, {
                            onSelected = function()
                                ClearPedTasksImmediately(PlayerPedId())
                            end
                        })
                    end)          
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent("EmsMenu")
AddEventHandler("EmsMenu", function()
    MenuEMS()
end)

RegisterNetEvent('UseItemSoins')
AddEventHandler('UseItemSoins', function(itemName)
	if itemName == 'medikit' then
		local playerPed = PlayerPedId()

        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)

		AddProgressBar("Soins en cours",42, 118, 46, 125, 10000)
        Citizen.Wait(10000)
        ClearPedTasksImmediately(playerPed)
        SetEntityHealth(PlayerPedId(), 200)
        ESX.ShowNotification("~g~Santé~w~\nLes soins ont été appliqués !")
	elseif itemName == 'bandage' then
		local playerPed = PlayerPedId()
        local healthPly = GetEntityHealth(PlayerPedId()) 
        TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)

		AddProgressBar("Soins en cours",42, 118, 46, 125, 10000)
        Citizen.Wait(10000)
        ClearPedTasksImmediately(playerPed)
        SetEntityHealth(PlayerPedId(), healthPly + 30)
        ESX.ShowNotification("~g~Santé~w~\nLes soins ont été appliqués !")
	end
end)

function GetRandomWalkingNPC()
	local search = {}
	local peds   = ESX.Game.GetPeds()

	for i=1, #peds, 1 do
		if IsPedHuman(peds[i]) and IsPedWalking(peds[i]) and not IsPedAPlayer(peds[i]) then
			table.insert(search, peds[i])
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end

	for i=1, 250, 1 do
		local ped = GetRandomPedAtCoord(0.0, 0.0, 0.0, math.huge + 0.0, math.huge + 0.0, math.huge + 0.0, 26)

		if DoesEntityExist(ped) and IsPedHuman(ped) and IsPedWalking(ped) and not IsPedAPlayer(ped) then
			table.insert(search, ped)
		end
	end

	if #search > 0 then
		return search[GetRandomIntInRange(1, #search)]
	end
end

function ClearCurrentMission()
	if DoesBlipExist(CurrentCustomerBlip) then
		RemoveBlip(CurrentCustomerBlip)
	end

	if DoesBlipExist(DestinationBlip) then
		RemoveBlip(DestinationBlip)
	end

	CurrentCustomer           = nil
	CurrentCustomerBlip       = nil
	DestinationBlip           = nil
    IsNearCustomer            = false
    CustomerIsEnteringVehicle = false
	CustomerEnteredVehicle    = false
end

function StartMissionMolduEMS()
	ClearCurrentMission()

	MissionActived = true
end

function StopMissionMolduEMS()
	local playerPed = PlayerPedId()

	if IsPedInAnyVehicle(playerPed, false) and CurrentCustomer ~= nil then
		local vehicle = GetVehiclePedIsIn(playerPed,  false)
		TaskLeaveVehicle(CurrentCustomer,  vehicle,  0)

		if CustomerEnteredVehicle then
			TaskGoStraightToCoord(CurrentCustomer,  vector3(285.278, -570.86, 42.54),  1.0,  -1,  0.0,  0.0)
		end
	end

	ClearCurrentMission()
	MissionActived = false
	ESX.DrawMissionText('Mission terminé', 5000)
end

function LoadingPrompt(loadingText, spinnerType)

    if IsLoadingPromptBeingDisplayed() then
        RemoveLoadingPrompt()
    end

    if (loadingText == nil) then
        BeginTextCommandBusyString(nil)
    else
        BeginTextCommandBusyString("STRING");
        AddTextComponentSubstringPlayerName(loadingText);
    end

    EndTextCommandBusyString(spinnerType)
end

Citizen.CreateThread(function()
	while true do

		Citizen.Wait(0)
		local playerPed = PlayerPedId()

		if MissionActived then
			if CurrentCustomer == nil then
				ESX.DrawMissionText("Conduisez à la recherche d'un ~g~patient", 5000)

				if IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
					local waitUntil = GetGameTimer() + GetRandomIntInRange(30000, 45000)

					while MissionActived and waitUntil > GetGameTimer() do
						Citizen.Wait(0)
					end

					if MissionActived and IsPedInAnyVehicle(playerPed, false) and GetEntitySpeed(playerPed) > 0 then
						CurrentCustomer = GetRandomWalkingNPC()

						if CurrentCustomer ~= nil then
							CurrentCustomerBlip = AddBlipForEntity(CurrentCustomer)

							SetBlipAsFriendly(CurrentCustomerBlip, true)
							SetBlipCategory(CurrentCustomerBlip, 3)
							SetBlipRoute(CurrentCustomerBlip, true)

							SetEntityAsMissionEntity(CurrentCustomer, true, false)
							ClearPedTasksImmediately(CurrentCustomer)
							SetBlockingOfNonTemporaryEvents(CurrentCustomer, true)

							local standTime = GetRandomIntInRange(60000, 180000)
							TaskStandStill(CurrentCustomer, standTime)

							ESX.ShowNotification("Vous avez ~g~trouvé~s~ un patient.")
						end
					end
				end
			else
				if IsPedFatallyInjured(CurrentCustomer) then
					ESX.ShowNotification('Votre patient est ~r~inconscient~s~.')

					if DoesBlipExist(CurrentCustomerBlip) then
						RemoveBlip(CurrentCustomerBlip)
					end

					if DoesBlipExist(DestinationBlip) then
						RemoveBlip(DestinationBlip)
					end

					SetEntityAsMissionEntity(CurrentCustomer, false, true)

					CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle = nil, nil, nil, false, false, false
				end

				if IsPedInAnyVehicle(playerPed, false) then
					local vehicle          = GetVehiclePedIsIn(playerPed, false)
					local playerCoords     = GetEntityCoords(playerPed)
					local customerCoords   = GetEntityCoords(CurrentCustomer)
                    local customerDistance = GetDistanceBetweenCoords(playerCoords, customerCoords, true)
                    
					if IsPedSittingInVehicle(CurrentCustomer, vehicle) then
						if CustomerEnteredVehicle then
							if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(285.278, -570.86, 42.54), true) <= 10.0 then
								TaskLeaveVehicle(CurrentCustomer, vehicle, 0)

								ESX.ShowNotification('Vous êtes ~g~arrivé~s~ à destination')

								TaskGoStraightToCoord(CurrentCustomer, vector3(285.278, -570.86, 42.54), 1.0, -1, 0.0, 0.0)
								SetEntityAsMissionEntity(CurrentCustomer, false, true)
								TriggerServerEvent('SuccesMission')
								RemoveBlip(DestinationBlip)

                                ESX.SetTimeout(60000, function()
                                    DeleteEntity(CurrentCustomer)
                                end)

								CurrentCustomer, CurrentCustomerBlip, DestinationBlip, IsNearCustomer, CustomerIsEnteringVehicle, CustomerEnteredVehicle = nil, nil, nil, false, false, false
							end

							DrawMarker(0, vector3(285.278, -570.86, 42.54) + 1.1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
						else
							RemoveBlip(CurrentCustomerBlip)
							CurrentCustomerBlip = nil

							ESX.ShowNotification('~g~Pillbox Hill~s~\nAmmenez le patient à la destination.')

							DestinationBlip = AddBlipForCoord(vector3(285.278, -570.86, 42.54))

							BeginTextCommandSetBlipName('STRING')
							AddTextComponentSubstringPlayerName('Destination')
							EndTextCommandSetBlipName(blip)
							SetBlipRoute(DestinationBlip, true)

							CustomerEnteredVehicle = true
						end
					else
						DrawMarker(0, customerCoords.x, customerCoords.y, customerCoords.z + 1.1, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)

						if not CustomerEnteredVehicle then
							if customerDistance <= 40.0 then
                                if not IsNearCustomer then
								    ESX.ShowNotification('Vous êtes à ~b~proximité~s~ du patient.')
                                    IsNearCustomer = true
                                end
							end

							if customerDistance <= 20.0 then
                                if not CustomerIsEnteringVehicle then
                                    local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)

                                    for i = maxSeats - 1, 0, -1 do
                                        if IsVehicleSeatFree(vehicle, i) then
                                            freeSeat = i
                                            break
                                        end
                                    end

                                    if freeSeat then
                                        TaskEnterVehicle(CurrentCustomer, vehicle, -1, freeSeat, 2.0, 0)
                                        CustomerIsEnteringVehicle = true
                                    end
                                end
							end
						end
					end
				else
					ESX.DrawMissionText('Veuillez remonter dans votre véhicule pour continuer la mission', 5000)
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)