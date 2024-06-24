CreateThread = Citizen.CreateThread
Wait = Citizen.Wait

CreateThread(function()
    TriggerServerEvent("crz_weather:setPlyOnList")
end)

local current = {
    ["weather"] = SharedWeather.default["weather"],
    ["freezeTime"] = nil,
    ["blackout"] = nil
}
local latestWeather = current["weather"]
local nextWeather = SharedWeather.default["nextWeather"]

RegisterNetEvent("crz_weather:syncNextWeather")
AddEventHandler("crz_weather:syncNextWeather", function(nextWeather2)
    nextWeather = nextWeather2
end)

RegisterNetEvent("crz_weather:syncWeather")
AddEventHandler("crz_weather:syncWeather", function(weather, blackout)
    current["weather"] = weather
    current["blackout"] = blackout
    SetArtificialLightsState(current["blackout"])
    SetArtificialLightsStateAffectsVehicles(not current["blackout"])
end)

CreateThread(function()
    ForceSnowPass(SharedWeather.isWinter)
    SetForceVehicleTrails(SharedWeather.isWinter)
    SetForcePedFootstepsTracks(SharedWeather.isWinter)
    while true do
        if latestWeather ~= current["weather"] then
            latestWeather = current["weather"]
            SetWeatherTypeOverTime(current["weather"], 15.0)
            Wait(15000)
        end
        Wait(100)
        ClearOverrideWeather()
		ClearWeatherTypePersist()
        SetWeatherTypePersist(latestWeather)
		SetWeatherTypeNow(latestWeather)
		SetWeatherTypeNowPersist(latestWeather)  
    end
end)

local baseTime = 0
local timeOffset = 0
local timer = 0

RegisterNetEvent("crz_weather:syncTime")
AddEventHandler("crz_weather:syncTime", function(base, offset, freeze)
    baseTime = base
    timeOffset = offset
    current["freezeTime"] = freeze
end)

CreateThread(function()
    local hour = 0
    local minute = 0
    while true do
        Wait(1000)
        local newBaseTime = baseTime
        if GetGameTimer() - 500 > timer then
            newBaseTime = newBaseTime+0.25
            timer = GetGameTimer()
        end
        if current["freezeTime"] then
            timeOffset = timeOffset + baseTime - newBaseTime
        end
        baseTime = newBaseTime
		hour = math.floor(((baseTime+timeOffset)/60)%24)
		minute = math.floor((baseTime+timeOffset)%60)
		NetworkOverrideClockTime(hour, minute, 0)
    end
end)

getNextWeather = function()
    local text = "10m = "..nextWeather[1].."\n20m = "..nextWeather[2].."\n30m = "..nextWeather[3]
    ESX.ShowNotification(text)
end

RegisterNetEvent("crz_weather:errorNotify")
AddEventHandler("crz_weather:errorNotify", function(text)
    ESX.ShowNotification(text)
end)