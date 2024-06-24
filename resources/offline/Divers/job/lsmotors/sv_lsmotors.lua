RegisterNetEvent('TransformationMoteur')
AddEventHandler('TransformationMoteur', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local itemToFarm = "cmoteur"
    local itemToRemove = "fertraiter"
    local itemToRemoveCount = xPlayer.getInventoryItem(itemToRemove)
    local itemToFarmLabel = xPlayer.getInventoryItem(itemToFarm)

    if #(GetEntityCoords(GetPlayerPed(source))-vector3(-1371.02, -460.47, 34.47)) < 30 then 
        if xPlayer.canCarryItem(itemToFarm, 1) then
            xPlayer.removeInventoryItem(itemToRemove, 1)
            xPlayer.addInventoryItem(itemToFarm, 1)
            xPlayer.MissionText('Vous avez récupéré un(e) ~g~' .. itemToFarmLabel.label .. '~s~. (~b~+1~s~)', 1500)
        else
            xPlayer.MissionText("~r~Vous n'avez plus de places sur vous.", 1500)
        end
    else
        DropPlayer(source, "Cheat Sell")
    end
end)