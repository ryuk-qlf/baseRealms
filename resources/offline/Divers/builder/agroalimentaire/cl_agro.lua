local Agro = {
    Circuit = {
        {name = "Fer brut > Outil en fer", ask = "3 Trocs", type = "fer"},
        {name = "Papier à rouler > Tabac", ask = "2 Trocs", type = "tabac"},
        {name = "Blé > Farine", ask = "1 Trocs", type = "farine"},
        {name = "Bouteille > Eau", ask = "3 Trocs", type = "eau"},
        {name = "Fruit > Jus de fruit", ask = "2 Trocs", type = "jusfruit"},
        {name = "Verre > Bouteille", ask = "5 Trocs", type = "bouteille"}
    },

    CircuitSelected = nil,
    JobName = nil,
    vName = nil,
}

Agro.openedMenu = false 
Agro.mainMenu = RageUI.CreateMenu("Entreprise", "Création")
Agro.mainMenu.Closed = function()
    Agro.openedMenu = false
    Agro.CircuitSelected = nil
    Agro.JobName = nil
    Agro.vName = nil
end

function menuAgro()
    RageUI.CloseAll()
    if Agro.openedMenu then
        Agro.openedMenu = false
        RageUI.Visible(Agro.mainMenu, false)
    else
        Agro.openedMenu = true
        RageUI.Visible(Agro.mainMenu, true)
            CreateThread(function()
                while Agro.openedMenu do
                    RageUI.IsVisible(Agro.mainMenu, function()
                        for k, v in pairs(Agro.Circuit) do
                            if v.name == Agro.vName then
                                RageUI.Button(v.name.." | ~o~"..v.ask, nil, {}, true, {
                                    onSelected = function()
                                        Agro.vName = nil
                                    end
                                })
                            else
                                RageUI.Button(v.name.." | ~b~"..v.ask, nil, {}, true, {
                                    onSelected = function()
                                        if Agro.vName == nil then
                                            Agro.vName = v.name
                                            Agro.CircuitSelected = v.type
                                        end
                                    end
                                })
                            end
                        end
                        RageUI.Separator("----------------------------------")
                        if Agro.CircuitSelected ~= nil then
                            RageUI.Button("Nom de l'entreprise", nil, {}, true, {
                                onSelected = function()
                                    local index = ESX.KeyboardInput("Nom de l'entreprise", 30)
                                    if index ~= nil and #index > 3 then
                                        Agro.JobName = index
                                    end
                                end
                            })
                            if Agro.JobName ~= nil then
                                RageUI.Button("~g~Créer l'entreprise", nil, {}, true, {
                                    onSelected = function()
                                        TriggerServerEvent("CreateJobFarm", Agro.JobName, Agro.CircuitSelected)
                                        Agro.CircuitSelected = nil
                                        Agro.JobName = nil
                                        Agro.vName = nil
                                    end
                                })
                            else
                                RageUI.Button("~g~Créer l'entreprise", nil, {}, false, {})
                            end
                        else
                            RageUI.Button("~g~Créer l'entreprise", nil, {}, false, {})
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
        local wait = 1000
            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId(), false), 236.53, -408.88, 47.92, true) <= 2 then
                wait = 1
                DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~g~parler à Jeremy~s~.")
                if IsControlJustPressed(0, 51) then
                    menuAgro()
                end
            else
                if Agro.openedMenu then
                    RageUI.CloseAll()
                    Agro.openedMenu = false
                end
            end
        Wait(wait)
    end
end)