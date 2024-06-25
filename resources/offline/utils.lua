ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

    AddTextEntry('FE_THDR_GTAO', '~b~offline~s~ - ID '..GetPlayerServerId(PlayerId()))
    AddTextEntry('PM_PANE_LEAVE', 'Retourner à l\'acceuil')
    AddTextEntry('PM_PANE_QUIT', 'Quitter FiveM')
    AddTextEntry('PM_PANE_CFX', 'offline')

    while true do
        DisablePlayerVehicleRewards(PlayerId()) -- Pas de drop d'arme véhicule

        DisableControlAction(0, 199, true) -- Pas la Map sur P
        
        SetPedSuffersCriticalHits(PlayerPedId(), false) -- Pas de NoHeadShot

		RestorePlayerStamina(PlayerId(), 1.0) -- Stamina infiny

        SetPlayerHealthRechargeMultiplier(PlayerId(), 0.0) -- Pas de regen vie

        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_UNARMED"), 0.5) -- Dégat cout de poing
        
        N_0x4757f00bc6323cfe(-1553120962, 0.0) -- 0 Dégat véhicule

        N_0xf4f2c0d4ee209e20() -- Disable cinématique AFK

        SetPedHelmet(PlayerPedId(), false) -- Pas de casque auto sur les moto

        for a = 1, 15 do
            EnableDispatchService(a, false) -- Pas de dispatch
        end

        DisablePoliceReports() -- Disable Police Call

        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            if GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(-1), false), 0) == GetPlayerPed(-1) then
                if GetIsTaskActive(GetPlayerPed(-1), 165) then
                    SetPedIntoVehicle(GetPlayerPed(-1), GetVehiclePedIsIn(GetPlayerPed(-1), false), 0)
                end
            end
        end
		Citizen.Wait(1)
    end
end)

local Prop = {}

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if item == "parapluie" then
        DeleteEntity(Prop.Parapluie)
        ClearPedTasks(PlayerPedId())
        usingParapluie = false
    elseif item == "box" then
        DeleteEntity(Prop.Gant1)
        DeleteEntity(Prop.Gant2)
        useGants = false
    end
end)

RegisterNetEvent('useParapluie')
AddEventHandler('useParapluie', function()
    local Ped = GetPlayerPed(-1)
    local PedCoords = GetEntityCoords(Ped)

    usingParapluie = not usingParapluie

    if usingParapluie then
        local dict, anim = "amb@world_human_drinking@coffee@male@base", "base"
        while not HasAnimDictLoaded(dict) do
            RequestAnimDict(dict)
            Wait(10)
        end
        local Model = GetHashKey("p_amb_brolly_01")
        local Object = CreateObject(Model, PedCoords, 1, 0, 0)
        TaskPlayAnim(GetPlayerPed(-1), dict, anim, 2.0, 2.0, -1, 51, 0, false, false, false)
        Prop.Parapluie = AttachEntityToEntity(Object, Ped, GetPedBoneIndex(Ped, 6286), vector3(0.06, 0.005, 0.0), vector3(87.0, -20.0, 180.0), 0, 0, 1, 0, 0, 1)
        SetEntityCollision(Prop.Parapluie, false, true)
        ESX.ShowNotification("Vous avez équipé votre ~g~parapluie~w~.")
    else
        DeleteEntity(Prop.Parapluie)
        ClearPedTasks(Ped)
    end
end)

RegisterNetEvent('healPlayer')
AddEventHandler('healPlayer', function()
	local playerPed = PlayerPedId()
    
	SetEntityHealth(playerPed, GetEntityMaxHealth(playerPed))
    TriggerEvent('esx_status:set', 'hunger', 1000000)
	TriggerEvent('esx_status:set', 'thirst', 1000000)
end)

local plyragdoll = false

RegisterCommand('+ragdoll', function()
    if not IsPedFalling(GetPlayerPed(-1)) then
        plyragdoll = not plyragdoll
    end
end)

RegisterKeyMapping('+ragdoll', 'S\'endormir / se réveiller', 'keyboard', 'j')

Citizen.CreateThread(function()
    while true do
        local time = 250
        local plyPed = PlayerPedId()
        local entityAlpha = GetEntityAlpha(GetPlayerPed(-1))

        if not IsPedSittingInAnyVehicle(plyPed) then
            if entityAlpha < 100 then
               time = 0
            else
                if plyragdoll and IsControlJustReleased(1, 22) or plyragdoll and IsControlJustReleased(1, 51) then
                    plyragdoll = not plyragdoll
                end
                if plyragdoll then
                    time = 0
                    SetPedRagdollForceFall(plyPed)
                    ResetPedRagdollTimer(PlayerPedId())
                    SetPedToRagdoll(PlayerPedId(), 1000, 1000, 3, 0, 0, 0)
                    ResetPedRagdollTimer(PlayerPedId())
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ ou ~INPUT_JUMP~ pour ~b~vous relever~w~.")
                end
            end
        end 
        Wait(time)   
    end
end)

Citizen.CreateThread(function()
    while true do
        local time = 500
        
        if IsPedArmed(GetPlayerPed(-1), 4) then
            time = 5
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end

        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            if math.ceil(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6) >= 60.0 then
                time = 5
                DisableControlAction(0, 75) 
            end

            if math.ceil(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6) >= 50.0 then
                time = 5
                SetPlayerCanDoDriveBy(PlayerId(), false)
            else
                SetPlayerCanDoDriveBy(PlayerId(), true)
            end
        end

        if IsPauseMenuActive() and not isPaused then
            time = 5
			isPaused = true
			TriggerEvent('esx_status:setDisplay', 0.0)
		elseif not IsPauseMenuActive() and isPaused then
            time = 5
			isPaused = false 
			TriggerEvent('esx_status:setDisplay', 10.0)
		end

        if IsPlayerFreeAiming(PlayerId()) then
            time = 5
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 36, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end

        if IsPedFalling(GetPlayerPed(-1)) then
            time = 5
            SetEntityInvincible(GetPlayerPed(-1), true)
        else
            SetEntityInvincible(GetPlayerPed(-1), false)
        end

        if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_unarmed") and IsPedInMeleeCombat(GetPlayerPed(-1)) then
            time = 5
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)
            DisableControlAction(0, 25, true)
        end

        local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)

        if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
            local roll = GetEntityRoll(vehicle)
            if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
                time = 5
                DisableControlAction(2, 59, true)
                DisableControlAction(2, 60, true)
            end
        end
        Wait(time)
    end
end)

Citizen.CreateThread(function()
    while true do
        local pCoords = GetEntityCoords(GetPlayerPed(-1))
        local distance = GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, 4840.571, -5174.425, 2.0, false)

        if distance < 2000.0 then
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", true)
            Citizen.InvokeNative("0x5E1460624D194A38", true)
        else
            Citizen.InvokeNative("0x9A9D1BA639675CF1", "HeistIsland", false)
            Citizen.InvokeNative("0x5E1460624D194A38", false)
        end
        Citizen.Wait(5000)
    end
end)

RegisterCommand('id', function()
	local plyData = ESX.GetPlayerData()
	if plyData and plyData.job and plyData.job.label and plyData.job.grade_label then
        ESX.ShowNotification("Votre ID est le numéro : ~g~" ..GetPlayerServerId(PlayerId()).. "")
	else 
        ESX.ShowNotification("~r~Données introuvables.")
	end
end)

RegisterCommand('job', function()
	local plyData = ESX.GetPlayerData()
	if plyData and plyData.job and plyData.job.label and plyData.job.grade_label then
        ESX.ShowNotification("Job : ~g~"..plyData.job.label.."~s~\nGrade : ~g~"..plyData.job.grade_label.."")
	else 
        ESX.ShowNotification("~r~Données introuvables.")
	end
end)

function SeTrainerAuSol()
    CreateThread(function()
        if IsPedInAnyVehicle(playerPed, false) then 
            return 
        end
        local PlayerPed = GetPlayerPed(-1)
        coucher = not coucher
        if not coucher then
            Wait(0)
            FreezeEntityPosition(PlayerPed, false)
            local dict, anim = "get_up@directional@transition@prone_to_knees@crawl", "front"
            TaskPlayAnim(PlayerPed, dict, anim, 8.0, -4.0, -1, 9, 0.0)
        else
        if IsPedRunning(PlayerPed)or IsPedSprinting(PlayerPed) or IsPedStrafing(PlayerPed)then
            local dict, anim = "move_jump", "dive_start_run"
            ESX.Streaming.RequestAnimDict(dict)
            TaskPlayAnim(PlayerPed, dict, anim, 8.0, -4.0, -1, 9, 0.0)
            Citizen.Wait(1200)
        end
        CreateThread(function()
            while coucher do 
                Wait(0)
                FreezeEntityPosition(GetPlayerPed(-1), false)
                    if IsPedSwimming(GetPlayerPed(-1)) or IsPedFalling(GetPlayerPed(-1)) then 
                        coucher = false
                        FreezeEntityPosition(GetPlayerPed(-1), false)
                        local dict, anim = "get_up@directional@transition@prone_to_knees@crawl", "front"
                        TaskPlayAnim(GetPlayerPed(-1), dict, anim, 8.0, -4.0, -1, 9, 0.0)
                        break 
                    end
                    if IsControlPressed(1,32) and not IsEntityPlayingAnim(PlayerPed,"move_crawl", "onfront_fwd",3) then
                        local dict, anim = "move_crawl", "onfront_fwd"
                        ESX.Streaming.RequestAnimDict(dict)
                        TaskPlayAnim(PlayerPed, dict, anim, 8.0, -4.0, -1, 9, 0.0)
                    elseif IsControlPressed(1, 33) and not IsEntityPlayingAnim(PlayerPed, "move_crawl", "onfront_bwd", 3) then
                        local dict, anim = "move_crawl", "onfront_bwd"
                        ESX.Streaming.RequestAnimDict(dict)
                        TaskPlayAnim(PlayerPed, dict, anim, 8.0, -4.0, -1, 9, 0.0)
                    end
                    if IsControlPressed(1, 34) then
                        SetEntityHeading(PlayerPed, GetEntityHeading(PlayerPed)+1.0)
                    elseif IsControlPressed(1, 35)then
                        SetEntityHeading(PlayerPed, GetEntityHeading(PlayerPed)-1.0)
                    end
                    if IsControlReleased(1, 32) and IsControlReleased(1, 33) then
                        local dict, anim = "move_crawl", "onfront_fwd"
                        ESX.Streaming.RequestAnimDict(dict)
                        TaskPlayAnim(PlayerPed, dict, anim, 8.0, -4.0, -1, 9, 0.0)
                        FreezeEntityPosition(PlayerPed, true)
                    end
                end 
            end)
        end 
    end)
end

RegisterKeyMapping("+allonger","S'allonger au Sol","keyboard","M")

RegisterCommand("+allonger", function()
    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
		if not IsPedSwimming(GetPlayerPed(-1)) then
			if not IsEntityInWater(GetPlayerPed(-1)) then
				if not IsPedFalling(GetPlayerPed(-1)) then 
        			SeTrainerAuSol()
				end
			end
		end
    end
end)

RegisterKeyMapping("stream","Filmer Rockstar Editor","keyboard","F3")

RegisterCommand("stream",function()
    if IsRecording()then 
        return
        StopRecordingAndSaveClip()
    end
    StartRecording(1)
end)

RegisterCommand("rockstar",function()
	NetworkSessionLeaveSinglePlayer()
	ActivateRockstarEditor()
end)

local peds = {}

local GetGameTimer = GetGameTimer

local function draw3dText(coords, text)
    local camCoords = GetGameplayCamCoord()
    local dist = #(coords - camCoords)
    local scale = 170 / (GetGameplayCamFov() * dist)

    SetTextScale(0.0, 0.5 * scale)
    SetTextFont(0)
    SetTextCentre(true)
    SetTextColour(114, 114, 246, 255)
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextEdge(2, 0, 0, 0, 150)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(text)
    SetDrawOrigin(coords, 0)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()

end

function displayText(ped, text)
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    local targetPos = GetEntityCoords(ped)
    local dist = #(playerPos - targetPos)
    local los = HasEntityClearLosToEntity(playerPed, ped, 17)

    if dist <= 250 and los then
        local exists = peds[ped] ~= nil

        peds[ped] = {
            time = GetGameTimer() + 5000,
            text = text
        }

        if not exists then
            local display = true

            while display do
                Wait(0)
                local pos = GetOffsetFromEntityInWorldCoords(ped, 0.0, 0.0, 1.0)
                draw3dText(pos, peds[ped].text)
                display = GetGameTimer() <= peds[ped].time
            end

            peds[ped] = nil
        end

    end
end

local function onShareDisplay(text, target)
    local player = GetPlayerFromServerId(target)
    if player ~= -1 or target == GetPlayerServerId(PlayerId()) then
        local ped = GetPlayerPed(player)
        displayText(ped, text)
    end
end

RegisterNetEvent('3dme:shareDisplay', onShareDisplay)

RegisterKeyMapping("conducteur", "Place Conducteur", "keyboard", "1")
RegisterKeyMapping("passager", "Place Passager", "keyboard", "2")
RegisterKeyMapping("arrieregauche", "Place Arrière Gauche", "keyboard", "3")
RegisterKeyMapping("arrieredroite", "Place Arrière Droite", "keyboard", "4")

RegisterCommand("conducteur", function() 
    local plyPed = GetPlayerPed(-1)
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 2.2369
    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, -1)
        end
    end
end)

RegisterCommand("passager", function()
    local plyPed = GetPlayerPed(-1)
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 2.2369
    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 0)
        end
    end
end)

RegisterCommand("arrieregauche", function() 
    local plyPed = GetPlayerPed(-1)
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 2.2369
    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 1)
        end
    end
end)

RegisterCommand("arrieredroite", function() 
    local plyPed = GetPlayerPed(-1)
    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
    local CarSpeed = GetEntitySpeed(plyVehicle) * 2.2369
    if IsPedSittingInAnyVehicle(plyPed) then
        if CarSpeed <= 20.0 then
            SetPedIntoVehicle(plyPed, plyVehicle, 2)
        end
    end
end)

RegisterKeyMapping("+handsup", "Lever les mains", "keyboard", "Y")

RegisterCommand('+handsup', function()
    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) then
        while not HasAnimDictLoaded("random@mugging3") do
            RequestAnimDict("random@mugging3")
            Citizen.Wait(5)
        end
        if not IsEntityPlayingAnim(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', 3) then
            TaskPlayAnim(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', 3.0, 1.0, -1, 50, 0, false, false, false)
        else
            StopAnimTask(PlayerPedId(), 'random@mugging3', 'handsup_standing_base', -3.0)
        end
    end
end)

local crouched = false

RegisterKeyMapping('accroupie', "S'accroupir", 'keyboard', 'X')

RegisterCommand('accroupie', function()
    local plyPed = PlayerPedId()
    local DemarcheBind = ESX.GetFieldValueFromName("offlineDemarche")
    
    if not IsPedInAnyVehicle(GetPlayerPed(-1), false) and DoesEntityExist(plyPed) and not IsEntityDead(plyPed) then 
        DisableControlAction(1, 104, true)
        if not IsPauseMenuActive() then 
            RequestAnimSet("move_ped_crouched")
            while not HasAnimSetLoaded("move_ped_crouched") do 
                Citizen.Wait(100)
            end 
            if crouched == true then 
                ResetPedMovementClipset(plyPed, 1.2)
                crouched = false
                
                if json.encode(DemarcheBind) ~= "[]" then
                    RequestAnimSet(DemarcheBind)
                    while not HasAnimSetLoaded(DemarcheBind) do
                        Citizen.Wait(100)
                    end
                    SetPedMovementClipset(PlayerPedId(), DemarcheBind, 1.2)
                end
            elseif crouched == false then
                SetPedMovementClipset(plyPed, "move_ped_crouched", 1.2)
                crouched = true 
            end 
        end
    end 
end)

local mp_pointing = false
local keyPressed = false
local once = true
local knockedOut = false
local wait = 8
local count = 60

-- function
local function startPointing()
    local ped = GetPlayerPed(-1)
    RequestAnimDict("anim@mp_point")
    while not HasAnimDictLoaded("anim@mp_point") do
        Wait(0)
    end
    SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
    SetPedConfigFlag(ped, 36, 1)
    Citizen.InvokeNative(0x2D537BA194896636, ped, "task_mp_pointing", 0.5, 0, "anim@mp_point", 24)
    RemoveAnimDict("anim@mp_point")
end

local function stopPointing()
    local ped = GetPlayerPed(-1)
    Citizen.InvokeNative(0xD01015C7316AE176, ped, "Stop")
    if not IsPedInjured(ped) then
        ClearPedSecondaryTask(ped)
    end
    if not IsPedInAnyVehicle(ped, 1) then
        SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
    end
    SetPedConfigFlag(ped, 36, 0)
    ClearPedSecondaryTask(PlayerPedId())
end
 
Citizen.CreateThread(function()
    while true do
        local time = 250
        if once then
            once = false
        end

        if not keyPressed then
            time = 0
            if IsControlPressed(0, 29) and not mp_pointing and IsPedOnFoot(PlayerPedId()) then
                Wait(200)
                if not IsControlPressed(0, 29) then
                    keyPressed = true
                    startPointing()
                    mp_pointing = true
                else
                    keyPressed = true
                    while IsControlPressed(0, 29) do
                        Wait(50)
                    end
                end
            elseif (IsControlPressed(0, 29) and mp_pointing) or (not IsPedOnFoot(PlayerPedId()) and mp_pointing) then
                keyPressed = true
                mp_pointing = false
                stopPointing()
            end
        end

        if keyPressed then
            if not IsControlPressed(0, 29) then
                keyPressed = false
            end
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) and not mp_pointing then
            stopPointing()
        end
        if Citizen.InvokeNative(0x921CE12C489C4C41, PlayerPedId()) then
            if not IsPedOnFoot(PlayerPedId()) then
                stopPointing()
            else
                local ped = GetPlayerPed(-1)
                local camPitch = GetGameplayCamRelativePitch()
                if camPitch < -70.0 then
                    camPitch = -70.0
                elseif camPitch > 42.0 then
                    camPitch = 42.0
                end
                camPitch = (camPitch + 70.0) / 112.0

                local camHeading = GetGameplayCamRelativeHeading()
                local cosCamHeading = Cos(camHeading)
                local sinCamHeading = Sin(camHeading)
                if camHeading < -180.0 then
                    camHeading = -180.0
                elseif camHeading > 180.0 then
                    camHeading = 180.0
                end
                camHeading = (camHeading + 180.0) / 360.0

                local blocked = 0
                local nn = 0

                local coords = GetOffsetFromEntityInWorldCoords(ped, (cosCamHeading * -0.2) - (sinCamHeading * (0.4 * camHeading + 0.3)), (sinCamHeading * -0.2) + (cosCamHeading * (0.4 * camHeading + 0.3)), 0.6)
                local ray = Cast_3dRayPointToPoint(coords.x, coords.y, coords.z - 0.2, coords.x, coords.y, coords.z + 0.2, 0.4, 95, ped, 7);
                nn,blocked,coords,coords = GetRaycastResult(ray)

                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Pitch", camPitch)
                Citizen.InvokeNative(0xD5BB4025AE449A4E, ped, "Heading", camHeading * -1.0 + 1.0)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isBlocked", blocked)
                Citizen.InvokeNative(0xB0A6CFD2C69C1088, ped, "isFirstPerson", Citizen.InvokeNative(0xEE778F8C7E1142E2, Citizen.InvokeNative(0x19CAFA3C87F7C2FF)) == 4)

            end
        end
        Wait(time)
    end
end)

RegisterNetEvent("useCiseaux")
AddEventHandler("useCiseaux", function()
    local Target = GetNearbyPlayer(3)
    local playerPed = PlayerPedId()

    if Target then
        if IsEntityPlayingAnim(GetPlayerPed(Target), 'random@mugging3', 'handsup_standing_base', 3) or IsPedCuffed(GetPlayerPed(Target)) or IsPedRagdoll(GetPlayerPed(Target)) then
            TriggerServerEvent("HairCut", GetPlayerServerId(Target))
            local plycoord = GetEntityCoords(GetPlayerPed(-1))
            ciseau = CreateObject(GetHashKey("p_cs_scissors_s"), plycoord.x, plycoord.y, plycoord.z,  true,  true, true)
            AttachEntityToEntity(ciseau, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), -0.0, 0.03, 0, 0, -270.0, -20.0, true, true, false, true, 1, true)
            ESX.Streaming.RequestAnimDict("missfam6ig_8_ponytail")
            TaskPlayAnim(playerPed, "missfam6ig_8_ponytail", "ig_7_loop_michael", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
            FreezeEntityPosition(playerPed, true)
            Citizen.Wait(20000)
            TriggerServerEvent('removeDiversInventoryItem', 'ciseaux')
            FreezeEntityPosition(playerPed, false)
            ClearPedTasks(playerPed)
            DeleteObject(ciseau)
            DetachEntity(ciseau, 1, true)
        else
            ESX.Notification("~r~Impossible l'individu doit être menotté.")
        end
    end
end)

RegisterNetEvent("HairCut")
AddEventHandler("HairCut", function()
    local playerPed = PlayerPedId()

    ESX.Streaming.RequestAnimDict("missfam6ig_8_ponytail")
    TaskPlayAnim(playerPed, "missfam6ig_8_ponytail", "ig_7_loop_lazlow", 8.0, 8.0, -1, 1, 1, 0, 0, 0)
    FreezeEntityPosition(playerPed, true)
    Citizen.Wait(20000)
    FreezeEntityPosition(playerPed, false)
    ESX.ShowNotification("Vos cheveux ont été ~r~coupés~w~.")
    TriggerEvent('skinchanger:change', 'hair_1', 0)
    TriggerEvent('skinchanger:getSkin', function(skin)
        TriggerServerEvent('esx_skin:save', skin)
    end)
    ClearPedTasks(playerPed)
end)

local healthEngineLast = 1000.0
local healthBodyLast = 1000.0
local healthPetrolTankLast = 1000.0

local cfg = {
	deformationMultiplier = 3.0,					-- How much should the vehicle visually deform from a collision. Range 0.0 to 10.0 Where 0.0 is no deformation and 10.0 is 10x deformation. -1 = Don't touch. Visual damage does not sync well to other players.
	deformationExponent = 0.4,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	collisionDamageExponent = 0.6,					-- How much should the handling file deformation setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.

	damageFactorEngine = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorBody = 10.0,					-- Sane values are 1 to 100. Higher values means more damage to vehicle. A good starting point is 10
	damageFactorPetrolTank = 64.0,					-- Sane values are 1 to 200. Higher values means more damage to vehicle. A good starting point is 64
	engineDamageExponent = 0.6,					-- How much should the handling file engine damage setting be compressed toward 1.0. (Make cars more similar). A value of 1=no change. Lower values will compress more, values above 1 it will expand. Dont set to zero or negative.
	weaponsDamageMultiplier = 1.5,					-- How much damage should the vehicle get from weapons fire. Range 0.0 to 10.0, where 0.0 is no damage and 10.0 is 10x damage. -1 = don't touch
	degradingHealthSpeedFactor = 10,			-- Speed of slowly degrading health, but not failure. Value of 10 means that it will take about 0.25 second per health point, so degradation from 800 to 305 will take about 2 minutes of clean driving. Higher values means faster degradation
	cascadingFailureSpeedFactor = 8.0,			-- Sane values are 1 to 100. When vehicle health drops below a certain point, cascading failure sets in, and the health drops rapidly until the vehicle dies. Higher values means faster failure. A good starting point is 8

	degradingFailureThreshold = 200.0,			-- Below this value, slow health degradation will set in
	cascadingFailureThreshold = 100.0,			-- Below this value, health cascading failure will set in
	engineSafeGuard = 0.0,					-- Final failure value. Set it too high, and the vehicle won't smoke when disabled. Set too low, and the car will catch fire from a single bullet to the engine. At health 100 a typical car can take 3-4 bullets to the engine before catching fire.

	torqueMultiplierEnabled = true,					-- Decrease engine torque as engine gets more and more damaged

	-- The response curve to apply to the Brake. Range 0.0 to 10.0. Higher values enables easier braking, meaning more pressure on the throttle is required to brake hard. Does nothing for keyboard drivers

	classDamageMultiplier = {
	[0] = 	0.65,		--	0: Compacts
            0.65,		--	1: Sedans
            0.65,		--	2: SUVs
            0.65,		--	3: Coupes
            0.65,		--	4: Muscle
            0.65,	--	5: Sports Classics
            0.65,		--	6: Sports
            0.65,	--	7: Super
            0.45,		--	8: Motorcycles
			0.65,		--	9: Off-road
            0.65,		--	10: Industrial
            0.65,	--	11: Utility
            0.65,	--	12: Vans
            0.65,	--	13: Cycles
			0.50,		--	14: Boats
            0.65,		--	15: Helicopters
            0.65,		--	16: Planes
            0.65,		--	17: Service
            0.65,		--	18: Emergency
            0.65,		--	19: Military
            0.65,		--	20: Commercial
            0.65,		--	21: Trains
            0.65,		--  22: OpenWheel
	}
}

local pedInSameVehicleLast = false
local vehicle
local lastVehicle
local vehicleClass
local fCollisionDamageMult = 0.0
local fDeformationDamageMult = 0.0
local fEngineDamageMult = 0.0
local fBrakeForce = 1.0

local healthEngineCurrent = 1000.0
local healthEngineNew = 1000.0
local healthEngineDelta = 0.0
local healthEngineDeltaScaled = 0.0

local healthBodyCurrent = 1000.0
local healthBodyNew = 1000.0
local healthBodyDelta = 0.0
local healthBodyDeltaScaled = 0.0

local healthPetrolTankCurrent = 1000.0
local healthPetrolTankNew = 1000.0
local healthPetrolTankDelta = 0.0
local healthPetrolTankDeltaScaled = 0.0

local function IsPedDrivingAVehicle(ped, vehicle)
	if GetPedInVehicleSeat(vehicle, -1) == ped then
		local class = GetVehicleClass(vehicle)
		if class ~= 15 and class ~= 16 and class ~= 21 and class ~= 13 then
			return true
		end
	end

	return false
end

Citizen.CreateThread(function()
	while true do
		local wait = 500

		local ped, veh = PlayerPedId(), GetVehiclePedIsIn(PlayerPedId(), false)

		if IsPedInAnyVehicle(PlayerPedId()) and veh and IsPedDrivingAVehicle(ped, veh) and IsThisModelACar(GetEntityModel(veh)) and not IsControlPressed(1, 337) then
			wait = 5
			vehicle = veh
			vehicleClass = GetVehicleClass(vehicle)

			healthEngineCurrent = GetVehicleEngineHealth(vehicle)
			if healthEngineCurrent == 1000 then healthEngineLast = 1000.0 end
			healthEngineNew = healthEngineCurrent
			healthEngineDelta = healthEngineLast - healthEngineCurrent
			healthEngineDeltaScaled = healthEngineDelta * cfg.damageFactorEngine * cfg.classDamageMultiplier[vehicleClass]

			healthBodyCurrent = GetVehicleBodyHealth(vehicle)
			if healthBodyCurrent == 1000 then healthBodyLast = 1000.0 end
			healthBodyNew = healthBodyCurrent
			healthBodyDelta = healthBodyLast - healthBodyCurrent
			healthBodyDeltaScaled = healthBodyDelta * cfg.damageFactorBody * cfg.classDamageMultiplier[vehicleClass]

			healthPetrolTankCurrent = GetVehiclePetrolTankHealth(vehicle)
			if cfg.compatibilityMode and healthPetrolTankCurrent < 1 then
				healthPetrolTankLast = healthPetrolTankCurrent
			end
			if healthPetrolTankCurrent == 1000 then healthPetrolTankLast = 1000.0 end
			healthPetrolTankNew = healthPetrolTankCurrent
			healthPetrolTankDelta = healthPetrolTankLast-healthPetrolTankCurrent
			healthPetrolTankDeltaScaled = healthPetrolTankDelta * cfg.damageFactorPetrolTank * cfg.classDamageMultiplier[vehicleClass]
			if healthEngineCurrent > cfg.engineSafeGuard + 1 then
				SetVehicleUndriveable(vehicle,false)
			end
			if healthEngineCurrent <= cfg.engineSafeGuard + 1 then
				SetVehicleUndriveable(vehicle,true)
			end
			-- If ped spawned a new vehicle while in a vehicle or teleported from one vehicle to another, handle as if we just entered the car
			if vehicle ~= lastVehicle then
				pedInSameVehicleLast = false
			end
			if pedInSameVehicleLast == true then
				-- Damage happened while in the car = can be multiplied
				-- Only do calculations if any damage is present on the car. Prevents weird behavior when fixing using trainer or other script
				if healthEngineCurrent ~= 1000.0 or healthBodyCurrent ~= 1000.0 or healthPetrolTankCurrent ~= 1000.0 then
					-- Combine the delta values (Get the largest of the three)
					local healthEngineCombinedDelta = math.max(healthEngineDeltaScaled, healthBodyDeltaScaled, healthPetrolTankDeltaScaled)
					-- If huge damage, scale back a bit
					if healthEngineCombinedDelta > (healthEngineCurrent - cfg.engineSafeGuard) then
						healthEngineCombinedDelta = healthEngineCombinedDelta * 0.7
					end
					-- If complete damage, but not catastrophic (ie. explosion territory) pull back a bit, to give a couple of seconds og engine runtime before dying
					if healthEngineCombinedDelta > healthEngineCurrent then
						healthEngineCombinedDelta = healthEngineCurrent - (cfg.cascadingFailureThreshold / 5)
					end
					------- Calculate new value
					healthEngineNew = healthEngineLast - healthEngineCombinedDelta
					------- Sanity Check on new values and further manipulations
					-- If somewhat damaged, slowly degrade until slightly before cascading failure sets in, then stop
					if healthEngineNew > (cfg.cascadingFailureThreshold + 5) and healthEngineNew < cfg.degradingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.038 * cfg.degradingHealthSpeedFactor)
					end
					-- If Damage is near catastrophic, cascade the failure
					if healthEngineNew < cfg.cascadingFailureThreshold then
						healthEngineNew = healthEngineNew-(0.1 * cfg.cascadingFailureSpeedFactor)
					end
					-- Prevent Engine going to or below zero. Ensures you can reenter a damaged car.
					if healthEngineNew < cfg.engineSafeGuard then
						healthEngineNew = cfg.engineSafeGuard
					end
					-- Prevent Explosions
					if cfg.compatibilityMode == false and healthPetrolTankCurrent < 750 then
						healthPetrolTankNew = 750.0
					end
					-- Prevent negative body damage.
					if healthBodyNew < 0  then
						healthBodyNew = 0.0
					end
				end
			else
				-- Just got in the vehicle. Damage can not be multiplied this round
				-- Set vehicle handling data
				fDeformationDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult')
				fBrakeForce = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce')
				local newFDeformationDamageMult = fDeformationDamageMult ^ cfg.deformationExponent	-- Pull the handling file value closer to 1
				if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fDeformationDamageMult', newFDeformationDamageMult * cfg.deformationMultiplier) end  -- Multiply by our factor
				if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier / cfg.damageFactorBody) end -- Set weaponsDamageMultiplier and compensate for damageFactorBody

				--Get the CollisionDamageMultiplier
				fCollisionDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFCollisionDamageMultiplier = fCollisionDamageMult ^ cfg.collisionDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fCollisionDamageMult', newFCollisionDamageMultiplier)

				--Get the EngineDamageMultiplier
				fEngineDamageMult = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult')
				--Modify it by pulling all number a towards 1.0
				local newFEngineDamageMult = fEngineDamageMult ^ cfg.engineDamageExponent	-- Pull the handling file value closer to 1
				SetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fEngineDamageMult', newFEngineDamageMult)

				-- If body damage catastrophic, reset somewhat so we can get new damage to multiply
				if healthBodyCurrent < cfg.cascadingFailureThreshold then
					healthBodyNew = cfg.cascadingFailureThreshold
				end
				pedInSameVehicleLast = true
			end

			-- set the actual new values
			if healthEngineNew ~= healthEngineCurrent then
				SetVehicleEngineHealth(vehicle, healthEngineNew)
			end

			if healthBodyNew ~= healthBodyCurrent then SetVehicleBodyHealth(vehicle, healthBodyNew) end
			if healthPetrolTankNew ~= healthPetrolTankCurrent then SetVehiclePetrolTankHealth(vehicle, healthPetrolTankNew) end

			-- Store current values, so we can calculate delta next time around
			healthEngineLast = healthEngineNew
			healthBodyLast = healthBodyNew
			healthPetrolTankLast = healthPetrolTankNew
			lastVehicle = vehicle
		else
			if pedInSameVehicleLast == true then
				-- We just got out of the vehicle
				lastVehicle = GetVehiclePedIsIn(ped, true)
				if IsThisModelACar(GetEntityModel(lastVehicle)) then
					if cfg.deformationMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fDeformationDamageMult', fDeformationDamageMult) end -- Restore deformation multiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fBrakeForce', fBrakeForce)  -- Restore Brake Force multiplier
					if cfg.weaponsDamageMultiplier ~= -1 then SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fWeaponDamageMult', cfg.weaponsDamageMultiplier) end	-- Since we are out of the vehicle, we should no longer compensate for bodyDamageFactor
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fCollisionDamageMult', fCollisionDamageMult) -- Restore the original CollisionDamageMultiplier
					SetVehicleHandlingFloat(lastVehicle, 'CHandlingData', 'fEngineDamageMult', fEngineDamageMult) -- Restore the original EngineDamageMultiplier
				end
			end
			pedInSameVehicleLast = false
		end
		Wait(wait)
	end
end)