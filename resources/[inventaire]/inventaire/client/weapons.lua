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

local currentWeapon = false
local canfire = false

local ItemShooting = false
local noWeaponBox = false
local Prop = {}

RegisterNetEvent('WeaponItem:useWeapon')
AddEventHandler('WeaponItem:useWeapon', function(weapon)
    if not IsPedInAnyVehicle(PlayerPedId()) and not noWeaponBox then
        if currentWeapon == weapon then
            RemoveWeapon(currentWeapon)
            currentWeapon = nil
        else
            currentWeapon = weapon
            GiveWeapon(currentWeapon)
            if weapon == "WEAPON_BRIEFCASE_02" then
                TriggerServerEvent("Malette", 1)
            elseif weapon == "WEAPON_BRIEFCASE" then
                TriggerServerEvent("Malette", 2)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if canfire then
            DisableControlAction(0, 25, true)
            DisablePlayerFiring(PlayerPedId(), true)
        end

        local weaponSelected = GetSelectedPedWeapon(PlayerPedId())

        if weaponSelected ~= GetHashKey("weapon_unarmed") then
            if GetHashKey(currentWeapon) ~= weaponSelected then
                RemoveAllPedWeapons(PlayerPedId(), false)
            end
        end
    end
end)

function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end

RegisterNetEvent('useGantsBox')
AddEventHandler('useGantsBox', function()
    local playerPed = PlayerPedId()
    useGants = not useGants
    if useGants then
        noWeaponBox = true
        local Model = GetHashKey("prop_boxing_glove_01")
        local Ped = GetPlayerPed(-1)
        local PedCoords = GetEntityCoords(Ped)
        local gants1 = CreateObject(Model, PedCoords, 1, 0, 0)
        local gants2 = CreateObject(Model, PedCoords, 1, 0, 0)
        Prop.Gant1 = AttachEntityToEntity(gants1, Ped, GetPedBoneIndex(Ped, 6286), vector3(-0.1, 0.01, -0.01), vector3(90.0, 0.0, 90.0), 0, 0, 1, 0, 0, 1)
        Prop.Gant2 = AttachEntityToEntity(gants2, Ped, GetPedBoneIndex(Ped, 36029), vector3(-0.1, 0.02, 0.02), vector3(-90.0, 0.0, -90.0), 0, 0, 1, 0, 0, 1)
        SetEntityCollision(Prop.Gant1, false, true)
        SetEntityCollision(Prop.Gant2, false, true)
        GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
        ESX.ShowNotification("Vous avez équipé ~g~vos gants de boxe~w~.")
    else
        noWeaponBox = false
        DeleteEntity(Prop.Gant1)
        DeleteEntity(Prop.Gant2)
    end
end)

RegisterNetEvent('ToggleCamWeazel')
AddEventHandler('ToggleCamWeazel', function()
    local playerPed = PlayerPedId()
    local camModel = "prop_v_cam_01"

    useCam = not useCam
    if useCam then
        noWeaponBox = true
        RequestModel(GetHashKey(camModel))
        while not HasModelLoaded(GetHashKey(camModel)) do
            Citizen.Wait(100)
        end
		
        GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local camera = CreateObject(GetHashKey(camModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Prop.CameraWeazel = AttachEntityToEntity(camera, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        loadAnimDict("missfinale_c2mcs_1")
        TaskPlayAnim(playerPed, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 1.0, -1, -1, 50, 0, 0, 0, 0)
        ESX.ShowNotification("Vous avez équipé ~g~votre caméra~w~.")
    else
        noWeaponBox = false
        ClearPedTasks(playerPed)
        DetachEntity(Prop.CameraWeazel)
        DeleteEntity(Prop.CameraWeazel)
    end
end)

RegisterNetEvent('ToggleMicroWeazel')
AddEventHandler('ToggleMicroWeazel', function()
    local playerPed = PlayerPedId()
    local micModel = "p_ing_microphonel_01"

    useMicro = not useMicro
    if useMicro then
        noWeaponBox = true
        RequestModel(GetHashKey(micModel))
        while not HasModelLoaded(GetHashKey(micModel)) do
            Citizen.Wait(100)
        end
		
        GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local micro = CreateObject(GetHashKey(micModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
        Prop.MicroWeazel = AttachEntityToEntity(micro, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 60309), 0.055, 0.05, 0.0, 240.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        ESX.ShowNotification("Vous avez équipé ~g~votre micro~w~.")
    else
        noWeaponBox = false
        ClearPedTasks(playerPed)
        DetachEntity(Prop.MicroWeazel)
        DeleteEntity(Prop.MicroWeazel)
    end
end)

RegisterNetEvent('ToggleMicroPercheWeazel')
AddEventHandler('ToggleMicroPercheWeazel', function()
    local playerPed = PlayerPedId()
    local bmicModel = "prop_v_bmike_01"

    useMicroPerche = not useMicroPerche
    if useMicroPerche then
        noWeaponBox = true
        RequestModel(GetHashKey(bmicModel))
        while not HasModelLoaded(GetHashKey(bmicModel)) do
            Citizen.Wait(100)
        end
		
        GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
        local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
        local microPerche = CreateObject(GetHashKey(bmicModel), plyCoords.x, plyCoords.y, plyCoords.z, true, true, false)
        Prop.MicroPercheWeazel = AttachEntityToEntity(microPerche, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 28422), -0.08, 0.0, 0.0, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
        loadAnimDict("missfra1")
        TaskPlayAnim(playerPed, "missfra1", "mcs2_crew_idle_m_boom", 1.0, -1, -1, 50, 0, 0, 0, 0)
        ESX.ShowNotification("Vous avez équipé ~g~votre micro perche~w~.")
    else
        noWeaponBox = false
        ClearPedTasks(playerPed)
        DetachEntity(Prop.MicroPercheWeazel)
        DeleteEntity(Prop.MicroPercheWeazel)
    end
end)

function RemoveWeapon(weapon)
    if weapon == "WEAPON_BRIEFCASE" or "WEAPON_BRIEFCASE_02" then
        TriggerServerEvent("Malette", 3)
    end
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local playerPed = PlayerPedId()

        ItemShooting = false
        GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
    end
end

local ListItemShooting = {
    0x497FACC3,
    0x24B17070,
    0x34A67B97,
    0x787F0BB,
    0x23C9F95C,
}

local ListWeaponsAnim = {
	'WEAPON_PISTOL',
    'WEAPON_APPISTOL',
    'WEAPON_PISTOL50',
    'WEAPON_REVOLVER',
    'WEAPON_SNSPISTOL',
    'WEAPON_HEAVYPISTOL',
    'WEAPON_VINTAGEPISTOL',
    'WEAPON_DOUBLEACTION',
    'WEAPON_COMBATPISTOL'
}

function GiveWeapon(weapon)
    if not IsPedInAnyVehicle(PlayerPedId(), false) then
        local playerPed = PlayerPedId()
        local hash = GetHashKey(weapon)
        local label = ESX.GetWeaponLabel(weapon)

        if label ~= nil then
            ESX.Notification("Vous avez équipé votre ~g~'"..label.."'~s~")
        end

        if PlayerData.job and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "uss" then
            for k,v in pairs(ListWeaponsAnim) do
                if weapon == v then
                    canfire = true
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    loadAnimDict("reaction@intimidation@1h")
                    TaskPlayAnimAdvanced(playerPed, "reaction@intimidation@1h", "intro", GetEntityCoords(playerPed, true), 0, 0, GetEntityHeading(playerPed), 8.0, 3.0, 2500, 50, 0, 0, 0)
                    Wait(800)
                end
            end
        end

        if 0x497FACC3 == hash then
            GiveWeaponToPed(playerPed, hash, 1, false, true)

            ItemShooting = true
            while ItemShooting do
                Wait(1)
                if IsPedShooting(PlayerPedId()) then
                    TriggerServerEvent('WeaponItem:removeItem', weapon)
                    Wait(150)
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    currentWeapon = nil
                    ItemShooting = false
                end
            end
        elseif 0x24B17070 == hash then
            GiveWeaponToPed(playerPed, hash, 1, false, true)

            ItemShooting = true
            while ItemShooting do
                Wait(1)
                if IsPedShooting(PlayerPedId()) then
                    TriggerServerEvent('WeaponItem:removeItem', weapon)
                    Wait(150)
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    currentWeapon = nil
                    ItemShooting = false
                end
            end
        elseif 0x34A67B97 == hash then
            GiveWeaponToPed(playerPed, hash, 1000, false, true)

            ItemShooting = true
            while ItemShooting do
                Wait(1)
                if IsPedShooting(PlayerPedId()) then
                    TriggerServerEvent('WeaponItem:removeItem', weapon)
                    Wait(150)
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    currentWeapon = nil
                    ItemShooting = false
                end
            end
        elseif 0x787F0BB == hash then
            GiveWeaponToPed(playerPed, hash, 1, false, true)

            ItemShooting = true
            while ItemShooting do
                Wait(1)
                if IsPedShooting(PlayerPedId()) then
                    TriggerServerEvent('WeaponItem:removeItem', weapon)
                    Wait(150)
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    currentWeapon = nil
                    ItemShooting = false
                end
            end
        elseif 0x23C9F95C == hash then
            GiveWeaponToPed(playerPed, hash, 1, false, true)
            
            ItemShooting = true
            while ItemShooting do
                Wait(1)
                if IsPedShooting(PlayerPedId()) then
                    TriggerServerEvent('WeaponItem:removeItem', weapon)
                    Wait(150)
                    GiveWeaponToPed(playerPed, "weapon_unarmed", 0, false, true)
                    currentWeapon = nil
                    ItemShooting = false
                end
            end
        else
            GiveWeaponToPed(playerPed, hash, 0, false, true)
            TriggerEvent("AddAmmoInWeapon")
            if canfire then
                Wait(1500)
                canfire = false
            end
        end
    end
end

RegisterNetEvent('WeaponItem:useWeaponFlashlight')
AddEventHandler('WeaponItem:useWeaponFlashlight', function()
    local pPed = PlayerPedId()
    local currentWeaponHash = GetSelectedPedWeapon(pPed)

    if currentWeaponHash == GetHashKey("WEAPON_PISTOL") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_PISTOL').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_PISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
        end
    elseif currentWeaponHash == GetHashKey("WEAPON_COMBATPISTOL") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_COMBATPISTOL').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_COMBATPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
        end
    elseif currentWeaponHash == GetHashKey("WEAPON_PISTOL50") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_PISTOL50').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_PISTOL50"), GetHashKey("COMPONENT_AT_PI_FLSH"))
        end
    elseif currentWeaponHash == GetHashKey("WEAPON_HEAVYPISTOL") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_HEAVYPISTOL').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_HEAVYPISTOL"), GetHashKey("COMPONENT_AT_PI_FLSH"))
        end
    elseif currentWeaponHash == GetHashKey("WEAPON_SMG") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_SMG').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_SMG"), GetHashKey("COMPONENT_AT_AR_FLSH"))
        end
    elseif currentWeaponHash == GetHashKey("WEAPON_CARBINERIFLE") then
        if not HasPedGotWeaponComponent(pPed, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH")) then
            GiveWeaponComponentToPed(pPed, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))  

            ESX.ShowNotification("Vous avez équipé votre lampe sur votre ~g~'"..ESX.GetWeaponLabel('WEAPON_CARBINERIFLE').."'~s~")
        else
            RemoveWeaponComponentFromPed(pPed, GetHashKey("WEAPON_CARBINERIFLE"), GetHashKey("COMPONENT_AT_AR_FLSH"))
        end
    end
end)