function GetGroundHash()
	local posped = GetEntityCoords(PlayerPedId())
	local num = StartShapeTestCapsule(posped.x,posped.y,posped.z+4,posped.x,posped.y,posped.z-2.0, 2, 1, PlayerPedId(), 7)
	local arg1, arg2, arg3, arg4, arg5, arg6 = GetShapeTestResultEx(num)
	return arg5
end

local PosFarmPelle = {
    {x = -2393.949, y = 2572.23, z = 1.04},
}

RegisterNetEvent('UsePelle')
AddEventHandler('UsePelle', function()
    for k in pairs(PosFarmPelle) do

        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, PosFarmPelle[k].x, PosFarmPelle[k].y, PosFarmPelle[k].z)

        if dist <= 1100.5 then
            if not IsPedInAnyVehicle(ped, false) and not IsPedSwimming(ped) then
                if GetGroundHash() == 3008270349 or GetGroundHash() == 3833216577 or GetGroundHash() == 1333033863 or GetGroundHash() == 1109728704 or GetGroundHash() == 3594309083 or GetGroundHash() == 1144315879 or GetGroundHash() == 2128369009 or GetGroundHash() == 223086562 or GetGroundHash() == 1584636462 or GetGroundHash() == -700658213 then
                    Shovel()
                else
                    ESX.ShowNotification('~r~Impossible de creuser vous devez aller sur de la terre.')
                end
            end
        else
            ESX.ShowNotification("~r~Impossible de creuser ici vous n'êtes pas dans la zone.")
        end
    end
end)

RegisterNetEvent('UseCasserole')
AddEventHandler('UseCasserole', function()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) and not IsPedSwimming(ped) then
        Casserole()
    end
end)

function Casserole()
    local playerPed = PlayerPedId()

    if IsEntityInWater(playerPed) then
        if not LookProgressBar() then
            local CasseroleModel = GetHashKey("prop_kitch_pot_lrg")
            local Model = CreateObject(CasseroleModel, GetEntityCoords(GetPlayerPed(-1))+GetEntityForwardVector(GetPlayerPed(-1))*0.7-vec3(0.0,0.0,1.0), true, true, true)   
            TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_BUM_WASH", 0, false)
            AddProgressBar("Action en cours", 0, 255, 185, 120, 15000)
            Wait(15000)
            TriggerServerEvent('qzdq-"éqzqzdfù*$^mdd$é"é&')
            DeleteEntity(Model)
            ClearPedTasks(playerPed)
            RemoveTimerBar()
        else
            ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
        end
    else
        ESX.ShowNotification("~r~Vous devez être dans l'eau pour réaliser cette action.")
    end
end

local pellebroken = 0

function Shovel()
    if not LookProgressBar() then
        pellebroken = pellebroken + 1
        local shovelModel = GetHashKey("prop_ld_shovel")
        local playerPed = PlayerPedId()
        local shovel = CreateObject(shovelModel, GetEntityCoords(playerPed), true, false, false)

        SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(shovel), false)
        SetCurrentPedWeapon(playerPed, GetHashKey("weapon_unarmed"), true)

        RequestAnimDict("random@burial")
        while not HasAnimDictLoaded("random@burial") do Citizen.Wait(0) end
        AddProgressBar("Vous êtes en train de creuser", 0, 255, 185, 120, 16000)
        TaskPlayAnim(playerPed, "random@burial", "a_burial", 8.0, -4.0, -1, 1, 0, 0, 0, 0);
        AttachEntityToEntity(shovel, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0, 0, 0, 0, 2, 1)
        Wait(16000)
        RemoveTimerBar()
        local random = math.random(1, 3)
        TriggerServerEvent("gefujjlzhbé^)mkjf:;n", 'terre', random)
        ClearPedTasks(playerPed)
        SetEntityDynamic(shovel, 0)
        DeleteEntity(shovel)
        if pellebroken >= 33 then 
            ESX.ShowNotification('~r~Vous avez brisé votre pelle.')
            pellebroken = 0
            TriggerServerEvent('removeDiversInventoryItem', 'pelle')
        end
    else
        ESX.ShowNotification("~r~Vous êtes déjà en train de réaliser une action.")
    end
end