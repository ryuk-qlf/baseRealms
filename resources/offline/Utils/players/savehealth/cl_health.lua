
ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('SetHealthAndArmour')
AddEventHandler('SetHealthAndArmour', function(health)
    local pPed = PlayerPedId()
    local HumeurBind = ESX.GetFieldValueFromName("OfflineHumeur")
    local DemarcheBind = ESX.GetFieldValueFromName("OfflineDemarche")

    SetEntityHealth(pPed, tonumber(health))

    if json.encode(HumeurBind) ~= "[]" then
        SetFacialIdleAnimOverride(pPed, HumeurBind, 0)
    end
    if json.encode(DemarcheBind) ~= "[]" then
        RequestAnimSet(DemarcheBind)
        while not HasAnimSetLoaded(DemarcheBind) do
            Citizen.Wait(100)
        end
        SetPedMovementClipset(pPed, DemarcheBind, 0)
    end
end)

AddEventHandler('skinchanger:modelLoaded', function()
    TriggerServerEvent('SetHealthAndArmourSpawn')
    TriggerEvent('skinchanger:change', 'bproof_1', 0)
    TriggerEvent('skinchanger:change', 'bproof_2', 0)
end)