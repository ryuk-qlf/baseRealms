ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local occupiedTracks = {}

RegisterServerEvent('landlife_bowling:start')
AddEventHandler('landlife_bowling:start', function()
    TriggerClientEvent('landlife_bowling:chooseTrack', source, occupiedTracks)
end)

RegisterServerEvent('landlife_bowling:end')
AddEventHandler('landlife_bowling:end', function(track)
    local src, old = source, occupiedTracks
    occupiedTracks = {}
    for k, v in pairs(old) do 
        if v ~= src then
            occupiedTracks[k] = v
        end
    end
    TriggerClientEvent('landlife_bowling:cancel', src)
end)

RegisterServerEvent('landlife_bowling:choose')
AddEventHandler('landlife_bowling:choose', function(track)
    local src = source
    if not occupiedTracks[track] then
        occupiedTracks[track] = src
        TriggerClientEvent('landlife_bowling:play', src, track)
    else
        TriggerClientEvent('landlife_bowling:cancel', src)
    end
end)

AddEventHandler('playerDropped', function()
    local src, old = source, occupiedTracks
    occupiedTracks = {}
    for k, v in pairs(old) do 
        if v ~= src then
            occupiedTracks[k] = v
        end
    end
end)