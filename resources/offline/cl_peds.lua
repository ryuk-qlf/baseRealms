function CreateAllPed(hash, coords, anim)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end
    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetEntityInvincible(ped, true)
    SetPedAlertness(ped, 0.0)
    FreezeEntityPosition(ped, true) 
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    if anim ~= nil then
        TaskStartScenarioInPlace(ped, anim, 0, 0)
    end
    return ped
end

local AllPeds = {
    {coords = vector4(-1097.48, -839.85, 18.00, 125.65), ped = "s_m_y_cop_01", name = "Sadam"},
    {coords = vector4(-1103.91, -827.88, 13.28, 221.01), ped = "s_f_y_cop_01", name = "Jan"},
    {coords = vector4(58.92, -1733.58, 28.30, 45.0), ped = "a_f_y_eastsa_03", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Cassandra"},
    {coords = vector4(1154.12, -386.01, 66.33, 78.48), ped = "csb_undercover", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Jeffrey"},
    {coords = vector4(243.74, 226.52, 105.3, 170.0), ped = "cs_bankman", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Bob"},
    {coords = vector4(483.25, -1325.19, 28.34, 27.42), ped = "cs_nervousron", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "William"},
    {coords = vector4(1722.16, 4734.80, 41.13, 282.61), ped = "mp_m_exarmy_01", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Dylan"},
    {coords = vector4(232.14, 365.22, 105.03, 164.26), ped = "a_m_y_vinewood_04", name = "Luc"},
    {coords = vector4(-828.72, -1085.63, 10.13, 217.20), ped = "cs_joeminuteman", anim = "WORLD_HUMAN_CLIPBOARD", name = "Tom"},
    {coords = vector4(-1128.95, 2692.57, 17.80, 47.76), ped = "a_m_m_eastsa_01", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Kevin"},
    {coords = vector4(-1371.02, -460.47, 33.47, 13.39), ped = "cs_lestercrest", anim = "WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT", name = "Lester"},
    {coords = vector4(-867.63, -1274.91, 4.15, 242.41), ped = "ig_josh", name = "Gérard"},
}

function DrawText3D(x, y, z, text, distance, v3)
    local dist = distance or 7
    local aze, zea, aez = table.unpack(GetGameplayCamCoords())
    local plyCoords = GetEntityCoords(PlayerPedId())
    distance = GetDistanceBetweenCoords(aze, zea, aez, x, y, z, 1)
    local Text3D = GetDistanceBetweenCoords((plyCoords), x, y, z, 1) - 1.65
    local scale, fov = ((1 / distance) * (dist * .7)) * (1 / GetGameplayCamFov()) * 100, 255;
    if Text3D < dist then
        fov = math.floor(255 * ((dist - Text3D) / dist))
    elseif Text3D >= dist then
        fov = 0
    end
    fov = v3 or fov
    SetTextFont(0)
    SetTextScale(.0 * scale, .1 * scale)
    SetTextColour(255, 255, 255, math.max(0, math.min(255, fov)))
    SetTextCentre(1)
    SetDrawOrigin(x, y, z, 0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(0.0, 0.0)
    ClearDrawOrigin()
end

Citizen.CreateThread(function()    
    for k, v in pairs(AllPeds) do
        CreateAllPed(v.ped, v.coords, v.anim)
    end

    local time = 900

    while true do
        for k, v in pairs(AllPeds) do
            local coords = GetEntityCoords(PlayerPedId(), false)
            local position = GetDistanceBetweenCoords(coords, v.coords, true)
            if position <= 25 then
                time = 5
                DrawText3D(v.coords.x, v.coords.y, v.coords.z+1.91, v.name)
            end
        end
        Wait(time)
    end
end)

RegisterCommand('sync', function()
    TriggerServerEvent('syncPlayer')
end)