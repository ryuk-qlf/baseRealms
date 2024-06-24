local propertyData = nil

RegisterNetEvent("esx_inventoryhud:openPropertyInventory")
AddEventHandler("esx_inventoryhud:openPropertyInventory", function(data, blackMoney, cashMoney, inventory, weapons, cards, idcard, vetement)
    setPropertyInventoryData(data, blackMoney, cashMoney, inventory, weapons, cards, idcard, vetement)
    openPropertyInventory()
end)

function setPropertyInventoryData(data, blackMoney, cashMoney, inventory, weapons, cards, idcard, vetement)
    propertyData = data

    SendNUIMessage(
        {
            action = "setWeightText",
            text = data.text
        }
    )

    items = {}
    chestproptenue, chestpropchaussures, chestpropmasque, chestproppantalon, chestprophaut, chestproplunettes, chestpropchapeau, chestpropsac, chestpropchaine, chestpropcalque, chestpropbracelet, chestpropmontre, chestproporeille, chestpropkevlar, chestproptshirt, chestpropgant = {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}, {}

    if blackMoney > 0 then
        accountData = {
            label = "Espèces Inconnu",
            count = blackMoney,
            type = "item_account",
            name = "black_money",
            usable = false,
            rare = false,
            limit = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

	if cashMoney ~= nil and cashMoney > 0 then
        accountData = {
            label = "Espèces",
            count = cashMoney,
            type = "item_money",
            name = "cash",
            usable = false,
            rare = false,
            weight = -1,
            canRemove = false
        }
        table.insert(items, accountData)
    end

    if cards ~= nil then
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
    end

    if idcard ~= nil then
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
    end

    if inventory ~= nil then
        for key, value in pairs(inventory) do
            if inventory[key].count <= 0 then
                inventory[key] = nil
            else
                inventory[key].type = "item_standard"
                inventory[key].usable = false
                inventory[key].rare = false
                inventory[key].limit = -1
                inventory[key].canRemove = false
                table.insert(items, inventory[key])
            end
        end
    end

    if Config.IncludeWeapons and weapons ~= nil then
        for key, value in pairs(weapons) do
            local weaponHash = GetHashKey(weapons[key].name)
            if weapons[key].name ~= "WEAPON_UNARMED" then
                table.insert(
                    items,
                    {
                        label = weapons[key].label,
                        count = weapons[key].ammo,
                        limit = -1,
                        type = "item_weapon",
                        name = weapons[key].name,
                        usable = false,
                        rare = false,
                        canRemove = false
                    }
                )
            end
        end
    end

    for k, v in pairs(vetement) do  
        if v.type == "tenue" and not v.onPickup then
            table.insert(chestproptenue, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id})
        end
        if v.type == "kevlar" and not v.onPickup then
            table.insert(chestpropkevlar, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bproof_1", data2 = "bproof_2", vie = v.vie})
        end
        if v.type == "tshirt" and not v.onPickup then
            table.insert(chestproptshirt, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "tshirt_1", data2 = "tshirt_2"})
        end
        if v.type == "gant" and not v.onPickup then
            table.insert(chestpropgant, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "arms", data2 = "arms_2"})
        end
        if v.type == "chaussures" and not v.onPickup then
            table.insert(chestpropchaussures, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "shoes_1", data2 = "shoes_2"})
        end 
        if v.type == "masque" and not v.onPickup then
            table.insert(chestpropmasque, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "mask_1", data2 = "mask_2"})
        end
        if v.type == "pantalon" and not v.onPickup then
            table.insert(chestproppantalon, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "pants_1", data2 = "pants_2"})
        end 
        if v.type == "montre" and not v.onPickup then
            table.insert(chestpropmontre, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "watches_1", data2 = "watches_2"})
        end 
        if v.type == "bracelet" and not v.onPickup then
            table.insert(chestpropbracelet, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bracelets_1", data2 = "bracelets_2"})
        end
        if v.type == "oreille" and not v.onPickup then
            table.insert(chestproporeille, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "ears_1", data2 = "ears_2"})
        end
        if v.type == "lunettes" and not v.onPickup then
            table.insert(chestproplunettes, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "glasses_1", data2 = "glasses_2"})
        end 
        if v.type == "chapeau" and not v.onPickup then
            table.insert(chestpropchapeau, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "helmet_1", data2 = "helmet_2"})
        end 
        if v.type == "sac" and not v.onPickup then 
            table.insert(chestpropsac, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "bags_1", data2 = "bags_1"})
        end 
        if v.type == "chaine" and not v.onPickup then 
            table.insert(chestpropchaine, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "chain_1", data2 = "chain_2"})
        end 
        if v.type == "calque" and not v.onPickup then 
            table.insert(chestpropcalque, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id, data = "decals_1", data2 = "decals_2"})
        end 
        if v.type == "haut" and not v.onPickup then 
            table.insert(chestprophaut, {name = v.nom or "Pas de nom", skins = json.decode(v.clothe), id = v.id})
        end 
    end

    if chestproptenue ~= nil then
        for k, v in pairs(chestproptenue) do
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
    end

    if chestpropchaussures ~= nil then
        for k, v in pairs(chestpropchaussures) do
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
    end

    if chestpropmasque ~= nil then
        for k, v in pairs(chestpropmasque) do
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
    end

    if chestproppantalon ~= nil then
        for k, v in pairs(chestproppantalon) do
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
    end

    if chestpropkevlar ~= nil then
        for k, v in pairs(chestpropkevlar) do
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
    end

    if chestprophaut ~= nil then
        for k, v in pairs(chestprophaut) do
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
    end

    if chestproptshirt ~= nil then
        for k, v in pairs(chestproptshirt) do
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
    end

    if chestpropgant ~= nil then
        for k, v in pairs(chestpropgant) do
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
    end

    if chestproplunettes ~= nil then
        for k, v in pairs(chestproplunettes) do
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
    end

    if chestpropchapeau ~= nil then
        for k, v in pairs(chestpropchapeau) do
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
    end
    
    if chestpropsac ~= nil then
        for k, v in pairs(chestpropsac) do
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
    end

    if chestpropmontre ~= nil then
        for k, v in pairs(chestpropmontre) do
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
    end

    if chestproporeille ~= nil then
        for k, v in pairs(chestproporeille) do
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
    end

    if chestpropbracelet ~= nil then
        for k, v in pairs(chestpropbracelet) do
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
    end

    if chestpropchaine ~= nil then
        for k, v in pairs(chestpropchaine) do
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
    end

    if chestpropcalque ~= nil then
        for k, v in pairs(chestpropcalque) do
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
    end

    SendNUIMessage(
        {
            action = "setSecondInventoryItems",
            itemList = items
        }
    )
end

function openPropertyInventory()
    loadPlayerInventory(currentMenu)
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "property"
        }
    )

    SetNuiFocus(true, true)
    SetKeepInputMode(true)
end

RegisterNUICallback("PutIntoProperty", function(data, cb)
    if IsPedRagdoll(PlayerPedId()) or exports["offline"]:GetPlayerDead() or exports["offline"]:GetPlayerKnockout() then
        ESX.ShowNotification("~r~Impossible de réaliser cette action.")
        return
    end

    if data.item.type == "item_idcard" then
        TriggerServerEvent("putItemIdCardPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if data.item.type == "item_card" then
        TriggerServerEvent("putItemCardBankPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if data.item.type == "item_tenue" or data.item.type == "item_tshirt" or data.item.type == "item_gant" or data.item.type == "item_haut" or data.item.type == "item_chaussures" or data.item.type == "item_lunettes" or data.item.type == "item_calque" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" or data.item.type == "item_montre" or data.item.type == "item_bracelet" or data.item.type == "item_oreille" or data.item.type == "item_kevlar" then
        TriggerServerEvent("putItemVetementPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if data.item.type ~= "item_card" or data.item.type ~= "item_idcard" or data.item.type ~= "item_tenue" or data.item.type ~= "item_tshirt" or data.item.type ~= "item_gant" or data.item.type ~= "item_haut" or data.item.type ~= "item_chaussures" or data.item.type ~= "item_lunettes" or data.item.type ~= "item_calque" or data.item.type ~= "item_chaine" or data.item.type ~= "item_masque" or data.item.type ~= "item_pantalon" or data.item.type ~= "item_chapeau" or data.item.type ~= "item_sac" or data.item.type ~= "item_montre" or data.item.type ~= "item_bracelet" or data.item.type ~= "item_oreille" or data.item.type ~= "item_kevlar" then
        if type(data.number) == "number" and math.floor(data.number) == data.number then
            local count = tonumber(data.number)

            if data.item.type == "item_weapon" then
                count = GetAmmoInPedWeapon(PlayerPedId(), GetHashKey(data.item.name))
            end

            TriggerServerEvent("property:putItem", propertyData.plate, data.item.type, data.item.name, count, propertyData.max, propertyData.myVeh, data.item.label)
        end
    end

    Wait(250)
    loadPlayerInventory(currentMenu)

    cb("ok")
end)

RegisterNUICallback("TakeFromProperty", function(data, cb)
    if IsPedRagdoll(PlayerPedId()) or exports["offline"]:GetPlayerDead() or exports["offline"]:GetPlayerKnockout() then
        ESX.ShowNotification("~r~Impossible de réaliser cette action.")
        return
    end
    
    if data.item.type == "item_idcard" then
        TriggerServerEvent("receiveIdCardPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if data.item.type == "item_card" then
        TriggerServerEvent("receiveCardBankPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("property:getItem", propertyData.plate, data.item.type, data.item.name, tonumber(data.number), propertyData.max, propertyData.myVeh)
    end

    if data.item.type == "item_tenue" or data.item.type == "item_tshirt" or data.item.type == "item_gant" or data.item.type == "item_haut" or data.item.type == "item_chaussures" or data.item.type == "item_lunettes" or data.item.type == "item_calque" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" or data.item.type == "item_montre" or data.item.type == "item_bracelet" or data.item.type == "item_oreille" or data.item.type == "item_kevlar" then
        TriggerServerEvent("receiveVetementPropChest", data.item.id, propertyData.plate, propertyData.max)
    end

    if data.item.type == "item_tenue" or data.item.type == "item_tshirt" or data.item.type == "item_gant" or data.item.type == "item_haut" or data.item.type == "item_chaussures" or data.item.type == "item_lunettes" or data.item.type == "item_calque" or data.item.type == "item_chaine" or data.item.type == "item_masque" or data.item.type == "item_pantalon" or data.item.type == "item_chapeau" or data.item.type == "item_sac" or data.item.type == "item_montre" or data.item.type == "item_bracelet" or data.item.type == "item_oreille" or data.item.type == "item_kevlar" then

    else
        Wait(250)
        loadPlayerInventory(currentMenu)
    end
    cb("ok")
end)