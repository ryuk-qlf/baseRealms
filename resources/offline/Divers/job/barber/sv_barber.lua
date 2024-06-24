ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('sitchairtarget')
AddEventHandler('sitchairtarget', function(target, poschaise, heading)
    TriggerClientEvent('sitchairtargetcl', target, poschaise, heading) 
end)

RegisterNetEvent('skinchanger:changetarget')
AddEventHandler('skinchanger:changetarget', function(target, type, var)
    TriggerClientEvent('skinchanger:changetargetcl', target, type, var) 
end)

RegisterNetEvent('SvFinalisation')
AddEventHandler('SvFinalisation', function(target, type, xyz)
    TriggerClientEvent('ClFinalisation', target, type, xyz) 
end)