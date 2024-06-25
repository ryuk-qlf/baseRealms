ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end) 

Robbery = {}

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

local cooldowns = {}

local TableBraquage = {}
local CountMoneyBraquage = {}

RegisterServerEvent('startholdup')
AddEventHandler('startholdup', function(type, shop) 
	if type == "end" then
		local time = 5 * 1000
        Citizen.Wait(time) 
	end
	TriggerClientEvent('allplayers_cldwn_cl', -1, type, shop)
end)

ESX.RegisterServerCallback("GetTimeForBraq", function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if not TableBraquage[xPlayer.identifier] then
		cb(true)
	else
		cb(false)
	end
end)

RegisterNetEvent("addTimeToBraq")
AddEventHandler("addTimeToBraq", function()
	local xPlayer = ESX.GetPlayerFromId(source)

	TableBraquage[xPlayer.identifier] = xPlayer.identifier
	CountMoneyBraquage[xPlayer.identifier] = 1
end)

RegisterServerEvent('addsale')
AddEventHandler('addsale', function()
	local coords = GetEntityCoords(GetPlayerPed(source))
	local xPlayer = ESX.GetPlayerFromId(source)
	local price = math.random(375, 475)

	if TableBraquage[xPlayer.identifier] and CountMoneyBraquage[xPlayer.identifier] < 13 then
		for k, v in pairs(Robbery.shops) do
			local distance = #(coords-v.coords)
			if distance <= 50 then
				CountMoneyBraquage[xPlayer.identifier] = CountMoneyBraquage[xPlayer.identifier] + 1
				xPlayer.addAccountMoney('black_money', price)
				xPlayer.MissionText("~g~+ "..price.."$", 3500)    
			end
		end
	end
end)

ESX.RegisterServerCallback('atmRobbery:hasTablet', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local tabletCount = xPlayer.getInventoryItem('tablette').count

    if tabletCount > 0 then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('atmRobbery:canRob', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    if cooldowns[identifier] and cooldowns[identifier] > os.time() then
        local remainingTime = cooldowns[identifier] - os.time()
        local remainingMinutes = math.ceil(remainingTime / 60)
        cb(false, remainingMinutes)
    else
        cb(true, 0) -- 0 minutes restantes, peut braquer immédiatement
    end
end)

RegisterServerEvent('atmRobbery:useTablet')
AddEventHandler('atmRobbery:useTablet', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('tablette', 1)
end)

RegisterServerEvent('atmRobbery:reward')
AddEventHandler('atmRobbery:reward', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local dirtyMoney = math.random(1000, 2000)
    xPlayer.addAccountMoney('black_money', dirtyMoney)
    TriggerClientEvent('esx:showNotification', source, '~g~Vous avez reçu ' .. dirtyMoney .. ' $ en argent sale')

    local identifier = xPlayer.identifier
    cooldowns[identifier] = os.time() + 3 * 60 * 60 -- 3 heures en secondes
end)
