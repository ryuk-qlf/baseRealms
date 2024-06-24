ESX = nil

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

local PositionLtd = {
	{comptoir = vector3(-706.09, -914.50, 19.21), deceler = vector3(-705.99, -904.84, 19.21), job = "ltd", notif = "LTD Sud"},
    {comptoir = vector3(1697.24, 4923.34, 42.06), deceler = vector3(1705.14, 4917.69, 42.06), job = "ltdnord", notif = "LTD Nord"},
    {comptoir = vector3(-47.34, -1758.63, 29.42), deceler = vector3(-40.96, -1751.35, 29.42), job = "ltdgs", notif = "LTD Groove Street"},
    {comptoir = vector3(24.47, -1345.68, 29.49), deceler = vector3(25.68, -1339.04, 29.49), job = "ltdfd", notif = "LTD Forum Drive"},
}

local Ltd = {}

Ltd.openedMenu = false 
Ltd.mainMenu = RageUI.CreateMenu(" ", "LTD", nil, 100, "shopui_title_gasstation", "shopui_title_gasstation")
Ltd.mainMenu.Closed = function()
    Ltd.openedMenu = false 
end
Ltd.mainMenu:DisplayGlare(false)

function ComptoirLtd(notif)
    RageUI.CloseAll()
    if Ltd.openedMenu then
        Ltd.openedMenu = false
        RageUI.Visible(Ltd.mainMenu, false)
    else
        Ltd.openedMenu = true
        RageUI.Visible(Ltd.mainMenu, true)
            CreateThread(function()
                while Ltd.openedMenu do
                    RageUI.IsVisible(Ltd.mainMenu, function()
                        RageUI.Button("Annonce", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local input = ESX.KeyboardInput("Annonce", 50)
                                if input ~= nil and #input > 5 then
                                    TriggerServerEvent("AnnonceLtd", input, notif)
                                end
                            end
                        })
                    end)
                Wait(1)
            end
        end)
    end
end

local LtdDeceler = {
    ItemList = {
        {item = "cmoteur", item2 = "moteur", label = "Moteur"},
        {item = "cpain_chocolat", item2 = "pain_chocolat", label = "Pain au Chocolat"},
        {item = "ccroissant", item2 = "croissant", label = "Croissant"},
        {item = "csandwich_thon", item2 = "sandwich_thon", label = "Sandwich au Thon"},
        {item = "csalade", item2 = "salade", label = "Salade"},
        {item = "ccoffe", item2 = "coffe", label = "Café"},
        {item = "cdonut", item2 = "donut", label = "Donut"},
        {item = "cecola", item2 = "ecola", label = "E-Cola"},
        {item = "csprunk", item2 = "sprunk", label = "Sprunk"},
    }
}

LtdDeceler.openedMenu = false 
LtdDeceler.mainMenu = RageUI.CreateMenu(" ", "LTD", nil, 150)
LtdDeceler.mainMenu.Closed = function()
    LtdDeceler.openedMenu = false 
end

LtdDeceler.mainMenu:DisplayHeader(false)

function DecelerLtd()
    RageUI.CloseAll()
    if LtdDeceler.openedMenu then
        LtdDeceler.openedMenu = false
        RageUI.Visible(LtdDeceler.mainMenu, false)
    else
        LtdDeceler.openedMenu = true
        RageUI.Visible(LtdDeceler.mainMenu, true)
            CreateThread(function()
                while LtdDeceler.openedMenu do
                    RageUI.IsVisible(LtdDeceler.mainMenu, function()
                        for k, v in pairs(LtdDeceler.ItemList) do
                            RageUI.Button(v.label, nil, {}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("Montant", 50)
                                    if tonumber(input) ~= nil then
                                        print(v.item, v.item2, input)
                                        TriggerServerEvent("LtdDecelerItem", v.item, v.item2, tonumber(input))
                                    end
                                end
                            })
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
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            for k, v in pairs(PositionLtd) do 
                local dist = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.comptoir, true)
                local dist2 = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), v.deceler, true)

                if dist <= 1 and PlayerData.job.name == v.job then
                    wait = 5
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~accédez au comptoir~s~.")
                    if IsControlJustPressed(0, 51) then
                        ComptoirLtd(v.notif, v.job)
                    end
                end
                if dist2 <= 1 and PlayerData.job.name == v.job then 
                    wait = 5
                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~déceler un objet~s~.")
                    if IsControlJustPressed(0, 51) then
                        DecelerLtd()
                    end
                end
            end 
        end
        Wait(wait)
    end
end)