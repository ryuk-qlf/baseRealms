ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterUsableItem('radio', function(source)
    TriggerClientEvent('setActiveRadio', source)
end)