ExampleItems = {
    {Label = "GPS", Id = "gps", Price = 150, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Téléphone", Price = 350, Id = "classic_phone", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Pain", Id = "bread", Price = 50, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Eau", Id = "water", Price = 50, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
}

Market = {}
Market.openedMenu = false
Market.mainMenu = RageUI.CreateMenu("", "Market", nil, 100, "shopui_title_gasstation", "shopui_title_gasstation")
Market.mainMenu:DisplayGlare(false)
Market.mainMenu.Closed = function()
    Market.openedMenu = false
end

function openMarket()
    if Market.openedMenu then
        Market.openedMenu = false
        RageUI.Visible(Market.mainMenu, false)
    else
        Market.openedMenu = true
        RageUI.Visible(Market.mainMenu, true)
            CreateThread(function()
                while Market.openedMenu do
                    RageUI.IsVisible(Market.mainMenu, function()
                        pos = GetEntityCoords(PlayerPedId())
                        RageUI.Separator("- ~o~Bienvenue~s~ -")
                        RageUI.Separator("~r~LTD~s~ Gasoline de ~g~"..GetStreetNameFromHashKey(GetStreetNameAtCoord(pos.x, pos.y, pos.z)).."~s~")
                        for k, items in pairs(ExampleItems) do
                            RageUI.List("~g~"..items.Price*tonumber(items.Index).."$~s~ - "..items.Label, items.List, items.Index, nil, {}, true, {
                                onListChange = function(Index, Button)
                                    items.Index = Index
                                end,
                                onSelected = function()
                                    TriggerServerEvent("marketPaiement", items.Price*tonumber(items.Index), items.Id, items.Label, items.List[items.Index])
                                end
                            })
                        end
                    end)
                Wait(1)
            end
        end)
    end
end

Citizen.CreateThread( function()
    while true do
        time = 750
            for k, v in pairs(Config.PosMarket) do
                local Playerpos = GetEntityCoords(PlayerPedId())
                local Pdist = #(v.posmark - Playerpos) 
                if Pdist <= 10 then 
                    time = 1
                    if Pdist <= 1.5 and not Market.openedMenu and IsPedOnFoot(PlayerPedId()) then 
                        DisplayNotification('Appuyez sur ~INPUT_TALK~ pour ~b~accéder au frigo~s~.')
                        if IsControlJustPressed(0, 51) then
                            openMarket()
                        end 
                    end
                end 
            end
        Citizen.Wait(time)
    end
end)