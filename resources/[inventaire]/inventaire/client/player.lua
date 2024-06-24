ESX = nil

local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob') 
AddEventHandler('esx:setJob', function(job)   
    PlayerData.job = job
end)

function refreshPlayerInventory()
    setPlayerInventoryData()
end

RegisterNetEvent("esx_inventoryhud:openPlayerInventory")
AddEventHandler("esx_inventoryhud:openPlayerInventory", function(target, playerName)
	targetPlayer = target
    targetPlayerName = playerName
    setPlayerInventoryData()
    openPlayerInventory()
end)

local openInventoryPlayer = true

RegisterCommand('fouiller', function()
    local closestPlayer = GetNearbyPlayer(true)

    if closestPlayer then
        if IsEntityPlayingAnim(GetPlayerPed(closestPlayer), 'random@mugging3', 'handsup_standing_base', 3) or IsPedCuffed(GetPlayerPed(closestPlayer)) or IsPedRagdoll(GetPlayerPed(closestPlayer)) then
            ExecuteCommand('me fouille quelqu\'un')
            if openInventoryPlayer then
                openInventoryPlayer = false
                TriggerEvent("esx_inventoryhud:openPlayerInventory", GetPlayerServerId(closestPlayer), GetPlayerName(PlayerPedId()))
                ESX.Streaming.RequestAnimDict('missexile3', function()
                    TaskPlayAnim(PlayerPedId(), 'missexile3', 'ex03_dingy_search_case_a_michael', 8.0, -8.0, -1, 35, 0.0, false, false, false)
                end)
                while not openInventoryPlayer do
                    if IsControlJustReleased(0, 37) then
                        openInventoryPlayer = true
                        ClearPedTasks(PlayerPedId())
                    end
                    Wait(5)
                end
            end
        else
            ESX.Notification("~r~Impossible l'individu doit être menotté.")
        end
    end
end)

function setPlayerInventoryData()
    ESX.TriggerServerCallback("esx_inventoryhud:getPlayerInventory", function(data)
        items = {}
        inventory = data.inventory
        accounts = data.accounts
        money = data.money
        weapons = data.weapons
        cards = data.cards
        idcard = data.idcard
        kevlar = data.kevlar

        if money ~= nil and money > 0 then
            moneyData = {
                label = "Espèces",
                name = "cash",
                type = "item_money",
                count = money,
                usable = false,
                rare = false,
                limit = -1,
                canRemove = true
            }

            table.insert(items, moneyData)
        end

        if accounts ~= nil then
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
                            weight = 0,
                            canRemove = canDrop
                        }
                        table.insert(items, accountData)
                    end
                end
            end
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
                    usable = false,
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
                        usable = false,
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
                        usable = false,
                        rename = false,
                        rare = false,
                        weight = -1
                    }
                end
                table.insert(items, idcardData)
            end
        end

        if inventory ~= nil then
            for k, v in pairs(inventory) do
                if v.count > 0 then
                    itemData = {
                        label = v.label,
                        name = v.name,
                        type = "item_standard",
                        count = v.count,
                        usable = false,
                        rename = false,
                        rare = false,
                        weight = -1
                    }
                    table.insert(items, itemData)
                end
            end
        end

        if kevlar ~= nil then
            for k, v in pairs(kevlar) do
                if v.type == "kevlar" then
                    cardsData = {
                        label = v.nom,
                        name = "kevlar",
                        type = "item_kev",
                        id = v.id,
                        count = 1,
                        usable = false,
                        rename = false,
                        rare = false,
                        weight = -1
                    }
                    table.insert(items, cardsData)
                end
            end
        end

        SendNUIMessage(
            {
                action = "setSecondInventoryItems",
                itemList = items
            }
        )
    end, targetPlayer)
end

function openPlayerInventory()
    loadPlayerInventory(currentMenu)
    isInInventory = true

    SendNUIMessage(
        {
            action = "display",
            type = "player"
        }
    )

    DisplayRadar(false)
    SetNuiFocus(true, true)
    SetKeepInputMode(true)
end

RegisterNUICallback("PutIntoPlayer", function(data, cb)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        if GetPlayerServerId(closestPlayer) == targetPlayer then
            if type(data.number) == "number" and math.floor(data.number) == data.number then
                local count = tonumber(data.number)
                if data.item.type == "item_weapon" then
                    count = data.item.count
                end
                TriggerServerEvent("esx_inventoryhud:tradePlayerItem", GetPlayerServerId(PlayerId()), targetPlayer, data.item.type, data.item.name, count, data.item)
            end
            Wait(250)
            refreshPlayerInventory()
            loadPlayerInventory(currentMenu)
        end
    end
    cb("ok")
end)

RegisterNUICallback("TakeFromPlayer", function(data, cb)
    local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    if closestPlayer ~= -1 and closestDistance <= 3.0 then
        if GetPlayerServerId(closestPlayer) == targetPlayer then
            if PlayerData.job and PlayerData.job.name == 'police' or PlayerData.job and PlayerData.job.name == 'usss' then
                if type(data.number) == "number" and math.floor(data.number) == data.number then
                    local count = tonumber(data.number)
                    if data.item.type == "item_weapon" then
                        count = data.item.count
                    end
                    TriggerServerEvent("esx_inventoryhud:tradePlayerItem", targetPlayer, GetPlayerServerId(PlayerId()), data.item.type, data.item.name, count, data.item)
                end
            end
            Wait(250)
            refreshPlayerInventory()
            loadPlayerInventory(currentMenu)
        end
    end
    cb("ok")
end)