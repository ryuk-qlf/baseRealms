ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('CreateLaboCoke')
AddEventHandler('CreateLaboCoke', function()
    TriggerServerEvent("CreateLaboCocaine", Property.Current.Id)
end)

local InfoLabo = {}

----

function callback()
    ESX.TriggerServerCallback('GetInfoLabo', function(results)
        for i = 1, #results, 1 do	
            InfoLabo.IdLabo = results[i].id_labo
            InfoLabo.IdProp = results[i].id_prop
            InfoLabo.StatusTable1 = results[i].table1
            InfoLabo.StatusTable2 = results[i].table2
            InfoLabo.StatusTable3 = results[i].table3
            InfoLabo.table1date = results[i].table1date
            InfoLabo.table2date = results[i].table2date
            InfoLabo.table3date = results[i].table3date
            InfoLabo.Ms1 = 0
            InfoLabo.timeRemaining1 = 3600
            InfoLabo.Ms2 = 0
            InfoLabo.timeRemaining2 = 3600
            InfoLabo.Ms3 = 0
            InfoLabo.timeRemaining3 = 3600
        end	
    end, Property.Current.Id)

    Wait(250)

    if json.encode(InfoLabo.table1date) ~= "null" then
        ESX.TriggerServerCallback("GetMsOfProd", function(result)
            InfoLabo.Ms1 = result
            InfoLabo.timeRemaining1 = InfoLabo.timeRemaining1-InfoLabo.Ms1
        end, InfoLabo.table1date)
    end

    if json.encode(InfoLabo.table2date) ~= "null" then
        ESX.TriggerServerCallback("GetMsOfProd", function(result)
            InfoLabo.Ms2 = result
            InfoLabo.timeRemaining2 = InfoLabo.timeRemaining2-InfoLabo.Ms2
        end, InfoLabo.table2date)
    end

    if json.encode(InfoLabo.table3date) ~= "null" then
        ESX.TriggerServerCallback("GetMsOfProd", function(result)
            InfoLabo.Ms3 = result
            InfoLabo.timeRemaining3 = InfoLabo.timeRemaining3-InfoLabo.Ms3
        end, InfoLabo.table3date)
    end

    Wait(250)

    Property.RefreshTimerCoke = false
    Property.RefreshTimerCoke = true

    print('1')
    if Property.RefreshCountCoke then
        print('2')
        Property.RefreshCountCoke = false
        while Property.RefreshTimerCoke do
            Wait(1000)
            print('3')
            if Property.Current.CanAccess and Property.Current.Interior == "Labo2" and Property.Current.Id_Crew ~= nil then
                print('4')
                if json.encode(InfoLabo.table1date) ~= "null" then
                    print('5')
                    InfoLabo.timeRemaining1 = InfoLabo.timeRemaining1-1
                end
                if json.encode(InfoLabo.table2date) ~= "null" then
                    print('5')
                    InfoLabo.timeRemaining2 = InfoLabo.timeRemaining2-1
                end
                if json.encode(InfoLabo.table3date) ~= "null" then
                    print('6')
                    InfoLabo.timeRemaining3 = InfoLabo.timeRemaining3-1
                end
            end
            print('7')
            if not Property.IsInProperty then
                print('8')
                print('plus dans la propriété')
                Property.RefreshTimerCoke = false
            end

            if InfoLabo.StatusTable1 == 2 and InfoLabo.timeRemaining1 <= 0 then
                print('Labz 2')
                TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 1, 3, InfoLabo.IdLabo)
            end
            if InfoLabo.StatusTable2 == 2 and InfoLabo.timeRemaining2 <= 0 then
                print('Labz 3')
                TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 2, 3, InfoLabo.IdLabo)
            end
            if InfoLabo.StatusTable3 == 2 and InfoLabo.timeRemaining3 <= 0 then
                print('Labz 4')
                TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 3, 3, InfoLabo.IdLabo)
            end
        end
    end
end

----

RegisterNetEvent("EnterLaboCoke")
AddEventHandler("EnterLaboCoke", function()
    Property.RefreshCountCoke = true

    callback()
    Wait(500)

    if InfoLabo.StatusTable1 == 2 then
        InfoLabo.Table1Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1095.388436, -3195.7072620000004, -39.191919, 0, 0, 0)
    end
    if InfoLabo.StatusTable2 == 2 then
        InfoLabo.Table2Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1093.103623, -3195.734745, -39.192493, 0, 0, 0)
    end
    if InfoLabo.StatusTable3 == 2 then
        InfoLabo.Table3Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1090.350258, -3195.7056300000004, -39.191955, 0, 0, 0)
    end
end)

RegisterNetEvent('DeleteObjCoke')
AddEventHandler('DeleteObjCoke', function()
    if DoesEntityExist(InfoLabo.Table1Object) then
        DeleteObject(InfoLabo.Table1Object)
    end
    if DoesEntityExist(InfoLabo.Table2Object) then
        DeleteObject(InfoLabo.Table2Object)
    end
    if DoesEntityExist(InfoLabo.Table3Object) then
        DeleteObject(InfoLabo.Table3Object)
    end
end)

RegisterNetEvent("ClRefreshLabo")
AddEventHandler("ClRefreshLabo", function(idprop)
    if Property.IsInProperty then
        if idprop == Property.Current.Id then
            callback()
            Wait(350)

            if InfoLabo.StatusTable1 == 0 then
                if DoesEntityExist(InfoLabo.Table1Object) then
                    DeleteObject(InfoLabo.Table1Object)
                end
            end
            if InfoLabo.StatusTable2 == 0 then
                if DoesEntityExist(InfoLabo.Table2Object) then
                    DeleteObject(InfoLabo.Table2Object)
                end
            end
            if InfoLabo.StatusTable3 == 0 then
                if DoesEntityExist(InfoLabo.Table3Object) then
                    DeleteObject(InfoLabo.Table3Object)
                end
            end
            if InfoLabo.StatusTable1 == 2 then
                if not DoesEntityExist(InfoLabo.Table1Object) then
                    InfoLabo.Table1Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1095.388436, -3195.7072620000004, -39.191919, 0, 0, 0)
                end
            end
            if InfoLabo.StatusTable2 == 2 then
                if not DoesEntityExist(InfoLabo.Table2Object) then
                    InfoLabo.Table2Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1093.103623, -3195.734745, -39.192493, 0, 0, 0)
                end
            end
            if InfoLabo.StatusTable3 == 2 then
                if not DoesEntityExist(InfoLabo.Table3Object) then
                    InfoLabo.Table3Object = CreateObject(GetHashKey("bkr_prop_coke_tablepowder"), 1090.350258, -3195.7056300000004, -39.191955, 0, 0, 0)
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        local time = 1000
        if Property.IsInProperty and Property.Current.CanAccess and Property.Current.Id_Crew ~= nil and Property.Current.Interior == 'Labo2' then
            if InfoLabo.StatusTable1 ~= nil and InfoLabo.StatusTable2 ~= nil and InfoLabo.StatusTable3 ~= nil then

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1095.27, -3194.82, -38.99)) <= 1.7 then
                    time = 1
                    if InfoLabo.StatusTable1 == 0 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour déposer.\n\n~c~Acide sulfurique (0/12)\nCoca (0/25)")
                        if IsControlJustReleased(0, 51) then
                            ESX.TriggerServerCallback('getItemLabo', function(cb)
                                if cb then
                                    TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 1, 1, InfoLabo.IdLabo)
                                else
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'acide sulfurique ou de coca sur vous~s~")
                                end
                            end, InfoLabo.IdProp)
                        end
                    elseif InfoLabo.StatusTable1 == 1 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~pour lancer la production~s~.")
                        if IsControlJustReleased(0, 51) then    
                            FreezeEntityPosition(PlayerPedId(), true)
                            while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                                RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                                Citizen.Wait(5)
                            end
                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 1, 0, 0, 0,  true, false, true)
                            Wait(9000)
                            TriggerServerEvent("StartProcessusLabo", InfoLabo.IdLabo, 1)
                            TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 1, 2, InfoLabo.IdLabo)
                            FreezeEntityPosition(PlayerPedId(), false)
                            StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", -1.8)
                            RequestNamedPtfxAsset("scr_rcbarry2")
                            while not HasNamedPtfxAssetLoaded("scr_rcbarry2") do
                                Citizen.Wait(1)
                            end
                            UseParticleFxAssetNextCall('scr_rcbarry2')
                            StartNetworkedParticleFxNonLoopedAtCoord('scr_exp_clown', 1095.42, -3195.28, -39.0, 0.0, 0.0, 0.0, 0.25, false, false, false)
                        end
                    elseif InfoLabo.StatusTable1 == 2 then
                        DisplayNotification("En cours\n~b~"..SecondsToClock(InfoLabo.timeRemaining1))
                    elseif InfoLabo.StatusTable1 == 3 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la ~g~cocaïne")
                        if IsControlJustReleased(0, 51) then
                            -- local player, distance = ESX.Game.GetClosestPlayer()
                            -- if distance ~= -1 and distance <= 3.0 then  
                                ESX.TriggerServerCallback("AddCokeToPlayer", function(result) 
                                    if not result then
                                        ESX.Notification("~r~Vous n'avez pas assez de place pour porter cette charge.")
                                    end
                                end, InfoLabo.IdLabo, InfoLabo.IdProp, 1)
                            -- else
                                -- ESX.ShowNotification("Impossible de récupérer la ~g~cocaïne~s~ quand il y à une personne autour de vous.")
                            -- end
                        end
                    end
                end

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1093.08, -3194.78, -38.99)) <= 1.7 then
                    time = 1
                    if InfoLabo.StatusTable2 == 0 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour déposer.\n\n~c~Acide sulfurique (0/12)\nCoca (0/25)")
                        if IsControlJustReleased(0, 51) then
                            ESX.TriggerServerCallback('getItemLabo', function(cb)
                                if cb then
                                    TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 2, 1, InfoLabo.IdLabo)
                                else
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'acide sulfurique ou de coca sur vous~s~")
                                end
                            end, InfoLabo.IdProp)
                        end
                    elseif InfoLabo.StatusTable2 == 1 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~pour lancer la production~s~.")
                        if IsControlJustReleased(0, 51) then    
                            FreezeEntityPosition(PlayerPedId(), true)
                            while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                                RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                                Citizen.Wait(5)
                            end
                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 1, 0, 0, 0,  true, false, true)
                            Wait(9000)
                            TriggerServerEvent("StartProcessusLabo", InfoLabo.IdLabo, 2)
                            TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 2, 2, InfoLabo.IdLabo)
                            FreezeEntityPosition(PlayerPedId(), false)
                            StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", -1.8)
                            RequestNamedPtfxAsset("scr_rcbarry2")
                            while not HasNamedPtfxAssetLoaded("scr_rcbarry2") do
                                Citizen.Wait(1)
                            end
                            UseParticleFxAssetNextCall('scr_rcbarry2')
                            StartNetworkedParticleFxNonLoopedAtCoord('scr_exp_clown', 1092.93, -3195.28, -39.0, 0.0, 0.0, 0.0, 0.25, false, false, false)
                        end
                    elseif InfoLabo.StatusTable2 == 2 then
                        DisplayNotification("En cours\n~b~"..SecondsToClock(InfoLabo.timeRemaining2))
                    elseif InfoLabo.StatusTable2 == 3 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la ~g~cocaïne")
                        if IsControlJustReleased(0, 51) then
                            -- local player, distance = ESX.Game.GetClosestPlayer()
                            -- if distance ~= -1 and distance <= 3.0 then  
                                ESX.TriggerServerCallback("AddCokeToPlayer", function(result) 
                                    if not result then
                                        ESX.Notification("~r~Vous n'avez pas assez de place pour porter cette charge.")
                                    end
                                end, InfoLabo.IdLabo, InfoLabo.IdProp, 2)
                            -- else
                                -- ESX.ShowNotification("Impossible de récupérer la ~g~cocaïne~s~ quand il y à une personne autour de vous.")
                            -- end
                        end
                    end
                end

                if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), vector3(1090.16, -3194.83, -38.99)) <= 1.7 then
                    time = 1
                    if InfoLabo.StatusTable3 == 0 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour déposer.\n\n~c~Acide sulfurique (0/12)\nCoca (0/25)")
                        if IsControlJustReleased(0, 51) then
                            ESX.TriggerServerCallback('getItemLabo', function(cb)
                                if cb then
                                    TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 3, 1, InfoLabo.IdLabo)
                                else
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'acide sulfurique ou de coca sur vous~s~")
                                end
                            end, InfoLabo.IdProp)
                        end
                    elseif InfoLabo.StatusTable3 == 1 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~pour lancer la production~s~.")
                        if IsControlJustReleased(0, 51) then    
                            FreezeEntityPosition(PlayerPedId(), true)
                            while not HasAnimDictLoaded("anim@amb@business@coc@coc_unpack_cut_left@") do
                                RequestAnimDict("anim@amb@business@coc@coc_unpack_cut_left@")
                                Citizen.Wait(5)
                            end
                            TaskPlayAnim(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", 8.0, 8.0, -1, 1, 1, 0, 0, 0,  true, false, true)
                            Wait(9000)
                            TriggerServerEvent("StartProcessusLabo", InfoLabo.IdLabo, 3)
                            TriggerServerEvent("UpdateStatusTable", InfoLabo.IdProp, 3, 2, InfoLabo.IdLabo)
                            FreezeEntityPosition(PlayerPedId(), false)
                            StopAnimTask(PlayerPedId(), "anim@amb@business@coc@coc_unpack_cut_left@", "coke_cut_v5_coccutter", -1.8)
                            RequestNamedPtfxAsset("scr_rcbarry2")
                            while not HasNamedPtfxAssetLoaded("scr_rcbarry2") do
                                Citizen.Wait(1)
                            end
                            UseParticleFxAssetNextCall('scr_rcbarry2')
                            StartNetworkedParticleFxNonLoopedAtCoord('scr_exp_clown', 1090.32, -3195.28, -39.0, 0.0, 0.0, 0.0, 0.25, false, false, false)
                        end
                    elseif InfoLabo.StatusTable3 == 2 then
                        DisplayNotification("En cours\n~b~"..SecondsToClock(InfoLabo.timeRemaining3))
                    elseif InfoLabo.StatusTable3 == 3 then
                        DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour récupérer la ~g~cocaïne")
                        if IsControlJustReleased(0, 51) then
                            ESX.TriggerServerCallback("AddCokeToPlayer", function(result) 
                                if not result then
                                    ESX.Notification("~r~Vous n'avez pas assez de place pour porter cette charge.")
                                end
                            end, InfoLabo.IdLabo, InfoLabo.IdProp, 3)
                        end
                    end
                end
            end
        end
        Wait(time)
    end
end)