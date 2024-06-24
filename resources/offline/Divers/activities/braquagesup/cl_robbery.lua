ESX = nil

PlayerData = {}

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj PlayerData = ESX.GetPlayerData() end) 

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

Robbery = {}

Robbery.chance = {1, 5} -- chance thad you get when you have bad weapons

Robbery.timeinterval = 5000 --- time between every non accepted robbery minimom 5000

Robbery.shops = {
    {coords = vector3(1164.94, -323.76, 68.2), heading = 100.0, packet = {10, 12}, ped = 0x4F46D607, rbs = false},
    {coords = vector3(372.85, 328.10, 102.56), heading = 266.0, packet = {10, 12}, ped = 0x61D201B3, rbs = false},
    {coords = vector3(1134.24, -983.14, 45.41), heading = 266.0, packet = {10, 12}, ped = 0x278C8CB7, rbs = false},
    {coords = vector3(-1221.40, -908.02, 11.32), heading = 40.0, packet = {10, 12}, ped = 0x893D6805, rbs = false},
    {coords = vector3(1728.62, 6416.81, 34.03), heading = 240.0, packet = {10, 12}, ped = 0x2DADF4AA, rbs = false},
    {coords = vector3(1959.16, 3741.52, 31.34), heading = 290.0, packet = {10, 12}, ped = 0x94562DD7, rbs = false},
    {coords = vector3(-2966.37, 391.57, 15.04), heading = 100.0, packet = {10, 12}, ped = 0x36E70600, rbs = false},
    {coords = vector3(-1486.51, -377.51, 40.16), heading = 133.0, packet = {10, 12}, ped = 0x1AF6542C, rbs = false},
}

local objeto = {}
local objetos = {}
local holdup = false
local moneypack = false
local count = nil

peds = {}

function CreatePedRobbery(hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end
    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityHeading(ped, heading)
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
    return ped
end

Citizen.CreateThread(function()    
    for k, v in pairs(Robbery.shops) do
        peds[k] = CreatePedRobbery(v.ped, v.coords, v.heading)
    end
	while true do
		Wait(500)
        local ped = PlayerPedId()
        local pos =  GetEntityCoords(ped)
		for k, v in pairs(peds) do
            local dist = Vdist(pos, GetEntityCoords(peds[k]))    
		    if dist < 5 and not IsPedDeadOrDying(peds[k]) then
                if Robbery.shops[k].rbs == false then 

                    if IsPedArmed(ped, 4) and IsControlPressed(0, 25) and not holdup then
                        if PlayerData.job and PlayerData.job.name ~= "police" then 
                            count = math.random(Robbery.shops[k].packet[1], Robbery.shops[k].packet[2])
                            PedClear = k
                            StartBraquage(k)
                        end
                    end
                    
                    if IsPedArmed(ped, 1) and IsControlPressed(0, 25) and not holdup then 
                        local chance = math.random(Robbery.chance[1], Robbery.chance[2])

                        if chance ~= 1 then 
                            if PlayerData.job and PlayerData.job.name ~= "police" then 
                                count = math.random(Robbery.shops[k].packet[1], Robbery.shops[k].packet[2])
                                PedClear = k
                                StartBraquage(k) 
                            end
                        else
                            GiveWeaponToPed(peds[k], GetHashKey("WEAPON_PISTOL"), 500, true, true)
                            Wait(5500)
                            TaskSetBlockingOfNonTemporaryEvents(peds[k], true)
                            TaskShootAtEntity(peds[k], GetPlayerPed(-1), Robbery.timeinterval,  GetHashKey("FIRING_PATTERN_FULL_AUTO"))
                            SetPedAccuracy(peds[k], 0.01)
                            Wait(Robbery.timeinterval)
                            RemoveAllPedWeapons(peds[k], true)
                        end 
                    end
                end
            end 
		end 
	end
end)

Citizen.CreateThread(function()
    while true do 
        time = 500
        if holdup then 
            time = 0
            local pos =  GetEntityCoords(PlayerPedId())
            local dist = GetDistanceBetweenCoords(pos, GetEntityCoords(currentPed), true)
            if dist > 15.0 then
                stopbraquage(PedClear)
                ClearPedTasks(currentPed)
                ESX.DrawMissionText("~r~Vous êtes parti du magasin.", 3500)
            end 
        end 
        Wait(time)
    end 
end)

function StartBraquage(result)
    if not holdup then
        ESX.TriggerServerCallback('JobInService', function(count)
            if count >= 0 then
                ESX.TriggerServerCallback("GetTimeForBraq", function(results)
                    if results then
                        TriggerServerEvent("addTimeToBraq")
                        TriggerServerEvent("call:makeCallSpecial", "police", GetEntityCoords(PlayerPedId()), "Braquage de superette")
                        braquage(result)
                    else
                        ESX.ShowNotification("~r~Vous avez déjà braqué une superette.")
                    end
                end)
            else
                ESX.ShowNotification("~r~Impossible aucun policier en service.")
            end
        end, "police")
    end
end

function braquage(result)
    if count ~= 0 and not holdup then
        currentPed = peds[result]
        holdup = true
        RequestAnimDict('mp_am_hold_up')
        while not HasAnimDictLoaded('mp_am_hold_up') do
            Wait(10)
        end
        TaskPlayAnim(peds[result], "mp_am_hold_up", "handsup_base", 8.0, -4.0, -1, 1, 0, 0, 0, 0)
        PlayAmbientSpeechWithVoice(peds[result], "SHOP_HURRYING", "MP_M_SHOPKEEP_01_PAKISTANI_MINI_01", "SPEECH_PARAMS_FORCE", 1)
        Citizen.Wait(16000)
        ClearPedTasks(peds[result])
        spawnmoneypack(result)
        
        moneypack = true
        count = count - 1 
 
        while moneypack do
            Wait(0)
            local pos = GetEntityCoords(PlayerPedId())
            local dist = Vdist(pos, Robbery.shops[result].coords) 
            if dist < 3 then
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~prendre l'argent")
                if IsControlPressed(0, 51) then 
                    ESX.Streaming.RequestAnimDict("random@domestic", function()
                        TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 8.0, -8.0, -1, 0, 0.0, false, false, false)
                    end)
                    PlaySound(-1, "PICK_UP", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    for k, v in pairs(objetos) do
                        DeleteObject(objetos[k].name)
                    end
                    moneypack = false
                    holdup = false
                    TriggerServerEvent('addsale')
                end
            end
        end
        braquage(result)
    else
        stopbraquage(result)
    end
end

RegisterNetEvent('allplayers_cldwn_cl')
AddEventHandler('allplayers_cldwn_cl', function(type, shop)
    if type == "start" then
        Robbery.shops[shop].rbs = true
    elseif type == "end" then 
        Robbery.shops[shop].rbs = false
    end
end)

function stopbraquage(result)
    TriggerServerEvent("startholdup", "end", result)
    holdup = false
    TriggerServerEvent("allplayers_cldwn", "end", result)
end

function spawnmoneypack(result)
    TaskPlayAnim(peds[result], "mp_am_hold_up","purchase_cigarette_shopkeeper", 8.0, -8.0, -1, 2, 0, false, false, false)
    objeto = CreateObject(GetHashKey("prop_anim_cash_pile_01"), Robbery.shops[result].coords, true, true, true)
    table.insert(objetos, {name = objeto})
    NetworkRegisterEntityAsNetworked(objeto) 
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(objeto, true))
    SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(objeto, true))
    SetEntityAsMissionEntity(objeto)
    AttachEntityToEntity(objeto, peds[result], GetPedBoneIndex(peds[result],  28422), 0.0, -0.03, 0.0, 90.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
    Wait(1500)
    DetachEntity(objeto, true, false)
end