ESX = nil

local scaleform = false

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj)
			ESX = obj
		end)
		Citizen.Wait(0)
	end

    while true do
        Wait(1)
        if scaleform then
            DrawScaleformMovieFullscreen(SetupScaleformFishing(), 255, 255, 255, 255, 0)
        end
	end
end)

local inPeche = false
local Pourcent = 0
local timepeche = 0
local inCapture = false
local UseBug = false

function ButtonMessageFishing(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function SetupScaleformFishing()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(1, 24, true))
    ButtonMessageFishing('Ferrer')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, 172, true))
    ButtonMessageFishing('Devant')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(3, 173, true))
    ButtonMessageFishing('Derrière')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(4, 174, true))
    ButtonMessageFishing('Gauche')
    PopScaleformMovieFunctionVoid()
    
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(5)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(5, 175, true))
    ButtonMessageFishing('Droite')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(6)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(6, 45, true))
    ButtonMessage('Annuler')
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function createFishing(bool)
    if not bool and HavePechet and DoesEntityExist(HavePechet) then
        SetEntityAsMissionEntity(HavePechet, 1, 1)
        DeleteObject(HavePechet)
        HavePechet = nil
    end
    if not bool and objectprop and DoesEntityExist(objectprop) then
        SetEntityAsMissionEntity(objectprop, 1, 1)
        DeleteObject(objectprop)
        hookfishingRodEntity = nil
    end
    if not bool then
        ClearPedTasks(GetPlayerPed(-1))
        RemoveTimerBar()
    else
        ESX.Streaming.RequestAnimDict("amb@world_human_stand_fishing@base", function()
            TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@base", "base", 8.0, -8.0, -1, 1, .0, false, false, false)
        end)
    end
    inCapture = false
    Pourcent = 0
    timepeche = 0
    StopAllScreenEffects()
end

function PecheStarting()
    local coord = GetEntityCoords(PlayerPedId())
    local ped = PlayerPedId()
    local pPed, pCoords = ped, coord

    if not UseBug then
        if not inPeche then
        for k, v in pairs(Fishing.FishingZone) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1))
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.pos)
            
            if dist <= 50.0 and not IsPedInAnyVehicle(ped, false) then
                ChanceDropFish = math.random(30 * 1000, 120 * 1000)
                GetTimerThread = nil
                percentage = nil
                inPeche = true
                UseBug = true
                createFishing()
                ESX.Streaming.RequestAnimDict("amb@world_human_stand_fishing@base", function()
                    TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@base", "base", 8.0, -8.0, -1, 1, .0, false, false, false)
                end)
                objectprop = CreateObject(Fishing.Peche.PropsCanne, GetEntityCoords(pPed), true, false, true)
                SetNetworkIdCanMigrate(ObjToNet(objectprop), false)
                SetModelAsNoLongerNeeded(Fishing.Peche.PropsCanne)
                AttachEntityToEntity(objectprop, pPed, GetPedBoneIndex(pPed, 60309), .0, .0, .0, .0, .0, .0, false, false, false, false, false, true)
                SetPedKeepTask(pPed, true)
                SetBlockingOfNonTemporaryEvents(pPed, true)
                Wait(550)
                HavePechet = CreateObject(Fishing.Peche.PropsAppat, GetEntityCoords(pPed), false, false, true)
                SetEntityCoordsNoOffset(HavePechet, GetEntityCoords(HavePechet) + GetEntityForwardVector(pPed) * 8, false, false, false)
                SetModelAsNoLongerNeeded(Fishing.Peche.PropsAppat)
                SetEntityVisible(HavePechet, false, false)
                PlaceObjectOnGroundProperly(HavePechet)
                SetEntityAsMissionEntity(HavePechet, 1, 1)
                SetEntityVisible(HavePechet, true, true)
                scaleform = true
                TimerBar = AddTimerBar("Distance", { percentage = 0.0, bg = { 100, 0, 0, 255 }, fg = { 200, 0, 0, 255 } })
                Citizen.CreateThread(function()
                    while inPeche do
                        Citizen.Wait(0)
                        if HavePechet and DoesEntityExist(HavePechet) then
                            DrawMarker(0, GetEntityCoords(HavePechet) + vector3(0.0, 0.0, 1.0), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.4, 0.4, 0.25, 0, 110, 180, 225, 0, 0, 2, 0, 0, 0, 0)
                        else
                            createFishing()
                        end

                        local Touche1, Touche2, Touche3, Touche4 = IsControlPressed(1, 172), IsControlPressed(1, 173), IsControlPressed(1, 175), IsControlPressed(1, 174)
                        if (Touche1 or Touche2 or Touche3 or Touche4) then
                            local pPedCoords = GetEntityCoords(HavePechet)
                            local pPedWat, pPedWat1 = GetWaterHeightNoWaves(pPedCoords.x, pPedCoords.y, pPedCoords.z)
                            if pPedWat then
                                SetEntityHeading(HavePechet, GetEntityHeading(pPed))
                                local pPedMa1, pPedMatrix = GetEntityMatrix(pPed)
                                local Presses = Touche1 and pPedMa1 or Touche2 and -pPedMa1 or Touche4 and -pPedMatrix or Touche3 and pPedMatrix
                                Presses = Presses * 0.025
                                local getPedCords = pPedCoords + Presses
                                SetEntityCoordsNoOffset(HavePechet, getPedCords.x, getPedCords.y, pPedWat1, false, false, false)
                                TaskLookAtEntity(pPed, HavePechet, -1, 2048, 3)
                            end
                        end

                        if inCapture and TimerBar then
                            UpdateTimerBar(TimerBar, { percentage = Pourcent })
                            if IsControlJustPressed(1, 24) then
                                Pourcent = math.max(0, math.min(1.0, Pourcent + 0.032))
                                local Between = GetDistanceBetweenCoords(GetEntityCoords(pPed), GetEntityCoords(HavePechet), true)
                                if Between > 6 then
                                    local CoordsHavePechet = GetEntityCoords(HavePechet)
                                    SetEntityCoordsNoOffset(HavePechet, CoordsHavePechet - GetEntityForwardVector(pPed) * 0.075, false, false, false)
                                end
                            end
                        end

                        if IsControlJustPressed(1, 45) then
                            inPeche = false
                            scaleform = false
                            UpdateTimerBar(TimerBar, { percentage = 0 })
                            createFishing()
                            ChanceDropFish = math.random(30 * 1000, 120 * 1000)
                            Wait(60000)
                            UseBug = false
                        end
                    end
                end)

                Citizen.CreateThread(function()
                    local ChanceGood = 200
                    while inPeche do
                        Citizen.Wait(ChanceDropFish)
                        if not inPeche then
                            break
                        end
                        if not inCapture then
                            if ChanceDropFish == ChanceGood then
                                ChanceDropFish = math.random(30 * 1000, 120 * 1000)
                            elseif ChanceDropFish ~= ChanceGood then
                                inCapture = true
                                GetTimerThread = nil
                                ChanceDropFish = ChanceGood
                                Pourcent = 0.2
                                timepeche = GetGameTimer()
                                ESX.Streaming.RequestAnimDict("amb@world_human_stand_fishing@idle_a", function()
                                    TaskPlayAnim(PlayerPedId(), "amb@world_human_stand_fishing@idle_a", "idle_c", 8.0, -8.0, -1, 1, .0, false, false, false)
                                end)
                                StartScreenEffect("MP_Celeb_Preload_Fade", 1500)
                            end
                        else
                            if Pourcent <= 0 or (Pourcent < 1 and timepeche + 30000 < GetGameTimer()) then
                                createFishing(true)
                                UpdateTimerBar(TimerBar, { percentage = 0 })
                                ESX.ShowNotification(Fishing.Peche.PoissonEchappe)
                                ChanceDropFish = math.random(30 * 1000, 120 * 1000)
                            elseif Pourcent >= 1 then
                                if not GetTimerThread then
                                    ChanceDropFish = 10
                                    GetTimerThread = nil
                                    PlaySoundFrontend(-1, "UNDER_THE_BRIDGE", "HUD_AWARDS", 1)
                                    UpdateTimerBar(TimerBar, { percentage = 0 })
                                    createFishing(true)
                                    ChanceDropFish = math.random(30 * 1000, 120 * 1000)
                                    TriggerServerEvent("PechePoisson")
                                    GetTimerThread = GetGameTimer()
                                else
                                    if GetTimerThread ~= nil and GetTimerThread + 2500 < GetGameTimer() then
                                        ESX.ShowNotification(Fishing.Peche.PoissonEchappe)
                                        UpdateTimerBar(TimerBar, { percentage = 0 })
                                        GetTimerThread = nil
                                        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 1)
                                        ChanceDropFish = ChanceGood
                                        createFishing(true)
                                    end
                                end
                            else
                                Pourcent = Pourcent - 0.01
                            end
                        end
                    end
                end)
            end
        end
        else
            ESX.ShowNotification(Fishing.Peche.PecheEnCours)
        end
    else
        ESX.ShowNotification("Veuillez patienter quelque secondes.")
    end
end

RegisterNetEvent('usecanne')
AddEventHandler('usecanne', function()
    PecheStarting()
end)

Citizen.CreateThread(function()
    for k, v in pairs(Fishing.FishingZone) do
        v.blip = AddBlipForCoord(v.pos)
        SetBlipSprite(v.blip, 68)
        SetBlipDisplay(v.blip, 4)
        SetBlipScale(v.blip, 0.8)
        SetBlipColour(v.blip, 26)
        SetBlipAsShortRange(v.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Zone de Pêche")
        EndTextCommandSetBlipName(v.blip)
    end
end)

local SellFishing = {
    Item = {
        {id = "truitearc", name = "> Truite arc-en-ciel", price = 12},
        {id = "kokanee", name = "> Kokanee", price = 15},
        {id = "ombrearctique", name = "> Ombre de l'artique", price = 168},
        {id = "percherock", name = "> Perche rock", price = 41},
        {id = "petitebouche", name = "> Petite bouche", price = 20},
        {id = "grandbouche", name = "> Grande bouche", price = 47},
        {id = "truitebull", name = "> Truite bull", price = 15},
        {id = "truitelac", name = "> Truite de lac", price = 62},
        {id = "chinook", name = "> Chinook", price = 23},
        {id = "esturgeonpale", name = "> Esturgeon pâle", price = 11},
        {id = "spatules", name = "> Spatules", price = 17},
        {id = "gardon", name = "> Gardon", price = 26},
    }
}

SellFishing.openedMenu = false 
SellFishing.mainMenu = RageUI.CreateMenu("Josh", "Vente de poissons", nil, 150)
SellFishing.mainMenu.Closed = function()
    SellFishing.openedMenu = false 
end

SellFishing.mainMenu:DisplayHeader(false)

function openSellFishing()
    if SellFishing.openedMenu == false then
        if SellFishing.openedMenu then
            SellFishing.openedMenu = false
            RageUI.Visible(SellFishing.mainMenu, false)
        else
            SellFishing.openedMenu = true
            RageUI.Visible(SellFishing.mainMenu, true)
                CreateThread(function()
                    while SellFishing.openedMenu do
                        RageUI.IsVisible(SellFishing.mainMenu, function()
                            for k,v in pairs(SellFishing.Item) do 
                                RageUI.Button(v.name, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("fishingSell", v.id, v.name, v.price) 
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

CreateThread(function()
    while true do
        Wait(1)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, 1465.55, 6548.10, 14.0)
		if dist <= 500 then
			if dist <= 3.0 then
				DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Josh~s~")
				if IsControlJustPressed(0, 51) then
                    openSellFishing()
                end
            end
		else
			Wait(1)
		end
    end
end)