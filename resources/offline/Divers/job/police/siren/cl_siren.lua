local instructionals = {}

function SetInstructionalButton(text, control, toggle)
    if toggle then
        if not instructionals[text] then
            instructionals[text] = true
            SetInstructionalButton(text, control, toggle)
        end
    else
        if instructionals[text] then
            instructionals[text] = false
            SetInstructionalButton(text, control, toggle)
        end
    end
end

local function ButtonMessage(text)
    BeginTextCommandScaleformString(text)
    EndTextCommandScaleformString()
end

local function Button(ControlButton)
    N_0xe83a3e3557a56640(ControlButton)
end

local function setupScaleform(scaleform, data)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end
    
    DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 0, 0)
    
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    for n, btn in next, data do
        PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
        PushScaleformMovieFunctionParameterInt(n-1)
        Button(GetControlInstructionalButton(2, btn.control, true))
        ButtonMessage(btn.name)
        PopScaleformMovieFunctionVoid()
    end

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

local form = nil
local data = {}

local entries = {}

function SetInstructions()
    form = setupScaleform("instructional_buttons", entries)
end

function SetInstructionalButton(name, control, enabled)
    local found = false
    for k, entry in next, entries do
        if entry.name == name and entry.control == control then
            found = true
            if not enabled then
                table.remove(entries, k)
                SetInstructions()
            end
            break
        end
    end
    if not found then
        if enabled then
            table.insert(entries, {name = name, control = control})
            SetInstructions()
        end
    end
end

Citizen.CreateThread(function()
    while true do
        local time = 350
        if form then
            time = 1
            DrawScaleformMovieFullscreen(form, 255, 255, 255, 255, 0)
        else
            time = 350
        end
        Wait(0)
    end
end)

local entityEnumerator = {
    __gc = function(enum)
    if enum.destructor and enum.handle then
        enum.destructor(enum.handle)
    end
    enum.destructor = nil
    enum.handle = nil
end}
  
local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(function()
        local iter, id = initFunc()
        if not id or id == 0 then
            disposeFunc(iter)
            return
        end
  
        local enum = {handle = iter, destructor = disposeFunc}
        setmetatable(enum, entityEnumerator)
  
        local next = true
        repeat
            coroutine.yield(id)
            next, id = moveFunc(iter)
        until not next
  
        enum.destructor, enum.handle = nil, nil
        disposeFunc(iter)
    end)
end
  
function EnumerateVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

  local CONTROLS = {
    TOGGLE = {"", 19 --[[INPUT_VEH_CIN_CAM]]},
    ENABLE = {"Activer les sirènes", 19 --[[INPUT_VEH_CIN_CAM]]},
    DISABLE = {"Éteindre les sirènes", 19 --[[INPUT_VEH_CIN_CAM]]},
    LIGHTS = {"Éteindre les Gyrophares", 86 --[[INPUT_VEH_HORN]]},
}

Citizen.CreateThread(function()
    local Wait = Wait
    local GetVehiclePedIsUsing = GetVehiclePedIsUsing
    local PlayerPedId = PlayerPedId
    local IsVehicleSirenOn = IsVehicleSirenOn
    local DisableControlAction = DisableControlAction
    local IsDisabledControlJustPressed = IsDisabledControlJustPressed
    local DecorExistOn = DecorExistOn
    local DecorGetBool = DecorGetBool
    local DecorSetBool = DecorSetBool
    local PlaySoundFrontend = PlaySoundFrontend

    AddTextEntry("ESC_ENABLE", CONTROLS['ENABLE'][1])
    AddTextEntry("ESC_DISABLE", CONTROLS['DISABLE'][1])
    AddTextEntry("ESC_LIGHTS", CONTROLS['LIGHTS'][1])

    DecorRegister("esc_siren_enabled", 2)
    DecorRegisterLock()
    while true do
        Wait(10)
        local veh = GetVehiclePedIsUsing(PlayerPedId())
        if veh then
            if IsVehicleSirenOn(veh) then
                DisableControlAction(0, CONTROLS['TOGGLE'][2], true)
                SetInstructionalButton("ESC_LIGHTS", CONTROLS['LIGHTS'][2], true)
                if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                    SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], false)
                    SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], true)
                    if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
                        DecorSetBool(veh, "esc_siren_enabled", false)
                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    end
                else
                    SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], true)
                    SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], false)
                    if IsDisabledControlJustPressed(0, CONTROLS['TOGGLE'][2]) then
                        DecorSetBool(veh, "esc_siren_enabled", true)
                        PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
                    end
                end
            else
                SetInstructionalButton("ESC_ENABLE", CONTROLS['ENABLE'][2], false)
                SetInstructionalButton("ESC_DISABLE", CONTROLS['DISABLE'][2], false)
                SetInstructionalButton("ESC_LIGHTS", CONTROLS['LIGHTS'][2], false)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        if IsPedInAnyVehicle(PlayerPedId(), false) then
            time = 10
            for veh in EnumerateVehicles() do
                if DecorExistOn(veh, "esc_siren_enabled") and DecorGetBool(veh, "esc_siren_enabled") then
                    DisableVehicleImpactExplosionActivation(veh, false)
                else
                    DisableVehicleImpactExplosionActivation(veh, true)
                end
            end
        else
            time = 1000
        end
        Wait(time)
    end
end)