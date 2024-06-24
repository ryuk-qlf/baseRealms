ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local TriggerSecu = {}

RegisterNetEvent('SetHealthAndArmourSpawn')
AddEventHandler('SetHealthAndArmourSpawn', function()
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    if not TriggerSecu[xPlayer.source] then
        TriggerSecu[xPlayer.source] = xPlayer.source

        MySQL.Async.fetchAll("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result)
            if result[1] then
                Health = result[1].health
    
                TriggerClientEvent('SetHealthAndArmour', _source, Health)
            end
        end)
    end
end)

AddEventHandler("playerDropped", function(reason)
    local _src = source
    local identifier = GetPlayerIdentifiers(_src)[1]
    local health = GetEntityHealth(GetPlayerPed(_src))
    MySQL.Async.execute("UPDATE users SET health = @health WHERE identifier = @identifier", { 
        ['@identifier'] = identifier,
        ['@health'] = health
    })
    print('Update Health ('.._src..') : '..health)
end)