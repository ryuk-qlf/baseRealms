ESX = nil
Citizen.CreateThread(function() while ESX == nil do TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end) Citizen.Wait(0) end while ESX.GetPlayerData().job == nil do Citizen.Wait(10)end ESX.PlayerData = ESX.GetPlayerData()end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

local Banking = {
    IndexCard = 1,
    ListeAccount = {},
    ListeCard = {},
    Card = {},
    ListeCardMenu = {},
    ListeTransac = {},
    GestionAccount = {},
    InfoAccount = {},
    GestionCard = {}, 
    OpenGestionCard,
    CompteN = "   ",
    MoneySociety = {},
}

local Numero
local Somme = "0"

Banking.openedMenu = false
Banking.openedMenuCard = false
Banking.openedMenuChoice = false
Banking.compteMenu = RageUI.CreateMenu(" ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.ChoiceMenu = RageUI.CreateMenu(" ", "Paiement", nil, 100, "root_cause", "shopui_title_fleecabank")
Banking.ChoiceListCards = RageUI.CreateSubMenu(Banking.ChoiceMenu, "", "Liste des cartes", nil, 100, "root_cause", "shopui_title_fleecabank")
Banking.CodeMenu = RageUI.CreateSubMenu(Banking.ChoiceListCards, " ", "Entrez votre code", nil, 100, "root_cause", "shopui_title_fleecabank")
Banking.ResumTransac = RageUI.CreateSubMenu(Banking.ChoiceMenu, " ", "Résumé de la transaction", nil, 100, "root_cause", "shopui_title_fleecabank")
Banking.cardMenu = RageUI.CreateMenu("", "ATM", nil, 100, "root_cause", "shopui_title_fleecabank")
Banking.subSocietyAccount = RageUI.CreateSubMenu(Banking.compteMenu, " ", "Mon compte", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.subCreatecompte = RageUI.CreateSubMenu(Banking.compteMenu, " ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.subAccountListe = RageUI.CreateSubMenu(Banking.compteMenu, " ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.subAccountInteraction = RageUI.CreateSubMenu(Banking.subAccountListe, " ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.SubAccountHistorique = RageUI.CreateSubMenu(Banking.subAccountInteraction, " ", "Banque", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.SubGestionCard = RageUI.CreateSubMenu(Banking.cardMenu, " ", "Action sur la carte", nil, 100, "root_cause", "shopui_title_mazebank")
Banking.compteMenu.Closed = function() 
    Banking.openedMenu = false 
end
Banking.cardMenu.Closed = function() 
    Banking.openedMenuCard = false 
end

Banking.ChoiceMenu.Closable = false

Banking.ChoiceMenu.Closed = function()
    Banking.openedMenuChoice = false
end

Banking.ChoiceListCards:AcceptFilter(true)

function ConvertToBool(number)
    local number = tonumber(number)
    if number == 1 then return true else return false end
end

function ConvertToNum(bool)
    if bool then return 1 else return 0 end
end

function GetMoneySociety()
    ESX.TriggerServerCallback("GetMoneySociety", function(cb)
        Banking.MoneySociety = cb
    end)
end

local CourantTable = {}

function openBanking()
    if Banking.openedMenu then
        Banking.openedMenu = false
        RageUI.Visible(Banking.compteMenu, false)
    else
        Banking.openedMenu = true
        RageUI.Visible(Banking.compteMenu, true)
            CreateThread(function()
                while Banking.openedMenu do
                    RageUI.IsVisible(Banking.compteMenu, function()
                        RageUI.Separator("- ~b~Intéraction bancaire~s~ -")
                        RageUI.Button("Créer un compte", nil, {RightLabel = "→"}, true, {}, Banking.subCreatecompte)

                        RageUI.Button("Mes comptes", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetAccountListByOwner", function(cb)
                                    Banking.ListeAccount = cb
                                end)
                                Wait(250)
                                for k,v in pairs(Banking.ListeAccount) do
                                    if v.courant == 1 then
                                        table.insert(CourantTable, {id = v.Numero})
                                    end
                                end
                                Wait(150)
                                RageUI.CloseAll()
                                RageUI.Visible(Banking.subAccountListe, true)
                            end
                        })

                        if ESX.PlayerData.job.grade_name == "boss" then
                            RageUI.Button("Mon compte société", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    GetMoneySociety()
                                    Wait(50)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Banking.subSocietyAccount, true)
                                end
                            })
                        end
                    end)   

                    RageUI.IsVisible(Banking.subSocietyAccount, function()
                        for k, v in pairs(Banking.MoneySociety) do
                            if v.job == ESX.PlayerData.job.name then
                                RageUI.Separator("Balance société : ~g~"..ESX.Math.GroupDigits(v.money).."$")
                            end
                        end
                        RageUI.Separator("Nom de l'entreprise : ~y~"..ESX.PlayerData.job.label)
                        RageUI.Button("Déposer", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local result = ESX.KeyboardInput("Montant", 30)
                                if tonumber(result) ~= nil and not string.match(result, "-") and not string.match(result, "+") then 
                                    TriggerServerEvent("depositSociety", ESX.PlayerData.job.name, result)
                                    Wait(500)
                                    GetMoneySociety()
                                end
                            end
                        })

                        RageUI.Button("Retirer", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                local result = ESX.KeyboardInput("Montant", 30)
                                if tonumber(result) ~= nil and not string.match(result, "-") and not string.match(result, "+") then 
                                    TriggerServerEvent("withdrawSociety", ESX.PlayerData.job.name, result)
                                    Wait(500)
                                    GetMoneySociety()
                                end
                            end
                        })

                    end)
                    
                    RageUI.IsVisible(Banking.subCreatecompte, function()
                        RageUI.Separator("- ~b~Création d'un compte~s~ -")
                        RageUI.List("Type de compte", {"Personnel"}, Banking.IndexCard, nil, {}, true, {})

                        RageUI.Button("Créer le compte", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                TriggerServerEvent("CreateAccount", 0)
                                ESX.ShowNotification("~y~Maze Bank~s~\nCréation du compte ~g~réussie~s~ avec succès, vous détenez dès maintenant un compte chez nous.")
                            end
                        })
                    end)

                    RageUI.IsVisible(Banking.subAccountListe, function()
                        RageUI.Separator("- ~g~Liste des comptes~s~ -")
                        if Banking.ListeAccount then
                            if #Banking.ListeAccount > 0 then
                                for k,v in pairs(Banking.ListeAccount) do
                                    RageUI.Button("Compte N°" ..v.Numero, nil, {RightLabel = "→"}, true, {
                                        onSelected = function()
                                            Banking.idAccount = v.Numero
                                            Banking.GestionAccount = v
                                            ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                                Banking.ListeCard = cb
                                            end, Banking.GestionAccount.Numero)
                                        end
                                    }, Banking.subAccountInteraction)
                                end
                            else 
                                RageUI.Separator("- ~r~Aucun compte~s~ -")
                            end 
                        end
                    end)

                    RageUI.IsVisible(Banking.subAccountInteraction, function()
                        if Banking.GestionAccount.type == 0 then 
                            Banking.GestionAccount.AccountType = "~g~Oui"
                        else
                            Banking.GestionAccount.AccountType = "~r~Non"
                        end
                        RageUI.Separator("- ~b~Information du compte~s~ -")
                        RageUI.Separator("~o~Compte N°" ..tostring(Banking.GestionAccount.Numero))
                        RageUI.Separator("Balance : ~g~" ..tostring(Banking.GestionAccount.balance).. "$")
                        RageUI.Separator("Appartenant à ~y~" ..tostring(Banking.GestionAccount.identite))

                        RageUI.Button("Historique", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetTransacListByOwner", function(cb)
                                    Banking.ListeTransac = cb
                                end, Banking.GestionAccount.Numero)
                            end
                        }, Banking.SubAccountHistorique)

                        RageUI.Button("Compte courant", not ConvertToBool(Banking.GestionAccount.courant) and "~r~Vous pouvez avoir qu'un seul compte courant, veuillez appuyez sur le statut", {RightLabel = ConvertToBool(Banking.GestionAccount.courant) and "~g~Oui" or "~r~Non"}, true , {
                            onSelected = function()
                                if #CourantTable == 0 then
                                    print('1')
                                    ESX.ShowNotification("Le compte ~g~ N°"..Banking.idAccount.."~s~ est maintenant utilisé comme compte courant.")
                                    TriggerServerEvent("StatusCourantCompte", Banking.GestionAccount.Numero, true)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Banking.compteMenu, true)
                                else
                                    print('2')
                                    if ConvertToBool(Banking.GestionAccount.courant) then
                                        print('3')
                                        TriggerServerEvent("StatusCourantCompte", Banking.GestionAccount.Numero, false)
                                        CourantTable = {}
                                        ESX.ShowNotification("Le compte ~r~ N°"..Banking.idAccount.."~s~ n'est plus utilisé comme compte courant.")
                                        RageUI.CloseAll()
                                        RageUI.Visible(Banking.compteMenu, true)
                                    else
                                        print('4')
                                        ESX.Notification("~r~Vous avez déjà un compte courant.")
                                    end
                                end
                            end
                        })

                        if #Banking.ListeCard > 0 then
                            RageUI.Button("Créer une carte", nil, {RightLabel = "→"}, false, {})
                        else
                            RageUI.Button("Créer une carte", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("CreateCardByAccount", Banking.GestionAccount.Numero)
                                    ESX.ShowNotification("~g~Acquisition~s~, vous avez reçu une carte")
                                    Wait(250)
                                    ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                        Banking.ListeCard = cb
                                    end, Banking.GestionAccount.Numero)
                                end
                            })
                        end
                        RageUI.Separator("- ~y~Carte appartenant au compte~s~ -")

                        if Banking.ListeCard then
                            if #Banking.ListeCard > 0 then
                                for k,v in pairs(Banking.ListeCard) do
                                    local isLocked = ConvertToBool(v.locked)
                                    RageUI.Separator("Identité : " ..v.identite)
                                    RageUI.Separator("Date d'expiration : " ..v.exp)
                                    RageUI.Separator("Numéro de la carte : ~g~" ..v.numero)
                                    RageUI.Button("Code de la carte : ~y~" ..v.code, nil, {}, true, {
                                        onSelected = function()
                                            local result = ESX.KeyboardInput("Nouveau Code", 4)
                                            if tonumber(result) ~= nil and #result == 4 then
                                                TriggerServerEvent("UpdateCodeCarte", result, v.account)
                                                Wait(150)
                                                ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                                    Banking.ListeCard = cb
                                                end, Banking.GestionAccount.Numero)
                                            end
                                        end
                                    })
                                    if not isLocked then
                                        RageUI.Button("~r~Vérouiller ma carte", nil, {}, true, {
                                            onSelected = function()
                                                TriggerServerEvent("DestroyCard", v.account, true)
                                                Wait(250)
                                                ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                                    Banking.ListeCard = cb
                                                end, Banking.GestionAccount.Numero)
                                                ESX.ShowNotification("Vous avez ~r~vérouillé~w~ votre carte.")
                                            end
                                        })
                                    else
                                        RageUI.Button("~r~Dévérouilller ma carte", nil, {}, true, {
                                            onSelected = function()
                                                TriggerServerEvent("DestroyCard", v.account, false)
                                                Wait(250)
                                                ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                                    Banking.ListeCard = cb
                                                end, Banking.GestionAccount.Numero)
                                                ESX.ShowNotification("Vous avez ~g~dévérouillé~w~ votre carte.")
                                            end
                                        })
                                    end
                                end
                            else 
                                RageUI.Separator("- ~r~Aucune carte enregistré~s~ -")
                            end 
                        end
                        RageUI.Button("~r~Supprimer le compte", nil, {}, true, {
                            onSelected = function()
                                if ConvertToBool(Banking.GestionAccount.courant) then
                                    CourantTable = {}
                                end
                                TriggerServerEvent("DestroyAccount", Banking.idAccount)
                                Wait(250)
                                ESX.TriggerServerCallback("GetAccountListByOwner", function(cb)
                                    Banking.ListeAccount = cb
                                end)
                                Wait(250)
                                ESX.TriggerServerCallback("GetCardListByOwner", function(cb)
                                    Banking.ListeCard = cb
                                end, Banking.GestionAccount.Numero)
                                ESX.ShowNotification("Vous avez ~r~supprimé~s~ votre compte chez ~y~Maze Bank~w~, n'hésitez pas à revenir si vous avez besoin.")
                            end
                        }, Banking.compteMenu)
                    end)

                    RageUI.IsVisible(Banking.SubAccountHistorique, function()
                        RageUI.Separator("- ~y~Liste des transactions~s~ -") 
                        if Banking.ListeTransac then 
                            if #Banking.ListeTransac > 0 then
                                for k,v in pairs(Banking.ListeTransac) do

                                    if v.type == 0 then
                                        v.Status = "Dépot"
                                    elseif v.type == 1 then
                                        v.Status = "Retrait"
                                    elseif v.type == 2 then
                                        v.Status = "Virement"
                                    elseif v.type == 3 then
                                        v.Status = "Paiement"
                                    elseif v.type == 4 then
                                        v.Status = "Facture"
                                    elseif v.type == 5 then
                                        v.Status = "Dynasty 8"
                                    end

                                    RageUI.Button("~o~"..v.Status.. "~w~ | ~g~" ..v.somme, nil, {}, true, {})
                                end
                            else 
                                RageUI.Separator("- ~r~Aucune transaction perçue~s~ -")
                            end
                        end 
                    end)
                Wait(1)
            end
        end)
    end
end

function openCardBanking(account, numero)
    if openATM() then
        CodeCarte = ESX.KeyboardInput("Code (~r~4 Chiffres~s~)", 4)
        if CodeCarte ~= nil then
            ESX.TriggerServerCallback("GetCodeCard", function(Check)
                if Check then
                    ESX.ShowNotification("Code ~r~invalide~s~")
                else 
                    ESX.TriggerServerCallback("GetInfosCardAccount", function(cb)
                        Banking.InfoAccount = cb
                    end, account)
                    ESX.TriggerServerCallback("GetInfosCard", function(cb)
                        Banking.Card = cb
                    end, numero, account)
                    Wait(250)
                    if Banking.Card == nil then
                        return
                    end
                    for k,v in pairs(Banking.Card) do
                        print(v.locked)
                        if v.locked == 1 then
                            ESX.Notification("~r~Impossible~s~\nCette carte est vérouillée")
                            return
                        end
                    end
                    if Banking.openedMenuCard then
                        Banking.openedMenuCard = false
                        RageUI.Visible(Banking.cardMenu, false)
                    else
                        Banking.openedMenuCard = true
                        RageUI.Visible(Banking.cardMenu, true)
                            CreateThread(function()
                                while Banking.openedMenuCard do
                                    RageUI.IsVisible(Banking.cardMenu, function()
                                        if Banking.InfoAccount then 
                                            for k,v in pairs(Banking.InfoAccount) do
                                                RageUI.Separator("~o~Compte N°" ..v.Numero)
                                                RageUI.Separator("Balance : ~g~" ..ESX.Math.GroupDigits(v.balance).. "$")
                                                RageUI.Separator("Appartenant à ~y~" ..v.identite)

                                                RageUI.Button("Retirer de l'argent", nil, {}, true, {
                                                    onSelected = function()
                                                        Somme = ESX.KeyboardInput("Somme", 6)
                                                        if tonumber(Somme) ~= nil and not string.match(Somme, "-") and not string.match(Somme, "+") then
                                                            TriggerServerEvent("WithdrawMoney", Somme, v.Numero)
                                                            Wait(250)
                                                            ESX.TriggerServerCallback("GetInfosCardAccount", function(cb)
                                                                Banking.InfoAccount = cb
                                                            end, v.Numero)
                                                        end
                                                    end
                                                })

                                                RageUI.Button("Déposer de l'argent", nil, {}, true, {
                                                    onSelected = function()
                                                        Somme = ESX.KeyboardInput("Somme", 6)
                                                        if tonumber(Somme) ~= nil and not string.match(Somme, "-") and not string.match(Somme, "+") then
                                                            TriggerServerEvent("DepositMoney", Somme, v.Numero)
                                                            Wait(250)
                                                            ESX.TriggerServerCallback("GetInfosCardAccount", function(cb)
                                                                Banking.InfoAccount = cb
                                                            end, v.Numero)
                                                        end
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
            end, CodeCarte, account)
        end
    end
end


RegisterNetEvent("ChoiceForPayment")
AddEventHandler("ChoiceForPayment", function(transacMessage, money, Actions)
    openChoiceMenu(money, Actions, transacMessage)
    ESX.TriggerServerCallback("GetListeCard", function(cb)
        Banking.ListeCardMenu = cb
    end)
end)

exports('openCardBanking', openCardBanking)

local typePayment = nil

function openChoiceMenu(money, Actions, transacMessage)
    RageUI.CloseAll()
    if Banking.openedMenuChoice then
        Banking.openedMenuChoice = false
        RageUI.Visible(Banking.ChoiceMenu, false)
    else
        Banking.openedMenuChoice = true
        RageUI.Visible(Banking.ChoiceMenu, true)
            CreateThread(function()
                while Banking.openedMenuChoice do
                    RageUI.IsVisible(Banking.ChoiceMenu, function()
                        RageUI.Button("→ Payer en liquide", nil, {}, true, {
                            onSelected = function()
                                typePayment = "liquide"
                            end
                        }, Banking.ResumTransac)
                        RageUI.Button("→ Payer en carte banquaire", nil, {}, true, {
                            onSelected = function()
                                typePayment = "bank"
                            end
                        }, Banking.ChoiceListCards)
                        RageUI.Button("~r~Annuler la transaction", nil, {}, true, {
                            onSelected = function()
                                Banking.openedMenuChoice = false
                                RageUI.CloseAll()
                                if (Actions.onCanceled ~= nil) then
                                    Citizen.CreateThread(function()
                                        Actions.onCanceled()
                                    end)
                                end
                            end
                        })
                    end)

                    RageUI.IsVisible(Banking.ChoiceListCards, function()
                            if Banking.ListeCardMenu then
                            for k,v in pairs(Banking.ListeCardMenu) do
                                RageUI.Button("Compte N°" ..v.account.. " : ~g~" ..v.numero.. "~s~", nil, {RightLabel =  Banking.CompteN}, true, {
                                    onSelected = function()
                                        RageUI.ResetFiltre()
                                        Banking.GestionCard = v
                                    end
                                }, Banking.CodeMenu)
                            end
                        end
                    end)
                    RageUI.IsVisible(Banking.CodeMenu, function()
                        RageUI.Button("Entrer le code", ConvertToBool(Banking.GestionCard.locked) and "~r~Cette carte est vérouillé" or nil, {}, not ConvertToBool(Banking.GestionCard.locked), {
                            onSelected = function()
                                CodeCarte = ESX.KeyboardInput("Code (~r~4 Chiffres~s~)", 4)
                                if tonumber(CodeCarte) ~= nil then
                                    ESX.TriggerServerCallback("GetCodeCard", function(Check)
                                        if Check then
                                            ESX.ShowNotification("Code ~r~invalide~s~")
                                        else 
                                            RageUI.CloseAll()
                                            RageUI.Visible(Banking.ResumTransac, true)
                                        end
                                    end, CodeCarte, Banking.GestionCard.account)
                                end
                            end
                        })
                    end)
                    RageUI.IsVisible(Banking.ResumTransac, function()
                        RageUI.Separator("↓ Montant ↓")
                        RageUI.Separator("~g~"..money.."$~s~")
                        RageUI.Separator("↓ Raison de la transaction ↓")
                        RageUI.Separator(transacMessage)
                        if typePayment == "liquide" then
                            RageUI.Button("→ Payer en liquide", nil, {}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("IfHasMoney", function(yesorno)
                                        if yesorno then
                                            TriggerServerEvent("WithdrawCash", money)
                                            if (Actions.onInteract ~= nil) then
                                                Citizen.CreateThread(function()
                                                    Actions.onInteract()
                                                end)
                                            end
                                            ESX.ShowNotification("Vous avez effectué un ~b~paiement~s~ de ~g~"..money.."$")
                                            Banking.openedMenuChoice = false
                                            RageUI.CloseAll()
                                        else
                                            ESX.ShowNotification("~r~Vous n'avez pas assez d'argent")
                                        end
                                    end, money)
                                end
                            })
                        else
                            RageUI.Button("→ Payer par carte", nil, {}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback("WithDrawBankPayment", function(result) 
                                        if result then
                                            if (Actions.onInteract ~= nil) then
                                                Citizen.CreateThread(function()
                                                    Actions.onInteract()
                                                end)
                                            end
                                            ESX.ShowNotification("Vous avez effectué un ~b~paiement~s~ de ~g~"..money.."$~s~ avec votre carte ~b~bleue~s~")
                                            Banking.openedMenuChoice = false
                                            RageUI.CloseAll()
                                        end
                                    end, money, Banking.GestionCard.account, transacMessage)
                                end
                            })
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

local ATMProps = {{prop = 'prop_atm_02'},{prop = 'prop_atm_03'},{prop = 'prop_fleeca_atm'},{prop = 'prop_atm_01'}}

function openATM()
    local objects = {}
    for _,v in pairs(ATMProps) do
      table.insert(objects, v.prop)
    end
  
    local ped = GetPlayerPed(-1)
    local list = {}
  
    for _,v in pairs(objects) do
        local obj = GetClosestObjectOfType(GetEntityCoords(ped).x, GetEntityCoords(ped).y, GetEntityCoords(ped).z, 5.0, GetHashKey(v), false, true ,true)
        local dist = GetDistanceBetweenCoords(GetEntityCoords(ped), GetEntityCoords(obj), true)
        table.insert(list, {object = obj, distance = dist})
      end
  
      local closest = list[1]
      for _,v in pairs(list) do
        if v.distance < closest.distance then
          closest = v
        end
      end
  
      local distance = closest.distance
      local object = closest.object

      local heading = GetEntityHeading(props)

      local pheading = GetEntityHeading(ped)

      if distance < 1.3 then
        return true 
      else
        return false
      end
end


CreateThread(function()
    while true do
        Wait(1)
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, 243.09, 224.34, 106.28)
		if dist <= 500 then
			if dist <= 0.5 then
				DisplayNotification("Appuyez sur ~INPUT_TALK~ pour ~b~parler à Bob~s~")
				if IsControlJustPressed(0, 51) then
                    openBanking()
                end
            end
		else
			Wait(1)
		end
    end
end)