ESX = nil

local Drugs = {}
Drugs.Position = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
    end

    while Drugs.Position == nil do
        Wait(1000)
        ESX.TriggerServerCallback("GetPositionDrugs", function(cb)
            Drugs.recGrainecanna = cb.recGrainecanna
            Drugs.traitGrainecanna = cb.traitGrainecanna
            Drugs.recGrainecoca = cb.recGrainecoca
            Drugs.recMethylamine = cb.recMethylamine
            Drugs.recAcidesulfurique = cb.recAcidesulfurique
            Drugs.recPhosphorerouge = cb.recPhosphorerouge
            Drugs.Position = true
        end)
		Citizen.Wait(10)
	end
end)

local inFarm = false

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if Drugs.Position ~= nil then
            local coords = GetEntityCoords(PlayerPedId(), false)
            local recGrainecanna = GetDistanceBetweenCoords(coords, Drugs.recGrainecanna, true)
            local traitGrainecanna = GetDistanceBetweenCoords(coords, Drugs.traitGrainecanna, true)
            local recGrainecoca = GetDistanceBetweenCoords(coords, Drugs.recGrainecoca, true)
            local recMethylamine = GetDistanceBetweenCoords(coords, Drugs.recMethylamine, true)
            local recAcidesulfurique = GetDistanceBetweenCoords(coords, Drugs.recAcidesulfurique, true)
            local recPhosphorerouge = GetDistanceBetweenCoords(coords, Drugs.recPhosphorerouge, true)

            --if PlayerData.job and PlayerData.job.name ~= "police" and PlayerData.job.name ~= "ems" then
                if recGrainecanna <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startFarmMatiere', "cannabis_graine")
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                elseif traitGrainecanna <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startTraitMatiere', "cannabis_plant", "cannabis_graine", 'matière')
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                elseif recGrainecoca <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startFarmMatiere', "coca")
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                elseif recMethylamine <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startFarmMatiere', "sodium_hydroxide")
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                elseif recAcidesulfurique <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startFarmMatiere', "acide")
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                elseif recPhosphorerouge <= 25 then
                    wait = 1
                    if not inFarm then
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                        if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                            inFarm = true
                            TriggerServerEvent('entreprise:startFarmMatiere', "red_phosphore")
                        end
                    elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                        wait = 5500
                    end
                else
                    if inFarm then
                        inFarm = false
                        TriggerServerEvent('entreprise:stopFarm')
                    end
                    wait = 5500
                end
            --end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('entreprise:stopFarm')
AddEventHandler('entreprise:stopFarm', function()
    inFarm = false
end)