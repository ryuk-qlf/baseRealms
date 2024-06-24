ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

function GetInventoryDrugs(xPlayer)
	if xPlayer.getInventoryItem("coke").count > 0 then
		TriggerClientEvent("ResellDrugs", xPlayer.source)
	elseif xPlayer.getInventoryItem("weed").count > 0 then
		TriggerClientEvent("ResellDrugs", xPlayer.source)
	elseif xPlayer.getInventoryItem("meth").count > 0 then
		TriggerClientEvent("ResellDrugs", xPlayer.source)
	else
		xPlayer.MissionText("  ", 3100)
	end
end

RegisterNetEvent("VenteDeDrogue")
AddEventHandler("VenteDeDrogue", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	
	if xPlayer.getInventoryItem("coke").count > 0 then 
		local random = math.random(75, 145)
		xPlayer.removeInventoryItem("coke", 1)
		xPlayer.addAccountMoney('black_money', random)
		xPlayer.MissionText("~b~Client:~s~ merci pour la cocaïne ~g~+"..random.."$", 3000)
		Wait(3500)
		GetInventoryDrugs(xPlayer)
	elseif xPlayer.getInventoryItem("meth").count > 0 then
		local random = math.random(100, 175)
		xPlayer.removeInventoryItem("meth", 1)
		xPlayer.addAccountMoney('black_money', random)
		xPlayer.MissionText("~b~Client:~s~ merci pour la méthamphétamine ~g~+"..random.."$", 3000)
		Wait(3500)
		GetInventoryDrugs(xPlayer)
	elseif xPlayer.getInventoryItem("weed").count > 0 then 
		xPlayer.removeInventoryItem("weed", 1)
		local random = math.random(40, 110)
		xPlayer.addAccountMoney('black_money', random)
		xPlayer.MissionText("~b~Client:~s~ merci pour le cannabis ~g~+"..random.."$", 3000)
		Wait(3500)
		GetInventoryDrugs(xPlayer)
	else
		xPlayer.showNotification("~r~Vous n'avez plus de marchandise.~s~")
	end
end)