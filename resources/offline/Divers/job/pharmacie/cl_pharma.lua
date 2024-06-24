local PlayerData = {}

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

local Pharma = {}

Pharma.openedMenu = false 
Pharma.mainMenu = RageUI.CreateMenu("Pharmacie", "Pharmacie")
Pharma.mainMenu:SetRectangleBanner(4, 169, 22, 70)
Pharma.mainMenu.Closed = function()
    Pharma.openedMenu = false 
end

function openPharma()
    if Pharma.openedMenu then
        Pharma.openedMenu = false
        RageUI.Visible(Pharma.mainMenu, false)
    else
        Pharma.openedMenu = true
        RageUI.Visible(Pharma.mainMenu, true)
            CreateThread(function()
                while Pharma.openedMenu do
                    RageUI.IsVisible(Pharma.mainMenu, function()
                        RageUI.Button("Annonce", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local input = ESX.KeyboardInput("Annonce", 50)
                                if input ~= nil and #input > 5 then
                                    TriggerServerEvent("annoncePharma", input)
                                else 
                                    ESX.ShowNotification("~r~Vous devez insérer plus de caractères~w~ (~o~5mininum~w~)~r~.")
                                end
                            end
                        })
                    end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent("pharmaMenu")
AddEventHandler("pharmaMenu", function()
    openPharma()
end)