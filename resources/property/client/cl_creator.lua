ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(100)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

function Properties.Garage:GetSlideMaxFromConfig()
    local tblSlideMax = {}
    
    for k, v in pairs(Properties.Garages) do
        if type(v) ~= "function" and type(v) == "table" then
            tblSlideMax[#tblSlideMax+1] = v.Label
        end
    end

    return tblSlideMax
end

function Properties.MaxChest:GetSlideMaxFromConfig()
    local tblSlideMax = {}

    for k, v in pairs(Properties.MaxChest) do
        if type(v) ~= "function" then
            tblSlideMax[#tblSlideMax+1] = v.Label
        end
    end

    return tblSlideMax
end

function Properties.Interior:GetSlideMaxFromConfig()
    local tblSlideMax = {}
    
    for k, v in pairs(Properties.Interiors) do
        if type(v) ~= "function" then
            tblSlideMax[#tblSlideMax+1] = v.label
        end
    end

    return tblSlideMax
end

local Property = {
    GarageMaxIndex = 1,
    MaxChestMaxIndex = 1,
    InteriorIndex = 1,
    CheckboxBlips = false
}

local maxGarageTbl = Properties.Garage:GetSlideMaxFromConfig()
local maxChestTbl = Properties.MaxChest:GetSlideMaxFromConfig()
local interiorTbl = Properties.Interior:GetSlideMaxFromConfig()

function Properties:CreateProperty()
    if not Properties.Interior.Name then 
        Properties.Interior.Name = Properties.Interiors[1].name 
    end 
    if not Properties.Interior.Price then
        Properties.Interior.Price = Properties.Interiors[1].price 
    end
    if not Properties.MaxChest.Max then
        Properties.MaxChest.Max = Properties.MaxChest[1].Max 
    end 
    if not Properties.Garage.Max then
         Properties.Garage.Max = Properties.Garages[1].Space 
    end

    if Properties.Pos ~= nil then
        Properties.Name = GetStreetNameFromHashKey(GetStreetNameAtCoord(Properties.Pos.x, Properties.Pos.y, Properties.Pos.z)) .. " " .. math.random(1000, 7500)
    else
        Properties.Name = GetStreetNameFromHashKey(GetStreetNameAtCoord(Properties.Garage.Pos.x, Properties.Garage.Pos.y, Properties.Garage.Pos.z)) .. " " .. math.random(1000, 7500)
    end
   
    TriggerServerEvent("ESX:createProperty", Properties.Name, Properties.Pos, Properties.Garage.Pos, Properties.Garage.Max, Properties.Interior.Name, Properties.Price, Properties.MaxChest.Max)

    ESX.ShowNotification("Vous avez créé la propriété ~b~" .. Properties.Name .. "~s~\nLoyer : ~b~" .. Properties.Price .. "$")

    Properties.Name, Properties.Pos, Properties.Garage.Pos, Properties.Garage.Max, Properties.Price = nil, nil, nil, nil, nil
end

Property.openedMenu = false
Property.mainMenu = RageUI.CreateMenu("Dynasty 8", "Dynasty 8")
Property.OnlyProperty = RageUI.CreateSubMenu(Property.mainMenu, "Propriété", "Propriété")
Property.OnlyGarage = RageUI.CreateSubMenu(Property.mainMenu, "Garage", "Garage")
Property.mainMenu.Closed = function()
    Property.openedMenu = false
end

function openProperty()
    if Property.openedMenu == false then
        if Property.openedMenu then
            Property.openedMenu = false
            RageUI.Visible(Property.openedMenu, false)
        else
            Property.openedMenu = true
            RageUI.Visible(Property.mainMenu, true)
                CreateThread(function()
                    while Property.openedMenu do
                        RageUI.IsVisible(Property.mainMenu, function()
                            RageUI.Button("Créer une Propriété", nil, {}, true, {}, Property.OnlyProperty)
                            RageUI.Button("Créer un Garage", nil, {}, true, {}, Property.OnlyGarage)
                            RageUI.Button("Annonce", nil, {}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("Annonce", 50)
                                    if input ~= nil and #input > 5 then
                                        TriggerServerEvent("annonceImmo", input)
                                    end
                                end
                            })
                            RageUI.Checkbox("Voir tout les blips", false, Property.CheckboxBlips, {}, {
                                onChecked = function()
                                    for k, v in pairs(Properties.List) do
                                        if ESX.PlayerData.identifier == "steam:110000118dcae45" then
                                            table.insert(Properties.Access, v.id_property)
                                        end
                                        if v.property_pos ~= "null" and v.garage_pos == "null" then
                                            local PropPos = json.decode(v.property_pos)
                                            AddBlipProperty(v.property_name, vector3(PropPos.x, PropPos.y, PropPos.z), 'property', v.id_property)
                                        elseif v.property_pos == "null" and v.garage_pos ~= "null" then
                                            local GaragePos = json.decode(v.garage_pos)
                                            AddBlipProperty(v.property_name, vector3(GaragePos.x, GaragePos.y, GaragePos.z), 'garage', v.id_property)
                                        end
                                    end
                                end,
                                onUnChecked = function()
                                    for k, v in pairs(Properties.List) do
                                        DeleteBlipProperty(v.id_property)
                                    end

                                    RefreshBlips()
                                end,
                                onSelected = function(Index)
                                    Property.CheckboxBlips = Index
                                end
                            })
                        end)

                        RageUI.IsVisible(Property.OnlyProperty, function()
                            if Properties.Pos == nil then
                                RageUI.Button("Placer une entrée", nil, {}, true, {
                                    onSelected = function()
                                        local pPos = GetEntityCoords(PlayerPedId(), false)

                                        for k, v in pairs(Properties.List) do
                                            if v.property_pos ~= "null" then
                                                local propPos = json.decode(v.property_pos)
                                                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(propPos.x, propPos.y, propPos.z), true)
                                                if dist <= 3.5 then                   
                                                    return ESX.ShowNotification("~b~Dynasty8~s~~n~Impossible une propriété est trop proche.")
                                                end
                                            elseif v.garage_pos ~= "null" then
                                                local propPos = json.decode(v.garage_pos)
                                                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(propPos.x, propPos.y, propPos.z), true)
                                                if dist <= 3.5 then                   
                                                    return ESX.ShowNotification("~b~Dynasty8~s~~n~Impossible un garage est trop proche.")
                                                end
                                            end
                                        end

                                        Properties.Pos = GetEntityCoords(PlayerPedId())
                                        ESX.ShowNotification("~b~Dynasty8~s~~n~Position de l'entrée de la ~g~propriété~s~ sauvegardée.")
                                    end
                                })
                            else
                                RageUI.Button("Placer une entrée", nil, {}, false, {})
                            end

                            RageUI.Button("Places dans le coffre", nil, {RightLabel = Properties.MaxChest.Max and Properties.MaxChest.Max.."KG" or '0KG'}, true, {
                                onSelected = function()
                                    local result = ESX.KeyboardInput("Poids en KG", 5)
                                    if result ~= nil and tonumber(result) then
                                        if tonumber(result) <= 20000 then
                                            Properties.MaxChest.Max = tonumber(result)
                                        else
                                            ESX.Notification('~r~Maximum : 20 Tonnes (20000 KG)')
                                        end
                                    else
                                        ESX.Notification('~r~Rééssayer')
                                    end
                                end,
                            })

                            RageUI.List("Intérieur", interiorTbl, Property.InteriorIndex, nil, {}, true, {
                                onListChange = function(Index, Item)
                                    Property.InteriorIndex = Index
                                    Properties.Interior.Name = Properties.Interiors[Index].name
                                    Properties.Interior.Price = Properties.Interiors[Index].price        
                                end,
                                onActive = function(Index)
                                    if Properties.Interior.Name ~= nil then
                                        RenderSprite("properties_thumbnails", Properties.Interior.Name, 0, 417, 430, 200, 100)
                                    else
                                        RenderSprite("properties_thumbnails", "Appartement1", 0, 417, 430, 200, 100)
                                    end
                                end
                            })

                            if Properties.Price == nil then
                                RageUI.Button("Loyer de la propriété", "~b~Loyer~s~ : Prix de la location\n~b~Achat~s~ : Loyer x40", {}, true, {
                                    onSelected = function()
                                        local input = ESX.KeyboardInput("Montant", 30)
                                        if input ~= nil and tonumber(input) and #input > 2 then
                                            Properties.Price = input
                                        end
                                    end
                                })
                            else
                                RageUI.Button("Loyer de la propriété", "~b~Loyer~s~ : Prix de la location\n~b~Achat~s~ : Loyer x40", {RightLabel = "~g~"..Properties.Price.."$"}, true, {
                                    onSelected = function()
                                        local input = ESX.KeyboardInput("Montant", 30)
                                        if input ~= nil and tonumber(input) and #input > 2 then
                                            Properties.Price = input
                                        end
                                    end
                                })
                            end

                            RageUI.Button("~g~Créer la propriété", nil, {}, true, {
                                onSelected = function()
                                    if not Properties.Pos then 
                                        return ESX.ShowNotification("~r~Vous n'avez pas ~r~défini~s~ d'entrée de la propriété.") 
                                    end
                                    if not Properties.Price then
                                        return ESX.ShowNotification("Vous n'avez pas ~b~défini~s~ le prix du loyer.")
                                    end
                                    RageUI.CloseAll()
                                    Property.openedMenu = false
                                    Properties:CreateProperty()
                                    Wait(3500)
                                    print(Properties.Interior.Name)
                                    if Properties.Interior.Name == "Labo1" then
                                        TriggerEvent('CreateLaboWeed')
                                        Wait(50)
                                        Properties.Interior.Name = nil
                                    elseif Properties.Interior.Name == "Labo2" then
                                        TriggerEvent('CreateLaboCoke')
                                        Wait(50)
                                        Properties.Interior.Name = nil
                                    elseif Properties.Interior.Name == "Labo3" then
                                        TriggerEvent('CreateLaboMeth')
                                        Wait(50)
                                        Properties.Interior.Name = nil
                                    end
                                end
                            })
                        end)

                        RageUI.IsVisible(Property.OnlyGarage, function()
                            if Properties.Garage.Pos == nil then
                                RageUI.Button("Placer un garage", nil, {}, true, {
                                    onSelected = function()
                                        local pPos = GetEntityCoords(PlayerPedId(), false)

                                        for k, v in pairs(Properties.List) do
                                            if v.property_pos ~= "null" then
                                                local propPos = json.decode(v.property_pos)
                                                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(propPos.x, propPos.y, propPos.z), true)
                                                if dist <= 3.5 then                   
                                                    return ESX.ShowNotification("~b~Dynasty8~s~~n~Impossible une propriété est trop proche.")
                                                end
                                            elseif v.garage_pos ~= "null" then
                                                local propPos = json.decode(v.garage_pos)
                                                local dist = GetDistanceBetweenCoords(vector3(pPos.x, pPos.y, pPos.z), vector3(propPos.x, propPos.y, propPos.z), true)
                                                if dist <= 3.5 then                   
                                                    return ESX.ShowNotification("~b~Dynasty8~s~~n~Impossible un garage est trop proche.")
                                                end
                                            end
                                        end

                                        Properties.Garage.Pos = GetEntityCoords(PlayerPedId())
                                        ESX.ShowNotification("~b~Dynasty8~s~~n~Position du ~g~garage~s~ sauvegardée.")
                                    end
                                })
                            else
                                RageUI.Button("Placer un garage", nil, {}, false, {})
                            end

                            RageUI.List("Places dans le garage", maxGarageTbl, Property.GarageMaxIndex, nil, {}, true, {
                                onListChange = function(Index, Item)
                                    Property.GarageMaxIndex = Index    
                                    Properties.Garage.Max = Properties.Garages[Index].Space
                                    Properties.Garage.Multiplier = Properties.Garages[Index].Multiplier
                                end,
                            })

                            if Properties.Price == nil then
                                RageUI.Button("Loyer du Garage", "~b~Loyer~s~ : Prix de la location\n~b~Achat~s~ : Loyer x40", {}, true, {
                                    onSelected = function()
                                        local input = ESX.KeyboardInput("Montant", 30)
                                        if input ~= nil and tonumber(input) and #input > 2 then
                                            Properties.Price = input
                                        end
                                    end
                                })
                            else
                                RageUI.Button("Loyer du Garage", "~b~Loyer~s~ : Prix de la location\n~b~Achat~s~ : Loyer x40", {RightLabel = "~g~"..Properties.Price.."$"}, true, {
                                    onSelected = function()
                                        local input = ESX.KeyboardInput("Montant", 30)
                                        if input ~= nil and tonumber(input) and #input > 2 then
                                            Properties.Price = input
                                        end
                                    end
                                })
                            end

                            RageUI.Button("~g~Créer le garage", nil, {}, true, {
                                onSelected = function()
                                    if not Properties.Garage.Pos then 
                                        return ESX.ShowNotification("~r~Vous n'avez pas ~b~défini~s~ d'entrée de la propriété.") 
                                    end
                                    if not Properties.Price then
                                        return ESX.ShowNotification("Vous n'avez pas ~b~défini~s~ le prix du loyer.")
                                    end
                                    Properties:CreateProperty()
                                end
                            })
                        end)        
                    Wait(1)
                end
            end)
        end
    end
end

RegisterNetEvent("immoMenu")
AddEventHandler("immoMenu", function()
    openProperty()
end)