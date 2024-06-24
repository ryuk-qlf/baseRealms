ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local Society = {
    SlideAction = 1,
    SlideArgent = 1,

    GetListEmployer = {},
    GetListGrades = {},
}

function GetEmployerJob()
    ESX.TriggerServerCallback("ListeEmployer", function(cb)
        Society.GetListEmployer = cb
    end, ESX.GetPlayerData().job.name)
    ESX.TriggerServerCallback("ListeGrades", function(cb)
        Society.GetListGrades = cb
    end, ESX.GetPlayerData().job.name)
end

Society.openedMenu = false 
Society.mainMenu = RageUI.CreateMenu("Entreprise", "Gestion")
Society.subMenu = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")
Society.subMenu2 = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")
Society.subMenu3 = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")
Society.subMenu4 = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")
Society.subMenu5 = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")
Society.subMenu6 = RageUI.CreateSubMenu(Society.mainMenu, "Entreprise", "Gestion")

Society.mainMenu.Closed = function()
    Society.openedMenu = false 
end

function openSociety()
    if Society.openedMenu then 
        Society.openedMenu = false 
        RageUI.Visible(Society.mainMenu,false)
        return
    else
        JobLabel = ESX.GetPlayerData().job.label
        JobName = ESX.GetPlayerData().job.name
        Society.openedMenu = true
        Identif = ESX.GetPlayerData().identifier
        RageUI.Visible(Society.mainMenu, true)
        GetEmployerJob()
        Wait(150)
        Citizen.CreateThread(function()
            while Society.openedMenu do 
                    RageUI.IsVisible(Society.mainMenu, function()
                        Society.mainMenu:SetTitle(JobLabel)
                        Society.subMenu:SetTitle(JobLabel)
                        Society.subMenu2:SetTitle(JobLabel)
                        Society.subMenu3:SetTitle(JobLabel)
                        Society.subMenu4:SetTitle(JobLabel)
                        Society.subMenu5:SetTitle(JobLabel)
                        Society.subMenu6:SetTitle(JobLabel)
                        RageUI.Button("Informations", nil, {RightLabel = "→"}, true, {}, Society.subMenu6)
                        RageUI.Button("Liste des Employés", nil, {RightLabel = "→"}, true, {}, Society.subMenu)
                        RageUI.Button("Liste des Grades", nil, {RightLabel = "→"}, true, {}, Society.subMenu4)
                        RageUI.Button("Recrutement", nil, {RightLabel = "→"}, true, {}, Society.subMenu5)
                    end)            
                    RageUI.IsVisible(Society.subMenu, function()
                        for k,v in pairs(Society.GetListEmployer) do
                            if v.identifier == Identif then
                                RageUI.Button(v.firstname.." "..v.lastname, nil, {RightLabel = "→"}, false, {})
                            else
                                RageUI.Button(v.firstname.." "..v.lastname, nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        Prenom = v.firstname
                                        Nom = v.lastname
                                        Identifier = v.identifier
                                        Job = v.job
                                    end
                                }, Society.subMenu2)
                            end
                        end
                    end)
                    RageUI.IsVisible(Society.subMenu2, function()
                        if Prenom and Nom and Identifier and Job then
                            RageUI.Button("~b~"..Prenom.." "..Nom, nil, {}, true, {})
                            RageUI.Button("Changer le grade", nil, {}, true, {}, Society.subMenu3)
                            RageUI.Button("~r~Virer~s~ "..Prenom.." "..Nom, nil, {}, true, {
                                onSelected = function()
                                    ESX.ShowNotification('Vous avez viré ~b~'..Prenom.." "..Nom.."~s~ de votre entreprise.")
                                    TriggerServerEvent('VirerLeJoueur', Identifier)
                                    RageUI.GoBack()
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Society.subMenu3, function()
                        for k,v in pairs(Society.GetListGrades) do
                            RageUI.Button(v.label, nil, {RightLabel = v.grade}, true, {
                                onSelected = function()
                                    ESX.ShowNotification("Vous avez mis le grade "..v.label.." à ~b~"..Prenom.." "..Nom.."~s~.")
                                    TriggerServerEvent("EditGradePlayer", Identifier, v.grade)
                                end
                            })
                        end
                    end)
                    RageUI.IsVisible(Society.subMenu4, function()
                        for k,v in pairs(Society.GetListGrades) do
                            RageUI.Button(v.label, "Les grades ne sont pas modifiable.", {RightLabel = v.grade}, true, {})
                        end
                    end)
                    RageUI.IsVisible(Society.subMenu5, function()
                        RageUI.List("Employée", {{Name = "Recruter"}, {Name = "Virer"}, {Name = "Promouvoir"}}, Society.SlideAction, nil, {}, true, {
                            onListChange = function(Index)
                                Society.SlideAction = Index;
                            end,
                            onSelected = function(Index)
                                local Target = GetNearbyPlayer(2)
                                if Index == 1 then
                                    if Target then
                                        TriggerServerEvent('BossRecrute', GetPlayerServerId(Target), "recruter")
                                    end
                                elseif Index == 2 then 
                                    if Target then
                                        TriggerServerEvent('BossRecrute', GetPlayerServerId(Target), "virer")
                                    end
                                elseif Index == 3 then 
                                    if Target then
                                        TriggerServerEvent('PromouvoirLeJoueur', GetPlayerServerId(Target))
                                    end
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Society.subMenu6, function()
                        RageUI.Button("Nom", nil, {RightLabel = "~g~"..JobLabel}, true, {})
                        RageUI.Button("Nombre d'employées", nil, {RightLabel = "~g~"..#Society.GetListEmployer}, true, {})
                        RageUI.Button("Nombre de grades", nil, {RightLabel = "~g~"..#Society.GetListGrades}, true, {})
                    end)
                Wait(1)
            end
        end)
    end
end

RegisterCommand("entreprise", function()
    if ESX.GetPlayerData().job.grade_name == "boss" then
        openSociety()
    else
        ESX.ShowNotification("Vous devez être ~b~patron~s~ d'une ~b~entreprise~s~ pour faire cela.")
    end
end)

RegisterNetEvent("SolutionJoinJob")
AddEventHandler("SolutionJoinJob", function(JobLabel)
    local timer = 1100
    
    ESX.ShowNotification("Voulez vous rejoindre le métier ~b~"..JobLabel)
    ESX.ShowNotification("~g~Y~s~ : Accepter\n~r~X~s~ : Refuser")

    while true do
        Wait(1)
        timer = timer - 1

        if timer <= 0 then
            ESX.ShowNotification("~r~Vous avez mis trop de temps à choisir.")
            TriggerServerEvent("AlertJoinJob", 1)
            break
        end

        if IsControlJustPressed(1, 73) then
            ESX.ShowNotification("~r~Vous avez refusé de rejoindre l'entreprise.")
            TriggerServerEvent("AlertJoinJob", 2)
            break
        end

        if IsControlJustPressed(1, 246) then
            ESX.ShowNotification("Vous avez été recruté dans l'entreprise ~b~"..JobLabel.."~s~.")
            TriggerServerEvent("JoinJob")
            break
        end
    end
end)