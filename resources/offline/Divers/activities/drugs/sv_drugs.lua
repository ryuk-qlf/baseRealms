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

local crews = {}  -- Stocker les informations des crews et leur état CVC

RegisterCommand("cvc", function(source, args)
    local playerId = source
    local action = args[1]
    local targetCrew = tonumber(args[2])

    if action == "start" and targetCrew then
		
        getPlayerCrew(playerId, function(playerCrew)
            if playerCrew then
                crews[playerCrew] = {opponent = targetCrew, status = "pending"}
                notifyCrew(targetCrew, "Vous avez été défié par le crew " .. playerCrew .. ". Tapez /cvc accept pour accepter.")
            else
                TriggerClientEvent('esx:showNotification', playerId, "~r~Vous n'êtes pas dans un crew.~s~")
            end
        end)
    elseif action == "accept" then
        getPlayerCrew(playerId, function(playerCrew)
            for crew, info in pairs(crews) do
                if info.opponent == playerCrew and info.status == "pending" then
                    info.status = "accepted"
                    notifyAll("CVC accepté. Début dans 3 minutes.")
                    Citizen.Wait(180000)  -- Attendre 3 minutes
                    startCVC(crew, info.opponent)
                    break
                end
            end
        end)
    end
end, false)

function getPlayerCrew(playerId, callback)
    local playerSteamId = GetPlayerIdentifier(playerId, 0)
    MySQL.Async.fetchAll("SELECT * FROM crew_membre WHERE identifier = @identifier", {
        ["@identifier"] = playerSteamId
    }, function(result)
        if result[1] then
            callback(result[1].id_crew)
        else
            callback(nil)
        end
    end)
end

function startCVC(crew1, crew2)
    crews[crew1].status = "ongoing"
    crews[crew2] = {opponent = crew1, status = "ongoing"}
    getCrewMembers(crew1, function(members1)
        getCrewMembers(crew2, function(members2)
            TriggerClientEvent('cvc:start', -1, crew1, crew2, members1, members2)
        end)
    end)
end

function getCrewMembers(crewId, callback)
    MySQL.Async.fetchAll("SELECT * FROM crew_membre WHERE id_crew = @id_crew", {
        ["@id_crew"] = crewId
    }, function(result)
        local members = {}
        for _, row in ipairs(result) do
            table.insert(members, row.identifier)
        end
        callback(members)
    end)
end

function notifyCrew(crewId, message)
    getCrewMembers(crewId, function(members)
        for _, identifier in ipairs(members) do
            local playerId = getPlayerFromIdentifier(identifier)
            if playerId then
                TriggerClientEvent('esx:showNotification', playerId, message)
            end
        end
    end)
end

function notifyAll(message)
    TriggerClientEvent('esx:showNotification', -1, message)
end

function getPlayerFromIdentifier(identifier)
    for _, playerId in ipairs(GetPlayers()) do
        local playerSteamId = GetPlayerIdentifier(playerId, 0)
        if playerSteamId == identifier then
            return playerId
        end
    end
    return nil
end
