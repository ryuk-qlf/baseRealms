function GetPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

function GetNearbyPlayer(notif)
    local Timer = GetGameTimer() + 10000
    local oPlayer = GetNearbyPlayers(2)

    if #oPlayer == 0 then
        if notif then
            ESX.ShowNotification("~r~ Il n'y a aucune personne aux alentours de vous.")
        end
        return false
    end

    if #oPlayer == 1 then
        return oPlayer[1]
    end

    ESX.ShowNotification("Appuyer sur ~g~E~s~ pour valider~n~Appuyer sur ~b~A~s~ pour changer de cible~n~Appuyer sur ~r~X~s~ pour annuler")
    Citizen.Wait(100)
    local aBase = 1
    while GetGameTimer() <= Timer do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            return oPlayer[aBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ESX.ShowNotification("Vous avez ~r~annulé~s~ cette ~r~action~s~")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            aBase = (aBase == #oPlayer) and 1 or (aBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[aBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    return false
end