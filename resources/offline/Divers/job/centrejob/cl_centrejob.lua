ESX = nil

local CentreJob = {}
CentreJob.Diamond = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
    end

    while CentreJob.Diamond == nil do
        Wait(1000)
        ESX.TriggerServerCallback("GetDiamondJob", function(cb)
            CentreJob.Diamond = cb
        end)
		Citizen.Wait(10)
	end
end)

CentreJob.openedMenu = false
CentreJob.mainMenu = RageUI.CreateMenu("Centre des Métiers", "Centre des Métiers")
CentreJob.mainMenu.Closed = function()
    CentreJob.openedMenu = false 
end

function CentreMetier()
    RageUI.CloseAll()
    if CentreJob.openedMenu then
        CentreJob.openedMenu = false
        RageUI.Visible(CentreJob.mainMenu, false)
    else
        CentreJob.openedMenu = true
        RageUI.Visible(CentreJob.mainMenu, true)
            CreateThread(function()
                while CentreJob.openedMenu do
                    RageUI.IsVisible(CentreJob.mainMenu, function()
                        if CentreJob.Diamond then
                            RageUI.Button("Tatoueur", nil, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("SetJobCenter", "tatoueur")
                                end
                            })
                        else
                            RageUI.Button("Tatoueur", nil, {}, false, {})
                        end
                        if CentreJob.Diamond then
                            RageUI.Button("Barber", nil, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("SetJobCenter", "barber")
                                end
                            })
                        else
                            RageUI.Button("Barber", nil, {}, false, {})
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
        if CentreJob.Diamond ~= nil then         
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), false), -867.63, -1274.91, 4.15, true) <= 2 then
                wait = 1
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~parler à Gérard~s~.")
                if IsControlJustPressed(0, 51) then
                    CentreMetier()
                end
            else
                if CentreJob.openedMenu then
                    RageUI.CloseAll()
                    CentreJob.openedMenu = false
                end
            end
        end
        Wait(wait)
    end
end)