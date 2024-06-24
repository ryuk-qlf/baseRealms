CreateThread = Citizen.CreateThread
Wait = Citizen.Wait
Players = {}

AddEventHandler('playerConnecting', function(name , reject, deferrals)
    addToPlayers(source)
end)

RegisterNetEvent("crz_weather:weatherSpawn")
AddEventHandler("crz_weather:weatherSpawn", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent("crz_weather:syncWeather", xPlayer.source, current["weather"], current["blackout"])
end)

RegisterNetEvent("crz_weather:setPlyOnList")
AddEventHandler("crz_weather:setPlyOnList", function()
    addToPlayers(source)
end)

addToPlayers = function(source)
    local playerId, identifier = source
    for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
            Players[playerId] = {
                id = playerId,
                identifier = identifier,
                name = GetPlayerName(playerId)
            }
			break
		end
	end
end

RegisterCommand("weather", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if args ~= nil then
            for k,v in pairs(SharedWeather.weather) do
                if string.upper(args[1]) == v then
                    current["weather"] = args[1]
                    TriggerClientEvent("crz_weather:syncWeather", -1, current["weather"], current["blackout"])
                else
                    TriggerClientEvent("crz_weather:errorNotify", source, SharedWeather.text[SharedWeather.lang]["error_weather"])
                end
            end
        end
    end
end)

RegisterCommand("nextWeather", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if args ~= nil then
            for k,v in pairs(SharedWeather.weather) do
                if string.upper(args[1]) == v then
                    nextWeather[1] = args[1]
                    nextWeather[2] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                    nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                    if not SharedWeather.isWinter then
                        while SharedWeather.notWinterBlacklist[nextWeather[2]] do
                            nextWeather[2] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                            Wait(0)
                        end
                        while SharedWeather.notWinterBlacklist[nextWeather[3]] do
                            nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                            Wait(0)
                        end
                    end
                    TriggerClientEvent("crz_weather:syncNextWeather", -1, nextWeather)
                else
                    TriggerClientEvent("crz_weather:errorNotify", source, SharedWeather.text[SharedWeather.lang]["error_weather"])
                end
            end
        end
    end
end)

RegisterCommand("time", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if args ~= nil and tonumber(args[1]) or tonumber(args[2]) then
            setToHours(args[1])
            setToMinute(args[2])
        else
            TriggerClientEvent("crz_weather:errorNotify", source, SharedWeather.text[SharedWeather.lang]["error_time"])
        end
    end
end)

RegisterCommand("freezeWeather", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if args[1] == nil then
            return TriggerClientEvent("crz_weather:errorNotify", source, SharedWeather.text[SharedWeather.lang]["error_bool"])
        end
        current["freezeWeather"] = args[1]
    end
end)

RegisterCommand("blackout", function(source, args, rawCommand)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
        if args[1] == nil then
            return TriggerClientEvent("crz_weather:errorNotify", source, SharedWeather.text[SharedWeather.lang]["error_bool"])
        end
        current["blackout"] = args[1]
        TriggerClientEvent("crz_weather:syncWeather", -1, current["weather"], current["blackout"])
    end
end)