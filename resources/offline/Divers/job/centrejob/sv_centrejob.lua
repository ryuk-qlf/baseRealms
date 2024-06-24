ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local PlayerDiamond = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if not PlayerDiamond[_src] then
        MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result)
            if result[1] then
                PlayerDiamond[_src] = true
            else
                if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
                    PlayerDiamond[_src] = true
                elseif xPlayer.getGroup() == "user" then
                    PlayerDiamond[_src] = false
                end
            end
        end)
    end
end)

RegisterNetEvent('SetJobCenter')
AddEventHandler('SetJobCenter', function(job)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-867.63, -1274.91, 4.15)) <= 5 then
        if PlayerDiamond[_src] then
            if job == "tatoueur" then
                xPlayer.setJob("tattoo2", 0)
                xPlayer.showNotification("Vous faite ~g~désormais~s~ partie du métier ~g~Tatoueur~s~.")
            elseif job == "barber" then
                xPlayer.setJob("barber2", 0)
                xPlayer.showNotification("Vous faite ~g~désormais~s~ partie du métier ~g~Barber~s~.")
            else
                DropPlayer(_src, "Cheat Job Center")
            end
        else
            DropPlayer(_src, "Cheat Job Center")
        end
    end
end)

ESX.RegisterServerCallback("GetDiamondJob", function(source, cb)
    local _src = source
    cb(PlayerDiamond[_src])
end)