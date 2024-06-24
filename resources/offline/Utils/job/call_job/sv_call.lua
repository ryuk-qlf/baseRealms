ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local inService = {
    ["barber"] = {},
    ["barber2"] = {},
    ["barber3"] = {},
    ["barber4"] = {},
    ["tattoo"] = {},
    ["tattoo2"] = {},
    ["tattoo3"] = {},
    ["tattoo4"] = {},
    ["concess"] = {},
    ["mayansmotors"] = {},
    ["bennys"] = {},
    ["pawnshop"] = {},
    ["police"] = {},
    ["usss"] = {},
    ["realestateagent"] = {},
    ["ems"] = {},
    ["unemployed"] = {},
    ["unicorn"] = {},
    ["harmonyrepair"] = {},
    ["grimmotors"] = {},
    ["pawnnord"] = {},
    ["pharma"] = {},
}

local inHistorique = {
    ["barber"] = {},
    ["barber2"] = {},
    ["barber3"] = {},
    ["barber4"] = {},
    ["tattoo"] = {},
    ["tattoo2"] = {},
    ["tattoo3"] = {},
    ["tattoo4"] = {},
    ["concess"] = {},
    ["mayansmotors"] = {},
    ["bennys"] = {},
    ["pawnshop"] = {},
    ["police"] = {},
    ["usss"] = {},
    ["realestateagent"] = {},
    ["ems"] = {},
    ["unemployed"] = {},
    ["unicorn"] = {},
    ["harmonyrepair"] = {},
    ["grimmotors"] = {},
    ["pawnnord"] = {},
    ["pharma"] = {},
}

function removeService(src, job)
    for k, v in pairs(inService[job]) do
        if v == src then
            table.remove(inService[job], k)
            break
        end
    end
end

function GetCountJobInService(job)
    local count = 0 

    for k, v in pairs(inService[job]) do
        count = count + 1
    end
    return count
end

RegisterNetEvent("player:serviceOn")
AddEventHandler("player:serviceOn", function(job)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if xPlayer.job.name == job then
        table.insert(inService[job], _src)
    else 
        DropPlayer(_src, "Cheat serviceOn")
    end
end)

RegisterNetEvent("player:serviceOff")
AddEventHandler("player:serviceOff", function(job)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if xPlayer.job.name == job then
        removeService(_src, job)
    else 
        DropPlayer(_src, "Cheat serviceOff")
    end
end)

RegisterNetEvent("call:makeCallSpecial")
AddEventHandler("call:makeCallSpecial", function(job, pos, message, type)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)

    for _, player in pairs(inService[job]) do
        TriggerClientEvent("call:callIncoming", player, job, pos, message, type)
    end
    if type ~= "fire" then
        table.insert(inHistorique[job], {
            pos = pos,
            message = message
        })
    end
end)

ESX.RegisterServerCallback('HistoriqueCall', function(source, cb, job)
    cb(inHistorique[job])
end)

RegisterNetEvent("call:AccepteCall")
AddEventHandler("call:AccepteCall", function(job)
    local xPlayer = ESX.GetPlayerFromId(source)

    for _, player in pairs(inService[job]) do
        TriggerClientEvent("esx:showNotification", player, "L'appel a été pris par ~g~"..xPlayer.getIdentity())
    end
end)

AddEventHandler("playerDropped", function(reason)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if xPlayer then
        removeService(_src, xPlayer.job.name)
    end
end)

ESX.RegisterServerCallback('JobInService', function(source, cb, job)
    local count = 0 

    for k, v in pairs(inService[job]) do
        count = count + 1
    end
    cb(count)
end)