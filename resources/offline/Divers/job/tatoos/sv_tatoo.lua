ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback('tattoo:getTattoos', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer then
		MySQL.Async.fetchAll('SELECT tattoos FROM users WHERE identifier = @identifier', {
			['@identifier'] = xPlayer.identifier
		}, function(result)
			if result[1].tattoos then
				cb(json.decode(result[1].tattoos))
			else
				cb()
			end
		end)
	else
		cb()
	end
end)

RegisterNetEvent("DeleteTatoos")
AddEventHandler('DeleteTatoos', function(Player)
	TriggerClientEvent("DeleteTatoos", Player, Player)
end)

RegisterNetEvent("PutTatooInBase")
AddEventHandler("PutTatooInBase", function(tattooList, Id)
	local xPlayer = ESX.GetPlayerFromId(Id)
	MySQL.Async.execute('UPDATE users SET tattoos = @tattoos WHERE identifier = @identifier', {
		['@tattoos'] = json.encode(tattooList),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterNetEvent("SVDrawTattoo")
AddEventHandler("SVDrawTattoo", function(Player, Cat, Iterator)
	local xPlayer = ESX.GetPlayerFromId(Player)
    TriggerClientEvent("DrawTattoo", xPlayer.source, Cat, Iterator)
end)

RegisterNetEvent("Validate")
AddEventHandler("Validate", function(Player, Cat, It)
	TriggerClientEvent('ReceiveValidate', Player, Cat, It, Player)
end)


RegisterNetEvent("CloseMenu")
AddEventHandler("CloseMenu", function(Player)
	local xPlayer = ESX.GetPlayerFromId(Player)
	TriggerClientEvent("CloseMenu", xPlayer.source)
end)

RegisterNetEvent("OpenMenu")
AddEventHandler("OpenMenu", function(Player)
	local xPlayer = ESX.GetPlayerFromId(Player)
	TriggerClientEvent("OpenMenu", xPlayer.source)
end)