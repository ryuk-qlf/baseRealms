local LsMotors = {}

LsMotors.openedMenu = false
LsMotors.mainMenu = RageUI.CreateMenu(" ", "Troc", nil, 150)
LsMotors.mainMenu.Closed = function()
    LsMotors.openedMenu = false 
end

LsMotors.mainMenu:DisplayHeader(false)

function TransformationMoteur()
    RageUI.CloseAll()
    if LsMotors.openedMenu then
        LsMotors.openedMenu = false
        RageUI.Visible(LsMotors.mainMenu, false)
    else
        LsMotors.openedMenu = true
        RageUI.Visible(LsMotors.mainMenu, true)
            CreateThread(function()
                while LsMotors.openedMenu do
                    RageUI.IsVisible(LsMotors.mainMenu, function()
                        RageUI.Button("Transformé en moteur", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("TransformationMoteur")
                            end
                        })
                    end)
                Wait(1)
            end
        end)
    end
end

local inFarm = false

Citizen.CreateThread(function()
    while true do
        local wait = 900
        local coords = GetEntityCoords(PlayerPedId(), false)
        local farmFer = GetDistanceBetweenCoords(coords, vector3(2052.66, 3192.07, 45.18), true)
        local traitementFer = GetDistanceBetweenCoords(coords, vector3(135.40, -375.03, 43.25), true)
        local pnjMoteur = GetDistanceBetweenCoords(coords, vector3(-1371.02, -460.47, 34.47), true)

        if PlayerData.job and PlayerData.job.name == "motors&co" then
            if farmFer <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        TriggerServerEvent('entreprise:startFarm', "fer")
                        inFarm = true
                    end
                elseif IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    inFarm = false
                    TriggerServerEvent('entreprise:stopFarm')
                    wait = 5500
                end
            elseif traitementFer <= 25 then
                wait = 1
                if not inFarm then
                    DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                    if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                        inFarm = true
                        TriggerServerEvent('entreprise:startTrait', "fertraiter", "fer", 'motors&co')
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

            if pnjMoteur <= 5 then
                wait = 1
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~g~commencer~s~.")
                if IsControlJustPressed(1, 51) and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                    TransformationMoteur()
                end
            else
                if LsMotors.openedMenu then
                    LsMotors.openedMenu = false
                    RageUI.CloseAll()
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent('entreprise:stopFarm')
AddEventHandler('entreprise:stopFarm', function()
    inFarm = false
end)