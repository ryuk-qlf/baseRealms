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

local PawnShop = {
    Item = {
        {id = "parfum", name = "Parfum Dior", price = 75},
        {id = "vin", name = "Vin", price = 30},
        {id = "phone", name = "IPhone", price = 550},
        {id = "phone2", name = "Samsung", price = 450},
        {id = "WEAPON_FLASHLIGHT", name = "Lampe", price = 145},
        {id = "dvd", name = "DVD", price = 43},
        {id = "grandturismo", name = "Grand turismo", price = 55},
        {id = "gtav", name = "GTAV", price = 60},
        {id = "ps5", name = "PS5", price = 650},
        {id = "mac", name = "Mac", price = 550},
        {id = "tv", name = "Ecran 4K", price = 660},
        {id = "rolex", name = "Rolex", price = 770},
        {id = "xbox", name = "Xbox Serie X", price = 600},
        {id = "tablette", name = "Tablette", price = 150},
        {id = "casque", name = "Casque", price = 70},
        {id = "ecranpc", name = "Ecran PC", price = 247},
        {id = "chargeur1", name = "Chargeur Lightning", price = 23},
        {id = "chargeur2", name = "Chargeur Android", price = 25},
        {id = "pepite", name = "Pépite d'or", price = 40},
    }
}

PawnShop.openedSellMenu = false 
PawnShop.mainSellMenu = RageUI.CreateMenu("Jeffrey", "Jeffrey", nil, 150)

PawnShop.mainSellMenu.Closed = function()
    PawnShop.openedSellMenu = false 
end

PawnShop.mainSellMenu:DisplayHeader(false)

function openSellPawnShop()
    if PawnShop.openedSellMenu then
        PawnShop.openedSellMenu = false
        RageUI.Visible(PawnShop.mainSellMenu, false)
    else
        PawnShop.openedSellMenu = true
        RageUI.Visible(PawnShop.mainSellMenu, true)
            CreateThread(function()
                while PawnShop.openedSellMenu do
                    RageUI.IsVisible(PawnShop.mainSellMenu, function()
                        for k,v in pairs(PawnShop.Item) do
                            RageUI.Button(v.name, nil, {RightLabel = "~g~"..v.price.."$~s~"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("pawnshopSell", v.id, v.name, v.price) 
                                end
                            })
                        end
                    end)            
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while true do
        local time = 1000 
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, 1154.12, -386.01, 67.33)
        local dist2 = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, -1128.95, 2692.57, 18.80)

        if dist <= 1.5 then
            time = 5
            if PlayerData.job.name == "pawnshop" then
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Jeffrey~s~")
                if IsControlJustPressed(0, 51) then
                    openSellPawnShop()
                end
            end
        elseif dist2 <= 1.5 then
            time = 5
            if PlayerData.job.name == "pawnnord" then
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Kevin~s~")
                if IsControlJustPressed(0, 51) then
                    openSellPawnShop()
                end
            end
        end
        Wait(time)
    end
end)