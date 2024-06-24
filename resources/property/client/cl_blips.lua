local ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local blips = {}

function AddBlipProperty(name, pos, type, id)
    if type == 'property' then
        if not DoesBlipExist(blips[id]) then
            blips[id] = AddBlipForCoord(pos)
            SetBlipSprite(blips[id], 411)
            SetBlipDisplay(blips[id], 4)
            SetBlipScale(blips[id], 0.7)
            SetBlipColour(blips[id], 2)
            SetBlipAsShortRange(blips[id], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Propriété")
            EndTextCommandSetBlipName(blips[id])
        end
    elseif type == "garage" then
        if not DoesBlipExist(blips[id]) then
            blips[id] = AddBlipForCoord(pos)
            SetBlipSprite(blips[id], 357)
            SetBlipDisplay(blips[id], 4)
            SetBlipScale(blips[id], 0.7)
            SetBlipColour(blips[id], 3)
            SetBlipAsShortRange(blips[id], true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString("Garage")
            EndTextCommandSetBlipName(blips[id])
        end
    end
end

function DeleteBlipProperty(id)
    if blips[id] then
        RemoveBlip(blips[id])
    end
end

RegisterNetEvent('ESX:DeleteBlipProperty')
AddEventHandler('ESX:DeleteBlipProperty', function(id)
    DeleteBlipProperty(id)
end)

function RefreshBlips()
    for k, v in pairs(Properties.AccessBlips) do
        if v.property_pos ~= "null" and v.garage_pos == "null" then
            local PropPos = json.decode(v.property_pos)
            AddBlipProperty(v.property_name, vector3(PropPos.x, PropPos.y, PropPos.z), 'property', v.id_property)
        elseif v.property_pos == "null" and v.garage_pos ~= "null" then
            local GaragePos = json.decode(v.garage_pos)
            AddBlipProperty(v.property_name, vector3(GaragePos.x, GaragePos.y, GaragePos.z), 'garage', v.id_property)
        end
    end
end