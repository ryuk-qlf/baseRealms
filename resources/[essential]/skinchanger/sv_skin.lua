ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)
	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

-- RegisterNetEvent('Sac')
-- AddEventHandler('Sac', function(skin)
-- 	local xPlayer = ESX.GetPlayerFromId(source)
-- 	local defaultMaxWeight = ESX.GetConfig().MaxWeight
-- 	local backpackModifier = Config.BackpackWeight[skin.bags_1]

-- 	if backpackModifier then
-- 		xPlayer.setMaxWeight(defaultMaxWeight + backpackModifier)
-- 		xPlayer.showNotification("~r~Informations~s~\nVous avez maintenant une capacité en plus de : "..(math.floor(backpackModifier/1000)).."KG")
-- 	else
-- 		xPlayer.setMaxWeight(defaultMaxWeight)
-- 	end
-- end)

ESX.RegisterServerCallback('esx_skin:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user, skin = users[1]

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}

		if user.skin then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)