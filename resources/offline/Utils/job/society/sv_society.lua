ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('PromouvoirLeJoueur')
AddEventHandler('PromouvoirLeJoueur', function(target)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)
	local JobxTarget = xTarget.job.name
	JobxPlayer = xPlayer.job.name
	GradeActuel = xTarget.job.grade

	if JobxTarget == JobxPlayer then

		GradeUP = GradeActuel + 1

		MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @jobname ORDER BY `grade` DESC', {
			['@jobname'] = JobxPlayer
		}, function(result)
	
			if GradeActuel < result[1].grade then
				xTarget.setJob(JobxPlayer, GradeUP)
				xPlayer.showNotification("Vous avez augmenté le grade de la ~b~personne~s~.")
				xTarget.showNotification("Vous venez d'être augmenté de grade dans votre entreprise~s~.")
			else
				xPlayer.showNotification("Impossible la ~b~personne~s~ à le grade maximum.")
			end
		end)
	else
		xPlayer.showNotification("~r~Impossible la personne ne fait pas partie de votre entreprise.")
	end
end)

RegisterServerEvent('VirerLeJoueur')
AddEventHandler('VirerLeJoueur', function(identifier, Prenom, Nom)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	MySQL.Async.execute('UPDATE `users` SET `job` = @job, `job_grade` = @job_grade WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@job'] = "unemployed",
		['@job_grade']	= 0
	})
	if xTarget then
		xTarget.setJob("unemployed", 0)
	end
	xPlayer.showNotification("Vous avez viré ~b~"..Prenom.." "..Nom.."~s~ de votre entreprise.")
end)

local tableJoinJob = {}

RegisterNetEvent("BossRecrute")
AddEventHandler("BossRecrute", function(target, choix)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xTarget = ESX.GetPlayerFromId(target)

	if choix == "recruter" then
		if xTarget.job.name == "unemployed" then
			xPlayer.showNotification("Vous avez ~b~proposer~s~ à la personne de rejoindre l'entreprise "..xPlayer.job.label)
			TriggerClientEvent("SolutionJoinJob", xTarget.source, xPlayer.job.label)
			tableJoinJob[xTarget.source] = xPlayer.source
		else
			xPlayer.showNotification("~r~La personne fait déjà partie d'une entreprise.")
		end
	elseif choix == "virer" then
		if xTarget.job.label == xPlayer.job.label then
			xTarget.setJob("unemployed", 0)
			xTarget.showNotification("Vous avez été ~b~viré~s~ de l'entreprise "..xPlayer.job.label)
			xPlayer.showNotification("Vous avez ~b~viré~s~ la personne de l'entreprise "..xPlayer.job.label)
		else
			xPlayer.showNotification("~r~La personne ne fait pas partie de votre entreprise.")
		end
	end
end)

RegisterNetEvent("JoinJob")
AddEventHandler("JoinJob", function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSrc = tableJoinJob[xPlayer.source]
	local xAdmin = ESX.GetPlayerFromId(xSrc)

	print(xSrc)
	print(xAdmin.source)
	
	if xAdmin then
		xPlayer.setJob(xAdmin.job.name, 0)
		xAdmin.showNotification("~b~La personne a accepté de rejoindre votre entreprise.")
		tableJoinJob[xPlayer.source] = nil
	end
end)

RegisterNetEvent("CancelJoinJob")
AddEventHandler("CancelJoinJob", function()
	local xPlayer = ESX.GetPlayerFromId(source)

	tableJoinJob[xPlayer.source] = nil
end)

RegisterNetEvent("AlertJoinJob")
AddEventHandler("AlertJoinJob", function(type)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xSrc = tableJoinJob[xPlayer.source]

	if not xSrc then
		print('pas dans la table')
		return
	end
	local xTarget = ESX.GetPlayerFromId(xSrc)
	
	if xTarget then
		if type == 1 then
			xTarget.showNotification("~r~La personne à mis trop de temps à choisir.")
			tableJoinJob[xPlayer.source] = nil
		elseif type == 2 then
			xTarget.showNotification("~r~La personne à refusé de rejoindre votre entreprise.")
			tableJoinJob[xPlayer.source] = nil
		end
	end
end)

RegisterServerEvent('EditGradePlayer')
AddEventHandler('EditGradePlayer', function(identifier, gradename)
	local xTarget = ESX.GetPlayerFromIdentifier(identifier)
	MySQL.Async.execute('UPDATE `users` SET `job_grade` = @job_grade WHERE identifier = @identifier', {
		['@identifier'] = identifier,
		['@job_grade'] = gradename
	})
	if xTarget then
		xTarget.setJob(xTarget.job.name, gradename)
	end
end)

ESX.RegisterServerCallback("ListeEmployer", function(source, cb, votrejob)
    local infojob = {}

    MySQL.Async.fetchAll('SELECT * FROM users WHERE job = @job', {
        ['@job'] = votrejob
    }, function(result)
        cb(result)
    end)
end)

ESX.RegisterServerCallback("ListeGrades", function(source, cb, votrejob)
    local infojob = {}

    MySQL.Async.fetchAll('SELECT * FROM job_grades WHERE job_name = @job', {
        ['@job'] = votrejob
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent('RemoveMoneySociety')
AddEventHandler('RemoveMoneySociety', function(job, amount)
	MySQL.Async.fetchAll("SELECT * FROM entreprise WHERE job = @job", {
        ["@job"] = job
    }, function(result)

		ModifMoney = json.encode(result[1].money) - amount

		MySQL.Async.execute('UPDATE `entreprise` SET `money` = @money WHERE job = @job', {
			['@job'] = job,
			['@money'] = ModifMoney
		})
	end)
end)

RegisterNetEvent('AddMoneySociety')
AddEventHandler('AddMoneySociety', function(job, amount) 
	MySQL.Async.fetchAll("SELECT * FROM entreprise WHERE job = @job", {
		["@job"] = job
	}, function(result)

		ModifMoney = json.encode(result[1].money) + amount

		MySQL.Async.execute('UPDATE `entreprise` SET `money` = @money WHERE job = @job', {
			['@job'] = job,
			['@money'] = ModifMoney
		})
	end)
end)

AddEventHandler('GetMoneySv', function(job, cb)
	MySQL.Async.fetchAll("SELECT * FROM entreprise WHERE job = @job", {
        ["@job"] = job
    }, function(result)

		ModifMoney = json.encode(result[1].money)

		cb(ModifMoney)
	end)
end)

ESX.RegisterServerCallback('GetMoneySociety', function(source, cb)
	MySQL.Async.fetchAll('SELECT job, money FROM entreprise', {}, function(result)
		cb(result)
	end)
end)

RegisterCommand("leavejob", function(source, args, rawCommand)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

	if xPlayer.job.name ~= "unemployed" then
		xPlayer.setJob("unemployed", 0)
		xPlayer.showNotification("~b~Vous avez quitté votre entreprise.")
	else
		xPlayer.showNotification("~r~Vous faite partie d'aucune entreprise.")
	end
end, false)