ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterCommand("wipe", function(source, args, rawCommand)
    if tonumber(args[1]) then
        TriggerServerEvent("WipePerso", args[1])
    end
end)

RegisterCommand("perso", function()
    TriggerServerEvent("InfoPerso")
end)