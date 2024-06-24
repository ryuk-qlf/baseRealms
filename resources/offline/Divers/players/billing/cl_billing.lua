ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterCommand("facture", function(source, args, rawCommand)
    if args[1] == "personnel" then
        local target = GetNearbyPlayer(2)
        if target then
            local motif = ESX.KeyboardInput("Motif de la facture", 30)
            if motif ~= nil then
                local price = ESX.KeyboardInput("Montant de la facture", 30)
                if tonumber(price) ~= nil then
                    TriggerServerEvent('SendBill', GetPlayerServerId(target), motif, price, "perso", GetPlayerServerId(PlayerId()))
                end
            end
        end
    elseif args[1] == "entreprise" then
        local target = GetNearbyPlayer(2)
        if target then
            local motif = ESX.KeyboardInput("Motif de la facture", 30)
            if motif ~= nil then
                local price = ESX.KeyboardInput("Montant de la facture", 30)
                if tonumber(price) ~= nil then
                    TriggerServerEvent('SendBill', GetPlayerServerId(target), motif, price, "entreprise", GetPlayerServerId(PlayerId()))
                end
            end
        end
    else
        ESX.ShowNotification("Vous devez ~b~inserer~s~ un argument.")
    end
end)

RegisterNetEvent("StartAnimation")
AddEventHandler("StartAnimation", function()
    RequestAnimDict("mp_common")
    while not HasAnimDictLoaded("mp_common") do
        Citizen.Wait(10)
    end
    TaskPlayAnim(GetPlayerPed(-1), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
    PlaySoundFrontend(-1, 'Bus_Schedule_Pickup', 'DLC_PRISON_BREAK_HEIST_SOUNDS', false)
end)

RegisterNetEvent("SolutionBill")
AddEventHandler("SolutionBill", function(motif, price, type, author)
    local timer = 1100
    
    ESX.ShowNotification("Motif : ~b~"..motif.."~s~.\nMontant : ~g~"..price.."$~s~.")
    ESX.ShowNotification("Appuyez sur vos touches ~b~(Y/X)")

    while true do
        Wait(1)
        timer = timer - 1

        if timer <= 0 then
            ESX.ShowNotification("~r~Vous avez refusé de payer la facture.")
            TriggerServerEvent("AlertBills", author, "~r~La personne à refusé de payer votre facture.")
            break
        end

        if IsControlJustPressed(1, 73) then
            ESX.ShowNotification("~r~Vous avez refusé de payer la facture.")
            TriggerServerEvent("AlertBills", author, "~r~La personne à refusé de payer votre facture.")
            break
        end

        if IsControlJustPressed(1, 246) then
            if type == "perso" then
                TriggerServerEvent('PayBillsPersonnel', price, author, motif)
            elseif type == "entreprise" then
                TriggerServerEvent('PayBillsEntreprise', price, author, motif)
            end
            break
        end
    end
end)