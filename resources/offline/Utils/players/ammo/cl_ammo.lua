ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local TableRemoveAmmo = {}

local AmmoTypes = {
    weapon_pistol = '45acp_ammo',
    weapon_compactrifle = '762mm_ammo',
    weapon_smg = '9mm_ammo',
    weapon_combatpistol = '9mm_ammo',
    weapon_combatmg = '762mm_ammo',
    weapon_pistol50 = '45acp_ammo',
    weapon_snspistol = '45acp_ammo',
    weapon_sawnoffshotgun = '12_ammo',
    weapon_heavypistol = '45acp_ammo',
    weapon_vintagepistol = '45acp_ammo',
    weapon_marksmanpistol = '9mm_ammo',
    weapon_revolver = '45acp_ammo',
    weapon_doubleaction = '45acp_ammo',
    weapon_navyrevolver = '45acp_ammo',
    weapon_heavysniper = '762mm_ammo',
    weapon_microsmg = '9mm_ammo',
    weapon_machinepistol = '9mm_ammo',
    weapon_pumpshotgun = '12_ammo',
    weapon_minismg = '9mm_ammo',
    weapon_carbinerifle = '762mm_ammo',
    weapon_assaultrifle = '762mm_ammo',
}

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  	if IsPedShooting(PlayerPedId()) then
			if json.encode(TableRemoveAmmo) ~= "[]" then
				TriggerServerEvent('removeAmmoBox', TableRemoveAmmo, 1)
			end
	  	end
	end
end)

local function GetInventoryItem(name)
	local inventory = ESX.GetPlayerData().inventory
	for k, v in pairs(inventory) do
	  	if v.name == name then
			return v
		end
	end
end

-- RegisterNetEvent('esx:removeInventoryItem')
-- AddEventHandler('esx:removeInventoryItem', function(item, count)
-- 	if string.match(item, "ammo") then
-- 		TriggerEvent("AddAmmoInWeapon")
-- 	end
-- end)

RegisterNetEvent('esx:addInventoryItem')
AddEventHandler('esx:addInventoryItem', function(item, count)
	if string.match(item, "ammo") then
		TriggerEvent("AddAmmoInWeapon")
	end
end)

RegisterNetEvent("AddAmmoInWeapon")
AddEventHandler("AddAmmoInWeapon", function()
	TableRemoveAmmo = nil 
	HashAmmo = nil

	local hash = GetSelectedPedWeapon(PlayerPedId())

	for k, v in pairs(AmmoTypes) do
		if GetHashKey(k) == hash then
			TableRemoveAmmo = v
			HashAmmo = k
		end
	end

	local item = GetInventoryItem(TableRemoveAmmo)

    if hash == GetHashKey(HashAmmo) then
		if item then
			if GetAmmoInPedWeapon(PlayerPedId(), hash) ~= item.count then
				PedSkipNextReloading(PlayerPedId())
				SetPedAmmo(PlayerPedId(), hash, 0)
				SetPedAmmo(PlayerPedId(), hash, item.count)
			end
		end
	end
end)