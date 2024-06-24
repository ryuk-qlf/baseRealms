Citizen.CreateThread(function()
    while true do
        if PhoneData.isOpen then
            DisableDisplayControlActions()
        end
        Citizen.Wait(0)
    end
end)

RegisterKeyMapping('TooglePhone', 'Ouvrir le téléphone', 'keyboard', 'F1')

local AbleToOpen = true
RegisterCommand("TooglePhone",function()
    if AbleToOpen then
        AbleToOpen = false
        if not IsPedDeadOrDying(PlayerPedId(), 1) then
            OpenPhone()
        end
        Wait(1000)
        AbleToOpen = true
    end
end)

-- Disabled control when the phone its opened
function DisableDisplayControlActions()
    if not Config.DisableMovement then
        DisableControlAction(0, 18, true) -- disable mouse
        DisableControlAction(0, 69, true) -- disable mouse
        DisableControlAction(0, 92, true) -- disable mouse
        DisableControlAction(0, 106, true) -- disable mouse
        DisableControlAction(0, 122, true) -- disable mouse
        

        DisableControlAction(0, 12, true) -- disable mouse look
        DisableControlAction(0, 13, true) -- disable mouse look

        DisableControlAction(0, 1, true) -- disable mouse look
        DisableControlAction(0, 2, true) -- disable mouse look
        DisableControlAction(0, 3, true) -- disable mouse look
        DisableControlAction(0, 4, true) -- disable mouse look
        DisableControlAction(0, 5, true) -- disable mouse look
        DisableControlAction(0, 6, true) -- disable mouse look
        DisableControlAction(0, 263, true) -- disable melee
        DisableControlAction(0, 264, true) -- disable melee
        DisableControlAction(0, 257, true) -- disable melee
        DisableControlAction(0, 140, true) -- disable melee
        DisableControlAction(0, 141, true) -- disable melee
        DisableControlAction(0, 142, true) -- disable melee
        DisableControlAction(0, 143, true) -- disable melee
        DisableControlAction(0, 177, true) -- disable escape
        DisableControlAction(0, 200, true) -- disable escape
        DisableControlAction(0, 202, true) -- disable escape
        DisableControlAction(0, 322, true) -- disable escape
        DisableControlAction(0, 245, true) -- disable chat

        DisableControlAction(0, 199, true) -- disable chat
        DisableControlAction(0, 25, true) -- disable aim
        DisableControlAction(0, 24, true) -- disable shoot
        DisableControlAction(0, 45, true) -- disable Reload (R)
        DisableControlAction(0, 44, true) -- disable Cover (Q)
        DisableControlAction(0, 0, true) -- disable Camera (V)
        DisableControlAction(0, 26, true) -- disable Camera Back (C)
        DisableControlAction(0, 20, true) -- disable Z
        DisableControlAction(0, 236, true) -- disable v
        
        DisableControlAction(0, 157, true) -- disable 1
        DisableControlAction(0, 158, true) -- disable 2
        DisableControlAction(0, 160, true) -- disable 3
        DisableControlAction(0, 164, true) -- disable 4
        DisableControlAction(0, 165, true) -- disable 5

        DisableControlAction(0, 159, true) -- disable 6
        DisableControlAction(0, 161, true) -- disable 7
        DisableControlAction(0, 162, true) -- disable 8
        DisableControlAction(0, 163, true) -- disable 9

        DisableControlAction(0, 163, true) -- disable 9

        DisableControlAction(0, 73, true) -- disable X
        DisableControlAction(0, 47, true) -- disable G
        DisableControlAction(0, 58, true) -- disable G
        
        DisableControlAction(0, 74, true) -- disable H
        
    else 
        DisableAllControlActions(true)
    end 
end

RegisterCommand("telfix", function(source)
    phoneLoaded = false
    loading = false
    LoadPhone()
end, false)

--[[ RegisterCommand("fakecall", function(source, raw, args)
    TriggerEvent('qs-smartphone:client:GetCalled', math.random(11111,99999), math.random(10000,11000), false)
end, false) ]]

AddEventHandler('esx:onPlayerDeath', function()
    TriggerEvent('qs-smartphone:ClosePhone')
end)