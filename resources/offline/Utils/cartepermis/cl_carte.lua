local Sadam = {}

Sadam.openedMenu = false 
Sadam.mainMenu = RageUI.CreateMenu("Sadam", "Sadam")
Sadam.mainMenu.Closed = function()
    Sadam.openedMenu = false 
end

function openSadam()
    if Sadam.openedMenu then
        Sadam.openedMenu = false
        RageUI.Visible(Sadam.mainMenu, false)
    else
        Sadam.openedMenu = true
        RageUI.Visible(Sadam.mainMenu, true)
            CreateThread(function()
                while Sadam.openedMenu do
                    RageUI.IsVisible(Sadam.mainMenu, function()
                        RageUI.Button("Acheter sa carte d'identité", nil, {RightLabel = "~g~50$"}, true, {
                            onSelected = function()
                                TriggerServerEvent("AddIdCard", 50)
                            end
                        })
                        RageUI.Button("Acheter la carte du permis", nil, {RightLabel = "~g~50$"}, true, {
                            onSelected = function()
                                TriggerServerEvent("AddPermisCard", 50)
                            end
                        })
                    end)
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while true do
        local wait = 1000
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = GetDistanceBetweenCoords(plyCoords.x, plyCoords.y, plyCoords.z, -1099.25, -841.15, 19.00, true)

        if dist <= 1.0 then
            if not IsPedInAnyVehicle(PlayerPedId(), false) then
                wait = 5
                DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Sadam~s~")
                if IsControlJustPressed(0, 51) then
                    openSadam()
                end
            end
        end
        Wait(wait)
    end
end)

RegisterNetEvent("ShowIdCardOfPlayer")
AddEventHandler("ShowIdCardOfPlayer", function(name, age, lieu)
    IsOpenPermis = false
    IsOpenIdCard = not IsOpenIdCard

    while IsOpenIdCard do
        Wait(0)
        RenderSprite("carte", "carteid", 1390, 740, 500, 300, 300)
        showText({size = 0.40, font = 4,
            msg = "Prénom / Nom : "..name,
            posx = 0.815, posy = 0.760
        })
        showText({size = 0.40, font = 4,
            msg = "Date de naissance : "..age,
            posx = 0.815, posy = 0.788
        })
        showText({size = 0.40, font = 4,
        msg = "Lieu de naissance : "..lieu,
        posx = 0.815, posy = 0.815
    })
        if IsControlJustPressed(0, 177) then
            IsOpenIdCard = false
        end
    end
end)

RegisterNetEvent("showPermisOfPlayer")
AddEventHandler("showPermisOfPlayer", function(car, pcar , moto, pmoto, camion, pcamion, boat, airplane)
    IsOpenIdCard = false
    IsOpenPermis = not IsOpenPermis

    while IsOpenPermis do
        Wait(0)
        RequestStreamedTextureDict("shop_tick_icon", false)
        RequestStreamedTextureDict("shop_lock", false)
        RenderSprite("carte", "permis", 1390, 740, 500, 300, 300)
        if ConvertToBool(car) then
            DrawSprite("commonmenu", "shop_tick_icon", 0.8528, 0.77+0.005, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pcar = pcar
        else
            DrawSprite("commonmenu", "shop_lock", 0.8528, 0.77+0.005, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pcar = nil
        end
        showText({size = 0.40, font = 4,
            msg = "Voiture : ",
            posx = 0.815, posy = 0.760
        })
        if ConvertToBool(moto) then
            DrawSprite("commonmenu", "shop_tick_icon", 0.8528, 0.80+0.003, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pmoto = pmoto
        else
            DrawSprite("commonmenu", "shop_lock", 0.8528, 0.80+0.003, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pmoto = nil
        end
        showText({size = 0.40, font = 4,
            msg = "Moto : ",
            posx = 0.815, posy = 0.788
        })
        if ConvertToBool(camion) then
            DrawSprite("commonmenu", "shop_tick_icon", 0.8528, 0.82+0.010, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pcamion = pcamion
        else
            DrawSprite("commonmenu", "shop_lock", 0.8528, 0.82+0.010, 0.02, 0.034, 0.0, 255, 255, 255, 255)
            pcamion = nil
        end
        showText({size = 0.40, font = 4,
            msg = "Camion : ",
            posx = 0.815, posy = 0.815
        })
        if ConvertToBool(boat) then
            DrawSprite("commonmenu", "shop_tick_icon", 0.8528, 0.85+0.006, 0.02, 0.034, 0.0, 255, 255, 255, 255)
        else
            DrawSprite("commonmenu", "shop_lock", 0.8528, 0.85+0.006, 0.02, 0.034, 0.0, 255, 255, 255, 255)
        end
        showText({size = 0.40, font = 4,
            msg = "Bateau : ",
            posx = 0.815, posy = 0.842
        })
        if ConvertToBool(airplane) then
            DrawSprite("commonmenu", "shop_tick_icon", 0.8925, 0.88+0.005, 0.02, 0.034, 0.0, 255, 255, 255, 255)
        else
            DrawSprite("commonmenu", "shop_lock", 0.8925, 0.88+0.005, 0.02, 0.034, 0.0, 255, 255, 255, 255)
        end
        showText({size = 0.40, font = 4,
            msg = "Avion / Hélicoptère : ",
            posx = 0.815, posy = 0.869
        })
        if pcar ~= nil then
            showText({size = 0.40, font = 4,
                msg = "point : "..pcar,
                posx = 0.860, posy = 0.760
            })
        end
        if pmoto ~= nil then
            showText({size = 0.40, font = 4,
                msg = "point : "..pmoto,
                posx = 0.860, posy = 0.788
            })
        end
        if pcamion ~= nil then
            showText({size = 0.40, font = 4,
                msg = "point : "..pcamion,
                posx = 0.860, posy = 0.815
            })
        end
        if IsControlJustPressed(0, 177) then
            IsOpenPermis = false
        end
    end
end)