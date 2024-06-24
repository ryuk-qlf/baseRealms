ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local TableCambriolage = {}

ESX.RegisterUsableItem('tournevis', function(source)
	TriggerClientEvent('useTournevis', source)
end)

RegisterNetEvent('AddTableCambriolage')
AddEventHandler('AddTableCambriolage', function(id_prop)
    MySQL.Async.execute("UPDATE properties_list SET cambriolage = @cambriolage WHERE id_property = @id_property", {
        ["@id_property"] = id_prop,
		["@cambriolage"] = "1"
    })
	Wait(500)
    TriggerEvent("Property:Actualizes")
end)

MySQL.ready(function()
	MySQL.Async.execute('UPDATE properties_list SET cambriolage = 0 WHERE cambriolage = 1', {})
end)

local ListItems = {
    {label = "Parfum Dior", item = "parfum"},
    {label = "Vin", item = "vin"},
    {label = "iPhone", item = "phone"},
    {label = "Samsung", item = "phone2"},
    {label = "Lampe", item = "WEAPON_FLASHLIGHT"},
    {label = "DVD", item = "dvd"},
    {label = "Grand turismo", item = "grandturismo"},
    {label = "GTAV", item = "gtav"},
    {label = "PS5", item = "ps5"},
    {label = "Mac", item = "mac"},
    {label = "Ecran 4K", item = "tv"},
    {label = "Rolex", item = "rolex"},
    {label = "Xbox Serie X", item = "xbox"},
    {label = "Tablette", item = "tablette"},
    {label = "Casque", item = "casque"},
    {label = "Ecran PC", item = "ecranpc"},
    {label = "Chargeur Lightning", item = "chargeur1"},
    {label = "Chargeur Android", item = "chargeur2"},
}

RegisterNetEvent("AddItemCambriolage")
AddEventHandler("AddItemCambriolage", function()
    local xPlayer = ESX.GetPlayerFromId(source)
	local ChanceDeTrouver = math.random(0, 3)

	if ChanceDeTrouver == 1 then   
		local item = ListItems[math.random(0, #ListItems)]

		if xPlayer.canCarryItem(item.label, 1) then
			xPlayer.addInventoryItem(item.item, 1)
			xPlayer.showNotification("Vous avez trouvé ~b~x1 "..item.label.."~s~.")
		else
			xPlayer.showNotification('~r~Vous n\'avez pas assez de place sur vous.')
		end
	else
		xPlayer.showNotification("~r~Vous n'avez rien trouvé pour le moment chercher encore.")
	end
end)