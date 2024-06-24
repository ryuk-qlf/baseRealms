current = {
    ["weather"] = SharedWeather.default["weather"],
    ["freezeWeather"] = false,
    ["freezeTime"] = false,
    ["blackout"] = false
}

nextWeather = SharedWeather.default["nextWeather"]

local nextWeatherTimer = 60

CreateThread(function()
    TriggerClientEvent("crz_weather:syncWeather", -1, current["weather"], current["blackout"])
    while true do
        nextWeatherTimer = nextWeatherTimer-1
        Wait(60000)
        if nextWeatherTimer == 0 then
            editNextWeather()
            nextWeatherTimer = 60
        elseif nextWeatherTimer == 5 then
            reloadNextWeather()
        end
    end
end)

editNextWeather = function()
    current["weather"] = nextWeather[1]
    nextWeather[1] = nextWeather[2]
    nextWeather[2] = nextWeather[3]
    nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
    if not SharedWeather.isWinter then
        while SharedWeather.notWinterBlacklist[nextWeather[3]] do
            nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
            Wait(0)
        end
    end
    
    if not current["freezeWeather"] then
        TriggerClientEvent("crz_weather:syncWeather", -1, current["weather"], current["blackout"])
    end
    TriggerClientEvent("crz_weather:syncNextWeather", -1, nextWeather)
end

reloadNextWeather = function()
    local rdm = math.random(1, SharedWeather.maxRandom)
    if rdm == 1 then
        nextWeather[1] = SharedWeather.weather[math.random(#SharedWeather.weather)]
        nextWeather[2] = SharedWeather.weather[math.random(#SharedWeather.weather)]
        nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
        if not SharedWeather.isWinter then
            while SharedWeather.notWinterBlacklist[nextWeather[1]] do
                nextWeather[1] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                Wait(0)
            end
            while SharedWeather.notWinterBlacklist[nextWeather[2]] do
                nextWeather[2] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                Wait(0)
            end
            while SharedWeather.notWinterBlacklist[nextWeather[3]] do
                nextWeather[3] = SharedWeather.weather[math.random(#SharedWeather.weather)]
                Wait(0)
            end
        end
    end
    if not current["freezeWeather"] then
        TriggerClientEvent("crz_weather:syncNextWeather", -1, nextWeather)
    end
end

local baseTime = 0
local timeOffset = 0

CreateThread(function()
	while true do
		Wait(0)
		local newBaseTime = os.time(os.date("!*t"))/2 + 360
		if current["freezeTime"] then
			timeOffset = timeOffset + baseTime - newBaseTime			
		end
		baseTime = newBaseTime
	end
end)

CreateThread(function()
	while true do
		Wait(25000)
        TriggerClientEvent("crz_weather:syncTime", -1, baseTime, timeOffset, current["freezeTime"])
    end
end)

setToHours = function(hours)
    timeOffset = timeOffset - ( ( ((baseTime+timeOffset)/60) % 24 ) - hours ) * 60
end

setToMinute = function(minutes)
    timeOffset = timeOffset - ( ( (baseTime+timeOffset) % 60 ) - minutes )
end