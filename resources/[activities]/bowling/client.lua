local bowling = false

Citizen.CreateThread(function()
    while not NetworkIsSessionStarted() do
        Wait(0)
    end
    Wait(2500)
    for k, v in pairs(Config['Bowling']['BowlingBalls']) do
        local ball = createObject('prop_bowling_ball', vector3(v.x, v.y, v.z-0.15))
        SetEntityAsMissionEntity(ball, true, true)
        FreezeEntityPosition(ball, true)
    end

    while true do
        local sleep = 250
        if not bowling then
            local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config['Bowling']['GetBall'], true)
            if distance <= 15.0 then
                sleep = 0
                DrawMarker(25, Config['Bowling']['GetBall'].x, Config['Bowling']['GetBall'].y, Config['Bowling']['GetBall'].z-0.90, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                if distance <= 1.5 then
                    DisplayNotification(Strings['press_start'])
                    if IsControlJustReleased(0, 38) then
                        bowling = true
                        TriggerServerEvent('landlife_bowling:start')
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

RegisterNetEvent('landlife_bowling:cancel')
AddEventHandler('landlife_bowling:cancel', function(full)
    if full then
        notify(Strings['this_occupied'])
    end
    bowling = false
end)

RegisterNetEvent('landlife_bowling:chooseTrack')
AddEventHandler('landlife_bowling:chooseTrack', function(occupiedTracks)
    local tracksLeft, currentTrack = {}, 1
    for i = 1, #Config['Bowling']['Tracks'] do
        if not occupiedTracks[i] then table.insert(tracksLeft, Config['Bowling']['Tracks'][i]) end
    end 
    if #tracksLeft >= 1 then
        local cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
        SetCamCoord(cam, Config['Bowling']['Cam']['Start'])
        RenderScriptCams(1, 0, 0, 1, 1)
        PointCamAtCoord(cam, Config['Bowling']['Cam']['End'])
        SetCamFov(cam, Config['Bowling']['Cam']['Fov'])
        while true do
            local current = tracksLeft[currentTrack]
            DrawMarker(20, current.x, current.y, current.z+1.0, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
            DrawScaleformMovieFullscreen(SetupScaleform('Choisir', 215, 'Retour', 194, 'Droite', 175, 'Gauche', 174), 255, 255, 255, 255, 0)
            if IsControlJustReleased(0, 215) then
                for i = 1, #Config['Bowling']['Tracks'] do
                    if Config['Bowling']['Tracks'][i] == tracksLeft[currentTrack] then
                        TriggerServerEvent('landlife_bowling:choose', i)
                    end
                end
                break
            elseif IsControlJustReleased(0, 194) then
                bowling = false
                break
            elseif IsControlJustReleased(0, 175) then
                if tracksLeft[currentTrack+1] then
                    currentTrack = currentTrack + 1
                else
                    currentTrack = 1
                end
            elseif IsControlJustReleased(0, 174) then
                if tracksLeft[currentTrack - 1] then
                    currentTrack = currentTrack - 1
                else
                    currentTrack = #tracksLeft
                end
            end
            Wait(0)
        end
        RenderScriptCams(false, false, 0, true, false)
        DestroyCam(cam, false)
    else
        notify(Strings['every_occupied'])
    end
end)

RegisterNetEvent('landlife_bowling:play')
AddEventHandler('landlife_bowling:play', function(chosenTrack)
    bowling = true 
    DoScreenFadeOut(750)
    while not IsScreenFadedOut() do Wait(0) end
    local track, me, currentCam, pins, force, secondTry = Config['Bowling']['Tracks'][chosenTrack], PlayerPedId(), 1, {}, 0.0, false
    SetEntityCoords(me, track)
    SetEntityHeading(me, track.w)

    for k, v in pairs(Config['Bowling']['BowlingPinSets'][chosenTrack]) do
        local pin = createObject('prop_bowling_pin', v)
        SetEntityHeading(pin, 0.0)
        SetEntityAsMissionEntity(pin, true, true)
        table.insert(pins, pin)
    end

    local ball = createObject('prop_bowling_ball', GetEntityCoords(me))
    SetEntityAsMissionEntity(ball, true, true)
    AttachEntityToEntity(ball, me, GetPedBoneIndex(me, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)

    local possibleCams = {
        {
            ['Coords'] = GetOffsetFromEntityInWorldCoords(me, 0.35, -1.0, 0.75),
            ['Point'] = GetOffsetFromEntityInWorldCoords(me, 0.0, 50.0, 0.0)
        },
        {
            ['Coords'] = GetOffsetFromEntityInWorldCoords(me, 0.0, 0.0, 3.0),
            ['Point'] = GetOffsetFromEntityInWorldCoords(me, 0.0, 0.1, 2.0)
        },
        {
            ['Coords'] = GetOffsetFromEntityInWorldCoords(me, 2.0, -3.0, 0.0),
            ['Point'] = GetOffsetFromEntityInWorldCoords(me, 0.0, 100.0, 0.0)
        },
        {
            ['Coords'] = GetOffsetFromEntityInWorldCoords(pins[1], 0.0, 2.0, 1.0),
            ['Point'] = GetOffsetFromEntityInWorldCoords(pins[1], 0.0, -0.25, 0.0)
        },
    }

    local cam = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
    RenderScriptCams(1, 0, 0, 1, 1)

    local dict = loadDict('weapons@projectile@')

    DoScreenFadeIn(1500)
    while bowling do
        SetCamCoord(cam, possibleCams[currentCam]['Coords'])
        PointCamAtCoord(cam, possibleCams[currentCam]['Point'])
        --DisplayNotification(Strings['bowling_info'])
        DrawScaleformMovieFullscreen(SetupScaleform('Puissance +', 173, 'Puissance -', 172, 'Droite', 175, 'Gauche', 174), 255, 255, 255, 255, 0)
        if not IsEntityPlayingAnim(me, dict, 'aimlive_l', 3) then
            loadDict(dict)
            TaskPlayAnim(me, dict, 'aimlive_l', 8.0, -8.0, -1, 17, 0, false, false, false)
        end

        for i = 0, 31 do DisableAllControlActions(i) end
        
        if IsDisabledControlPressed(0, 174) then
            if GetEntityHeading(me)+0.15 <= Config['Bowling']['Heading'][2] then
                SetEntityHeading(me, GetEntityHeading(me)+0.15)
            end
        elseif IsDisabledControlPressed(0, 175) then
            if GetEntityHeading(me)-0.15 >= Config['Bowling']['Heading'][1] then
                SetEntityHeading(me, GetEntityHeading(me)-0.15)
            end
        elseif IsDisabledControlJustReleased(0, 34) then
            if possibleCams[currentCam-1] then
                currentCam = currentCam - 1
            else
                currentCam = #possibleCams
            end
        elseif IsDisabledControlJustReleased(0, 35) then
            if possibleCams[currentCam+1] then
                currentCam = currentCam + 1
            else
                currentCam = 1
            end
        elseif IsDisabledControlJustReleased(0, 24) then
            loadDict(dict)
            TaskPlayAnim(me, dict, 'throw_l_fb_stand', 8.0, -8.0, -1, 17, 0, false, false, false)
            local timer = GetGameTimer() + 150
            while timer >= GetGameTimer() do Wait(0) for i = 0, 31 do DisableAllControlActions(i) end end
            DetachEntity(ball)
            SetEntityHeading(ball, GetEntityHeading(me))
            SetEntityVelocity(ball, GetEntityForwardX(ball) * (25 + (force/10)), GetEntityForwardY(ball) * (25 + (force/10)), 0.0)
            ClearPedTasks(me)

            loadDict(dict)
            TaskPlayAnim(me, dict, 'aimlive_l', 8.0, -8.0, -1, 17, 0, false, false, false)
            timer = GetGameTimer() + 7500

            local cam2 = CreateCam('DEFAULT_SCRIPTED_Camera', 1)
            SetCamCoord(cam2, GetOffsetFromEntityInWorldCoords(pins[1], 0.0, 0.5, 2.5))
            PointCamAtCoord(cam2, GetEntityCoords(pins[1]))
            SetCamActiveWithInterp(cam2, cam, 3000, false, false)
            while timer >= GetGameTimer() do 
                Wait(0) 
                for i = 0, 31 do DisableAllControlActions(i) end 
            end
            DestroyCam(cam2)
            AttachEntityToEntity(ball, me, GetPedBoneIndex(me, 57005), 0.09, 0.03, -0.02, -78.0, 13.0, 28.0, false, true, true, true, 0, true)
            SetCamActive(cam, true)
            RenderScriptCams(1, 0, 0, 1, 1)

            local pinsDown = 0
            for k, v in pairs(pins) do
                if not ((GetEntityRotation(v).x <= 0.1 and GetEntityRotation(v).y >= -0.1) and (GetEntityRotation(v).y <= 0.1 and GetEntityRotation(v).y >= -0.1) and (GetEntityRotation(v).z <= 0.1 and GetEntityRotation(v).z >= -0.1)) then
                    pinsDown = pinsDown + 1
                end
                if secondTry then
                    DeleteEntity(v)
                end
            end

            if secondTry then
                pins = {}
                for k, v in pairs(Config['Bowling']['BowlingPinSets'][chosenTrack]) do
                    local pin = createObject('prop_bowling_pin', v)
                    SetEntityHeading(pin, 0.0)
                    SetEntityAsMissionEntity(pin, true, true)
                    table.insert(pins, pin)
                end
            end

            if pinsDown == #Config['Bowling']['BowlingPinSets'][chosenTrack] then
                if secondTry then
                    secondTry = false
                    wastedMsg(Strings['spare'][1], Strings['spare'][2], 3000)
                else
                    for k, v in pairs(pins) do DeleteEntity(v) end
                    pins = {}
                    for k, v in pairs(Config['Bowling']['BowlingPinSets'][chosenTrack]) do
                        local pin = createObject('prop_bowling_pin', v)
                        SetEntityHeading(pin, 0.0)
                        SetEntityAsMissionEntity(pin, true, true)
                        table.insert(pins, pin)
                    end
                    wastedMsg(Strings['strike'][1], Strings['strike'][2], 3000)
                end
            else
                if secondTry then
                    wastedMsg(Strings['x_pinsdown'][1], (Strings['x_pinsdown'][2]):format(pinsDown, #Config['Bowling']['BowlingPinSets'][chosenTrack]), 2000)
                    secondTry = false
                else
                    secondTry = true
                end
            end

        elseif IsDisabledControlJustReleased(0, 194) then
            DeleteEntity(ball)
            break
        elseif IsDisabledControlPressed(0, 172) then
            if force < 100.0 then
                force = force + 0.1
            end
        elseif IsDisabledControlPressed(0, 173) then
            if force > 0.1 then
                force = force - 0.1
            end
        end

        DrawMissionText((Strings['force']):format(math.floor(force*10)/10))
        Wait(0)
    end
    RenderScriptCams(false, false, 0, true, false)
    DestroyCam(cam, false)
    ClearPedTasks(me)
    TriggerServerEvent('landlife_bowling:end', chosenTrack)
    for k, v in pairs(pins) do DeleteEntity(v) end
    bowling = false
end)

function wastedMsg(title, text, time)
    local scaleform = RequestScaleformMovie('mp_big_message_freemode')
    while not HasScaleformMovieLoaded(scaleform) do Wait(0) end
        
    BeginScaleformMovieMethod(scaleform, 'SHOW_SHARD_WASTED_MP_MESSAGE')
    PushScaleformMovieMethodParameterString(title)
    PushScaleformMovieMethodParameterString(text)
    EndScaleformMovieMethod()
        
    local timer = GetGameTimer() + time
    while GetGameTimer() <= timer do
        Wait(0)
        DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
    end
end

function createObject(object, coords)
    local model = GetHashKey(object)
    while not HasModelLoaded(model) do
        Wait(0)
        RequestModel(model)
    end
    return CreateObject(model, coords, true, false)
end

function loadDict(dict, anim)
    while not HasAnimDictLoaded(dict) do
        Wait(0)
        RequestAnimDict(dict)
    end
    return dict
end

function DisplayNotification(msg)
    SetTextComponentFormat("jamyfafi")
	AddTextComponentString(msg)
	DisplayHelpTextFromStringLabel(0, 0, init, -1)
end

function notify(msg)
    SetNotificationTextEntry('STRING')
	AddTextComponentSubstringPlayerName(msg)
    DrawNotification(false, true)
end

function DrawMissionText(text, time)
    ClearPrints()
    SetTextEntry_2("STRING")
    AddTextComponentString(text)
    DrawSubtitleTimed(time, 1)
end

function ButtonMessageFishing(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function SetupScaleform(text1, touche1, text2, touche2, text3, touche3, text4, touche4)
    local scaleform = RequestScaleformMovie("instructional_buttons")

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(1, touche1, true))
    ButtonMessageFishing(text1)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(2)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, touche2, true))
    ButtonMessageFishing(text2)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(3)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(3, touche3, true))
    ButtonMessageFishing(text3)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(4)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(4, touche4, true))
    ButtonMessageFishing(text4)
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