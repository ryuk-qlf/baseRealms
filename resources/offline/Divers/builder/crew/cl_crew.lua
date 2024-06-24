ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local Crew = {
    SlideRang = 1,
    SlideExclure = 1,

    GetMembres = {},
    GetAllRang = {},
    InfosCrew = {},
    GetInfoGrade = {},
}

Crew.openedMenu = false 
Crew.mainMenu = RageUI.CreateMenu("Crew", "Crew")
Crew.subMenuInfos = RageUI.CreateSubMenu(Crew.mainMenu, "Crew", "Crew")
Crew.subMenuListeMembres = RageUI.CreateSubMenu(Crew.mainMenu, "Crew", "Crew")
Crew.subMenuEditMembres = RageUI.CreateSubMenu(Crew.subMenuListeMembres, "Crew", "Crew")
Crew.subMenuEditRang = RageUI.CreateSubMenu(Crew.mainMenu, "Crew", "Crew")
Crew.subMenuActions = RageUI.CreateSubMenu(Crew.mainMenu, "Crew", "Crew")
Crew.subMenuListeRang = RageUI.CreateSubMenu(Crew.mainMenu, "Crew", "Crew")
Crew.subMenuEditPermsRang = RageUI.CreateSubMenu(Crew.subMenuListeRang, "Crew", "Crew")
Crew.mainMenu.Closed = function()
    Crew.openedMenu = false 
end

function openCrew()
    if Crew.openedMenu then 
        Crew.openedMenu = false 
        RageUI.Visible(Crew.mainMenu,false)
    else
        Crew.openedMenu = true
        RageUI.Visible(Crew.mainMenu, true)
        Citizen.CreateThread(function()
            while Crew.openedMenu do 
                    RageUI.IsVisible(Crew.mainMenu, function()
                        RageUI.Button("Information", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("InfosCrew", function(cb)
                                    Crew.InfosCrew = cb
                                end)
                                ESX.TriggerServerCallback("GetAllRang", function(cb)
                                    Crew.GetAllRang = cb
                                end)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Crew.subMenuInfos, true)
                            end
                        })
                        RageUI.Button("Actions", nil, {RightLabel = "→"}, true, {}, Crew.subMenuActions)
                        RageUI.Button("Liste des membres", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("ListeMembres", function(cb)
                                    Crew.GetMembres = cb
                                end)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Crew.subMenuListeMembres, true)
                            end
                        })
                        RageUI.Button("Liste des rangs", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetAllRang", function(cb)
                                    Crew.GetAllRang = cb
                                end)
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Crew.subMenuListeRang, true)
                            end
                        })
                    end)
                    RageUI.IsVisible(Crew.subMenuActions, function()
                        RageUI.Button("Recruter quelqu'un", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                                if target then
                                    TriggerServerEvent('RecrutThePlayer', GetPlayerServerId(target))
                                end
                            end
                        })
                        RageUI.Button("Exclure quelqu'un", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local target = GetNearbyPlayer(2)
                                if target then
                                    TriggerServerEvent('FireTarget', GetPlayerServerId(target))
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Crew.subMenuListeRang, function()
                        RageUI.Button("~g~Créer d'autre grade", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local result = ESX.KeyboardInput("Nom du Grade", 30)
                                if result ~= nil then
                                    TriggerServerEvent('AddNewRang', result)
                                    RageUI.GoBack()
                                end
                            end
                        })
                        for k, v in pairs(Crew.GetAllRang) do
                            RageUI.Button(v.name, nil, {RightLabel = v.rang}, true, {
                                onSelected = function(Index)
                                    GradeName = v.name
                                    GradeRang = v.rang
                                    GradeID = v.id_grade
                                    AccesGestion = v.gestion
                                    AccesChest = v.acces_chest
                                    AccesProperty = v.acces_property
                                    AccesSellVeh = v.sell_vehicle
                                    AccesKeyVeh = v.key_vehicle

                                    if AccesGestion == 1 then
                                        Crew.CheckboxGestion = true
                                    else
                                        Crew.CheckboxGestion = false
                                    end
                                    if AccesChest == 1 then
                                        Crew.CheckboxChest = true
                                    else
                                        Crew.CheckboxChest = false
                                    end
                                    if AccesProperty == 1 then
                                        Crew.CheckboxProperty = true
                                    else
                                        Crew.CheckboxProperty = false
                                    end
                                    if AccesSellVeh == 1 then
                                        Crew.CheckboxSellVeh = true
                                    else
                                        Crew.CheckboxSellVeh = false
                                    end
                                    if AccesKeyVeh == 1 then
                                        Crew.CheckboxKeyVeh = true
                                    else
                                        Crew.CheckboxKeyVeh = false
                                    end
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Crew.subMenuEditPermsRang, true)
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Crew.subMenuEditPermsRang, function()
                        if GradeRang == 1 then
                            RageUI.Button("Accès à la gestion Crew", nil, {}, false, {})
                            RageUI.Button("Accès au propriété", nil, {}, false, {})
                            RageUI.Button("Accès au coffre des propriété", nil, {}, false, {})
                            RageUI.Button("Accès au clés des véhicules", nil, {}, false, {})
                            RageUI.Button("Accès à la vente des véhicules", nil, {}, false, {})
                        else
                            RageUI.Checkbox("Accès à la gestion Crew", false, Crew.CheckboxGestion, {}, {
                                onChecked = function()
                                    TriggerServerEvent("UpdateAccesGestionCrew", 1, GradeID)
                                    ESX.Notification("Vous avez donner l'accès à la gestion du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onUnChecked = function()
                                    TriggerServerEvent("UpdateAccesGestionCrew", 0, GradeID)
                                    ESX.Notification("Vous avez retiré l'accès à la gestion du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onSelected = function(Index)
                                    Crew.CheckboxGestion = Index
                                end
                            })
                            RageUI.Checkbox("Accès au propriété", false, Crew.CheckboxProperty, {}, {
                                onChecked = function()
                                    TriggerServerEvent("UpdateAccesPropertyCrew", 1, GradeID)
                                    ESX.Notification("Vous avez donner l'accès au propriété du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onUnChecked = function()
                                    TriggerServerEvent("UpdateAccesPropertyCrew", 0, GradeID)
                                    ESX.Notification("Vous avez retiré l'accès au propriété du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onSelected = function(Index)
                                    Crew.CheckboxProperty = Index
                                end
                            })
                            RageUI.Checkbox("Accès au coffre des propriété", false, Crew.CheckboxChest, {}, {
                                onChecked = function()
                                    TriggerServerEvent("UpdateAccesChestPropertyCrew", 1, GradeID)
                                    ESX.Notification("Vous avez donner l'accès au coffre des propriété du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onUnChecked = function()
                                    TriggerServerEvent("UpdateAccesChestPropertyCrew", 0, GradeID)
                                    ESX.Notification("Vous avez retiré l'accès au coffre des propriété du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onSelected = function(Index)
                                    Crew.CheckboxChest = Index
                                end
                            })
                            RageUI.Checkbox("Accès au clés des véhicules", false, Crew.CheckboxKeyVeh, {}, {
                                onChecked = function()
                                    TriggerServerEvent("UpdateAccesKeyVehicleCrew", 1, GradeID)
                                    ESX.Notification("Vous avez donner l'accès au clés des véhicules du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onUnChecked = function()
                                    TriggerServerEvent("UpdateAccesKeyVehicleCrew", 0, GradeID)
                                    ESX.Notification("Vous avez retiré l'accès au clés des véhicules du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onSelected = function(Index)
                                    Crew.CheckboxKeyVeh = Index
                                end
                            })
                            RageUI.Checkbox("Accès à la vente des véhicules", false, Crew.CheckboxSellVeh, {}, {
                                onChecked = function()
                                    TriggerServerEvent("UpdateAccesSellVehicleCrew", 1, GradeID)
                                    ESX.Notification("Vous avez donner l'accès de vendre les véhicule du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onUnChecked = function()
                                    TriggerServerEvent("UpdateAccesSellVehicleCrew", 0, GradeID)
                                    ESX.Notification("Vous avez retiré l'accès de vendre les véhicule du crew au grade ~b~"..GradeName.."~s~.")
                                end,
                                onSelected = function(Index)
                                    Crew.CheckboxSellVeh = Index
                                end
                            })
                            RageUI.Button("~r~Supprimer le grade", nil, {RightLabel = GradeName}, true, {
                                onSelected = function()
                                    TriggerServerEvent("DeleteGrade", GradeID)
                                    ESX.Notification("Vous avez supprimé le grade ~b~"..GradeName.."~s~ et kick tout les membres qui avaient le grade.")
                                    RageUI.GoBack()
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Crew.subMenuInfos, function()
                        for k, v in pairs(Crew.InfosCrew) do
                            RageUI.Button("Nom", nil, {RightLabel = v.name}, true, {})
                            RageUI.Button("Devise", nil, {RightLabel = v.devise}, true, {})
                            RageUI.Button("ID du Crew", nil, {RightLabel = v.id_crew}, true, {})
                        end
                    end)
                    RageUI.IsVisible(Crew.subMenuListeMembres, function()
                        for k,v in pairs(Crew.GetMembres) do
                            RageUI.Button(v.label, nil, {RightLabel = v.label_grade}, true, {
                                onSelected = function()
                                    Identifier = v.identifier
                                    Label = v.label
                                    IdCrew = v.id_crew
                                    LabelGrade = v.label_grade
                                    RangGrade = v.rang_grade
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Crew.subMenuEditMembres, true)
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Crew.subMenuEditMembres, function()
                        RageUI.Button("Nom", nil, {RightLabel = Label}, true, {})
                        if RangGrade ~= 1 then
                            RageUI.Button("Rang", nil, {}, true, {
                                onSelected = function(Index)
                                    ESX.TriggerServerCallback("GetAllRang", function(cb)
                                        Crew.GetAllRang = cb
                                    end)
                                    Wait(150)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Crew.subMenuEditRang, true)
                                end
                            })
                            RageUI.List('Exclure', {"non", "oui"}, Crew.SlideExclure, nil, {}, true, {
                                onListChange = function(Index)
                                    Crew.SlideExclure = Index
                                end,

                                onSelected = function(Index)
                                    if Index == 2 then
                                        print(Identifier)
                                        TriggerServerEvent('FireThePlayer', Identifier)
                                        ESX.ShowNotification('Vous avez expulsé ~b~'..Label.."~s~ de votre crew.")
                                        RageUI.CloseAll()
                                        Crew.openedMenu = false
                                    end
                                end
                            })
                        else
                            RageUI.Button("Rang", nil, {}, false, {})
                            RageUI.Button("Exclure", nil, {}, false, {})
                        end
                    end)
                    RageUI.IsVisible(Crew.subMenuEditRang, function()
                        for k, v in pairs(Crew.GetAllRang) do
                            if v.rang == 1 then
                                RageUI.Button(v.name, nil, {RightLabel = v.rang}, false, {})
                            else
                                RageUI.Button(v.name, nil, {RightLabel = v.rang}, true, {
                                    onSelected = function(Index)
                                        TriggerServerEvent('EditRang', Identifier, v.id_grade, v.name, v.rang)
                                        ESX.ShowNotification('Vous avez mis le rang ~b~'..v.name.."~s~ à ~b~"..Label.."~s~.")
                                        RageUI.CloseAll()
                                        Crew.openedMenu = false
                                    end
                                })
                            end
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

RegisterCommand("crew", function()
    ESX.TriggerServerCallback("GetPermGestion", function(cb)
        if cb == true then
            openCrew()
        else
            print('pas les perm')
        end
    end)
end)

local CreaCrew = {
    GetMembres = {},
    GetPerms = {},
    GetPerms2 = {},
    TableGrade = {},

    RangDefault = 1,
}

CreaCrew.openedMenu = false 
CreaCrew.mainMenu = RageUI.CreateMenu("Crew", "Crew")
CreaCrew.CreateGradesCrew = RageUI.CreateSubMenu(CreaCrew.mainMenu, "Grade", "Grade")
CreaCrew.mainMenu.Closed = function()
    CreaCrew.openedMenu = false 
end

function openCreaCrew()
    if CreaCrew.openedMenu then 
        CreaCrew.openedMenu = false 
        RageUI.Visible(CreaCrew.mainMenu,false)
        return
    else
        CreaCrew.openedMenu = true
        RageUI.Visible(CreaCrew.mainMenu, true)
        Citizen.CreateThread(function()
            while CreaCrew.openedMenu do 
                RageUI.IsVisible(CreaCrew.mainMenu, function()
                    RageUI.Button("Nom du Crew", nil, {RightLabel = CreaCrew.Name}, true, {
                        onSelected = function()
                            local result = ESX.KeyboardInput("Nom du Crew", 30)
                            if result ~= nil then
                                CreaCrew.Name = result
                            end
                        end
                    })
                    RageUI.Button("Devise du Crew", nil, {RightLabel = CreaCrew.DeviseCrew}, true, {
                        onSelected = function()
                            local result = ESX.KeyboardInput("Devise du Crew", 30)
                            if result ~= nil then
                                CreaCrew.DeviseCrew = result
                            end
                        end
                    })
                    RageUI.Button("Grades", nil, {RightLabel = "→"}, true, {}, CreaCrew.CreateGradesCrew)
                    RageUI.Button("~g~Créer le crew", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            if CreaCrew.Name ~= nil and CreaCrew.DeviseCrew ~= nil and CreaCrew.TableGrade ~= nil then
                                TriggerServerEvent("CreateCrew", CreaCrew.Name, CreaCrew.DeviseCrew, CreaCrew.NomGradeChef or "Chef", CreaCrew.TableGrade)
                                RageUI.CloseAll()
                                Crew.openedMenu = false 
                            else
                                ESX.ShowNotification("Vous devez remplir tout les champs.")
                            end
                        end
                    })
                end)
                RageUI.IsVisible(CreaCrew.CreateGradesCrew, function()
                    RageUI.Button("~g~Créer d'autre grade", nil, {RightLabel = "→"}, true, {
                        onSelected = function()
                            local result = ESX.KeyboardInput("Nom du Grade", 30)
                            if result ~= nil then
                                CreaCrew.RangDefault = CreaCrew.RangDefault + 1
                                table.insert(CreaCrew.TableGrade, {
                                    name = result, rang = CreaCrew.RangDefault,
                                })
                            end
                        end
                    })
                    RageUI.Button(CreaCrew.NomGradeChef or "Chef", nil, {RightLabel = "1"}, true, {
                        onSelected = function()
                            local result = ESX.KeyboardInput("Nom du Grade Chef", 30)
                            if result ~= nil then
                                CreaCrew.NomGradeChef = result
                            end
                        end
                    })
                    for k,v in pairs(CreaCrew.TableGrade) do
                        RageUI.Button(v.name, nil, {RightLabel = v.rang}, true, {})
                    end
                end)
                Wait(1)
            end
        end)
    end
end

RegisterNetEvent("SolutionJoinCrew")
AddEventHandler("SolutionJoinCrew", function(CrewName)
    local timer = 1100
    
    ESX.ShowNotification("Voulez vous rejoindre le crew ~b~"..CrewName)
    ESX.ShowNotification("~g~Y~s~ : Accepter\n~r~X~s~ : Refuser")
    
    while true do
        Wait(1)
        timer = timer - 1

        if timer <= 0 then
            ESX.ShowNotification("~r~Vous avez mis trop de temps à choisir.")
            TriggerServerEvent("AlertJoinCrew", 1)
            break
        end

        if IsControlJustPressed(1, 73) then
            ESX.ShowNotification("~r~Vous avez refusé de rejoindre le crew.")
            TriggerServerEvent("AlertJoinCrew", 2)
            break
        end

        if IsControlJustPressed(1, 246) then
            ESX.ShowNotification("Vous avez été recruté dans le crew ~b~"..CrewName.."~s~.")
            TriggerServerEvent("JoinCrew")
            TriggerServerEvent("AlertJoinCrew", 3)
            break
        end
    end
end)

RegisterCommand("createcrew", function()
    ESX.TriggerServerCallback("GetCrewPly", function(cb)
        if cb == true then
            openCreaCrew()
        else
            print('deja un crew')
        end
    end)
end)

RegisterCommand("leavecrew", function()
    TriggerServerEvent("LeaveCrew")
end)