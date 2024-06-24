ESX = nil

PlayerData = {}

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj PlayerData = ESX.GetPlayerData() end) 

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
end)

function poschair(xyz, h)
    ESX.Streaming.RequestAnimDict("misshair_shop@hair_dressers")
    TaskPlayAnimAdvanced(PlayerPedId(), "misshair_shop@hair_dressers", "player_base", vector3(xyz), vector3(0.0, 0.0, h), 1000.0, -1000.0, -1, 5643, 0.0, 2, 1)
end

RegisterNetEvent('sitchairtargetcl') 
AddEventHandler('sitchairtargetcl', function(poschaise, heading)
    poschair(poschaise, heading)
    FreezeEntityPosition(GetPlayerPed(-1), true)
    TriggerEvent('skinchanger:change', "helmet_1", -1)
end)

RegisterNetEvent('skinchanger:changetargetcl') 
AddEventHandler('skinchanger:changetargetcl', function(type, var)
    TriggerEvent('skinchanger:change', type, var)
end)

RegisterNetEvent('ClFinalisation') 
AddEventHandler('ClFinalisation', function(type, xyz)
    if type == "cancel" then
        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
            TriggerEvent('skinchanger:loadSkin', skin)
        end)
    elseif type == "save" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            TriggerServerEvent('esx_skin:save', skin)
        end)
    end
    FreezeEntityPosition(GetPlayerPed(-1), false)
    ClearPedTasksImmediately(GetPlayerPed(-1))
    ClearPedSecondaryTask(GetPlayerPed(-1))
    SetEntityCoords(PlayerPedId(), xyz)
end)

function startAnims(lib, anim)
	ESX.Streaming.RequestAnimDict(lib)
	TaskPlayAnim(GetPlayerPed(-1), lib, anim, 8.0, -4.0, -1, 1, 0, 0, 0, 0)
end

Barber = {
    SelectionListingIndex = 1,
    GestionListingIndex = 1,
    HairListingIndex = 1,
    BeardListingIndex = 1,
    EyebrowListingIndex = 1,
    BeardSizeListingIndex = 1,
    EyebrowSizeListingIndex = 1,

    HairValue = {},
    BeardValue = {},
    EyebrowValue = {},

    HairColor = {
        primary = { 1, 1 },
        secondary = { 1, 1 }
    },
    BeardColor = {
        primary = { 1, 1 },
    },
    EyebrowColor = {
        primary = { 1, 1 },
    },
    MakeupColor = {
        primary = { 1, 1 },
        secondary = { 1, 1 }
    },
    cameraBarber = nil,

    inMenuCoiffeur = true
}

Barber.openedMenu = false
Barber.openedGestMenu = false
Barber.mainMenu = RageUI.CreateMenu("", "Herr Kutz", nil, 100, "shopui_title_barber", "shopui_title_barber")
Barber.mainGestMenu = RageUI.CreateMenu("", "Herr Kutz", nil, 100, "shopui_title_barber", "shopui_title_barber")
Barber.mainMenu.EnableMouse = true;
Barber.mainMenu.Closable = false

function openBarber(poschaise, xTarget)
    if Barber.openedMenu then 
        Barber.openedMenu = false 
        RageUI.Visible(Barber.mainMenu,false)
        return
    else
        Barber.HairValue = {}
        Barber.BeardValue = {}
        Barber.EyebrowValue = {}
        Barber.MakeupValue = {}
        Barber.HairListingIndex = 1
        Barber.BeardListingIndex = 1
        Barber.EyebrowListingIndex = 1
        Barber.MakeupListingIndex = 1
        for i = 1, GetNumberOfPedDrawableVariations(GetPlayerPed(xTarget), 2) do
            table.insert(Barber.HairValue, {Name = tostring(i)})
        end
        
        for i = 1, GetPedHeadOverlayNum(1)-1 do
            table.insert(Barber.BeardValue, {Name = tostring(i)})
        end
        
        for i = 1, GetNumberOfPedDrawableVariations(GetPlayerPed(xTarget), 0) do
            table.insert(Barber.EyebrowValue, {Name = tostring(i)})
        end

        for i = 1, GetNumHeadOverlayValues(4)-1 do
            table.insert(Barber.MakeupValue, {Name = tostring(i)})
        end
        Wait(150)
        Barber.openedMenu = true
        RageUI.Visible(Barber.mainMenu, true)
        Citizen.CreateThread(function()
            while Barber.openedMenu do 
                    RageUI.IsVisible(Barber.mainMenu, function()
                        RageUI.Separator("- ~o~Selection~s~ -")
                        RageUI.List('Liste des coiffures', Barber.HairValue, Barber.HairListingIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Barber.HairListingIndex = Index
                                TriggerServerEvent('skinchanger:changetarget', target, 'hair_1', Barber.HairListingIndex-1)
                            end
                        })

                        RageUI.List('Liste des barbes', Barber.BeardValue, Barber.BeardListingIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Barber.BeardListingIndex = Index
                                TriggerServerEvent('skinchanger:changetarget', target, 'beard_1', Barber.BeardListingIndex)
                            end
                        })
                        RageUI.List('Liste des sourcils', Barber.EyebrowValue, Barber.EyebrowListingIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Barber.EyebrowListingIndex = Index
                                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_1', Barber.EyebrowListingIndex)
                            end
                        })
                        RageUI.List('Liste des maquillages', Barber.MakeupValue, Barber.MakeupListingIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Barber.MakeupListingIndex = Index
                                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_1', Barber.MakeupListingIndex-2)
                            end
                        })
                        RageUI.List("Selection", {
                            {Name = "~g~Valider~s~", Value = 1},
                            {Name = "~r~Annuler~s~", Value = 2},
                        }, Barber.SelectionListingIndex, nil, {}, true, {
                            onListChange = function(Index)
                                Barber.SelectionListingIndex = Index;
                            end,
                            
                            onSelected = function(Index)
                                if Index == 1 then
                                    RageUI.CloseAll()
                                    Barber.mainMenu.Closable = true
                                    Barber.openedMenu = false
                                    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
                                    ciseau = CreateObject(GetHashKey("p_cs_scissors_s"), x, y, z,  true,  true, true)
                                    AttachEntityToEntity(ciseau, GetPlayerPed(-1), GetPedBoneIndex(GetPlayerPed(-1), 28422), -0.0, 0.03, 0, 0, -270.0, -20.0, true, true, false, true, 1, true)
                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                    startAnims("misshair_shop@barbers", "keeper_idle_b")
                                    Wait(10500)
                                    DeleteObject(ciseau)
                                    DetachEntity(ciseau, 1, true)
                                    ClearPedTasksImmediately(GetPlayerPed(-1))
                                    ClearPedSecondaryTask(GetPlayerPed(-1))
                                    TriggerServerEvent('SvFinalisation', target, "save", poschaise)
                                    ESX.ShowNotification("~g~Coiffeur~s~\nVous avez changé la coupe de votre client.")
                                    Barber.inMenuCoiffeur = true
                                elseif Index == 2 then
                                    TriggerServerEvent('SvFinalisation', target, "cancel", poschaise)
                                    FreezeEntityPosition(GetPlayerPed(-1), false)
                                    DeleteObject(ciseau)
                                    DetachEntity(ciseau, 1, true)
                                    ClearPedTasksImmediately(GetPlayerPed(-1))
                                    ClearPedSecondaryTask(GetPlayerPed(-1))
                                    Barber.openedMenu = false
                                    Barber.inMenuCoiffeur = true
                                end
                            end
                        })

                        RageUI.ColourPanel("Couleur de cheveux", RageUI.PanelColour.HairCut, Barber.HairColor.primary[1], Barber.HairColor.primary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.HairColor.primary[1] = MinimumIndex
                                Barber.HairColor.primary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'hair_color_1', CurrentIndex)
                            end
                        }, 2)
                        RageUI.ColourPanel("Couleur secondaire cheveux", RageUI.PanelColour.HairCut, Barber.HairColor.secondary[1], Barber.HairColor.secondary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.HairColor.secondary[1] = MinimumIndex
                                Barber.HairColor.secondary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'hair_color_2', MinimumIndex)
                            end
                        }, 2)
                        RageUI.ColourPanel("Couleur de barbe", RageUI.PanelColour.HairCut, Barber.BeardColor.primary[1], Barber.BeardColor.primary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.BeardColor.primary[1] = MinimumIndex
                                Barber.BeardColor.primary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'beard_3', CurrentIndex)
                            end
                        }, 3)
                        RageUI.ColourPanel("Couleur de sourcils", RageUI.PanelColour.HairCut, Barber.EyebrowColor.primary[1], Barber.EyebrowColor.primary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.EyebrowColor.primary[1] = MinimumIndex
                                Barber.EyebrowColor.primary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_3', CurrentIndex)
                            end
                        }, 4)
                        RageUI.ColourPanel("Couleur de maquillage", RageUI.PanelColour.HairCut, Barber.MakeupColor.primary[1], Barber.MakeupColor.primary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.MakeupColor.primary[1] = MinimumIndex
                                Barber.MakeupColor.primary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_3', CurrentIndex)
                            end
                        }, 5)
                        RageUI.ColourPanel("Couleur secondaire maquillage", RageUI.PanelColour.HairCut, Barber.MakeupColor.secondary[1], Barber.MakeupColor.secondary[2], {
                            onColorChange = function(MinimumIndex, CurrentIndex)
                                Barber.MakeupColor.secondary[1] = MinimumIndex
                                Barber.MakeupColor.secondary[2] = CurrentIndex
                                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_4', MinimumIndex)
                            end
                        }, 5)
                
                        RageUI.PercentagePanel(Barber.BeardSizeListingIndex, 'Taille de la barbe', '0', '10', {
                            onProgressChange = function(Percentage)
                                Barber.BeardSizeListingIndex = Percentage
                                TriggerServerEvent('skinchanger:changetarget', target, 'beard_2', Percentage*10)
                            end
                        }, 3)
                        RageUI.PercentagePanel(Barber.EyebrowSizeListingIndex, 'Opacité', '0', '10', {
                            onProgressChange = function(Percentage)
                                Barber.EyebrowSizeListingIndex = Percentage
                                TriggerServerEvent('skinchanger:changetarget', target, 'eyebrows_2', Percentage*10)
                            end
                        }, 4)
                        RageUI.PercentagePanel(Barber.MakeupListingIndex, 'Opacité', '0', '10', {
                            onProgressChange = function(Percentage)
                                Barber.MakeupListingIndex = Percentage
                                TriggerServerEvent('skinchanger:changetarget', target, 'makeup_2', Percentage*10)
                            end
                        }, 5)
                    end)            
                Wait(1)
            end
        end)
    end
end

local PositionBarber = {
	{
        pos = vector3(138.12, -1708.47, 28.30),
        headingpos = 210.8189697,
        poschaise = vector3(138.25, -1709.20, 28.50),
        headingchair = -35.00,
        finish = vector3(137.81, -1709.77, 28.30),
        metier = "barber"
    },
    {
        pos = vector3(-816.38, -183.77, 36.55),
        headingpos = 2.247,
        poschaise = vector3(-816.28, -182.84, 36.55),
        headingchair = 122.55,
        finish = vector3(-815.59, -182.56, 36.56),
        metier = "barber2"
    },
    {
        pos = vector3(1932.39, 3731.165, 31.85),
        headingpos = 273.01,
        poschaise = vector3(1933.32, 3731.21, 32.0),
        headingchair = 35.00,
        finish = vector3(1933.65, 3730.55, 31.85),
        metier = "barber2"
    },
    {
        pos = vector3(-278.74, 6227.025, 30.70),
        headingpos = 113.37,
        poschaise = vector3(-279.46, 6226.91, 30.90),
        headingchair = 220.00,
        finish = vector3(-280.06, 6227.38, 30.70),
        metier = "barber2"
    },
}

Citizen.CreateThread(function()
    for _, v in pairs(PositionBarber) do
        v.blips = AddBlipForCoord(v.pos)
        SetBlipSprite(v.blips, 71)
        SetBlipDisplay(v.blips, 4)
        SetBlipScale(v.blips, 0.8)
        SetBlipColour(v.blips, 71)
        SetBlipAsShortRange(v.blips, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString("Barber")
        EndTextCommandSetBlipName(v.blips)
    end
    while true do
        local wait = 1000
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            for k, v in pairs(PositionBarber) do 
                local dist = Vdist(GetEntityCoords(PlayerPedId()), v.pos)
                if PlayerData.job and PlayerData.job.name == v.metier then 
                    if dist <= 15 then
                        wait = 5
                        DrawMarker(25, v.pos+0.05, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.6, 0.6, 0.6, 46, 134, 193, 178, false, false, false, false)
                    end
                    if dist <= 3 then 
                        wait = 5
                        DisplayNotification("Appuyez sur ~INPUT_TALK~ pour accéder au ~y~coiffeur~w~.")
                        if IsControlJustPressed(0, 51) then
                            TriggerEvent('skinchanger:getSkin', function(skin)
                                local xTarget = GetNearbyPlayer(2)
                                if xTarget and Barber.inMenuCoiffeur then
                                    Barber.inMenuCoiffeur = false
                                    TriggerServerEvent('sitchairtarget', GetPlayerServerId(xTarget), v.poschaise, v.headingchair)
                                    FreezeEntityPosition(GetPlayerPed(-1), true)
                                    openBarber(v.finish, xTarget)
                                    SetEntityCoords(PlayerPedId(), v.pos)
                                    SetEntityHeading(PlayerPedId(), v.headingpos)
                                    startAnims("misshair_shop@hair_dressers", "keeper_idle_b")
                                    target = GetPlayerServerId(xTarget)
                                end
                            end)
                        end
                    end
                end
            end 
        end
        Wait(wait)
    end
end)