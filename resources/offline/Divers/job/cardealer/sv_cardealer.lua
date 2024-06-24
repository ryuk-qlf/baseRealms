ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('SetVehiclePlayer')
AddEventHandler('SetVehiclePlayer', function(playerId, vehicleProps, plate, model, amount)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	MySQL.Async.execute('INSERT INTO vehicle_owner (owner, plate, model, custom) VALUES (@owner, @plate, @model, @custom)', {
		['@owner']   = xPlayer.identifier,
		['@plate']   = plate,
		['@model']   = model,
		['@custom'] = json.encode(vehicleProps)
	})

	xPlayer.showNotification('~b~Concessionnaire~s~\nVous avez reçu le véhicule immatriculé [~b~'..plate..'~s~]')
	TriggerEvent('RemoveMoneySociety', "concess", amount)
end)

RegisterNetEvent('SetVehicleJob')
AddEventHandler('SetVehicleJob', function(target, vehicleProps, plate, model, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local JobTarget = xTarget.getJob().name

	if JobTarget ~= nil and JobTarget ~= "unemployed" then
		MySQL.Async.execute('INSERT INTO jobs_vehicles (job, plate, model, custom) VALUES (@job, @plate, @model, @custom)', {
			['@job']   = JobTarget,
			['@plate']   = plate,
			['@model']   = model,
			['@custom'] = json.encode(vehicleProps)
		})
		xTarget.showNotification('~b~Concessionnaire~s~\nVous avez reçu le véhicule immatriculé [~b~'..plate..'~s~]')
		TriggerEvent('RemoveMoneySociety', "concess", amount)
	else
		xPlayer.showNotification("~r~La personne est membre d'aucun crew.")
	end
end)

RegisterNetEvent('SetVehicleCrew')
AddEventHandler('SetVehicleCrew', function(target, vehicleProps, plate, model, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xTarget.identifier
    }, function(result)

        if json.encode(result[1]) ~= "null" then
			local CrewTarget = result[1].id_crew

			MySQL.Async.execute('INSERT INTO crew_vehicles (crew, plate, model, custom) VALUES (@crew, @plate, @model, @custom)', {
				['@crew']   = CrewTarget,
				['@plate']   = plate,
				['@model']   = model,
				['@custom'] = json.encode(vehicleProps)
			})
			xTarget.showNotification('~b~Concessionnaire~s~\nVous avez reçu le véhicule immatriculé [~b~'..plate..'~s~]')
			TriggerEvent('RemoveMoneySociety', "concess", amount)
		else
			xPlayer.showNotification("~r~La personne est membre d'aucun crew.")
		end
	end)
end)

RegisterNetEvent('addKeyVehicle')
AddEventHandler('addKeyVehicle', function(target, plate)
	local xTarget = ESX.GetPlayerFromId(target)
	
	if target ~= nil and plate ~= nil then
		MySQL.Async.execute('INSERT INTO vehicle_key (identifier, plate, label) VALUES (@identifier, @plate, @label)', {
			['@identifier']   = xTarget.identifier,
			['@plate']   = plate,
			['@label']   = xTarget.getIdentity()
		})
	end
end)

ESX.RegisterServerCallback('GetKeyVehicle', function(source, cb, plaque)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll("SELECT * FROM vehicle_key WHERE identifier = @identifier AND plate = @plate", {
		['@plate'] = plaque,
		['@identifier'] = xPlayer.identifier
	}, function(row)

		if row[1] ~= nil then
			print('1')
			cb(true)
		else
			MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
				["@identifier"] = xPlayer.identifier
			}, function(row2)
		
				if json.encode(row2[1]) ~= "null" then
					local IdGradeCrew = row2[1].id_grade
					local IdCrew = row2[1].id_crew

					MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_grade = @id_grade', {
						['@id_grade'] = IdGradeCrew
					}, function(row3)
						print(json.encode(row3))
						if row3[1].key_vehicle == 1 then
							MySQL.Async.fetchAll("SELECT * FROM crew_vehicles WHERE plate = @plate AND crew = @crew", {
								['@plate'] = plaque,
								['@crew'] = IdCrew
							}, function(row4)
								if json.encode(row4[1]) ~= "null" then
									cb(true)
								else
									MySQL.Async.fetchAll("SELECT * FROM jobs_vehicles WHERE plate = @plate AND job = @job", {
										['@plate'] = plaque,
										['@job'] = xPlayer.job.name
									}, function(row5)
										if json.encode(row5[1]) ~= "null" then
											cb(true)
										else
											cb(false)
											xPlayer.showNotification("~r~Vous n'avez pas les clés de ce véhicule.")
										end
									end)
								end
							end)
						else
							xPlayer.showNotification("~r~Vous n'avez pas les clés de ce véhicule.")
							cb(false)
						end
					end)
				else
					MySQL.Async.fetchAll("SELECT * FROM jobs_vehicles WHERE plate = @plate AND job = @job", {
						['@plate'] = plaque,
						['@job'] = xPlayer.job.name
					}, function(row5)
						if json.encode(row5[1]) ~= "null" then
							cb(true)
						else
							cb(false)
							xPlayer.showNotification("~r~Vous n'avez pas les clés de ce véhicule.")
						end
					end)
				end
			end)
		end
	end)
end)