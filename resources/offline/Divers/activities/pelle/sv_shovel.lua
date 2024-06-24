ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('pelle', function(source)
	TriggerClientEvent('UsePelle', source)
end)

ESX.RegisterUsableItem('casserole', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = xPlayer.getInventoryItem('terre').count

	if tonumber(item) > 0 then 
		TriggerClientEvent('UseCasserole', source)
	else
		xPlayer.showNotification('~r~Action impossible vous devez avoir de la terre.')
	end
end)

RegisterNetEvent('removeDiversInventoryItem')
AddEventHandler('removeDiversInventoryItem', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)

	xPlayer.removeInventoryItem(item, 1)     
end) 

RegisterNetEvent('gefujjlzhbé^)mkjf:;n')
AddEventHandler('gefujjlzhbé^)mkjf:;n', function(item, count) 
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.canCarryItem(item, count) then
		xPlayer.addInventoryItem(item, count)
	else
		xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
	end
end)

RegisterNetEvent('qzdq-"éqzqzdfù*$^mdd$é"é&')
AddEventHandler('qzdq-"éqzqzdfù*$^mdd$é"é&', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local item = 'pepite'
	local item2 = 'terre'
	local count = math.random(1, 3)
	local random = math.random(1, 3)

	if random == 1 then 
		if xPlayer.getInventoryItem(item2).count > 0 then
			if xPlayer.canCarryItem(item, count) then
				xPlayer.removeInventoryItem(item2, 1)
				xPlayer.addInventoryItem(item, count)
			else
				xPlayer.showNotification("~r~Impossible vous n'avez plus de places sur vous.")
			end
		else
			xPlayer.showNotification("~r~Impossible vous n'avez plus pas de terre sur vous.")
		end
	else
		xPlayer.showNotification("~r~Vous n'avez rien trouver dans la terre.")
		xPlayer.removeInventoryItem(item2, 1)
	end
end)