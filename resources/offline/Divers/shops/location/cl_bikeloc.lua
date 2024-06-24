local shopBike = {
    Categorie = {
        {Label = "Bmx", Id = "bmx", Price = 250},
        {Label = "Cruiser", Id = "cruiser", Price = 350},
        {Label = "Fixter", Id = "fixter", Price = 350},
        {Label = "Scorcher", Id = "scorcher", Price = 350},
        {Label = "Tribike", Id = "tribike", Price = 350},
        {Label = "Tribike 2", Id = "tribike2", Price = 350},
        {Label = "Tribike 3", Id = "tribike3", Price = 350},
    }
}

shopBike.openedMenu = false
shopBike.mainMenu = RageUI.CreateMenu("Vélo", "Vélo", nil, 150)
shopBike.mainMenu.Closed = function()
    shopBike.openedMenu = false
end

shopBike.mainMenu:DisplayHeader(false)

function openshopBike()
    if shopBike.openedMenu then
        shopBike.openedMenu = false
        RageUI.Visible(shopBike.mainMenu, false)
    else
        shopBike.openedMenu = true
        RageUI.Visible(shopBike.mainMenu, true)
            CreateThread(function()
                while shopBike.openedMenu do
                    RageUI.IsVisible(shopBike.mainMenu, function()
                        for k,v in pairs(shopBike.Categorie) do 
                            RageUI.Button(""..v.Label, nil, {RightLabel = "~g~"..v.Price.."$"}, true, {
                                onSelected = function()
                                    TriggerServerEvent("buyBike", v.Price, v.Id, v.Label)
                                end
                            })
                        end
                    end)            
                Wait(1)
            end
        end)
    end
end

CreateThread(function()
    while true do
        local time = 1000
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, -828.72, -1085.63, 10.13)

		if dist <= 2.0 then
			time = 5
			DisplayNotification("Appuyez sur ~INPUT_TALK~ pour intéragir avec ~b~Tom.")
			if IsControlJustPressed(0, 51) then
				openshopBike()
			end
		end
		Wait(time)
    end
end)