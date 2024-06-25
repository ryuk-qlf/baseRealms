ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent("LandLife:GetSharedObject", function(obj)
            ESX = obj
        end)
        Citizen.Wait(0)
    end
end)

local Kevlar = {}

Kevlar.StartDegatKevlar = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if Kevlar.StartDegatKevlar then
            if GetPedArmour(GetPlayerPed(-1)) == 0 then
                TriggerEvent('skinchanger:getSkin', function(skin)
                    if skin.bproof_1 ~= 0 then
                        Kevlar.StartDegatKevlar = false
                        SetPedArmour(PlayerPedId(), 0)
                        TriggerServerEvent('DeleteVetement', Kevlar.IdKev)
                        TriggerEvent("skinchanger:change", 'bproof_1', 0)
                        ShakeGameplayCam("DEATH_FAIL_IN_EFFECT_SHAKE", 1.5)
                        ESX.ShowNotification("~r~Attention~s~\nVotre kevlar s'est brisé.")
                        Citizen.Wait(5000)
                    end
                end)
            end
        end
    end
end)

SetFieldValueFromNameEncode = function(stringName, data)
	SetResourceKvp(stringName, json.encode(data))
end

GetFieldValueFromName = function(stringName)
	local data = GetResourceKvpString(stringName)
	return data and json.decode(data) or {}
end

-- RegisterCommand("face", function()
--     local TableFace = {}
--     TriggerEvent('skinchanger:getSkin', function(skin)
--         TableFace.Peau = skin.skin
--         TableFace.Mom = skin.mom
--         TableFace.Dad = skin.dad
--     end)

--     print(TableFace.Peau*2)

--     Wait(150)
    
--     TriggerEvent('skinchanger:change', 'mom', 0)
--     TriggerEvent('skinchanger:change', 'dad', 0)
--     TriggerEvent('skinchanger:change', 'skin', TableFace.Peau)
--     Wait(10000)
--     print('restart face')
    
--     TriggerEvent('skinchanger:change', 'mom', TableFace.Mom)
--     TriggerEvent('skinchanger:change', 'dad', TableFace.Dad)
--     TriggerEvent('skinchanger:change', 'skin', TableFace.Peau)
-- end)

RegisterCommand("kev1", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 0)
end)

RegisterCommand("kev2", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 1)
end)

RegisterCommand("kev3", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 2)
end)

RegisterCommand("kev4", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 3)
end)

RegisterCommand("kev5", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 4)
end)

RegisterCommand("kev6", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 5)
end)

RegisterCommand("kev7", function()
    TriggerServerEvent("InsertVetement", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 6)
end)

RegisterCommand("kevlar", function(source, args, rawCommand)
    -- Vérifie si un ID de joueur a été fourni
    local playerId = tonumber(args[1])

        TriggerServerEvent("InsertKev", "kevlar", "Kevlar 10", "bproof_1", 21, "bproof_2", 6, playerId)

end)



local offline = exports["offline"]

local totalWeight = 0
local NotificationWeight = true

Inv = {}
Inv.FastWeapons = GetFieldValueFromName('offline').name and GetFieldValueFromName('offline').name or {}

local open = false
currentMenu = 'item'

local blacklistitem = {
    ["gps"] = true,
    ["phone"] = true,
    ["pepite"] = true,
    ["terre"] = true,
    ["planche"] = true,
    ["meuble"] = true,
    ["raisin"] = true,
    ["vin"] = true,
    ['hei_prop_yah_table_01'] = true,
    ['hei_prop_yah_table_03'] = true,
    ['prop_chateau_table_01'] = true,
    ['prop_patio_lounger1_table'] = true,
    ['prop_proxy_chateau_table'] = true,
    ['prop_rub_table_02'] = true,
    ['prop_rub_table_01'] = true,
    ['prop_table_01'] = true,
    ['prop_table_02'] = true,
    ['prop_table_03'] = true,
    ['prop_table_04'] = true,
    ['prop_table_05'] = true,
    ['prop_table_06'] = true,
    ['prop_table_07'] = true,
    ['prop_table_08'] = true,
    ['prop_ven_market_table1'] = true,
    ['prop_yacht_table_01'] = true,
    ['prop_yacht_table_02'] = true,
    ['v_ret_fh_dinetable'] = true,
    ['v_ret_fh_dinetble'] = true,
    ['v_res_mconsoletrad'] = true,
    ['prop_rub_table_02'] = true,
    ['ba_prop_int_trad_table'] = true,
    ['xm_prop_x17_desk_cover_01a'] = true,
    ['xm_prop_lab_desk_02'] = true,
    ['xm_prop_lab_desk_01'] = true,
    ['ex_mp_h_din_table_05'] = true,
    ['hei_prop_yah_table_02'] = true,
    ['prop_ld_farm_table02'] = true,
    ['prop_t_coffe_table'] = true,
    ['prop_t_coffe_table_02'] = true,
    ['prop_ld_greenscreen_01'] = true,
    ['prop_tv_cam_02'] = true,
    ['p_pharm_unit_02'] = true,
    ['p_pharm_unit_01'] = true,
    ['p_v_43_safe_s'] = true,
    ['prop_bin_03a'] = true,
    ['prop_bin_07c'] = true,
    ['prop_bin_08open'] = true,
    ['prop_bin_10a'] = true,
    ['prop_devin_box_01'] = true,
    ['prop_ld_int_safe_01'] = true,
    ['prop_dress_disp_01'] = true,
    ['prop_dress_disp_02'] = true,
    ['prop_dress_disp_03'] = true,
    ['prop_dress_disp_04'] = true,
    ['v_ret_fh_displayc'] = true,
    ['apa_mp_h_bed_double_08'] = true,
    ['apa_mp_h_bed_double_09'] = true,
    ['apa_mp_h_bed_wide_05'] = true,
    ['imp_prop_impexp_sofabed_01a'] = true,
    ['apa_mp_h_bed_with_table_02'] = true,
    ['bka_prop_biker_campbed_01'] = true,
    ['apa_mp_h_yacht_bed_01'] = true,
    ['apa_mp_h_yacht_bed_02'] = true,
    ['p_lestersbed_s'] = true,
    ['p_mbbed_s'] = true,
    ['v_res_d_bed'] = true,
    ['v_res_tre_bed2'] = true,
    ['v_res_tre_bed1'] = true,
    ['v_res_mdbed'] = true,
    ['v_res_msonbed'] = true,
    ['v_res_tt_bed'] = true,
    ['prop_barrier_work05'] = true,
    ['prop_boxpile_07d'] = true,
    ['p_ld_stinger_s'] = true,
    ['prop_roadcone02a'] = true,
    ['hei_prop_yah_lounger'] = true,
    ['hei_prop_yah_seat_01'] = true,
    ['hei_prop_yah_seat_02'] = true,
    ['hei_prop_yah_seat_03'] = true,
    ['miss_rub_couch_01'] = true,
    ['p_armchair_01_s'] = true,
    ['p_ilev_p_easychair_s'] = true,
    ['p_lev_sofa_s'] = true,
    ['p_patio_lounger1_s'] = true,
    ['p_res_sofa_l_s'] = true,
    ['p_v_med_p_sofa_s'] = true,
    ['prop_bench_01a'] = true,
    ['prop_bench_06'] = true,
    ['prop_ld_farm_chair01'] = true,
    ['prop_ld_farm_couch01'] = true,
    ['prop_ld_farm_couch02'] = true,
    ['prop_rub_couch04'] = true,
    ['prop_t_sofa'] = true,
    ['prop_t_sofa_02'] = true,
    ['v_ilev_m_sofa'] = true,
    ['v_res_tre_sofa_s'] = true,
    ['v_tre_sofa_mess_a_s'] = true,
    ['v_tre_sofa_mess_b_s'] = true,
    ['v_tre_sofa_mess_c_s'] = true,
    ['bkr_prop_duffel_bag_01a'] = true,
    ['v_med_emptybed'] = true,
    ['v_med_cor_emblmtable'] = true,
    ['v_ret_gc_bag01'] = true,
    ['xm_prop_body_bag'] = true,
    ['prop_chair_01a'] = true,
    ['prop_chair_01b'] = true,
    ['prop_chair_02'] = true,
    ['prop_chair_03'] = true,
    ['prop_chair_04'] = true,
    ['prop_chair_05'] = true,
    ['prop_chair_06'] = true,
    ['prop_chair_07'] = true,
    ['prop_chair_08'] = true,
    ['prop_chair_09'] = true,
    ['prop_chair_10'] = true,
    ['apa_mp_h_din_chair_04'] = true,
    ['apa_mp_h_din_chair_08'] = true,
    ['apa_mp_h_din_chair_09'] = true,
    ['apa_mp_h_din_chair_12'] = true,
    ['apa_mp_h_stn_chairarm_01'] = true,
    ['apa_mp_h_stn_chairarm_02'] = true,
    ['apa_mp_h_stn_chairarm_09'] = true,
    ['apa_mp_h_stn_chairarm_11'] = true,
    ['apa_mp_h_stn_chairarm_12'] = true,
    ['apa_mp_h_stn_chairarm_13'] = true,
    ['apa_mp_h_stn_chairarm_23'] = true,
    ['apa_mp_h_stn_chairarm_24'] = true,
    ['apa_mp_h_stn_chairarm_25'] = true,
    ['apa_mp_h_stn_chairarm_26'] = true,
    ['apa_mp_h_stn_chairstrip_08'] = true,
    ['apa_mp_h_stn_chairstrip_04'] = true,
    ['apa_mp_h_stn_chairstrip_05'] = true,
    ['apa_mp_h_stn_chairstrip_06'] = true,
    ['apa_mp_h_yacht_armchair_03'] = true,
    ['apa_mp_h_yacht_armchair_04'] = true,
    ['ba_prop_battle_club_chair_02'] = true,
    ['apa_mp_h_yacht_strip_chair_01'] = true,
    ['ba_prop_battle_club_chair_01'] = true,
    ['ba_prop_battle_club_chair_03'] = true,
    ['bka_prop_biker_boardchair01'] = true,
    ['bka_prop_biker_chairstrip_01'] = true,
    ['bka_prop_biker_chairstrip_02'] = true
}

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if item == "gps" then
        for k,v in pairs(ESX.GetPlayerData().inventory) do
            if v.name == item then
                if v.count < 1 then
                    DisplayRadar(false)
                end
            end
        end
	end
    if string.match(item, "WEAPON_") then
        RemoveWeapon(item)
    end
end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
    if item == "gps" then
        for k,v in pairs(ESX.GetPlayerData().inventory) do
            if v.name == item then
                if v.count == 1 then
                    if not isInInventory then
                        DisplayRadar(true)
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("addgps")
AddEventHandler("addgps", function()
	DisplayRadar(true)
end)

RegisterNetEvent("removegps")
AddEventHandler("removegps", function()
	DisplayRadar(false)
end)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler("esx:playerLoaded", function(xPlayer)
    PlayerData = xPlayer
	DisplayRadar(false)
	TriggerServerEvent("getgps")
end)

CreateThread(function()
    Wait(15000)
    if ESX ~= nil then
        for k,v in ipairs(ESX.GetPlayerData().inventory) do
            if v.count > 0 then
                totalWeight = totalWeight + (v.weight * v.count)
            end
        end
    end
end)

RegisterNetEvent("UpdateTotal")
AddEventHandler("UpdateTotal", function()
    totalWeight = 0
    for k,v in ipairs(ESX.GetPlayerData().inventory) do
		if v.count > 0 then
            totalWeight = totalWeight + (v.weight * v.count)
        end
	end
end)

local disablecontrol = false

Citizen.CreateThread(function()
	while true do
		if disablecontrol then
			DisableControlAction(0, 24, true) -- Attack
			DisableControlAction(0, 69, true) -- Attack
			DisableControlAction(0, 70, true) -- Attack
			DisableControlAction(0, 92, true) -- Attack
			DisableControlAction(0, 114, true) -- Attack
			DisableControlAction(0, 121, true) -- Attack
            DisableControlAction(0, 140, true) -- Attack
            DisableControlAction(0, 141, true) -- Attack
            DisableControlAction(0, 142, true) -- Attack
            DisableControlAction(0, 257, true) -- Attack
            DisableControlAction(0, 263, true) -- Attack
            DisableControlAction(0, 264, true) -- Attack
            DisableControlAction(0, 331, true) -- Attack
            DisableControlAction(0, 157, true) -- Weapon 1
            DisableControlAction(0, 158, true) -- Weapon 2
            DisableControlAction(0, 160, true) -- Weapon 3
		end
		Wait(0)
	end
end)

RegisterCommand('invbug', function()
    if invbug then 
        SetNuiFocus(false, false)
        SetKeepInputMode(false)
    else
        SetNuiFocus(true, true)
        SetKeepInputMode(true)
    end
    invbug = not invbug
end)

function openInventory()
    if currentMenu ~= 'item' then
        items = nil
        currentMenu = 'item'
        loadPlayerInventory(currentMenu)
    else
        loadPlayerInventory(currentMenu)
    end
    isInInventory = true
    open = true
    SendNUIMessage({action = "display", type = "normal"})
    SendNUIMessage({action = "setWeightText", text = ""})
    SetNuiFocus(true, true)
    SetKeepInputMode(true)
    disablecontrol = true
    DisplayRadar(false)
    TriggerEvent('esx_status:setDisplay', 0.0)
end

function closeInventory()
    isInInventory = false
    open = false
    SendNUIMessage({action = "hide"})
    SetNuiFocus(false, false)
    SetKeepInputMode(false)
    disablecontrol = false
    TriggerServerEvent("getgps")
    TriggerEvent('esx_status:setDisplay', 10.0)
    TriggerEvent("ResetPropChest")
    TriggerEvent("ResetVehChest")
end

RegisterNetEvent("esx_inventoryhud:closeInventory")
AddEventHandler("esx_inventoryhud:closeInventory", function()
    closeInventory()
end)

RegisterNetEvent("esx_inventoryhud:refreshInventory")
AddEventHandler("esx_inventoryhud:refreshInventory", function()
    currentMenu = 'item'
    loadPlayerInventory(currentMenu)
end)

RegisterNUICallback('escape', function(data, cb)
    closeInventory()
    SetKeepInputMode(false)
end)

RegisterNUICallback("NUIFocusOff",function()
    closeInventory()
    SetKeepInputMode(false)
end)

RegisterNUICallback("GetNearPlayers", function(data, cb)
    local targetT = GetNearbyPlayer(true)

    if targetT then

        closeInventory()
        
        if IsPedRagdoll(PlayerPedId()) or exports["offline"]:GetPlayerDead() or exports["offline"]:GetPlayerKnockout() then
            ESX.ShowNotification("~r~Impossible de réaliser cette action.")
            return
        end

        local count = tonumber(data.number)

        if data.item.type == "item_standard" then
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
        end

        if data.item.type == "item_money" then 
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
            TriggerServerEvent("esx_inventoryhud:tradePlayerItem", GetPlayerServerId(PlayerId()), GetPlayerServerId(targetT), data.item.type, data.item.name, count)
            Wait(250)
            if string.match(data.item.name, "ammo") then
                GiveWeaponToPed(PlayerPedId(), "weapon_unarmed", 0, false, true)
            end
        end

        if data.item.type == "item_tenue" or data.item.type == "item_tshirt" or data.item.type == "item_gant" or data.item.type == "item_haut" or data.item.type == "item_chaussures" or data.item.type == "item_lunettes" or data.item.type == "item_calque" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" or data.item.type == "item_montre" or data.item.type == "item_bracelet" or data.item.type == "item_oreille" or data.item.type == "item_kevlar" then
            if data.item.type == "item_haut" then

                TriggerEvent('skinchanger:getSkin', function(skin)
                    if tonumber(skin.torso_1) == tonumber((data.item.skins).torso_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    arms_2   = 0,
                                    torso_1  = 15,
                                    torso_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    arms_2   = 0,
                                    torso_1  = 15,
                                    torso_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)    
                    end
                save()
            end)

            elseif data.item.type == "item_kevlar" then

                TriggerEvent('skinchanger:getSkin', function(skin)
        
                if tonumber(skin.bproof_1) == tonumber((data.item.skins).bproof_1) then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                bproof_1  = 0,
                                bproof_2  = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                bproof_1  = 0,
                                bproof_2  = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                    TriggerServerEvent('UpdateVieKevlar', Kevlar.IdKev, GetPedArmour(PlayerPedId()))
                    Wait(150)
                    SetPedArmour(PlayerPedId(), 0)
                    TriggerServerEvent('RefreshPlayerHealthArmour', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
                    Kevlar.StartDegatKevlar = false
                end
                save()
            end)

            elseif data.item.type == "item_tenue" then
                
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.torso_1) == tonumber((data.item.skins).torso_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 14,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    glasses_1  = -1,
                                    glasses_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 15,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    glasses_1  = -1,
                                    glasses_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
                elseif data.item.type == "item_chaussures" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.shoes_1) == tonumber((data.item.skins).shoes_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    shoes_1  = 34,
                                    shoes_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)    
                    end
                    save()
                end)
                
            elseif data.item.type == "item_pantalon" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.pants_1) == tonumber((data.item.skins).pants_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    pants_1  = 14,
                                    pants_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    pants_1  = 15,
                                    pants_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_masque" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.mask_1) == tonumber((data.item.skins).mask_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    mask_1   = 0,
                                    mask_2   = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    mask_1   = 0,
                                    mask_2   = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_lunettes" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.glasses_1) == tonumber((data.item.skins).glasses_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 0,
                                    glasses_1 = 0,
                                    glasses_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 1,
                                    glasses_1 = 0,
                                    glasses_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_chapeau" then
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.helmet_1) == tonumber((data.item.skins).helmet_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    helmet_1 = -1,
                                    helmet_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    helmet_1 = -1,
                                    helmet_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_montre" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.watches_1) == tonumber((data.item.skins).watches_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 0,
                                    watches_1 = -1,
                                    watches_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 1,
                                    watches_1 = -1,
                                    watches_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_oreille" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.ears_1) == tonumber((data.item.skins).ears_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex    = 0,
                                    ears_1 = -1,
                                    ears_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex    = 1,
                                    ears_1 = -1,
                                    ears_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_bracelet" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.bracelets_1) == tonumber((data.item.skins).bracelets_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex         = 0,
                                    bracelets_1 = -1,
                                    bracelets_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex         = 1,
                                    bracelets_1 = -1,
                                    bracelets_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)

            elseif data.item.type == "item_calque" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.decals_1) == tonumber((data.item.skins).decals_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    decals_1 = 0,
                                    decals_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    decals_1 = 0,
                                    decals_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_sac" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.bags_1) == tonumber((data.item.skins).bags_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_chaine" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.chain_1) == tonumber((data.item.skins).chain_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex     = 0,
                                    chain_1 = 0,
                                    chain_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex     = 1,
                                    chain_1 = 0,
                                    chain_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
            end
            TriggerServerEvent('Vetement:giveitem', data.item.id, GetPlayerServerId(targetT), data.item.label)
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
            Wait(250)
            loadPlayerInventory(currentMenu)
            ESX.ShowNotification('Vous venez de donner votre ~b~'..data.item.label)
        elseif data.item.type == "item_card" then
            TriggerServerEvent("ChangePorteurCard", GetPlayerServerId(targetT), data.item.account, data.item.label)
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
            ESX.DrawMissionText("- 1 "..data.item.label, 3000)
        elseif data.item.type == "item_idcard" then
            TriggerServerEvent("ChangePorteurIdCard", GetPlayerServerId(targetT), data.item.id, data.item.label)
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
            ESX.DrawMissionText("- 1 "..data.item.label, 3000)
        else
            TriggerServerEvent("esx:giveInventoryItem", GetPlayerServerId(targetT), data.item.type, data.item.name, count)
            ESX.Streaming.RequestAnimDict("mp_common", function()
                TaskPlayAnim(PlayerPedId(), "mp_common", "givetake2_a", 2.0, -2.0, 2500, 49, 0, false, false, false)
            end)
            Wait(250)
            loadPlayerInventory(currentMenu)
        end
    end

    cb("ok")
end)

RegisterNUICallback("OngletInventory", function(data, cb)
    if currentMenu ~= data.type then 
        currentMenu = data.type
        loadPlayerInventory(data.type)
    end
end)

RegisterNUICallback("RenameCloth", function(data, cb)
    if data.item.type ~= "item_money" and data.item.type ~= "item_account" and data.item.type ~= "item_standard" and data.item.type ~= "item_card" and data.item.type ~= "item_idcard" then
        closeInventory()
        local result = ESX.KeyboardInput(data.item.label, 30)
        if result ~= nil then
            if data.item.type ~= "item_standard" then
                TriggerServerEvent('ModifNom', data.item.id, result)
            end
            TriggerEvent('esx:ReloadInventory')
            ESX.ShowNotification("Vous avez changé le nom ~b~"..data.item.label.."~s~ en ~b~"..result.."~s~.")
        end
    end 
end)

RegisterNUICallback("LoadInventaire", function(data, cb)
    loadPlayerInventory(currentMenu)
end)
RegisterNUICallback("UseItem", function(data, cb)
    if not IsPedRagdoll(PlayerPedId()) or not exports["offline"]:GetPlayerDead() or not exports["offline"]:GetPlayerKnockout() then
        if data.item.type == "item_standard" then 
            TriggerServerEvent("esx:useItem", data.item.name)
        
        elseif data.item.type == "item_haut" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if tonumber(skin.torso_1) ~= tonumber((data.item.skins).torso_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, { 
                        ["tshirt_1"] = data.item.skins["tshirt_1"], 
                        ["tshirt_2"] = data.item.skins["tshirt_2"], 
                        ["torso_1"] = data.item.skins["torso_1"], 
                        ["torso_2"] = data.item.skins["torso_2"],
                        ["arms"] = data.item.skins["arms"],
                        ["arms_2"] = data.item.skins["arms_2"]
                    })
                    save()
                else
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadSkin', {
                            sex      = 0,
                            tshirt_1 = 15,
                            tshirt_2 = 0,
                            arms     = 15,
                            arms_2   = 0,
                            torso_1  = 15,
                            torso_2  = 0
                        })
                    elseif skin.sex == 1 then
                        TriggerEvent('skinchanger:loadSkin', {
                            sex      = 1,
                            tshirt_1 = 15,
                            tshirt_2 = 0,
                            arms     = 15,
                            arms_2   = 0,
                            torso_1  = 15,
                            torso_2  = 0
                        })
                    elseif skin.sex >= 2 then
                        -- Gérer le cas pour d'autres sexes si nécessaire
                    end
                    save()
                end
            end)
        
        elseif data.item.type == "item_kevlar" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if tonumber(skin.bproof_1) ~= tonumber((data.item.skins).bproof_1) then
                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                        if math.ceil(GetEntitySpeed(GetVehiclePedIsIn(GetPlayerPed(-1), false)) * 3.6) <= 20.0 then
                            TriggerEvent('skinchanger:loadClothes', skin, {
                                ["bproof_1"] = data.item.skins["bproof_1"],
                                ["bproof_2"] = data.item.skins["bproof_2"]
                            })
                            SetPedArmour(PlayerPedId(), data.item.vie)
                            Kevlar.IdKev = data.item.id
                            ESX.Notification("Vous avez équipé votre ~g~Gilet par balle~s~.")
                            Wait(500)
                            Kevlar.StartDegatKevlar = true
                        else
                            ESX.ShowNotification("~r~Impossible de mettre son kevlar en conduisant.")
                        end
                    else
                        TriggerEvent('skinchanger:loadClothes', skin, {
                            ["bproof_1"] = data.item.skins["bproof_1"],
                            ["bproof_2"] = data.item.skins["bproof_2"]
                        })
                        SetPedArmour(PlayerPedId(), data.item.vie)
                        Kevlar.IdKev = data.item.id
                        ESX.Notification("Vous avez équipé votre ~g~Gilet par balle~s~.")
                        Wait(500)
                        Kevlar.StartDegatKevlar = true
                    end
                else
                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:loadSkin', {
                            sex      = 0,
                            bproof_1  = 0,
                            bproof_2  = 0
                        })
                    elseif skin.sex == 1 then
                        TriggerEvent('skinchanger:loadSkin', {
                            sex      = 1,
                            bproof_1  = 0,
                            bproof_2  = 0
                        })
                    elseif skin.sex >= 2 then
                        -- Gérer le cas pour d'autres sexes si nécessaire
                    end
                    ESX.Notification("Vous avez retiré votre ~g~Gilet par balle~s~.")
                    TriggerServerEvent('UpdateVieKevlar', Kevlar.IdKev, GetPedArmour(PlayerPedId()))
                    Wait(150)
                    SetPedArmour(PlayerPedId(), 0)
                    TriggerServerEvent('RefreshPlayerHealthArmour', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
                    Kevlar.StartDegatKevlar = false
                    save()
                end
            end)
        
        elseif data.item.type == "item_tenue" then

            
            TriggerEvent('skinchanger:getSkin', function(skin)

                if skin.sex == 0 or skin.sex == 1 then
                    if tonumber(skin.torso_1) ~= tonumber((data.item.skins).torso_1) then

                        TriggerEvent('skinchanger:loadClothes', skin, { 
                            ["pants_1"] = data.item.skins["pants_1"], 
                            ["pants_2"] = data.item.skins["pants_2"], 
                            ["tshirt_1"] = data.item.skins["tshirt_1"], 
                            ["tshirt_2"] = data.item.skins["tshirt_2"], 
                            ["torso_1"] = data.item.skins["torso_1"], 
                            ["torso_2"] = data.item.skins["torso_2"],
                            ["arms"] = data.item.skins["arms"],
                            ["arms_2"] = data.item.skins["arms_2"],
                            ["decals_1"] = data.item.skins["decals_1"],
                            ["decals_2"] = data.item.skins["decals_2"],
                            ["shoes_1"] = data.item.skins["shoes_1"],
                            ["shoes_2"] = data.item.skins["shoes_2"],
                            ["helmet_1"] = data.item.skins["helmet_1"],
                            ["helmet_2"] = data.item.skins["helmet_2"],
                            ["mask_1"] = data.item.skins["mask_1"],
                            ["mask_2"] = data.item.skins["mask_2"],
                            ["bags_1"] = data.item.skins["bags_1"],
                            ["bags_2"] = data.item.skins["bags_2"],
                            ["chain_1"] = data.item.skins["chain_1"],
                            ["chain_2"] = data.item.skins["chain_2"]})
                    else
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 14,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 15,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    glasses_1  = -1,
                                    glasses_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                elseif skin.sex >= 2 then
                    print(skin.sex)
                    --if tonumber(skin.torso_1) ~= tonumber((data.item.skins).torso_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, { 
                        ["pants_1"] = data.item.skins["pants_1"], 
                        ["pants_2"] = data.item.skins["pants_2"], 
                        --["tshirt_1"] = data.item.skins["tshirt_1"], 
                        --["tshirt_2"] = data.item.skins["tshirt_2"], 
                        ["arms"] = data.item.skins["arms"],
                        ["arms_2"] = data.item.skins["arms_2"],
                        ["shoes_1"] = data.item.skins["shoes_1"],
                        ["shoes_2"] = data.item.skins["shoes_2"],
                        ["helmet_1"] = data.item.skins["helmet_1"],
                        ["helmet_2"] = data.item.skins["helmet_2"]})
                    --end
                end
                save()
            end)

            elseif data.item.type == "item_tshirt" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if tonumber(skin.tshirt_1) ~= tonumber((data.item.skins).tshirt_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, { ["tshirt_1"] = data.item.skins["tshirt_1"], ["tshirt_2"] = data.item.skins["tshirt_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                        elseif skin.sex >= 2 then
                            TriggerEvent('skinchanger:change', "tshirt_1", 0)
                            TriggerEvent('skinchanger:change', "tshirt_2", 0)
                        end
                    end)
                end
                save()
            end)

            elseif data.item.type == "item_gant" then
            TriggerEvent('skinchanger:getSkin', function(skin)
                if tonumber(skin.arms) ~= tonumber((data.item.skins).arms) or tonumber(skin.arms_2) ~= tonumber((data.item.skins).arms_2) then
                    TriggerEvent('skinchanger:loadClothes', skin, { ["arms"] = data.item.skins["arms"], ["arms_2"] = data.item.skins["arms_2"]})
                end
                save()
            end)

            elseif data.item.type == "item_chaussures" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.shoes_1) ~= tonumber((data.item.skins).shoes_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["shoes_1"] = data.item.skins["shoes_1"], ["shoes_2"] = data.item.skins["shoes_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                shoes_1  = 34,
                                shoes_2  = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                shoes_1  = 34,
                                shoes_2  = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_pantalon" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.pants_1) ~= tonumber((data.item.skins).pants_1) or tonumber(skin.pants_2) ~= tonumber((data.item.skins).pants_2) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["pants_1"] = data.item.skins["pants_1"], ["pants_2"] = data.item.skins["pants_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                pants_1  = 14,
                                pants_2  = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                pants_1  = 15,
                                pants_2  = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_masque" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.mask_1) ~= tonumber((data.item.skins).mask_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["mask_1"] = data.item.skins["mask_1"], ["mask_2"] = data.item.skins["mask_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                mask_1   = 0,
                                mask_2   = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                mask_1   = 0,
                                mask_2   = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_lunettes" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.glasses_1) ~= tonumber((data.item.skins).glasses_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["glasses_1"] = data.item.skins["glasses_1"], ["glasses_2"] = data.item.skins["glasses_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex       = 0,
                                glasses_1 = 0,
                                glasses_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex       = 1,
                                glasses_1 = -1,
                                glasses_2 = 0
                            })
                        elseif skin.sex >= 2 then
                            TriggerEvent('skinchanger:change', "glasses_1", -1)
                            TriggerEvent('skinchanger:change', "glasses_2", 0)
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_chapeau" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.helmet_1) ~= tonumber((data.item.skins).helmet_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["helmet_1"] = data.item.skins["helmet_1"], ["helmet_2"] = data.item.skins["helmet_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                helmet_1 = -1,
                                helmet_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                helmet_1 = -1,
                                helmet_2 = 0
                            })
                        elseif skin.sex >= 2 then
                            TriggerEvent('skinchanger:change', "helmet_1", -1)
                            TriggerEvent('skinchanger:change', "helmet_2", 0)
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_montre" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.watches_1) ~= tonumber((data.item.skins).watches_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["watches_1"] = data.item.skins["watches_1"], ["watches_2"] = data.item.skins["watches_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex       = 0,
                                watches_1 = -1,
                                watches_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex       = 1,
                                watches_1 = -1,
                                watches_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_oreille" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.ears_1) ~= tonumber((data.item.skins).ears_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["ears_1"] = data.item.skins["ears_1"], ["ears_2"] = data.item.skins["ears_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex    = 0,
                                ears_1 = -1,
                                ears_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex    = 1,
                                ears_1 = -1,
                                ears_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_bracelet" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.bracelets_1) ~= tonumber((data.item.skins).bracelets_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["bracelets_1"] = data.item.skins["bracelets_1"], ["bracelets_2"] = data.item.skins["bracelets_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex         = 0,
                                bracelets_1 = -1,
                                bracelets_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex         = 1,
                                bracelets_1 = -1,
                                bracelets_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_calque" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.decals_1) ~= tonumber((data.item.skins).decals_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["decals_1"] = data.item.skins["decals_1"], ["decals_2"] = data.item.skins["decals_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                decals_1 = 0,
                                decals_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                decals_1 = 0,
                                decals_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)

        elseif data.item.type == "item_sac" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.bags_1) ~= tonumber((data.item.skins).bags_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["bags_1"] = data.item.skins["bags_1"], ["bags_2"] = data.item.skins["bags_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                bags_1 = 0,
                                bags_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                bags_1 = 0,
                                bags_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                -- ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
                --     weight = data.weight
                --     maxWeight = data.maxWeight
        
                --     SendNUIMessage(
                --         {
                --             action = "setItems",
                --             text = "<div id=\"weightValue\"><p>" ..(weight/1000).. " / " ..(maxWeight/1000).. "KG</p></span>"
                --         }
                --     )
                -- end, GetPlayerServerId(PlayerId()))
                -- Wait(150)
                -- loadPlayerInventory('clothe')
                -- currentMenu = 'clothe'
                save()
            end)

        elseif data.item.type == "item_chaine" then

            TriggerEvent('skinchanger:getSkin', function(skin)

                if tonumber(skin.chain_1) ~= tonumber((data.item.skins).chain_1) then
                    TriggerEvent('skinchanger:loadClothes', skin, {["chain_1"] = data.item.skins["chain_1"], ["chain_2"] = data.item.skins["chain_2"]})
                else
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex     = 0,
                                chain_1 = 0,
                                chain_2 = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex     = 1,
                                chain_1 = 0,
                                chain_2 = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                end
                save()
            end)
        elseif data.item.type == "item_card" then
            closeInventory()
            Wait(100)
            offline:openCardBanking(data.item.account, data.item.numero)
        elseif data.item.type == "item_idcard" then
            local targetT = GetNearbyPlayer(false)

            if targetT then
                if data.item.license == "idcard" then
                    ESX.ShowNotification("Vous montrez votre carte ~g~"..data.item.cartename.."~s~ à un individu.")
                    TriggerEvent("ShowIdCardOfPlayer", data.item.cartename, data.item.dateofbirth, data.item.ldn)
                    TriggerServerEvent("ShowIdCardOfPlayer", GetPlayerServerId(targetT), data.item.cartename, data.item.dateofbirth, data.item.ldn)
                elseif data.item.license == "permis" then
                    ESX.ShowNotification("Vous montrez votre permis ~g~"..data.item.cartename.."~s~ à un individu.")
                    TriggerEvent("showPermisOfPlayer", data.item.permisCar, data.item.pointCar, data.item.permisMoto, data.item.pointMoto, data.item.permisCamion, data.item.pointCamion, data.item.permisBoat, data.item.permisAirplanes)
                    TriggerServerEvent("showPermisOfPlayer", GetPlayerServerId(targetT), data.item.permisCar, data.item.pointCar, data.item.permisMoto, data.item.pointMoto, data.item.permisCamion, data.item.pointCamion, data.item.permisBoat, data.item.permisAirplanes)
                end
            else
                if data.item.license == "idcard" then
                    TriggerEvent("ShowIdCardOfPlayer", data.item.cartename, data.item.dateofbirth, data.item.ldn)
                elseif data.item.license == "permis" then
                    TriggerEvent("showPermisOfPlayer", data.item.permisCar, data.item.pointCar, data.item.permisMoto, data.item.pointMoto, data.item.permisCamion, data.item.pointCamion, data.item.permisBoat, data.item.permisAirplanes)
                end
            end
        end
        if shouldCloseInventory(data.item.name) then
            closeInventory()
        else
            loadPlayerInventory(currentMenu)
        end
        cb("ok")
    else
        loadPlayerInventory(currentMenu)
        ESX.ShowNotification("~r~Impossible de réaliser cette action.")
    end
end)

RegisterNUICallback("DropItem", function(data, cb)
        local playerPed = GetPlayerPed(-1)
        if IsPedSittingInAnyVehicle(playerPed) then
            return
        end
        if IsPedRagdoll(PlayerPedId()) or exports["offline"]:GetPlayerDead() or exports["offline"]:GetPlayerKnockout() then
            ESX.ShowNotification("~r~Impossible de réaliser cette action.")
            return
        end
        if exports["property"]:GetIsInProperty() or exports["property"]:GetIsInGarage() then
            ESX.ShowNotification("~r~Impossible de jeter dans une propriété.")
            return
        end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
		if data.item.type == "item_money" then
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local position = vector4(coords.x, coords.y, coords.z-1, heading)
			TriggerServerEvent("esx:removeInventoryItem", "item_account", "money", data.number, position)
            TaskPlayAnim(playerPed, "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
		else  
            if string.match(data.item.name, "ammo") then
                GiveWeaponToPed(PlayerPedId(), "weapon_unarmed", 0, false, true)
            end
            local coords = GetEntityCoords(playerPed)
            local heading = GetEntityHeading(playerPed)
            local position = vector4(coords.x, coords.y, coords.z-1, heading)
            TriggerServerEvent("esx:removeInventoryItem", data.item.type, data.item.name, data.number, position)
            TaskPlayAnim(playerPed, "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
        end
    end

    if data.item.type == "item_card" then
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local position = vector4(coords.x, coords.y, coords.z-1, heading)
        TriggerServerEvent("esx:removeInventoryItemCards", data.item.type, data.item.id, 1, position) 
        TaskPlayAnim(playerPed, "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
    end

    if data.item.type == "item_idcard" then
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local position = vector4(coords.x, coords.y, coords.z-1, heading)
        TriggerServerEvent("esx:removeInventoryItemIdCards", data.item.type, data.item.id, 1, position) 
        TaskPlayAnim(playerPed, "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
    end

    if currentMenu ~= 'clothe' then 
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            TaskPlayAnim(playerPed, "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
        end
    else

            if data.item.type == "item_haut" then

                TriggerEvent('skinchanger:getSkin', function(skin)
                    if tonumber(skin.torso_1) == tonumber((data.item.skins).torso_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    arms_2   = 0,
                                    torso_1  = 15,
                                    torso_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    arms_2   = 0,
                                    torso_1  = 15,
                                    torso_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)    
                    end
                save()
                end)
        
            elseif data.item.type == "item_kevlar" then

                TriggerEvent('skinchanger:getSkin', function(skin)
        
                if tonumber(skin.bproof_1) == tonumber((data.item.skins).bproof_1) then
                    TriggerEvent('skinchanger:getSkin', function(skin)
                        if skin.sex == 0 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 0,
                                bproof_1  = 0,
                                bproof_2  = 0
                            })
                        elseif skin.sex == 1 then
                            TriggerEvent('skinchanger:loadSkin', {
                                sex      = 1,
                                bproof_1  = 0,
                                bproof_2  = 0
                            })
                        elseif skin.sex >= 2 then
                        end
                    end)
                    TriggerServerEvent('UpdateVieKevlar', Kevlar.IdKev, GetPedArmour(PlayerPedId()))
                    Wait(150)
                    SetPedArmour(PlayerPedId(), 0)
                    TriggerServerEvent('RefreshPlayerHealthArmour', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
                    Kevlar.StartDegatKevlar = false
                end
                save()
            end)

            elseif data.item.type == "item_tenue" then
                
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.torso_1) == tonumber((data.item.skins).torso_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 14,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    glasses_1  = -1,
                                    glasses_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    tshirt_1 = 15,
                                    tshirt_2 = 0,
                                    arms     = 15,
                                    torso_1  = 15,
                                    torso_2  = 0,
                                    pants_1  = 15,
                                    pants_2  = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0,
                                    helmet_1  = -1,
                                    helmet_2  = 0,
                                    glasses_1  = -1,
                                    glasses_2  = 0,
                                    chain_1 = 0,
                                    chain_2 = 0,
                                    decals_1 = 0,
                                    decals_2 = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
                elseif data.item.type == "item_chaussures" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.shoes_1) == tonumber((data.item.skins).shoes_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    shoes_1  = 34,
                                    shoes_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    shoes_1  = 34,
                                    shoes_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)    
                    end
                    save()
                end)

            elseif data.item.type == "item_pantalon" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.pants_1) == tonumber((data.item.skins).pants_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    pants_1  = 14,
                                    pants_2  = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    pants_1  = 15,
                                    pants_2  = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_masque" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.mask_1) == tonumber((data.item.skins).mask_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    mask_1   = 0,
                                    mask_2   = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    mask_1   = 0,
                                    mask_2   = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_lunettes" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.glasses_1) == tonumber((data.item.skins).glasses_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 0,
                                    glasses_1 = 0,
                                    glasses_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 1,
                                    glasses_1 = 0,
                                    glasses_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_chapeau" then
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.helmet_1) == tonumber((data.item.skins).helmet_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    helmet_1 = -1,
                                    helmet_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    helmet_1 = -1,
                                    helmet_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_montre" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.watches_1) == tonumber((data.item.skins).watches_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 0,
                                    watches_1 = -1,
                                    watches_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex       = 1,
                                    watches_1 = -1,
                                    watches_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_oreille" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.ears_1) == tonumber((data.item.skins).ears_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex    = 0,
                                    ears_1 = -1,
                                    ears_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex    = 1,
                                    ears_1 = -1,
                                    ears_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_bracelet" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.bracelets_1) == tonumber((data.item.skins).bracelets_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex         = 0,
                                    bracelets_1 = -1,
                                    bracelets_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex         = 1,
                                    bracelets_1 = -1,
                                    bracelets_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_calque" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.decals_1) == tonumber((data.item.skins).decals_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    decals_1 = 0,
                                    decals_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    decals_1 = 0,
                                    decals_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_sac" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.bags_1) == tonumber((data.item.skins).bags_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 0,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex      = 1,
                                    bags_1 = 0,
                                    bags_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
        
            elseif data.item.type == "item_chaine" then
        
                TriggerEvent('skinchanger:getSkin', function(skin)
        
                    if tonumber(skin.chain_1) == tonumber((data.item.skins).chain_1) then
                        TriggerEvent('skinchanger:getSkin', function(skin)
                            if skin.sex == 0 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex     = 0,
                                    chain_1 = 0,
                                    chain_2 = 0
                                })
                            elseif skin.sex == 1 then
                                TriggerEvent('skinchanger:loadSkin', {
                                    sex     = 1,
                                    chain_1 = 0,
                                    chain_2 = 0
                                })
                            elseif skin.sex >= 2 then
                            end
                        end)
                    end
                    save()
                end)
            end
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        local position = vector4(coords.x, coords.y, coords.z-1, heading)
        TriggerServerEvent("esx:removeInventoryItemClothe", data.item.type, data.item.label, 1, position, data.item.id)
        TaskPlayAnim(GetPlayerPed(-1), "random@domestic", "pickup_low" , 8.0, -8.0, 1780, 35, 0.0, false, false, false)
    end

    Wait(250)
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

function shouldCloseInventory(itemName)
    for index, value in ipairs(Config.CloseUiItems) do
        if value == itemName then
            return true
        end
    end

    return false
end

function shouldSkipAccount(accountName)
    for index, value in ipairs(Config.ExcludeAccountsList) do
        if value == accountName then
            return true
        end
    end

    return false
end

function save()
	TriggerEvent('skinchanger:getSkin', function(skin)
		TriggerServerEvent('esx_skin:save', skin)
	end)
end

local tenue, chaussures, masque, pantalon, haut, lunettes, chapeau, sac, chaine, calque, bracelet, montre, oreille, kevlar = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

function loadPlayerInventory(result)

    if result == 'item' then 
    
        ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
            items = {}
            fastItems = {}
			inventory = data.inventory
			accounts = data.accounts
			money = data.money
			weapons = data.weapons
			weight = data.weight
            maxWeight = data.maxWeight
            cards = data.cards
            idcard = data.idcard

            SendNUIMessage(
                {
                    action = "setItems",
                    text = "<div id=\"weightValue\"><p>" ..(weight/1000).. " / " ..(maxWeight/1000).. "KG</p></span>"
                }
            )
            
			if Config.IncludeCash and money ~= nil and money > 0 then
				moneyData = {
					label = "Espèces",
					name = "cash",
					type = "item_money",
					count = money,
					usable = false,
					rare = false,
					weight = 0
				}
				table.insert(items, moneyData)
			end

            if Config.IncludeAccounts and accounts ~= nil then
                for key, value in pairs(accounts) do
                    if not shouldSkipAccount(accounts[key].name) then
                        local canDrop = accounts[key].name ~= "bank"

                        if accounts[key].money > 0 then
                            accountData = {
                                label = "Espèces Inconnu",
                                count = accounts[key].money,
                                type = "item_account",
                                name = accounts[key].name,
                                usable = false,
                                rare = false,
                                weight = 0
                            }
                            table.insert(items, accountData)
                        end
                    end
                end
            end

            for k, v in pairs(cards) do
                cardsData = {
                    label = "Compte N°"..v.account,
                    name = "carte",
                    type = "item_card",
                    account = v.account,
                    numero = v.numero,
                    id = v.id,
                    count = 1,
                    usable = true,
                    rename = false,
                    rare = false,
                    weight = -1
                }
                table.insert(items, cardsData)
            end

            for k, v in pairs(idcard) do
                if v.type == "idcard" then
                    idcardData = {
                        license = v.type,
                        label = v.name,
                        name = "carteidentite",
                        type = "item_idcard",
                        cartename = v.name,
                        dateofbirth = v.dateofbirth,
                        ldn = v.ldn,
                        id = v.id,
                        count = 1,
                        usable = true,
                        rename = false,
                        rare = false,
                        weight = -1
                    }
                elseif v.type == "permis" then
                    idcardData = {
                        license = v.type,
                        label = v.name,
                        name = "permis",
                        type = "item_idcard",
                        cartename = v.name,
                        dateofbirth = v.dateofbirth,
                        ldn = v.ldn,
                        permisCar = v.permisCar,
                        pointCar = v.pointCar,
                        permisMoto = v.permisMoto,
                        pointMoto = v.pointMoto,
                        permisCamion = v.permisCamion,
                        pointCamion = v.pointCamion,
                        permisBoat = v.permisBoat,
                        permisAirplanes = v.permisAirplanes,
                        id = v.id,
                        count = 1,
                        usable = true,
                        rename = false,
                        rare = false,
                        weight = -1
                    }
                end
                table.insert(items, idcardData)
            end

            if inventory ~= nil then
                for key, value in pairs(inventory) do
                    if inventory[key].count <= 0 then
                        inventory[key] = nil
                    else
                        if json.encode(Inv.FastWeapons) ~= "[]" then
                            for k,v in pairs(Inv.FastWeapons) do 
                                for fast, bind in pairs(Inv.FastWeapons) do
                                    if inventory[key].name == bind then
                                        table.insert(fastItems, {
                                            label = inventory[key].label,
                                            count = inventory[key].count,
                                            limit = -1,
                                            type = inventory[key].type,
                                            name = inventory[key].name,
                                            usable = true,
                                            rare = false,
                                            slot = fast
                                        })
                                    end
                                end
                            end
                        end
  
                        -- if inventory[key].name == altix.a then
                        --     inventory[key].label = altix.b
                        -- end

                        inventory[key].type = "item_standard"
                        table.insert(items, inventory[key])
                    end
                end
            end

         
        SendNUIMessage({ action = "setItems", itemList = items, fastItems = fastItems, text = texts, crMenu = currentMenu})
        end, GetPlayerServerId(PlayerId()))
    elseif result == 'clothe' then 
        items = {}

        ESX.TriggerServerCallback('AltixGetType', function(Vetement)
            tenue, chaussures, masque, pantalon, haut, lunettes, chapeau, sac, chaine, calque, bracelet, montre, oreille, kevlar, tshirt, gant = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}
            for k, v in pairs(Vetement) do  
                if v.type == "tenue" and not v.onPickup then 
                    table.insert(tenue, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id})
                end
                if v.type == "kevlar" and not v.onPickup then 
                    table.insert(kevlar, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bproof_1", data2 = "bproof_2", vie = v.vie})
                end
                if v.type == "tshirt" and not v.onPickup then 
                    table.insert(tshirt, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "tshirt_1", data2 = "tshirt_2"})
                end
                if v.type == "gant" and not v.onPickup then 
                    table.insert(gant, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "arms", data2 = "arms_2"})
                end
                if v.type == "chaussures" and not v.onPickup then 
                    table.insert(chaussures, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "shoes_1", data2 = "shoes_2"})
                end 
                if v.type == "masque" and not v.onPickup then 
                    table.insert(masque, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "mask_1", data2 = "mask_2"})
                end
                if v.type == "pantalon" and not v.onPickup then 
                    table.insert(pantalon, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "pants_1", data2 = "pants_2"})
                end 
                if v.type == "montre" and not v.onPickup then 
                    table.insert(montre, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "watches_1", data2 = "watches_2"})
                end 
                if v.type == "bracelet" and not v.onPickup then 
                    table.insert(bracelet, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bracelets_1", data2 = "bracelets_2"})
                end
                if v.type == "oreille" and not v.onPickup then 
                    table.insert(oreille, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "ears_1", data2 = "ears_2"})
                end
                if v.type == "lunettes" and not v.onPickup then 
                    table.insert(lunettes, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "glasses_1", data2 = "glasses_2"})
                end 
                if v.type == "chapeau" and not v.onPickup then 
                    table.insert(chapeau, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "helmet_1", data2 = "helmet_2"})
                end 
                if v.type == "sac" and not v.onPickup then 
                    table.insert(sac, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bags_1", data2 = "bags_1"})
                end 
                if v.type == "chaine" and not v.onPickup then 
                    table.insert(chaine, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "chain_1", data2 = "chain_2"})
                end 
                if v.type == "calque" and not v.onPickup then 
                    table.insert(calque, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "decals_1", data2 = "decals_2"})
                end 
                if v.type == "haut" and not v.onPickup then 
                    table.insert(haut, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id})
                end 
            end

            Wait(10)

            for k, v in pairs(tenue) do
                tenueData = {
                    label = v.name,
                    name = "tenue",
                    type = "item_tenue",
                    skins = v.skins,
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    id = v.id, 
                    weight = -1
                }
                table.insert(items, tenueData)
            end

            for k, v in pairs(chaussures) do
                chaussuresData = {
                    label = v.name,
                    name = "shoes",
                    type = "item_chaussures",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    count = "",
                    usable = true,
                    id = v.id, 
                    decals = v.decals,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, chaussuresData)
            end

            for k, v in pairs(masque) do
                masqueData = {
                    label = v.name,
                    name = "mask",
                    type = "item_masque",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, masqueData)
            end

            for k, v in pairs(pantalon) do
                pantalonData = {
                    label = v.name,
                    name = "jean",
                    type = "item_pantalon",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    decals = v.decals,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, pantalonData)
            end

            for k, v in pairs(kevlar) do
                kevlarData = {
                    label = v.name,
                    name = "kevlar",
                    type = "item_kevlar",
                    skins = v.skins,
                    vie = v.vie,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, kevlarData)
            end

            for k, v in pairs(haut) do
                hautData = {
                    label = v.name,
                    name = "shirt",
                    type = "item_haut",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, hautData)
            end

            for k, v in pairs(tshirt) do
                tshirtData = {
                    label = v.name,
                    name = "mask",
                    type = "item_tshirt",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, tshirtData)
            end

            for k, v in pairs(gant) do
                gantData = {
                    label = v.name,
                    name = "shirt",
                    type = "item_gant",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, gantData)
            end

            for k, v in pairs(lunettes) do
                lunettesData = {
                    label = v.name,
                    name = "tie",
                    type = "item_lunettes",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, lunettesData)
            end

            for k, v in pairs(chapeau) do
                chapeauData = {
                    label = v.name,
                    name = "hat",
                    type = "item_chapeau",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    decals = 11,
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, chapeauData)
            end
            
            for k, v in pairs(sac) do
                sacData = {
                    label = v.name,
                    name = "bag",
                    type = "item_sac",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, sacData)
            end

            for k, v in pairs(montre) do
                montreData = {
                    label = v.name,
                    name = "montre",
                    type = "item_montre",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, montreData)
            end

            for k, v in pairs(oreille) do
                oreilleData = {
                    label = v.name,
                    name = "boucleoreille",
                    type = "item_oreille",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, oreilleData)
            end

            for k, v in pairs(bracelet) do
                braceletData = {
                    label = v.name,
                    name = "bracelet",
                    type = "item_bracelet",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, braceletData)
            end

            for k, v in pairs(chaine) do
                chaineData = {
                    label = v.name,
                    name = "chaine",
                    type = "item_chaine",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, chaineData)
            end
    
            for k, v in pairs(calque) do
                calqueData = {
                    label = v.name,
                    name = "shirt",
                    type = "item_calque",
                    skins = v.skins,
                    info = v.data,
                    info2 = v.data2,
                    id = v.id, 
                    count = "",
                    usable = true,
                    rename = true,
                    rare = false,
                    weight = -1
                }
                table.insert(items, calqueData)
            end

        SendNUIMessage({ action = "setItems", itemList = items, fastItems = fastItems, text = texts, crMenu = currentMenu})
        Wait(50)
    end)
    end
end

Citizen.CreateThread(function()
    Citizen.Wait(1000)
    while true do
        Citizen.Wait(750)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(20)
        BlockWeaponWheelThisFrame()
        SetPedCanSwitchWeapon(PlayerPedId(), false)

        if not isInInventory then 
            SendNUIMessage({showUi = false})
        end 
    end
end)

RegisterNUICallback("PutIntoFast", function(data, cb)
    if not blacklistitem[data.item.name] then
	    if data.item.slot ~= nil then
		    Inv.FastWeapons[data.item.slot] = nil
	    end
	    Inv.FastWeapons[data.slot] = data.item.name
        SetFieldValueFromNameEncode('offline', {name = Inv.FastWeapons})
	    loadPlayerInventory(currentMenu)
	    cb("ok")
    end
end)

RegisterNUICallback("TakeFromFast", function(data, cb)
	Inv.FastWeapons[data.item.slot] = nil
    SetFieldValueFromNameEncode('offline', {name = Inv.FastWeapons})
	loadPlayerInventory(currentMenu)
	cb("ok")
end)

RegisterKeyMapping('+ouvririnventaire', 'Ouverture inventaire', 'keyboard', 'TAB')
RegisterKeyMapping('+keybind1', 'Slot d\'arme 1', 'keyboard', '1')
RegisterKeyMapping('+keybind2', 'Slot d\'arme 2', 'keyboard', '2')
RegisterKeyMapping('+keybind3', 'Slot d\'arme 3', 'keyboard', '3')
RegisterKeyMapping('+keybind4', 'Slot d\'arme 4', 'keyboard', '4')
RegisterKeyMapping('+keybind5', 'Slot d\'arme 5', 'keyboard', '5')

RegisterCommand('+ouvririnventaire', function()
    if not isInInventory then
        openInventory()
    elseif isInInventory then 
        closeInventory()
    end
end)

RegisterCommand('+keybind1', function()
    useitem(1)
end)

RegisterCommand('+keybind2', function()
    useitem(2)
end)

RegisterCommand('+keybind3', function()
    useitem(3)
end)

RegisterCommand('+keybind4', function()
    useitem(4)
end)

RegisterCommand('+keybind5', function()
    useitem(5)
end)

function useitem(num)
    if IsPedRagdoll(PlayerPedId()) or exports["offline"]:GetPlayerDead() or exports["offline"]:GetPlayerKnockout() then
        ESX.ShowNotification("~r~Impossible de réaliser cette action.")
        return
    end
    if not blacklistitem[Inv.FastWeapons[num]] and not isInInventory then
        if Inv.FastWeapons[num] ~= nil then
            TriggerServerEvent('esx:useItem', Inv.FastWeapons[num])
        end
    end
end

KEEP_FOCUS = false
local threadCreated = false
local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 69, 70, 111, 117, 118, 182, 199, 200, 257}

function SetKeepInputMode(bool)
    if SetNuiFocusKeepInput then
        SetNuiFocusKeepInput(bool)
    end

    KEEP_FOCUS = bool

    if not threadCreated and bool then
        threadCreated = true

        Citizen.CreateThread(function()
            while KEEP_FOCUS do
                Wait(0)

                for _,v in pairs(controlDisabled) do
                    DisableControlAction(0, v, true)
                end
            end

            threadCreated = false
        end)
    end
end

CreateThread(function()
    while true do
        local time = 500
        if totalWeight >= 40000 then
            time = 1
            DisableControlAction(0, 21, true)
            DisableControlAction(0, 22, true)

            if NotificationWeight then
                NotificationWeight = false
                ESX.Notification('Personnage ('..(totalWeight/1000)..' KG)\n~r~Vous êtes trop lourd pour courir.')
            end
        else
            NotificationWeight = true
        end
        Wait(time)
    end
end)

function PlayAnimBind(anim, dict, mov)   
    if not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) and not isInInventory then
        if not IsEntityPlayingAnim(PlayerPedId(), anim, dict, 3) then
            if dict and not HasAnimDictLoaded(anim) then
                if DoesAnimDictExist(anim) then
                    RequestAnimDict(anim)
                    while not HasAnimDictLoaded(anim) do
                        Citizen.Wait(10)
                    end
                end
            end
            if GetSelectedPedWeapon(PlayerPedId()) == GetHashKey("weapon_unarmed") then
                ClearPedTasks(PlayerPedId())
                TaskPlayAnim(PlayerPedId(), anim, dict, 8.0, 8.0, -1, mov or 0, 1, 0, 0, 0)
            end
        else
            ClearPedTasks(PlayerPedId())
        end
    end
end

RegisterKeyMapping("-bind0", "Jouer l'animation n°0", "keyboard", "NUMPAD0")
RegisterKeyMapping("-bind1", "Jouer l'animation n°1", "keyboard", "NUMPAD1")
RegisterKeyMapping("-bind2", "Jouer l'animation n°2", "keyboard", "NUMPAD2")
RegisterKeyMapping("-bind3", "Jouer l'animation n°3", "keyboard", "NUMPAD3")
RegisterKeyMapping("-bind4", "Jouer l'animation n°4", "keyboard", "NUMPAD4")
RegisterKeyMapping("-bind5", "Jouer l'animation n°5", "keyboard", "NUMPAD5")
RegisterKeyMapping("-bind6", "Jouer l'animation n°6", "keyboard", "NUMPAD6")
RegisterKeyMapping("-bind7", "Jouer l'animation n°7", "keyboard", "NUMPAD7")
RegisterKeyMapping("-bind8", "Jouer l'animation n°8", "keyboard", "NUMPAD8")
RegisterKeyMapping("-bind9", "Jouer l'animation n°9", "keyboard", "NUMPAD9")

RegisterCommand("-bind0", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind0")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind1", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind1")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind2", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind2")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind3", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind3")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind4", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind4")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind5", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind5")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind6", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind6")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind7", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind7")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind8", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind8")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterCommand("-bind9", function()
    local AnimBind = ESX.GetFieldValueFromName("offlineBind9")
    if json.encode(AnimBind) ~= "[]" then
        PlayAnimBind(AnimBind.name, AnimBind.anim, AnimBind.mouv)
    end
end)

RegisterNetEvent('UseKevlarItem')
AddEventHandler('UseKevlarItem', function(kevlarItem)
    if kevlarItem.type == "item_kevlar" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if tonumber(skin.bproof_1) ~= tonumber(kevlarItem.skins.bproof_1) then
                if IsPedInAnyVehicle(PlayerPedId(), false) then
                    if math.ceil(GetEntitySpeed(GetVehiclePedIsIn(PlayerPedId(), false)) * 3.6) <= 20.0 then
                        TriggerEvent('skinchanger:loadClothes', skin, {
                            ["bproof_1"] = kevlarItem.skins.bproof_1,
                            ["bproof_2"] = kevlarItem.skins.bproof_2
                        })
                        SetPedArmour(PlayerPedId(), kevlarItem.vie)
                        Kevlar.IdKev = kevlarItem.id
                        ESX.Notification("Vous avez équipé votre ~g~Gilet par balle~s~.")
                        Wait(500)
                        Kevlar.StartDegatKevlar = true
                    else
                        ESX.ShowNotification("~r~Impossible de mettre son kevlar en conduisant.")
                    end
                else
                    TriggerEvent('skinchanger:loadClothes', skin, {
                        ["bproof_1"] = kevlarItem.skins.bproof_1,
                        ["bproof_2"] = kevlarItem.skins.bproof_2
                    })
                    SetPedArmour(PlayerPedId(), kevlarItem.vie)
                    Kevlar.IdKev = kevlarItem.id
                    ESX.Notification("Vous avez équipé votre ~g~Gilet par balle~s~.")
                    Wait(500)
                    Kevlar.StartDegatKevlar = true
                end
            else
                if skin.sex == 0 then
                    TriggerEvent('skinchanger:loadSkin', {
                        sex = 0,
                        bproof_1 = 0,
                        bproof_2 = 0
                    })
                elseif skin.sex == 1 then
                    TriggerEvent('skinchanger:loadSkin', {
                        sex = 1,
                        bproof_1 = 0,
                        bproof_2 = 0
                    })
                elseif skin.sex >= 2 then
                    -- Gérer le cas pour d'autres sexes si nécessaire
                end
                ESX.Notification("Vous avez retiré votre ~g~Gilet par balle~s~.")
                TriggerServerEvent('UpdateVieKevlar', Kevlar.IdKev, GetPedArmour(PlayerPedId()))
                Wait(150)
                SetPedArmour(PlayerPedId(), 0)
                TriggerServerEvent('RefreshPlayerHealthArmour', GetEntityHealth(PlayerPedId()), GetPedArmour(PlayerPedId()))
                Kevlar.StartDegatKevlar = false
            end
        end)
    end
end)