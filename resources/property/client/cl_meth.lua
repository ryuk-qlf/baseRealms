RegisterNetEvent('CreateLaboMeth')
AddEventHandler('CreateLaboMeth', function()
    TriggerServerEvent("CreateLaboMeth", Property.Current.Id)
end)

local InfoLabo = {}
local doingAnimation = false
local Doing1hThing = {
    value = false,
    finished = false,
    temps = 60
}

RegisterNetEvent('EnterLaboMeth')
AddEventHandler('EnterLaboMeth', function()
    BikerMethLab = exports['bob74_ipl']:GetBikerMethLabObject()

    BikerMethLab.Style.Set(BikerMethLab.Style.basic)
    BikerMethLab.Security.Set(BikerMethLab.Security.upgrade)
    BikerMethLab.Details.Enable(BikerMethLab.Details.production, true)

    RefreshInterior(BikerMethLab.interiorId)
    Property.RefreshCountLabo = true
    callbackM()
end)

local timeInM = 60

function callbackM()
    ESX.TriggerServerCallback('GetInfoLaboM', function(result)
        for i = 1, #result, 1 do	
            InfoLabo.IdLabo = result[i].id_labo
            InfoLabo.IdProp = result[i].id_prop
            InfoLabo.HaveMachineOn = ConvertToBool(result[i].HaveMachineOn)
            InfoLabo.HavePreparedTable = ConvertToBool(result[i].HavePreparedTable)
            InfoLabo.HaveDisposedInCuve = ConvertToBool(result[i].HaveDisposedInCuve)
            InfoLabo.DateTable = result[i].DateTable
            InfoLabo.Ms = 0
            InfoLabo.timeRemaining = 3600
        end	
    end, Property.Current.Id)
    Wait(250)
    if json.encode(InfoLabo.DateTable) ~= "null" then
        ESX.TriggerServerCallback("GetTimeFortable", function(result)
            local temps = (timeInM-result)
            if temps > 0 then
                Doing1hThing.value = true
                Doing1hThing.temps = temps
            else
                Doing1hThing.value = true
                Doing1hThing.finished = true
                Doing1hThing.temps = temps
            end
        end, InfoLabo.DateTable)
    end

    if json.encode(InfoLabo.DateTable) ~= "null" then
        ESX.TriggerServerCallback("GetMsOfProd", function(result)
            InfoLabo.Ms = result
            InfoLabo.timeRemaining = InfoLabo.timeRemaining-InfoLabo.Ms
        end, InfoLabo.DateTable)
    end

    Wait(500)
    Property.RefreshTimerMeth = false
    Property.RefreshTimerMeth = true

    if Property.RefreshCountLabo then
        Property.RefreshCountLabo = false
        while Property.RefreshTimerMeth do
            print("1")
            if Property.Current.CanAccess and Property.Current.Interior == "Labo3" and Property.Current.Id_Crew ~= nil then
                print("2")
                if json.encode(InfoLabo.DateTable) ~= "null" then
                    print("3")
                    InfoLabo.timeRemaining = InfoLabo.timeRemaining-1
                else
                    print("4")
                    break
                end
            end
            if not Property.IsInProperty then
                print('plus dans la propriété')
                Property.RefreshTimerMeth = false
            end
            Wait(1000)
        end
    end
end

RegisterNetEvent("ClRefreshLaboM")
AddEventHandler("ClRefreshLaboM", function(idprop)
    if Property.IsInProperty then
        if idprop == Property.Current.Id then
            callbackM()
        end
    end
end)

RegisterNetEvent("DoAnimForAll")
AddEventHandler("DoAnimForAll", function(idprop, state)
    if Property.IsInProperty then
        if idprop == Property.Current.Id then
            doingAnimation = state
        end
    end
end)

function SecondsToClock(seconds)
	seconds = tonumber(seconds)

	if seconds <= 0 then
		return "00:00"
	else
		mins = string.format("%02.f", math.floor(seconds / 60))
		secs = string.format("%02.f", math.floor(seconds - mins * 60))
		return string.format("%s:%s", mins, secs)
	end
end

CreateThread(function()
    while true do
        local time = 1000
        if Property.IsInProperty and Property.Current.CanAccess and Property.Current.Id_Crew ~= nil and Property.Current.Interior == "Labo3" then
            local coordsMachine = vector3(1006.647, -3197.655, -38.99318)
            local coordsCuve = vector3(1005.748, -3200.359, -38.519)
            local coordsTable = vector3(1012.226, -3194.876, -38.993)
            local PlyCoords = GetEntityCoords(PlayerPedId())
            local BoolMessageMachine = not InfoLabo.HaveMachineOn and "~g~allumer~s~" or "~r~éteindre~s~"
            local BoolMessageCuve = not InfoLabo.HaveDisposedInCuve and "Appuyez sur ~INPUT_CONTEXT~ pour déposer.\n\n~c~Phosphore (0/12)\nAcide (0/12)\nMéthylamine (0/12)" or 'Vous avez ~r~déjà~s~ déposé les ingrédients dans la cuve'
            if GetDistanceBetweenCoords(PlyCoords, coordsMachine, true) < 1.7 then
                time = 1
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour "..BoolMessageMachine.." la machine")
                if IsControlJustPressed(0, 51) then
                    if not InfoLabo.HaveMachineOn and not InfoLabo.HaveDisposedInCuve then
                        InfoLabo.HaveMachineOn = true
                    elseif InfoLabo.HaveMachineOn and not InfoLabo.HaveDisposedInCuve then
                        InfoLabo.HaveMachineOn = false
                    end
                    if InfoLabo.HaveDisposedInCuve then
                        ESX.Notification('~r~Impossible, une production est déjà en cours !')
                    end
                    if not InfoLabo.HaveDisposedInCuve then
                        TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Machine', ConvertToNum(InfoLabo.HaveMachineOn))
                        --TriggerServerEvent("SvRefreshLaboM", Property.Current.Id)
                    end
                end
            end
            if GetDistanceBetweenCoords(PlyCoords, coordsCuve, true) < 1.7 then
                time = 1
                if not doingAnimation then
                    DisplayNotification(BoolMessageCuve)
                end
                if IsControlJustPressed(0, 51) then
                    if InfoLabo.HaveMachineOn and not InfoLabo.HaveDisposedInCuve then
                        if not doingAnimation then
                            ESX.TriggerServerCallback('HaveEnoughItemsMeth', function(result)
                                if result then
                                    DoAnimationMeth1()
                                    TriggerServerEvent('DoAnimForAll', Property.Current.Id, true)
                                else
                                    ESX.ShowNotification("~r~Vous n'avez pas assez d'ingrédients sur vous~s~")
                                end
                            end)
                        end
                    else
                        ESX.Notification("~r~La machine est éteinte")
                    end
                end
            end

            if GetDistanceBetweenCoords(PlyCoords, coordsTable, true) < 1.7 then
                time = 1
                    if not doingAnimation then
                        DisplayNotification(not InfoLabo.HavePreparedTable and 'Appuyez sur ~INPUT_CONTEXT~ pour ~g~préparer~s~ la table' or InfoLabo.HavePreparedTable and not Doing1hThing.value and 'Appuyez sur ~INPUT_CONTEXT~ pour ~g~lancer~s~ la production de Meth' or InfoLabo.HavePreparedTable and Doing1hThing.value and not Doing1hThing.finished and '~b~En cours~s~\n'..SecondsToClock(InfoLabo.timeRemaining) or InfoLabo.HavePreparedTable and Doing1hThing.value and Doing1hThing.finished and 'Appuyez sur ~INPUT_CONTEXT~ pour ~g~récupérer~s~ la meth')
                    end
                    if IsControlJustPressed(0, 51) then
                    if not doingAnimation then
                        if InfoLabo.HaveMachineOn and InfoLabo.HaveDisposedInCuve then
                            if not InfoLabo.HavePreparedTable then
                                DoAnimationMeth2()
                                TriggerServerEvent('DoAnimForAll', Property.Current.Id, true)
                            end
                        else
                            ESX.Notification('~r~Impossible, la machine est éteinte ou une production est déjà en cours !')
                        end

                        if InfoLabo.HaveMachineOn and InfoLabo.HaveDisposedInCuve and InfoLabo.HavePreparedTable then
                            if not Doing1hThing.value and not Doing1hThing.finished then
                                TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Date')
                                Doing1hThing.value = true
                                -- Wait(1000)
                                -- TriggerServerEvent("SvRefreshLaboM", Property.Current.Id)
                                -- Property:Exit()
                                -- Property:Enter()
                            end
                            if Doing1hThing.finished then
                                ESX.TriggerServerCallback("CanCarryItem", function(result)
                                    if result then
                                        DoAnimationMeth3()
                                        TriggerServerEvent('DoAnimForAll', Property.Current.Id, true)
                                    else
                                        ESX.Notification('~r~Vous n\'avez pas assez de place pour porter cette charge.')
                                    end
                                end)
                            end
                        end
                    end
                end
            end
        end
        Wait(time)
    end
end)

function DoAnimationMeth1()
    doingAnimation = true
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(10)
			local ped = PlayerPedId() 
            local targetRotation = vec3(180.0, 180.0, 180.0)
            local x,y,z = table.unpack(vec3(1005.748, -3200.359, -38.519))

			local animDict = "anim@amb@business@meth@meth_monitoring_cooking@cooking@"
    
            RequestAnimDict(animDict)
            RequestModel("bkr_prop_meth_ammonia")
            RequestModel("bkr_prop_meth_sacid")
            RequestModel("bkr_prop_fakeid_clipboard_01a")
            RequestModel("bkr_prop_fakeid_penclipboard")
    
            while not HasAnimDictLoaded(animDict) and
                not HasModelLoaded("bkr_prop_meth_ammonia") and 
                not HasModelLoaded("bkr_prop_meth_sacid") and 
                not HasModelLoaded("bkr_prop_fakeid_clipboard_01a") and
                not HasModelLoaded("bkr_prop_fakeid_penclipboard") do 
                Citizen.Wait(100)
            end

            ammonia = CreateObject(GetHashKey('bkr_prop_meth_ammonia'), x, y, z, 1, 0, 1)
            acido = CreateObject(GetHashKey('bkr_prop_meth_sacid'), x, y, z, 1, 0, 1)
            caderneta = CreateObject(GetHashKey('bkr_prop_fakeid_clipboard_01a'), x, y, z, 1, 0, 1)
            caneta = CreateObject(GetHashKey('bkr_prop_fakeid_penclipboard'), x, y, z, 1, 0, 1)   

            SetEntityCollision(ammonia, false, false)
            SetEntityCollision(acido, false, false)
            SetEntityCollision(caderneta, false, false)
            SetEntityCollision(caneta, false, false)

            local netScene = NetworkCreateSynchronisedScene(x + 5.0 ,y + 2.0, z - 0.4, targetRotation, 2, false, false, 1148846080, 0, 1.3)
            local netScene2 = NetworkCreateSynchronisedScene(x + 5.0 ,y + 2.0, z - 0.4, targetRotation, 2, false, false, 1148846080, 0, 1.3)
            NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "chemical_pour_long_cooker", 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(ammonia, netScene, animDict, "chemical_pour_long_ammonia", 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(acido, netScene, animDict, "chemical_pour_long_sacid", 4.0, -8.0, 1)
            NetworkAddEntityToSynchronisedScene(caderneta, netScene, animDict, "chemical_pour_long_clipboard", 4.0, -8.0, 1)
            NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "chemical_pour_long_cooker", 1.5, -4.0, 1, 16, 1148846080, 0)
            NetworkAddEntityToSynchronisedScene(caneta, netScene2, animDict, "chemical_pour_long_pencil", 4.0, -8.0, 1)
			
			Citizen.Wait(150)
            NetworkStartSynchronisedScene(netScene)
            NetworkStartSynchronisedScene(netScene2)

			Citizen.Wait(GetAnimDuration(animDict, "chemical_pour_long_cooker") * 770)
            DeleteObject(ammonia)
            DeleteObject(acido)
            DeleteObject(caderneta)
			DeleteObject(caneta)
            InfoLabo.HaveDisposedInCuve = true
            TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Cuve', ConvertToNum(InfoLabo.HaveDisposedInCuve))
            --TriggerServerEvent("SvRefreshLaboM", Property.Current.Id)
            doingAnimation = false
            TriggerServerEvent('DoAnimForAll', Property.Current.Id, false)
			break
		end
	end)
end

function DoAnimationMeth2()
    doingAnimation = true
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5)
			local ped = PlayerPedId() 
			local  targetRotation = vec3(180.0, 180.0, 168.0)
			local x,y,z = table.unpack(vec3(1012.226, -3194.876, -38.993))

			local animDict = "anim@amb@business@meth@meth_smash_weight_check@"
    
			RequestAnimDict(animDict)
			RequestModel("bkr_prop_meth_tray_02a")
			RequestModel("w_me_hammer")
			RequestModel("bkr_prop_meth_tray_01a")
			RequestModel("bkr_prop_meth_smashedtray_01")
			RequestModel("bkr_prop_meth_smashedtray_01_frag_")
			RequestModel("bkr_prop_meth_bigbag_02a")

			while not HasAnimDictLoaded(animDict) and
				not HasModelLoaded("bkr_prop_meth_tray_02a") and 
				not HasModelLoaded("bkr_prop_fakeid_penclipboard") and 
				not HasModelLoaded("w_me_hammer") and 
				not HasModelLoaded("bkr_prop_meth_tray_01a") and 
				not HasModelLoaded("bkr_prop_meth_smashedtray_01") and 
				not HasModelLoaded("bkr_prop_meth_smashedtray_01_frag_") and 
				not HasModelLoaded("bkr_prop_meth_bigbag_02a") do 
				Citizen.Wait(100)
			end

			forma = CreateObject(GetHashKey('bkr_prop_meth_tray_02a'), x, y, z, 1, 0, 1)
			forma_2 = CreateObject(GetHashKey('bkr_prop_meth_tray_01a'), x, y, z, 1, 0, 1)
			--forma_quebrada = CreateObject(GetHashKey('bkr_prop_meth_smashedtray_01'), x, y, z, 1, 0, 1)
			forma_quebrada_2 = CreateObject(GetHashKey('bkr_prop_meth_smashedtray_01_frag_'), x, y, z, 1, 0, 1)
			martelo = CreateObject(GetHashKey('w_me_hammer'), x, y, z, 1, 0, 1)
			caixa = CreateObject(GetHashKey('bkr_prop_meth_bigbag_02a'), x, y, z, 1, 0, 1)




			local netScene = NetworkCreateSynchronisedScene(x - 3.6,y - 1.0, z - 1.0, targetRotation, 2, false, false, 1148846080, 0, 1.3)
			local netScene2 = NetworkCreateSynchronisedScene(x - 3.6,y - 1.0, z - 1.0, targetRotation, 2, false, false, 1148846080, 0, 1.3)
			
			NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "break_weigh_char02", 1.5, -4.0, 1, 16, 1148846080, 0)
			NetworkAddEntityToSynchronisedScene(forma_2, netScene, animDict, "break_weigh_tray01^1", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(martelo, netScene, animDict, "break_weigh_hammer", 4.0, -8.0, 1)

			NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "break_weigh_char02", 1.5, -4.0, 1, 16, 1148846080, 0)
			NetworkAddEntityToSynchronisedScene(forma, netScene2, animDict, "break_weigh_tray01^2", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(forma_quebrada_2, netScene2, animDict, "break_weigh_tray01", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(caixa, netScene2, animDict, "break_weigh_box01^1", 4.0, -8.0, 1)
			
			Citizen.Wait(150)
			NetworkStartSynchronisedScene(netScene)
			NetworkStartSynchronisedScene(netScene2)
            Citizen.Wait(GetAnimDuration(animDict, "break_weigh_char02") * 770)
			DeleteObject(forma)
			DeleteObject(forma_2)
			DeleteObject(forma_quebrada_2)
			DeleteObject(martelo)
			DeleteObject(caixa)
            doingAnimation = false
            TriggerServerEvent('DoAnimForAll', Property.Current.Id, false)
            InfoLabo.HavePreparedTable = true
            TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Table', ConvertToNum(InfoLabo.HavePreparedTable))
            --TriggerServerEvent("SvRefreshLaboM", Property.Current.Id)
			break
		end
	end)
end

function DoAnimationMeth3()
    doingAnimation = true
	Citizen.CreateThread(function()
		while true do
			Citizen.Wait(5)
			local ped = PlayerPedId() 
			local  targetRotation = vec3(180.0, 180.0, 168.0)
			local x,y,z = table.unpack(vec3(1012.226, -3194.876, -38.993))   

			local animDict = "anim@amb@business@meth@meth_smash_weight_check@"
    
			RequestAnimDict(animDict)
			RequestModel("bkr_prop_meth_scoop_01a")
			RequestModel("bkr_prop_meth_bigbag_03a")
			RequestModel("bkr_prop_meth_bigbag_04a")
			RequestModel("bkr_prop_fakeid_penclipboard")
			RequestModel("bkr_prop_fakeid_clipboard_01a")
			RequestModel("bkr_prop_meth_openbag_02")
			--RequestModel("bkr_prop_coke_scale_01")
			RequestModel("bkr_prop_meth_smallbag_01a")
			RequestModel("bkr_prop_meth_openbag_01a")
			RequestModel("bkr_prop_fakeid_penclipboard")

			while not HasAnimDictLoaded(animDict) and
				not HasModelLoaded("bkr_prop_meth_scoop_01a") and 
				not HasModelLoaded("bkr_prop_meth_bigbag_03a") and 
				not HasModelLoaded("bkr_prop_meth_bigbag_04a") and
				not HasModelLoaded("bkr_prop_meth_openbag_02") and 
				--not HasModelLoaded("bkr_prop_coke_scale_01") and 
				not HasModelLoaded("bkr_prop_meth_smallbag_01a") and 
				not HasModelLoaded("bkr_prop_meth_openbag_01a") and 
				not HasModelLoaded("bkr_prop_fakeid_clipboard_01a") and
				not HasModelLoaded("bkr_prop_fakeid_penclipboard") do 
				Citizen.Wait(100)
			end

			pazinha = CreateObject(GetHashKey('bkr_prop_meth_scoop_01a'), x, y, z, 1, 0, 1)
			caixa_grande = CreateObject(GetHashKey('bkr_prop_meth_bigbag_03a'), x, y, z, 1, 0, 1)
			caixa_grande_2 = CreateObject(GetHashKey('bkr_prop_meth_bigbag_04a'), x, y, z, 1, 0, 1)
			bolsa = CreateObject(GetHashKey('bkr_prop_meth_openbag_02'), x, y, z, 1, 0, 1)
			bolsa_fechada = CreateObject(GetHashKey('bkr_prop_meth_smallbag_01a'), x, y, z, 1, 0, 1)
			bolsa_aberta = CreateObject(GetHashKey('bkr_prop_meth_openbag_01a'), x, y, z, 1, 0, 1)
			--balanca = CreateObject(GetHashKey('bkr_prop_coke_scale_01'), x, y, z, 1, 0, 1)
			caderneta = CreateObject(GetHashKey('bkr_prop_fakeid_clipboard_01a'), x, y, z, 1, 0, 1)
			caneta = CreateObject(GetHashKey('bkr_prop_fakeid_penclipboard'), x, y, z, 1, 0, 1)


			local netScene = NetworkCreateSynchronisedScene(x - 5.3,y - 0.4, z - 1.0, targetRotation, 2, false, false, 1148846080, 0, 1.3)
			local netScene2 = NetworkCreateSynchronisedScene(x - 5.3 ,y - 0.4, z - 1.0, targetRotation, 2, false, false, 1148846080, 0, 1.3)
			local netScene3 = NetworkCreateSynchronisedScene(x - 5.3 ,y - 0.4, z - 1.0, targetRotation, 2, false, false, 1148846080, 0, 1.3)
			NetworkAddPedToSynchronisedScene(ped, netScene, animDict, "break_weigh_char01", 1.5, -4.0, 1, 16, 1148846080, 0)
			NetworkAddEntityToSynchronisedScene(pazinha, netScene, animDict, "break_weigh_scoop", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(caixa_grande_2, netScene, animDict, "break_weigh_box01", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(bolsa, netScene, animDict, "break_weigh_methbag01^3", 4.0, -8.0, 1)

			NetworkAddPedToSynchronisedScene(ped, netScene2, animDict, "break_weigh_char01", 1.5, -4.0, 1, 16, 1148846080, 0)
			--NetworkAddEntityToSynchronisedScene(balanca, netScene2, animDict, "break_weigh_scale", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(caixa_grande, netScene2, animDict, "break_weigh_box01^1", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(bolsa_fechada, netScene2, animDict, "break_weigh_methbag01^2", 4.0, -8.0, 1)

			NetworkAddPedToSynchronisedScene(ped, netScene3, animDict, "break_weigh_char01", 1.5, -4.0, 1, 16, 1148846080, 0)
			NetworkAddEntityToSynchronisedScene(bolsa_aberta, netScene3, animDict, "break_weigh_methbag01^1", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(caderneta, netScene3, animDict, "break_weigh_clipboard", 4.0, -8.0, 1)
			NetworkAddEntityToSynchronisedScene(caneta, netScene3, animDict, "break_weigh_pen", 4.0, -8.0, 1)
			
			NetworkStartSynchronisedScene(netScene)
			NetworkStartSynchronisedScene(netScene2)
			NetworkStartSynchronisedScene(netScene3)


			
			Citizen.Wait(GetAnimDuration(animDict, "break_weigh_char01") * 770)
            doingAnimation = false
            TriggerServerEvent('DoAnimForAll', Property.Current.Id, false)
			DeleteObject(pazinha)
			DeleteObject(caixa_grande)
			DeleteObject(caixa_grande_2)
			DeleteObject(bolsa)
			DeleteObject(bolsa_fechada)
			DeleteObject(bolsa_aberta)
			--DeleteObject(balanca)
			DeleteObject(caderneta)
			DeleteObject(caneta)
            InfoLabo.HavePreparedTable = false
            InfoLabo.HaveDisposedInCuve = false
            TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Cuve', ConvertToNum(InfoLabo.HaveDisposedInCuve))
            TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Table', ConvertToNum(InfoLabo.HavePreparedTable))
            TriggerServerEvent('UpdateServLaboMeth', InfoLabo.IdProp, InfoLabo.IdLabo, 'Date', {})
            Doing1hThing = {
                value = false,
                finished = false,
                temps = 60
            }
            Wait(500)
            --TriggerServerEvent("SvRefreshLaboM", Property.Current.Id)
			break
		end
	end)
end