ExampleItems2 = {
    {Label = "Radio", Id = "radio", Price = 250, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Gants de boxe", Price = 150, Id = "box", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Pelle", Id = "pelle", Price = 550, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Casserole", Price = 450, Id = "casserole", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Crochet", Price = 230, Id = "lockpick", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Tournevis", Id = "tournevis", Price = 210, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    -- {Label = "Ciseaux", Price = 170, Id = "ciseaux", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Canne à pêche", Id = "cannepeche", Price = 350, List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
    {Label = "Jumelles", Price = 350, Id = "jumelle", List = {"1","2","3","4","5","6","7","8","9","10"}, Index = 1},
}

Shop = {}
Shop.openedMenu = false
Shop.mainMenu = RageUI.CreateMenu("Vendeur", "Produits")
Shop.mainMenu:DisplayGlare(false)
Shop.mainMenu.Closed = function()
    Shop.openedMenu = false
end

function openShop()
    if Shop.openedMenu then
        Shop.openedMenu = false
        RageUI.Visible(Shop.mainMenu, false)
    else
        Shop.openedMenu = true
        RageUI.Visible(Shop.mainMenu, true)
            CreateThread(function()
                while Shop.openedMenu do
                    RageUI.IsVisible(Shop.mainMenu, function()
                        for extended, items in pairs(ExampleItems2) do
                            RageUI.List("~g~"..items.Price*tonumber(items.Index).."$~s~ - "..items.Label, items.List, items.Index, nil, {}, true, {
                                onListChange = function(Index, Button)
                                    items.Index = Index
                                end,
                                onSelected = function()
                                    RageUI.CloseAll()
                                    TriggerServerEvent("shopBuy", items.Price*tonumber(items.Index), items.Id, items.Label, items.List[items.Index])
                                    Shop.openedMenu = false
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
        local time = 1000
        for k, v in pairs(Config.PosShop) do
            local Playerpos = GetEntityCoords(PlayerPedId())
            local Pdist = #(v.posshop - Playerpos) 
            
            if Pdist <= 1.0 and not Shop.openedMenu and IsPedOnFoot(PlayerPedId()) then
                time = 5
                DisplayNotification('Appuyez sur ~INPUT_TALK~ pour ~b~parler à '..v.pedName)
                if IsControlJustPressed(0, 51) then
                    openShop()
                end 
            end
        end
        Wait(time)
    end
end)