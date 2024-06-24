local cachedData = {}

local function HandleCamera(toggle, coords)
    local Camerapos = nil

    Camerapos = coords

    if not Camerapos then
        return
    end

    if not toggle then
        if cachedData["camAmmu"] then
        DestroyCam(cachedData["camAmmu"])
        end
        RenderScriptCams(0, 1, 750, 1, 0)
        return
    end

    if cachedData["camAmmu"] then
        DestroyCam(cachedData["camAmmu"])
    end

    cachedData["camAmmu"] = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamCoord(cachedData["camAmmu"], Camerapos.x+1, Camerapos.y, Camerapos.z+1)
    SetCamActive(cachedData["camAmmu"], true)
    RenderScriptCams(1, 1, 750, 1, 1)
end

function refreshTenue()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

local Ammun = {
    items = {
        {label = "Fumigène", price = 800, item = "WEAPON_FLARE", props = "w_am_flare"}
    },

    illegalKev = {
        {label = "Kevlar #1", price = 4000, number = 21, variation = 0},
        {label = "Kevlar #2", price = 4000, number = 21, variation = 1},
        {label = "Kevlar #3", price = 4000, number = 21, variation = 2},
        {label = "Kevlar #4", price = 4000, number = 21, variation = 3},
        {label = "Kevlar #5", price = 4000, number = 19, variation = 0},
        {label = "Kevlar #6", price = 4000, number = 19, variation = 1},
        {label = "Kevlar #7", price = 4000, number = 19, variation = 2},
        {label = "Kevlar #8", price = 4000, number = 19, variation = 3},
        {label = "Kevlar #9", price = 4000, number = 22, variation = 1},
        {label = "Kevlar #10", price = 4000, number = 11, variation = 0},
        {label = "Kevlar #11", price = 4000, number = 11, variation = 1},
    },

    CrewKevlar = {259, 260, 261, 267, 269, 271, 281, 283, 293, 294, 299, 301},

    PoliceKev = {
        {label = "Kevlar #1", price = 4000, number = 18, variation = 0},
        {label = "Kevlar #2", price = 4000, number = 18, variation = 1},
        {label = "Kevlar #3", price = 4000, number = 18, variation = 2},
        {label = "Kevlar #4", price = 4000, number = 18, variation = 3},
        {label = "Kevlar #5", price = 4000, number = 18, variation = 4},

        {label = "Kevlar #6", price = 4000, number = 15, variation = 0},
        {label = "Kevlar #7", price = 4000, number = 15, variation = 1},
        {label = "Kevlar #8", price = 4000, number = 15, variation = 2},
        {label = "Kevlar #9", price = 4000, number = 15, variation = 3},
        {label = "Kevlar #10", price = 4000, number = 15, variation = 4},

        {label = "Kevlar #11", price = 4000, number = 14, variation = 0},
        {label = "Kevlar #12", price = 4000, number = 14, variation = 1},
        {label = "Kevlar #13", price = 4000, number = 14, variation = 2},
        {label = "Kevlar #14", price = 4000, number = 14, variation = 3},
        {label = "Kevlar #15", price = 4000, number = 14, variation = 4},
    },
 
    EmsKev = {
        {label = "Kevlar #1", price = 4000, number = 13, variation = 2},
        {label = "Kevlar #2", price = 4000, number = 13, variation = 1},
        {label = "Kevlar #3", price = 4000, number = 13, variation = 0},
    },

    WeazelNewsKev = {
        {label = "Kevlar #23", price = 4000, number = 13, variation = 4},
        {label = "Kevlar #22", price = 4000, number = 13, variation = 3},
    },

    PosAmmu = {
        vector3(22.72, -1105.36, 28.8),
        vector3(-662.24, -933.43, 20.83),
        vector3(-331.86, 6084.98, 30.45),
        vector3(253.92, -50.43, 68.94),
        vector3(842.51, -1035.33, 27.19),
        vector3(810.05, -2159.21, 28.62),
        vector3(-1119.06, 2699.75, 17.55),
        vector3(2567.92, 292.51, 107.73),
        vector3(1692.04, 3760.88, 33.71),
        vector3(-1305.40, -394.12, 36.69)
    },

    Munitions = {
        {label = "Munitions 45 ACP", item = "45acp_ammo", Price = 10, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
        {label = "Munitions 9mm", item = "9mm_ammo", Price = 12, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
        {label = "Munitions Calibre 12", item = "12_ammo", Price = 22, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
        {label = "Munitions 7.62mm", item = "762mm_ammo", Price = 50, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1}
    }
}

Ammun.inMenu = false
Ammun.menu = RageUI.CreateMenu("", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.subMenu = RageUI.CreateSubMenu(Ammun.menu, "", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.subMenu2 = RageUI.CreateSubMenu(Ammun.menu, "", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.subMenu3 = RageUI.CreateSubMenu(Ammun.menu, "", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.subMenu4 = RageUI.CreateSubMenu(Ammun.menu, "", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.subMenu5 = RageUI.CreateSubMenu(Ammun.menu, "", "Ammu-Nation", nil, 100, "shopui_title_gunclub", "shopui_title_gunclub")
Ammun.lastprops = nil
Ammun.Camera = true
Ammun.AccessKevIllegal = false
Ammun.menu:DisplayGlare(false)
Ammun.subMenu:DisplayGlare(false)

Ammun.subMenu2.Closed = function()
    refreshTenue()
    menuIsOpened = false
    RageUI.Visible(Ammun.subMenu2, false)
end

Ammun.subMenu3.Closed = function()
    refreshTenue()
    menuIsOpened = false
    RageUI.Visible(Ammun.subMenu3, false)
end

Ammun.subMenu4.Closed = function()
    refreshTenue()
    menuIsOpened = false
    RageUI.Visible(Ammun.subMenu4, false)
end

Ammun.subMenu5.Closed = function()
    refreshTenue()
    menuIsOpened = false
    RageUI.Visible(Ammun.subMenu5, false)
end

Ammun.menu.Closed = function()
    Ammun.inMenu = false
    RageUI.Visible(Ammun.menu, false)

    if DoesEntityExist(object) then
        DeleteObject(object)
        Ammun.lastprops = nil
        Ammun.Camera = true
        local Ppos = GetEntityCoords(PlayerPedId())
        HandleCamera(false, Ppos)
        FreezeEntityPosition(PlayerPedId(), false)
    end
end

function OpenMenuAmmu()
    if Ammun.inMenu then
        Ammun.inMenu = false
        RageUI.Visible(Ammun.menu, false)
    else
        Ammun.job = ESX.GetPlayerData().job.name
        ESX.TriggerServerCallback('GetTonCrewAmmu', function(cb)
            if cb == nil then
                Ammun.AccessKevIllegal = false
            else
                for k, v in pairs(Ammun.CrewKevlar) do
                    if cb == v then
                        Ammun.AccessKevIllegal = true
                        break
                    else
                        Ammun.AccessKevIllegal = false
                    end
                end
            end
        end)
        Wait(250)
        Ammun.inMenu = true
        RageUI.Visible(Ammun.menu, true)
        local Ppos = GetEntityCoords(PlayerPedId())
            CreateThread(function()
                while Ammun.inMenu do
                    RageUI.IsVisible(Ammun.menu, function()
                        for k,v in pairs(Ammun.items) do 
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                onActive = function()
                                    if v.props then
                                        if DoesEntityExist(object) then
                                            if Ammun.ToucheZ or Ammun.ToucheA or Ammun.ToucheS or Ammun.ToucheD or Ammun.ToucheQ or Ammun.ToucheY then
                                                local Rotation = GetEntityRotation(object, 2)
                                                SetEntityRotation(object, Rotation.x + (Ammun.ToucheZ and -0.7 or ToucheS and 0.7 or .0), Rotation.y - (Ammun.ToucheA and 0.7 or Ammun.ToucheD and -0.7 or .0), Rotation.z - (Ammun.ToucheQ and 0.7 or Ammun.ToucheY and -0.7 or .0), 2, 1)
                                            end
                                            if Ammun.Camera then
                                                Ammun.Camera = false
                                                FreezeEntityPosition(GetPlayerPed(-1), true)
                                                local Ppos = GetEntityCoords(PlayerPedId())
                                                HandleCamera(true, Ppos)
                                            end
                                        end
                                        if v.props ~= Ammun.lastprops then
                                            DeleteObject(object)
                                            local hash = GetHashKey(v.props)
                                            Ammun.lastprops = v.props
                                            RequestModel(hash)
                                            while not HasModelLoaded(hash) do
                                                Citizen.Wait(0)
                                            end
                                            object = CreateObject(hash, Ppos.x+1, Ppos.y+1.0, Ppos.z+0.7, false)
                                        end
                                    end
                                end,
                                onSelected = function()
                                    TriggerServerEvent("22ZDQDp_çéç232EppùDEQ2*p3ZDQ", v.price, v.item, v.label, 1)
                                end
                            })
                        end
                        RageUI.Separator("↓ Autres ↓")
                        RageUI.Button("Munitions", nil, {RightLabel = "→"}, true, {
                            onActive = function()
                                if DoesEntityExist(object) then
                                    DeleteObject(object)
                                    Ammun.lastprops = nil
                                    Ammun.Camera = true
                                    local Ppos = GetEntityCoords(PlayerPedId())
                                    HandleCamera(false, Ppos)
                                    FreezeEntityPosition(PlayerPedId(), false)
                                end
                            end,
                        }, Ammun.subMenu)

                         if Ammun.job == "police" then
                             RageUI.Button("Gilet pare Balles", nil, {RightLabel = "→"}, true, {
                                 onActive = function()
                                     if DoesEntityExist(object) then
                                         DeleteObject(object)
                                         Ammun.lastprops = nil
                                         Ammun.Camera = true
                                         local Ppos = GetEntityCoords(PlayerPedId())
                                         HandleCamera(false, Ppos)
                                         FreezeEntityPosition(PlayerPedId(), false)
                                     end
                                 end,
                             }, Ammun.subMenu3)
                         end

                         if Ammun.job == "ems" then
                             RageUI.Button("Gilet pare Balles", nil, {RightLabel = "→"}, true, {
                                 onActive = function()
                                     if DoesEntityExist(object) then
                                         DeleteObject(object)
                                         Ammun.lastprops = nil
                                         Ammun.Camera = true
                                         local Ppos = GetEntityCoords(PlayerPedId())
                                         HandleCamera(false, Ppos)
                                         FreezeEntityPosition(PlayerPedId(), false)
                                     end
                                 end,
                             }, Ammun.subMenu4)
                         end

                         if Ammun.job == "weazel" then
                             RageUI.Button("Gilet pare Balles", nil, {RightLabel = "→"}, true, {
                                 onActive = function()
                                     if DoesEntityExist(object) then
                                         DeleteObject(object)
                                         Ammun.lastprops = nil
                                         Ammun.Camera = true
                                         local Ppos = GetEntityCoords(PlayerPedId())
                                         HandleCamera(false, Ppos)
                                         FreezeEntityPosition(PlayerPedId(), false)
                                    end
                                 end,
                             }, Ammun.subMenu5)
                         end

                        -- if Ammun.AccessKevIllegal then
                        --     RageUI.Button("Kevlar", nil, {RightLabel = "→"}, true, {
                        --         onActive = function()
                        --             if DoesEntityExist(object) then
                        --                 DeleteObject(object)
                        --                 Ammun.lastprops = nil
                        --                 Ammun.Camera = true
                        --                 local Ppos = GetEntityCoords(PlayerPedId())
                        --                 HandleCamera(false, Ppos)
                        --                 FreezeEntityPosition(PlayerPedId(), false)
                        --             end
                        --         end,
                        --     }, Ammun.subMenu2)
                        -- end
                    end)
                    RageUI.IsVisible(Ammun.subMenu, function()
                        for _, munitionsData in pairs(Ammun.Munitions) do
                            RageUI.List(munitionsData.label, munitionsData.List, munitionsData.Index, nil, {RightLabel = "~g~"..munitionsData.Price*munitionsData.Index.."$"}, true, {
                                onListChange = function(Index)
                                    munitionsData.Index = Index
                                end,
                                onSelected = function()
                                    TriggerServerEvent("22ZDQDp_çéç232EppùDEQ2*p3ZDQ", munitionsData.Price*tonumber(munitionsData.Index), munitionsData.item, munitionsData.label, munitionsData.List[munitionsData.Index])
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Ammun.subMenu2, function()
                        for _, v in pairs(Ammun.illegalKev) do
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                onActive = function()
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        if tonumber(skin.bproof_1) ~= tonumber(v.number) or tonumber(skin.bproof_2) ~= tonumber(v.variation) then
                                            TriggerEvent('skinchanger:change', 'bproof_1', v.number)
                                            TriggerEvent('skinchanger:change', 'bproof_2', v.variation)
                                        end
                                    end)
                                end,

                                onSelected = function()
                                    ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                        if cb then
                                            ESX.ShowNotification("Vous avez acheté ~b~"..v.label.." pour ~g~"..v.price.."$")
                                            TriggerServerEvent("InsertVetement", "kevlar", v.label, "bproof_1", v.number, "bproof_2", v.variation)
                                            refreshTenue()
                                        else
                                            ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..v.price..'$)')
                                        end
                                    end, v.price)
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Ammun.subMenu3, function()
                        for _, v in pairs(Ammun.PoliceKev) do
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                onActive = function()
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        if tonumber(skin.bproof_1) ~= tonumber(v.number) or tonumber(skin.bproof_2) ~= tonumber(v.variation) then
                                            TriggerEvent('skinchanger:change', 'bproof_1', v.number)
                                            TriggerEvent('skinchanger:change', 'bproof_2', v.variation)
                                        end
                                    end)
                                end,

                                onSelected = function()
                                    ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                        if cb then
                                            ESX.ShowNotification("Vous avez acheté ~b~"..v.label.." pour ~g~"..v.price.."$")
                                            TriggerServerEvent("InsertVetement", "kevlar", v.label, "bproof_1", v.number, "bproof_2", v.variation)
                                            refreshTenue()
                                        else
                                            ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..v.price..'$)')
                                        end
                                    end, v.price)
                                end
                            })   
                        end
                    end)
                    RageUI.IsVisible(Ammun.subMenu4, function()
                        for _, v in pairs(Ammun.EmsKev) do
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                onActive = function()
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        if tonumber(skin.bproof_1) ~= tonumber(v.number) or tonumber(skin.bproof_2) ~= tonumber(v.variation) then
                                            TriggerEvent('skinchanger:change', 'bproof_1', v.number)
                                            TriggerEvent('skinchanger:change', 'bproof_2', v.variation)
                                        end
                                    end)
                                end,

                                onSelected = function()
                                    ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                        if cb then
                                            ESX.ShowNotification("Vous avez acheté ~b~"..v.label.." pour ~g~"..v.price.."$")
                                            TriggerServerEvent("InsertVetement", "kevlar", v.label, "bproof_1", v.number, "bproof_2", v.variation)
                                            refreshTenue()
                                        else
                                            ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..v.price..'$)')
                                        end
                                    end, v.price)
                                end
                            })   
                        end
                    end)
                    RageUI.IsVisible(Ammun.subMenu5, function()
                        for _, v in pairs(Ammun.WeazelNewsKev) do
                            RageUI.Button(v.label, nil, {RightLabel = "~g~"..v.price.."$"}, true, {
                                onActive = function()
                                    TriggerEvent('skinchanger:getSkin', function(skin)
                                        if tonumber(skin.bproof_1) ~= tonumber(v.number) or tonumber(skin.bproof_2) ~= tonumber(v.variation) then
                                            TriggerEvent('skinchanger:change', 'bproof_1', v.number)
                                            TriggerEvent('skinchanger:change', 'bproof_2', v.variation)
                                        end
                                    end)
                                end,

                                onSelected = function()
                                    ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                        if cb then
                                            ESX.ShowNotification("Vous avez acheté ~b~"..v.label.." pour ~g~"..v.price.."$")
                                            TriggerServerEvent("InsertVetement", "kevlar", v.label, "bproof_1", v.number, "bproof_2", v.variation)
                                            refreshTenue()
                                        else
                                            ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~('..v.price..'$)')
                                        end
                                    end, v.price)
                                end
                            })   
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread( function()
    while true do
        time = 750
            for k, v in pairs(Ammun.PosAmmu) do
                local Playerpos = GetEntityCoords(PlayerPedId())
                local Pdist = #(v - Playerpos) 
                if Pdist <= 10 then 
                    time = 1
                    if Pdist <= 2.4 and not Ammun.inMenu and IsPedOnFoot(PlayerPedId()) then 
                        DisplayNotification('Appuyez sur ~INPUT_TALK~ pour ~b~accéder a l\'ammunation~s~.')
                        if IsControlJustPressed(0, 51) then
                           OpenMenuAmmu()
                        end 
                    end 
                end 
            end
        Citizen.Wait(time)
    end
end)