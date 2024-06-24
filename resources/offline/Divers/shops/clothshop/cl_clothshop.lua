local menuIsOpened = false

local doplus1 = nil

local ClothShop = {
    SlideTShirt = 1,
    SlideTorse = 1,
    SlideBras = 1,
    SlideTShirt2 = 1,
    SlideTorse2 = 1,
    SlideBras2 = 1,
    Torse = {},
    tShirt = {},
    Bras = {},
    IndexMalette = 1,
    IndexMalette2 = 1,
    MaletteList = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
    MaletteList2 = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"},
    IndexParapluie = 1,
    ParapluieList = {"1", "2", "3", "4", "5", "6", "7", "8", "9", "10"}
}

local function OpenClotheShopMenu(header, Type)
    if Type == "Cloth" then
        local maxValsI = {}
        TriggerEvent('skinchanger:getData', function(components, maxVals)
            maxValsI["tshirt_1"] = maxVals.tshirt_1
            maxValsI["torso_1"] = maxVals.torso_1
            maxValsI["pants_1"] = maxVals.pants_1
            maxValsI["shoes_1"] = maxVals.shoes_1
            maxValsI["helmet_1"] = maxVals.helmet_1
            maxValsI["glasses_1"] = maxVals.glasses_1
            maxValsI["ears_1"] = maxVals.ears_1
            maxValsI["bags_1"] = maxVals.bags_1
            maxValsI["gloves_1"] = maxVals.arms
            maxValsI["watches_1"] = maxVals.watches_1
            maxValsI["bracelets_1"] = maxVals.bracelets_1
            maxValsI["chain_1"] = maxVals.chain_1
            maxValsI["decals_1"] = maxVals.decals_1

            ClothShop.Torse = {}
            ClothShop.tShirt = {}
            ClothShop.Bras = {}

            for i = 0, maxVals.torso_1, 1 do
                table.insert(ClothShop.Torse, {Name = tostring(i)})
            end
            for i = 0, maxVals.tshirt_1, 1 do
                table.insert(ClothShop.tShirt, {Name = tostring(i)})
            end
            for i = 0, maxVals.arms, 1 do
                table.insert(ClothShop.Bras, {Name = tostring(i)})
            end
        end)
        local clothMenu = RageUI.CreateMenu("", "Magasin de vêtements", nil, 100, header, header)
        local Haut = RageUI.CreateSubMenu(clothMenu, "", "Hauts", nil, 100, header, header)
        local pantsMenu = RageUI.CreateSubMenu(clothMenu, "", "Pantalons", nil, 100, header, header)
        local shoesMenu = RageUI.CreateSubMenu(clothMenu, "", "Chaussures", nil, 100, header, header)
        local AccessoireMenu = RageUI.CreateSubMenu(clothMenu, "", "Accessoires", nil, 100, header, header)
        local helmetMenu = RageUI.CreateSubMenu(AccessoireMenu, "", "Chapeaux", nil, 100, header, header)
        local glassesMenu = RageUI.CreateSubMenu(AccessoireMenu, "", "Lunettes", nil, 100, header, header)
        local earsMenu = RageUI.CreateSubMenu(AccessoireMenu, "", "Oreillettes", nil, 100, header, header)
        local bagsMenu = RageUI.CreateSubMenu(AccessoireMenu, "", "Sac à dos", nil, 100, header, header)
        local glovesMenu = RageUI.CreateSubMenu(clothMenu, "", "Hauts", nil, 100, header, header)
        local watchesMenu = RageUI.CreateSubMenu(clothMenu, "", "Montres", nil, 100, header, header)
        local braceletsMenu = RageUI.CreateSubMenu(clothMenu, "", "Bracelets", nil, 100, header, header)
        local chainesMenu = RageUI.CreateSubMenu(clothMenu, "", "Chaînes", nil, 100, header, header)
        local badgesMenu = RageUI.CreateSubMenu(clothMenu, "", "Badges", nil, 100, header, header)
        local VariationMenu = RageUI.CreateSubMenu(clothMenu, "", "Variations", nil, 100, header, header)
        local ObjetsMenu = RageUI.CreateSubMenu(clothMenu, "", "Objets", nil, 100, header, header)
        local iteratorSelected = nil
        local CurrentValue1 = nil
        local CurrentValue2 = nil
        local CurrentName = nil
        local CurrentCategory = nil
        clothMenu:DisplayGlare(false)
        VariationMenu:DisplayGlare(false)
        pantsMenu:DisplayGlare(false)
        shoesMenu:DisplayGlare(false)
        helmetMenu:DisplayGlare(false)
        glassesMenu:DisplayGlare(false)
        earsMenu:DisplayGlare(false)
        bagsMenu:DisplayGlare(false)
        glovesMenu:DisplayGlare(false)
        watchesMenu:DisplayGlare(false)
        braceletsMenu:DisplayGlare(false)
        chainesMenu:DisplayGlare(false)
        badgesMenu:DisplayGlare(false)
        Haut:DisplayGlare(false)
        ObjetsMenu:DisplayGlare(false)
        AccessoireMenu:DisplayGlare(false)

        clothMenu.Closed = function()
            refreshskin()
            menuIsOpened = false
            RageUI.Visible(clothMenu, false)
        end

        if menuIsOpened then
            menuIsOpened = false
            RageUI.Visible(clothMenu, false)
            refreshskin()
        else
            refreshskin()
            Wait(250)
            TriggerEvent('skinchanger:getSkin', function(skin)
                    menuIsOpened = true
                    RageUI.Visible(clothMenu, true)
                    Citizen.CreateThread(function()
                        while menuIsOpened do
                            RageUI.IsVisible(ObjetsMenu, function()
                                RageUI.List("Parapluie", ClothShop.ParapluieList, ClothShop.IndexParapluie, nil, {RightLabel = "~g~"..(ClothShop.IndexParapluie*30).."$"}, true, {
                                    onListChange = function(Index)
                                        ClothShop.IndexParapluie = Index
                                    end,
                                    onSelected = function()     
                                        TriggerServerEvent("marketPaiement", (ClothShop.IndexParapluie*30), "parapluie", "Parapluie", ClothShop.IndexParapluie)
                                    end
                                })
                                RageUI.List("Malette en cuir", ClothShop.MaletteList, ClothShop.IndexMalette, nil, {RightLabel = "~g~"..(ClothShop.IndexMalette*150).."$"}, true, {
                                    onListChange = function(Index)
                                        ClothShop.IndexMalette = Index
                                    end,
                                    onSelected = function()
                                        TriggerServerEvent("marketPaiement", (ClothShop.IndexMalette*150), "WEAPON_BRIEFCASE_02", "Malette en cuir", ClothShop.IndexMalette)
                                    end
                                })
                                RageUI.List("Malette grise", ClothShop.MaletteList2, ClothShop.IndexMalette2, nil, {RightLabel = "~g~"..(ClothShop.IndexMalette2*150).."$"}, true, {
                                    onListChange = function(Index)
                                        ClothShop.IndexMalette2 = Index
                                    end,
                                    onSelected = function()
                                        TriggerServerEvent("marketPaiement", (ClothShop.IndexMalette2*150), "WEAPON_BRIEFCASE", "Malette grise", ClothShop.IndexMalette2)
                                    end
                                })
                            end)
                            RageUI.IsVisible(clothMenu, function()
                                if skin.sex <=1 then
                                    RageUI.Button("Enregistrer une tenue", nil, {RightLabel = "~g~25$"}, true, {
                                        onSelected = function()
                                            local name = ESX.KeyboardInput("Nom de la tenue", 30)
                                            if name ~= nil then
                                                ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                                    if cb then
                                                        TriggerEvent('skinchanger:getSkin', function(h)
                                                            local skin = {
                                                                ["pants_1"] = tonumber(h.pants_1), 
                                                                ["pants_2"] = tonumber(h.pants_2), 
                                                                ["tshirt_1"] = tonumber(h.tshirt_1), 
                                                                ["tshirt_2"] = tonumber(h.tshirt_2), 
                                                                ["torso_1"] = tonumber(h.torso_1), 
                                                                ["torso_2"] = tonumber(h.torso_2), 
                                                                ["arms"] = tonumber(h.arms), 
                                                                ["arms_2"] = tonumber(h.arms_2), 
                                                                ["decals_1"] = tonumber(h.decals_1), 
                                                                ["decals_2"] = tonumber(h.decals_2),
                                                                ["mask_1"] = tonumber(h.mask_1),
                                                                ["mask_2"] = tonumber(h.mask_2),
                                                                ["helmet_1"] = tonumber(h.helmet_1),
                                                                ["helmet_2"] = tonumber(h.helmet_2),
                                                                ["shoes_1"] = tonumber(h.shoes_1), 
                                                                ["shoes_2"] = tonumber(h.shoes_2), 
                                                                ["chain_1"] = tonumber(h.chain_1), 
                                                                ["chain_2"] = tonumber(h.chain_2),
                                                            }
                                                            TriggerServerEvent("InsertTenue", "tenue", name, skin)
                                                            ESX.ShowNotification("~g~Vous avez acheté une tenue personnalisée.")
                                                        end)
                                                    else
                                                        ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(25$)')
                                                    end
                                                end, 25)
                                            end
                                        end
                                    })
                                    RageUI.Button("Hauts", nil, {RightLabel = "→"}, true, {}, Haut)
                                    RageUI.Button("Pantalons", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "pants_1"
                                            CurrentValue2 = "pants_2"
                                            CurrentName = "Pantalon "
                                            CurrentCategory = "pantalon"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, pantsMenu)
                                    RageUI.Button("Chaussures", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "shoes_1"
                                            CurrentValue2 = "shoes_2"
                                            CurrentName = "Chaussures "
                                            CurrentCategory = "chaussures"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, shoesMenu)
                                    RageUI.Button("Sacs", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "bags_1"
                                            CurrentValue2 = "bags_2"
                                            CurrentName = "Sac à dos "
                                            CurrentCategory = "sac"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, bagsMenu)
                                    RageUI.Button("Accessoires", nil, {RightLabel = "→"}, true, {}, AccessoireMenu)
                                    RageUI.Button("Badge", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "decals_1"
                                            CurrentValue2 = "decals_2"
                                            CurrentName = "Badge "
                                            CurrentCategory = "calque"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, badgesMenu)
                                    RageUI.Button("Objets", nil, {RightLabel = "→"}, true, {}, ObjetsMenu)
                                else
                                    RageUI.Button("Haut", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "arms"
                                            CurrentValue2 = "arms_2"
                                            CurrentName = "Haut "
                                            CurrentCategory = "gant"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, glovesMenu)
                                    RageUI.Button("Pantalons", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "pants_1"
                                            CurrentValue2 = "pants_2"
                                            CurrentName = "Pantalon "
                                            CurrentCategory = "pantalon"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, pantsMenu)
                                    RageUI.Button("Chapeaux", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "helmet_1"
                                            CurrentValue2 = "helmet_2"
                                            CurrentName = "Chapeau "
                                            CurrentCategory = "chapeau"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, helmetMenu)
                                    RageUI.Button("Lunettes", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "glasses_1"
                                            CurrentValue2 = "glasses_2"
                                            CurrentName = "Lunettes "
                                            CurrentCategory = "lunettes"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, glassesMenu)
                                    RageUI.Button("Badge", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "decals_1"
                                            CurrentValue2 = "decals_2"
                                            CurrentName = "Badge "
                                            CurrentCategory = "calque"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, badgesMenu)
                                    RageUI.Button("Masque", nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            CurrentValue1 = "tshirt_1"
                                            CurrentValue2 = "tshirt_2"
                                            CurrentName = "Masque "
                                            CurrentCategory = "tshirt"
                                            TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                        end,
                                    }, tShirtMenu)
                                    RageUI.Button("Objets", nil, {RightLabel = "→"}, true, {}, ObjetsMenu)
                                end
                            end)
                            RageUI.IsVisible(AccessoireMenu, function()
                                RageUI.Button("Chapeaux", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "helmet_1"
                                        CurrentValue2 = "helmet_2"
                                        CurrentName = "Chapeau "
                                        CurrentCategory = "chapeau"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, helmetMenu)
                                RageUI.Button("Lunettes", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "glasses_1"
                                        CurrentValue2 = "glasses_2"
                                        CurrentName = "Lunettes "
                                        CurrentCategory = "lunettes"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, glassesMenu)
                                RageUI.Button("Oreillettes", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "ears_1"
                                        CurrentValue2 = "ears_2"
                                        CurrentName = "Oreillette "
                                        CurrentCategory = "oreille"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, earsMenu)
                                RageUI.Button("Montres", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "watches_1"
                                        CurrentValue2 = "watches_2"
                                        CurrentName = "Montre "
                                        CurrentCategory = "montre"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, watchesMenu)
                                RageUI.Button("Bracelets", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "bracelets_1"
                                        CurrentValue2 = "bracelets_2"
                                        CurrentName = "Bracelet "
                                        CurrentCategory = "bracelet"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, braceletsMenu)
                                RageUI.Button("Chaines", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        CurrentValue1 = "chain_1"
                                        CurrentValue2 = "chain_2"
                                        CurrentName = "Chaine "
                                        CurrentCategory = "chaine"
                                        TriggerEvent('skinchanger:change', CurrentValue2, 0)
                                    end,
                                }, chainesMenu)
                            end)
                            RageUI.IsVisible(Haut, function()
                                RageUI.List('T-Shirt', ClothShop.tShirt, ClothShop.SlideTShirt, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideTShirt = Index
                                        TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                                        TriggerEvent('skinchanger:change', 'tshirt_1', ClothShop.SlideTShirt-1)
                                    end
                                })
                                RageUI.List('Couleur du T-Shirt', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, ClothShop.SlideTShirt2, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideTShirt2 = Index
                                        TriggerEvent('skinchanger:change', 'tshirt_2', ClothShop.SlideTShirt2-1)
                                    end
                                })
                                RageUI.List('Torse', ClothShop.Torse, ClothShop.SlideTorse, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideTorse = Index
                                        TriggerEvent('skinchanger:change', 'torso_2', 0)
                                        TriggerEvent('skinchanger:change', 'torso_1', ClothShop.SlideTorse-1)
                                    end
                                })
                                RageUI.List('Couleur du Torse', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, ClothShop.SlideTorse2, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideTorse2 = Index
                                        TriggerEvent('skinchanger:change', 'torso_2', ClothShop.SlideTorse2-1)
                                    end
                                })
                                RageUI.List('Gants', ClothShop.Bras, ClothShop.SlideBras, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideBras = Index
                                        TriggerEvent('skinchanger:change', 'arms_2', 0)
                                        TriggerEvent('skinchanger:change', 'arms', ClothShop.SlideBras-1)
                                    end
                                })
                                RageUI.List('Couleur des Gants', {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30}, ClothShop.SlideBras2, nil, {}, true, {
                                    onListChange = function(Index)
                                        ClothShop.SlideBras2 = Index
                                        TriggerEvent('skinchanger:change', 'arms_2', ClothShop.SlideBras2-1)
                                    end
                                })
                                RageUI.Button("Acheter", nil, {RightLabel = "~g~25$"}, true, {
                                    onSelected = function()
                                        ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                            if cb then
                                                TriggerEvent('skinchanger:getSkin', function(skin)
                                                    local haut = {
                                                        ["tshirt_1"] = tonumber(skin.tshirt_1),
                                                        ["tshirt_2"] = tonumber(skin.tshirt_2),
                                                        ["torso_1"] = tonumber(skin.torso_1),
                                                        ["torso_2"] = tonumber(skin.torso_2),
                                                        ["arms"] = tonumber(skin.arms),
                                                        ["arms_2"] = tonumber(skin.arms_2),
                                                    }
                                                    TriggerServerEvent("InsertTenue", "haut", "Haut "..skin.torso_1, haut)
                                                    ESX.ShowNotification("~g~Voici votre Haut : "..skin.torso_1)
                                                    ClothShop.SlideTShirt = 1
                                                    ClothShop.SlideTorse = 1
                                                    ClothShop.SlideBras = 1
                                                    ClothShop.SlideTShirt2 = 1
                                                    ClothShop.SlideTorse2 = 1
                                                    ClothShop.SlideBras2 = 1
                                                    refreshskin()
                                                end)
                                            else
                                                ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(25$)')
                                            end
                                        end, 25)
                                    end
                                })
                            end)
                            RageUI.IsVisible(tShirtMenu, function()
                                for i=0, maxValsI["tshirt_1"], 1 do
                                    RageUI.Button("T-Shirt : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.tshirt_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'tshirt_1', i)
                                                end
                                            end)
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(pantsMenu, function()
                                for i=0, maxValsI["pants_1"], 1 do
                                    RageUI.Button("Pantalon : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.pants_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'pants_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(shoesMenu, function()
                                for i=0, maxValsI["shoes_1"], 1 do
                                    RageUI.Button("Chaussures : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.shoes_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'shoes_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(helmetMenu, function()
                                for i=0, maxValsI["helmet_1"] + 1, 1 do
                                    RageUI.Button("Chapeau : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.helmet_1) ~= tonumber(i-1) then
                                                    TriggerEvent('skinchanger:change', 'helmet_1', i-1)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i-1
                                            doplus1 = true
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(glassesMenu, function()
                                for i=0, maxValsI["glasses_1"], 1 do
                                    RageUI.Button("Lunettes : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.glasses_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'glasses_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(earsMenu, function()
                                for i=0, maxValsI["ears_1"] + 1, 1 do
                                    RageUI.Button("Oreillette : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.ears_1) ~= tonumber(i-1) then
                                                    TriggerEvent('skinchanger:change', 'ears_1', i-1)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i-1
                                            doplus1 = true
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(bagsMenu, function()
                                for i=0, maxValsI["bags_1"], 1 do
                                    RageUI.Button("Sac à dos : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.bags_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'bags_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(glovesMenu, function()
                                for i=0, maxValsI["gloves_1"], 1 do
                                    RageUI.Button("Gants : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.arms) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'arms', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(watchesMenu, function()
                                for i=0, maxValsI["watches_1"] + 1, 1 do
                                    RageUI.Button("Montre : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.watches_1) ~= tonumber(i-1) then
                                                    TriggerEvent('skinchanger:change', 'watches_1', i-1)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i-1
                                            doplus1 = true
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(braceletsMenu, function()
                                for i=0, maxValsI["bracelets_1"] + 1, 1 do
                                    RageUI.Button("Bracelet : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.bracelets_1) ~= tonumber(i-1) then
                                                    TriggerEvent('skinchanger:change', 'bracelets_1', i-1)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i-1
                                            doplus1 = true
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(chainesMenu, function()
                                for i=0, maxValsI["chain_1"], 1 do
                                    RageUI.Button("Chaine : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.chain_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'chain_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(badgesMenu, function()
                                for i=0, maxValsI["decals_1"], 1 do
                                    RageUI.Button("Badge : "..i, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.decals_1) ~= tonumber(i) then
                                                    TriggerEvent('skinchanger:change', 'decals_1', i)
                                                end
                                            end) 
                                        end,
                                        onSelected = function()
                                            iteratorSelected = i
                                        end
                                    }, VariationMenu)
                                end
                            end)
                            RageUI.IsVisible(VariationMenu, function()
                                for j = 0, 30, 1 do 
                                    RageUI.Button("Variation : "..j, nil, {}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if CurrentValue2 == "tshirt_2" then
                                                    if tonumber(skin.tshirt_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "torso_2" then
                                                    if tonumber(skin.torso_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "pants_2" then
                                                    if tonumber(skin.pants_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "shoes_2" then
                                                    if tonumber(skin.shoes_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "arms_2" then
                                                    if tonumber(skin.arms_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "helmet_2" then
                                                    if tonumber(skin.helmet_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "glasses_2" then
                                                    if tonumber(skin.glasses_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "ears_2" then
                                                    if tonumber(skin.ears_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "bags_2" then
                                                    if tonumber(skin.bags_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "watches_2" then
                                                    if tonumber(skin.watches_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "bracelets_2" then
                                                    if tonumber(skin.bracelets_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "chain_2" then
                                                    if tonumber(skin.chain_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                elseif CurrentValue2 == "decals_2" then
                                                    if tonumber(skin.decals_2) ~= tonumber(j) then
                                                        TriggerEvent('skinchanger:change', CurrentValue2, j)
                                                    end
                                                end
                                            end)      
                                        end,
                                        onSelected = function()
                                            ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                                if cb then
                                                    ESX.ShowNotification("Vous avez acheté ~b~"..CurrentName.." pour ~g~25$")
                                                    TriggerServerEvent("InsertVetement", CurrentCategory, CurrentName, CurrentValue1, iteratorSelected, CurrentValue2, j)
                                                    refreshskin()
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(25$)')
                                                end
                                            end, 25)
                                        end
                                    })
                                end
                            end)
                            Wait(1)
                        end
                    end)

            end)
        end
    end

    if Type == "Mask" then
        TriggerEvent('skinchanger:getSkin', function(skin)
            if skin.sex <=1 then
                local maxValsI = nil
                TriggerEvent('skinchanger:getData', function(components, maxVals)
                    maxValsI = maxVals.mask_1
                end)
                local iteratorSelected = nil
                local mainMenu = RageUI.CreateMenu("", "Magasin de masques", nil, 100, header, header)
                local subMenu = RageUI.CreateSubMenu(mainMenu, "", "Magasin de masques", nil, 100, header, header)
                mainMenu:DisplayGlare(false)
                subMenu:DisplayGlare(false)
                mainMenu.Closed = function()
                    refreshskin()
                    menuIsOpened = false
                    FreezeEntityPosition(PlayerPedId(), false)
                    RageUI.Visible(mainMenu, false)
                end
                if menuIsOpened then
                    menuIsOpened = false
                    RageUI.Visible(mainMenu, false)
                    refreshskin()
                else
                    refreshskin()   
                    menuIsOpened = true
                    RageUI.Visible(mainMenu, true)
                    Citizen.CreateThread(function()
                        while menuIsOpened do
                            RageUI.IsVisible(mainMenu, function()
                                for j = 0, maxValsI, 1 do 
                                    RageUI.Button("Masque : "..j, nil, {RightLabel = "~g~25$~s~"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.mask_1) ~= tonumber(j) then
                                                    TriggerEvent('skinchanger:change', 'mask_1', j)
                                                end
                                            end)
                                        end,
                                        onSelected = function()
                                            iteratorSelected = j
                                        end,
                                    }, subMenu)
                                end
                            end)
                            RageUI.IsVisible(subMenu, function()
                                for j = 0, 30, 1 do 
                                    RageUI.Button("Variation : "..j, nil, {RightLabel = "~g~25$"}, true, {
                                        onActive = function()
                                            TriggerEvent('skinchanger:getSkin', function(skin)
                                                if tonumber(skin.mask_2) ~= tonumber(j) then
                                                    TriggerEvent('skinchanger:change', 'mask_2', j)
                                                end
                                            end)
                                        end,
                                        onSelected = function()
                                            ESX.TriggerServerCallback('IfHasMoney', function(cb)
                                                if cb then
                                                    ESX.ShowNotification("Vous avez acheté ~b~".."Masque : "..iteratorSelected.." pour ~g~25$")
                                                    TriggerServerEvent("InsertVetement", "masque", "Masque "..iteratorSelected, "mask_1", iteratorSelected, "mask_2", j)
                                                    refreshskin()
                                                else
                                                    ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(25$)')
                                                end
                                            end, 25)
                                        end
                                    })
                                end
                            end)
                            Wait(1)
                        end
                    end)
                end
            else
               ESX.ShowNotification("~r~Vous n'avez pas accès avec votre personnage.")
            end
        end)
    end
end

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function setupScaleform()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, 51, true))
    ButtonMessage("Tourner votre personnage à droite")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, 44, true))
    ButtonMessage("Tourner votre personnage à gauche")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

function refreshskin()
    ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
        TriggerEvent('skinchanger:loadSkin', skin)
    end)
end

CreateThread(function()
    while true do
        local time = 500
        local plyCoord = GetEntityCoords(PlayerPedId())
        for k,v in pairs(Config.zoneClothStop) do
            for i=1, #v, 1 do
                local distance = GetDistanceBetweenCoords(plyCoord, v[i].coords, true)
                if distance < 1.7 and not menuIsOpened then
                    time = 1
                    DisplayNotification("Appuyez sur ~INPUT_PICKUP~ pour ~b~accéder au magasin")
                    if IsControlJustPressed(0, 38) then
                        OpenClotheShopMenu(v.Header, v.Type)
                    end
                elseif distance < 10.0 then
                    time = 1
                    DrawMarker(25, v[i].coords, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 46, 134, 193, 178, false, false, false, false)
                end
            end
        end
        Wait(time)
    end
end)