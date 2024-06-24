ESX = nil

Server = {}
Server.Properties = {}
local PropertyAccess = {}
local PropertyAccessBlips = {}
local GetAccessCrew = {}

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

RegisterNetEvent("ESX:createProperty")
AddEventHandler("ESX:createProperty", function(name, propertypos, garagepos, garagemax, interior, price, maxChest)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.insert("INSERT INTO properties_list(property_name, property_pos, property_chest, garage_pos, garage_max, property_type, property_price) VALUES(@property_name, @property_pos, @property_chest, @garage_pos, @garage_max, @property_type, @property_price)", {
        ["@property_name"] = name,
        ["@property_pos"] = json.encode(propertypos),
        ["@property_chest"] = maxChest,
        ["@garage_pos"] = json.encode(garagepos),
        ["@garage_max"] = garagemax,
        ["@property_type"] = interior,
        ["@property_price"] = price
    })

    Wait(1000)
    TriggerEvent("Property:Actualizes")
end)

RegisterNetEvent("ESX:ProlongerLocation")
AddEventHandler("ESX:ProlongerLocation", function(idprop)
    local date = {
        year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
	}
    MySQL.Async.execute("UPDATE properties_list SET expiration = @expiration WHERE id_property = @idprop", {
        ["@expiration"] = json.encode(date),
        ["@idprop"] = idprop
    })
    Wait(500)
    TriggerEvent("Property:Actualizes")
end)

RegisterNetEvent("ESX:ProlongerLocationDiamond")
AddEventHandler("ESX:ProlongerLocationDiamond", function(idprop, PropName, PropPrice)
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll('SELECT * FROM bank_account WHERE courant = 1 AND license = @license', {
        ['@license'] = xPlayer.identifier
    }, function(result)
        if json.encode(result) ~= "[]" then

            for k, v in pairs(result) do
                local NumeroxPlayer = v.Numero
                local ArgentxPlayer = v.balance

                if tonumber(ArgentxPlayer) >= tonumber(PropPrice) then
                    MySQL.Async.execute("UPDATE bank_account SET balance='" .. ArgentxPlayer - tonumber(PropPrice) .. "' WHERE Numero ='" .. NumeroxPlayer .. "';", {})
                    MySQL.Async.execute("INSERT INTO transaction_account (somme, type, account) VALUES ('" .. "(-~r~ " .. tonumber(PropPrice) .. "~s~) - ~y~Prolongement ".. PropName .. "', '" .. 5 .. "', '" .. NumeroxPlayer .. "')", {})
                    xPlayer.showNotification("Vous avez payé ~g~"..PropPrice.."$~s~ pour prolonger : ~b~"..PropName..".")
                
                    local date = {
                        year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
                    }
                    MySQL.Async.execute("UPDATE properties_list SET expiration = @expiration WHERE id_property = @idprop", {
                        ["@expiration"] = json.encode(date),
                        ["@idprop"] = idprop
                    })
                    Wait(500)
                    TriggerEvent("Property:Actualizes")
                else 
                    xPlayer.showNotification("~r~Vous n'avez pas assez d'argent pour prolonger la location.")
                end
            end
        else
            xPlayer.showNotification("~r~Vous n'avez pas défini de compte courant.")
        end
    end)
end)

RegisterNetEvent("ESX:PassezEnAchat")
AddEventHandler("ESX:PassezEnAchat", function(idprop)
    MySQL.Async.execute("UPDATE properties_list SET property_status = @status WHERE id_property = @idprop", {
        ["@status"] = "bought",
        ["@idprop"] = idprop
    })
    Wait(500)
    TriggerEvent("Property:Actualizes")
end)

RegisterNetEvent("ESX:updateProperty")
AddEventHandler("ESX:updateProperty", function(pName, status, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    local date = {
        year = os.date("*t").year, month = os.date("*t").month, day = os.date("*t").day, hour = os.date("*t").hour, min = os.date("*t").min, sec = os.date("*t").sec
	}
    if status == "rented" then
        MySQL.Async.execute("UPDATE properties_list SET property_status = @status, expiration = @expiration, property_owner = @identifier WHERE id_property = @pName", {
            ["@expiration"] = json.encode(date),
            ["@status"] = status,
            ["@identifier"] = xPlayer.identifier,
            ["@pName"] = pName
        })
    else
        MySQL.Async.execute("UPDATE properties_list SET property_status = @status, property_owner = @identifier WHERE id_property = @pName", {
            ["@status"] = status,
            ["@identifier"] = xPlayer.identifier,
            ["@pName"] = pName
        }) 
    end

    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous possedez désormais la propriété \n~b~" .. pName)
    Wait(500)
    TriggerEvent("Property:Actualizes")

    table.insert(PropertyAccess[xPlayer.source], pName)
    Wait(550)
    TriggerClientEvent("AccessActualize", xPlayer.source, PropertyAccess[xPlayer.source], PropertyAccessBlips[xPlayer.source])
end)

RegisterNetEvent("ESX:FinContractLocation")
AddEventHandler("ESX:FinContractLocation", function(pId)

    MySQL.Async.execute('UPDATE `properties_list` SET `property_owner` = @owner, `id_crew` = @crew, `jobs` = @job, `property_status` = @status, `expiration` = @exp WHERE id_property = @property', {
        ['@owner'] = nil,
        ['@crew'] = nil,
        ['@property'] = pId,
        ['@job'] = nil,
        ['@status'] = nil,
        ['@exp'] = nil
    })
    MySQL.Async.execute("DELETE FROM properties_access WHERE id_property = @id_property", {
        ["@id_property"] = pId
    })
    Wait(150)
    TriggerEvent("Property:Actualizes")
end)

RegisterNetEvent("ESX:updatePropertyName")
AddEventHandler("ESX:updatePropertyName", function(pName, newName)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("UPDATE properties_list SET property_name = @newName WHERE id_property = @pName", {
        ["@newName"] = newName,
        ["@pName"] = pName
    })    
    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez renommé votre propriété :\n~b~" .. newName .. ".")

    Wait(500)
    TriggerEvent("Property:Actualizes")
end)

RegisterNetEvent("ESX:deleteProperty")
AddEventHandler("ESX:deleteProperty", function(Id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute("DELETE FROM data_inventory WHERE plate = 'property_"..Id.."'", {})
    MySQL.Async.execute("DELETE FROM labo_coke WHERE id_prop = @id_property", {
        ["@id_property"] = Id
    })
    MySQL.Async.execute("DELETE FROM labo_weed WHERE id_prop = @id_property", {
        ["@id_property"] = Id
    })
    MySQL.Async.execute("DELETE FROM labo_meth WHERE id_prop = @id_property", {
        ["@id_property"] = Id
    })
    MySQL.Async.execute("DELETE FROM labo_meth WHERE id_prop = @id_property", {
        ["@id_property"] = Id
    })
    MySQL.Async.execute("DELETE FROM properties_access WHERE id_property = @id_property", {
        ["@id_property"] = Id
    })
    MySQL.Async.execute("DELETE FROM properties_vehicles WHERE id_property = @id_property", {
        ["@id_property"] = Id
    })
    Wait(1000)
    MySQL.Async.execute("DELETE FROM properties_list WHERE id_property = @id_property", {
        ["@id_property"] = Id
    })


    TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez ~r~supprimé~s~ la propriété ~r~" .. Id .. "~s~.")
    Wait(500)
    TriggerEvent("Property:Actualizes")
    TriggerClientEvent('ESX:DeleteBlipProperty', -1, Id)
end)

RegisterNetEvent("ESX:addAccess")
AddEventHandler("ESX:addAccess", function(pId, plyId, pName)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(plyId)

    if xTarget then
        MySQL.Async.fetchAll("SELECT * FROM properties_access WHERE identifier = @identifier AND id_property = @id_property", {
            ["@identifier"] = xPlayer.identifier,
            ["@id_property"] = pId
        }, function(row)
            if not row[1] then
                local PlayerName = xTarget.getIdentity()
                MySQL.Async.execute("INSERT INTO properties_access (label, identifier, id_property) VALUES (@plyName, @identifier, @pId)", {
                    ["@plyName"] = PlayerName,
                    ["@identifier"] = xTarget.identifier,
                    ["@pId"] = pId
                })

                TriggerClientEvent("esx:showNotification", xPlayer.source, "Vous avez ajouté ~b~" .. PlayerName .. "~s~ à la propriété. \n~b~" .. pName)
                TriggerClientEvent("esx:showNotification", xTarget.source, "Vous êtes désormais locataire de la propriété \n~b~" .. pName)
                Wait(500)

                table.insert(PropertyAccess[xTarget.source], pId)

                Wait(550)

                MySQL.Async.fetchAll("SELECT * FROM properties_list", {}, function(result)
                    TriggerClientEvent("Property:ActualizeProperties", xTarget.source, result)
                    TriggerClientEvent("AccessActualize", xTarget.source, PropertyAccess[xTarget.source], PropertyAccessBlips[xPlayer.source])
                end)
            else
                xPlayer.showNotification("~r~Impossible la personne à déjà l'accès a la propriété.")
            end
        end)
    end
end)

RegisterNetEvent("ESX:deleteAccess")
AddEventHandler("ESX:deleteAccess", function(identifier, pId)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromIdentifier(identifier)
    MySQL.Async.execute("DELETE FROM properties_access WHERE identifier = @identifier AND id_property = @id_property", {
        ["@identifier"] = identifier,
        ["@id_property"] = pId
    })
    Wait(500)

    xSource = xTarget.source
    PropertyAccess[xSource] = {}

    MySQL.Async.fetchAll("SELECT * FROM properties_access WHERE identifier = @identifier", {
        ["@identifier"] = xTarget.identifier
    }, function(result)
        for k, v in pairs(result) do
            table.insert(PropertyAccess[xSource], v.id_property)
        end
    end)
    
    MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE jobs = @jobs", {
        ["@jobs"] = xPlayer.getJob().name
    }, function(result)
        for k, v in pairs(result) do
            table.insert(PropertyAccess[xSource], v.id_property)
        end
    end)

    if GetAccessCrew[xSource] ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE id_crew = @id_crew", {
            ["@id_crew"] = GetAccessCrew[xSource]
        }, function(result)
            for k, v in pairs(result) do
                table.insert(PropertyAccess[xSource], v.id_property)
            end
        end)
    end

    Wait(550)

    if xTarget then
        TriggerClientEvent("AccessActualize", xSource, PropertyAccess[xSource], PropertyAccessBlips[xSource])
    end
end)

RegisterNetEvent("ESX:stockVehicleInProperty")
AddEventHandler("ESX:stockVehicleInProperty", function(pName, max, VehicleProperty, pId, vehname, vehicleEntity)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM properties_vehicles WHERE id_property = @pName", {
        ["@pName"] = pName
    }, function(result)
        for k, v in pairs(result) do
            local veh = json.decode(v.vehicle_property)
            if veh.plate == VehicleProperty.plate then
                return TriggerClientEvent("esx:showNotification", xPlayer.source, "~r~Impossible le véhicule est déjà dans le garage.")
            end
        end
        if result[max] then
            return TriggerClientEvent("esx:showNotification", xPlayer.source, "Aucun emplacement ~b~disponible~s~ dans le garage.")
        end

        MySQL.Async.execute("INSERT INTO properties_vehicles(label, vehicle_property, id_property) VALUES(@label, @vehProps, @pId)", {
            ["@label"] = vehname,
            ["@vehProps"] = json.encode(VehicleProperty),
            ["@pId"] = pId
        })

        --TriggerClientEvent('off_vehicle:cl_removeToPersist', xPlayer.source, vehicleEntity)
        TriggerEvent("GetPlateVehicleInPound", VehicleProperty.plate, 2)
        TriggerClientEvent("ESX:stockVehicleInProperty", xPlayer.source, VehicleProperty.model)
    end)

    if Server.Properties[pId].Players then
        for k,v in pairs (Server.Properties[pId].Players) do
            local xTarget = ESX.GetPlayerFromId(k)
            if v ~= source then
                TriggerClientEvent("ESX:refreshGarage", xTarget.source)
            end
        end
    end
end)

RegisterNetEvent("ESX:ringProperty")
AddEventHandler("ESX:ringProperty", function(tblAccess, owner, pName, type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local owner = ESX.GetPlayerFromIdentifier(owner)

    if owner then
        TriggerClientEvent("ESX:ringProperty", owner.source, pName, xPlayer.source, type)
    end

    for k, v in pairs(tblAccess) do
        local xTarget = ESX.GetPlayerFromIdentifier(v.identifier) or nil
        if xTarget then
            TriggerClientEvent("ESX:ringProperty", xTarget.source, pName, xPlayer.source, type)
        end
    end
end)

RegisterNetEvent("ESX:refuseEnterProperty")
AddEventHandler("ESX:refuseEnterProperty", function(pName, target)
    local xPlayer = ESX.GetPlayerFromId(target)

    TriggerClientEvent("esx:showNotification", xPlayer.source, "L'accès à la propriété vous a été ~r~refusé.")
end)

RegisterNetEvent("ESX:acceptEnterProperty")
AddEventHandler("ESX:acceptEnterProperty", function(pName, target, type)
    local xPlayer = ESX.GetPlayerFromId(target)
    TriggerClientEvent("esx:showNotification", xPlayer.source, "L'accès à la propriété vous a été ~g~autorisé.")
    TriggerClientEvent("ESX:enterRingedProperty", xPlayer.source, type)
end)

RegisterNetEvent("ESX:vehicleOutGarage")
AddEventHandler("ESX:vehicleOutGarage", function(vehId, propId)
    MySQL.Async.execute("DELETE FROM properties_vehicles WHERE id_vehicle = @id", {
        ["@id"] = vehId
    })

    if Server.Properties[propId].Players then
        for k,v in pairs (Server.Properties[propId].Players) do
            local xTarget = ESX.GetPlayerFromId(k)
            if v ~= source then
                TriggerClientEvent("ESX:refreshGarage", xTarget.source)
            end
        end
    end
end)

RegisterNetEvent('AddSv')
AddEventHandler('AddSv', function(type, table, id, id2)
	for k,v in pairs (Server.Properties[id].Players) do
        local xTarget = ESX.GetPlayerFromId(k)
        TriggerClientEvent("AddCl", xTarget.source, type, table, id2)
    end
end)

RegisterNetEvent('SetFinishedForEveryone')
AddEventHandler('SetFinishedForEveryone', function(table, id)
	for k,v in pairs (Server.Properties[id].Players) do
        local xTarget = ESX.GetPlayerFromId(k)
        TriggerClientEvent("SetFinished", xTarget.source, table)
    end
end)

RegisterNetEvent('Refresh')
AddEventHandler("Refresh", function(id)
    for k,v in pairs (Server.Properties[id].Players) do
        local xTarget = ESX.GetPlayerFromId(k)
        TriggerClientEvent("RefreshCl", xTarget.source)
    end
end)

RegisterNetEvent("annonceImmo")
AddEventHandler("annonceImmo", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "realestateagent" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "Dynasty8", "~b~Annonce ", input, 'CHAR_PROPERTY_BAR_AIRPORT', 1)
    else
        DropPlayer(source, "cheat annonceImmo")
    end
end)

RegisterNetEvent("ESX:initInstance")
AddEventHandler("ESX:initInstance", function(id)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)
    if not Server.Properties[id].Players[xPlayer.source] then
        Server.Properties[id].Players[xPlayer.source] = xPlayer.source
    end

    SetPlayerRoutingBucket(_src, (250000 + id))
    SetRoutingBucketPopulationEnabled((250000 + id), false)
end)

RegisterNetEvent("ESX:outInstance")
AddEventHandler("ESX:outInstance", function(id)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)   
    if Server.Properties[id].Players[xPlayer.source] then
        Server.Properties[id].Players[xPlayer.source] = nil 
    end

    SetPlayerRoutingBucket(_src, 0)
end)

RegisterNetEvent("ESX:attributePropertyToCrew")
AddEventHandler("ESX:attributePropertyToCrew", function(pName)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if json.encode(result[1]) ~= "null" then

            local IdCrew = result[1].id_crew

            MySQL.Async.execute("UPDATE properties_list SET id_crew = @id_crew WHERE property_name = @pName", {
                ["@id_crew"] = IdCrew,
                ["@pName"] = pName
            })

            TriggerClientEvent("esx:showNotification", xPlayer.source, "~b~Vous avez attribué la propriété à votre organisation.")

            Wait(1500)
            TriggerEvent("Property:Actualizes")
        end
    end)
end)

ESX.RegisterServerCallback("ESX:getProperties", function(source, cb)
    Server.Properties = {}
    MySQL.Async.fetchAll("SELECT * FROM properties_list", {}, function(result)
        cb(result)
    end)
end)

RegisterNetEvent("Property:Actualizes")
AddEventHandler("Property:Actualizes", function()
    Server.Properties = {}

    MySQL.Async.fetchAll("SELECT * FROM properties_list", {}, function(result)
        TriggerClientEvent("Property:ActualizeProperties", -1, result)
    end)
end)

ESX.RegisterServerCallback("ESX:getAccess", function(source, cb, pName)
    MySQL.Async.fetchAll("SELECT properties_access.label AS 'player_name', properties_access.identifier AS 'player_identifier' FROM properties_access WHERE id_property = @name", {
        ["@name"] = pName
    }, function(result)
        cb(result)
    end)
end)

function ActualizesPerso(src, access, blips)
    Server.Properties = {}

    MySQL.Async.fetchAll("SELECT * FROM properties_list", {}, function(result)
        TriggerClientEvent("Property:ActualizePropertiesPerso", src, result, access, blips)
    end)
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(source, xPlayer)
    local _src = source
    local xPlayer = ESX.GetPlayerFromId(_src)

    if not GetAccessCrew[_src] then
        MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
            ["@identifier"] = xPlayer.identifier
        }, function(result)

            if json.encode(result[1]) ~= "null" then
                local id_grade = result[1].id_grade
                local id_crew = result[1].id_crew
    
                MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_grade = @id_grade', {
                    ['@id_grade'] = id_grade
                }, function(result2)
    
                    if result2[1].acces_property == 1 then
                        GetAccessCrew[_src] = id_crew
                    else
                        GetAccessCrew[_src] = nil
                    end
                end)
            end
        end)
    end

    Wait(1500)

    PropertyAccess[_src] = {}
    PropertyAccessBlips[_src] = {}

    MySQL.Async.fetchAll("SELECT * FROM properties_access WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        for k, v in pairs(result) do
            table.insert(PropertyAccess[_src], v.id_property)

            MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE id_property = @id_property", {
                ["@id_property"] = v.id_property
            }, function(result)
                for a, b in pairs(result) do
                    table.insert(PropertyAccessBlips[_src], b)
                end
            end)
        end
    end)

    MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE property_owner = @property_owner", {
        ["@property_owner"] = xPlayer.identifier
    }, function(result)
        for k, v in pairs(result) do
            table.insert(PropertyAccess[_src], v.id_property)
            table.insert(PropertyAccessBlips[_src], v)
        end
    end)
    
    MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE jobs = @jobs", {
        ["@jobs"] = xPlayer.getJob().name
    }, function(result)
        for k, v in pairs(result) do
            table.insert(PropertyAccess[_src], v.id_property)
            table.insert(PropertyAccessBlips[_src], v)
        end
    end)

    if GetAccessCrew[_src] ~= nil then
        MySQL.Async.fetchAll("SELECT * FROM properties_list WHERE id_crew = @id_crew", {
            ["@id_crew"] = GetAccessCrew[_src]
        }, function(result)
            for k, v in pairs(result) do
                table.insert(PropertyAccess[_src], v.id_property)
                table.insert(PropertyAccessBlips[_src], v)
            end
        end)
    end

    Wait(4550)

    ActualizesPerso(_src, PropertyAccess[_src], PropertyAccessBlips[_src])
end)

ESX.RegisterServerCallback("ESX:getVehicles", function(source, cb, pName)
    MySQL.Async.fetchAll("SELECT * FROM properties_vehicles WHERE id_property = @pName", {
        ["@pName"] = pName
    }, function(result)
        cb(result)
    end)
end)

RegisterNetEvent("ESX:attributePropertyToJob")
AddEventHandler("ESX:attributePropertyToJob", function(pName, job)
    MySQL.Async.execute("UPDATE properties_list SET jobs = @jobs WHERE property_name = @pName", {
        ["@jobs"] = job,
        ["@pName"] = pName
    })
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then 
        TriggerClientEvent("esx:showNotification", xPlayer.source, "~b~Vous avez attribuer la propriété à votre métier.")

        Wait(500)
        TriggerEvent("Property:Actualizes")
    end
end)

ESX.RegisterServerCallback("ESX:ringPropertyCrew", function(source, cb, idcrew)
    MySQL.Async.fetchAll("SELECT identifier FROM crew_membres WHERE id_crew = @id_crew", {
        ["@id_crew"] = idcrew
    }, function(result)

        if result then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback("ESX:ringPropertyJob", function(source, cb, metier)
    MySQL.Async.fetchAll("SELECT identifier FROM users WHERE job = @job", {
        ["@job"] = metier
    }, function(result)
        if result then
            cb(result)
        else
            cb(nil)
        end
    end)
end)

ESX.RegisterServerCallback("GetDimandPlayer", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM diamond WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if result[1] then
            cb(true)
        else
            if xPlayer.getGroup() == 'superadmin' or xPlayer.getGroup() == 'admin' or xPlayer.getGroup() == 'moderator' then
                cb(true)
            elseif xPlayer.getGroup() == "user" then
                cb(false)
            end
        end
    end)
end)

ESX.RegisterServerCallback("GetDayLocation", function(source, cb, Time, span)
    local endtime = os.time({year = Time.year, month = Time.month, day = Time.day + span, hour = Time.hour, min = Time.min, sec = Time.sec})

    local DateFin = {day = os.date("%d", endtime), month = os.date("%m", endtime), year = os.date("%Y", endtime), hour = os.date("%H", endtime),  min = os.date("%M", endtime)}
    cb(DateFin)
end)

local Table = {}

function LoadInTable()
    local xPlayers 	= ESX.GetPlayers()

    for i = 1, #xPlayers, 1 do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])

        MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
            ["@identifier"] = xTarget.identifier
        }, function(row2)
            if row2[1] then
                Table[xTarget.identifier] = row2[1]
            end
        end)
    end
end

RegisterNetEvent("StartAttackLabo")
AddEventHandler("StartAttackLabo", function(crew, name, id, x, y, z)
    LoadInTable()
    local xPlayer = ESX.GetPlayerFromId(source)
    local xPlayers 	= ESX.GetPlayers()
    local countCrewSource = 0
    local countCrewSourceAttacked = 0

    Wait(500)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(row)

        if row[1] ~= nil then
            local crewsource = row[1].id_crew

            for i = 1, #xPlayers, 1 do
                local xTarget = ESX.GetPlayerFromId(xPlayers[i])
                MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
                    ["@identifier"] = xTarget.identifier
                }, function(row2)
                    if row2[1] then
                        local crewplayer = row2[1].id_crew

                        if crewplayer == crew then
                            countCrewSourceAttacked = countCrewSourceAttacked + 1
                        end
                        
                        if crewplayer == crewsource then
                            countCrewSource = countCrewSource + 1
                        end
                    end
                end)
            end

            for i = 1, #xPlayers, 1 do
                local xTarget = ESX.GetPlayerFromId(xPlayers[i])

                MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
                    ["@identifier"] = xTarget.identifier
                }, function(row2)
                    if row2[1] then
                        local crewplayer = row2[1].id_crew

                        if crewplayer == crew then
                            if countCrewSourceAttacked >= 0 and countCrewSource >= 0 then
                                xTarget.showNotification("Votre propriété ~b~("..name..")~s~ se fait attaquer par un groupe.")
                            end
                        end
                        
                        if crewplayer == crewsource then
                            if countCrewSourceAttacked >= 0 and countCrewSource >= 0 then
                                TriggerClientEvent("AttackLaboCount", xTarget.source, x, y, z, crewsource, id)
                                TriggerClientEvent('ChangeHaveStartedAttack', xTarget.source, true)
                                xTarget.showNotification("~b~Votre crew a lancé une attaque sur une propriété restez dans la zone.")
                            else
                                xPlayer.showNotification("~r~Pas assez de membres connectés pour attaquer le laboratoire")
                            end
                        end
                    end
                end)
            end
        end
    end)
end)

RegisterNetEvent("AddPourcentageSv")
AddEventHandler("AddPourcentageSv", function(idcrew)
    local xPlayers 	= ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        local crewplayer = nil
        if Table[xTarget.identifier] then
            crewplayer = Table[xTarget.identifier].id_crew
        else
            crewplayer = nil
        end
        if crewplayer ~= nil then
            if crewplayer == idcrew then
                TriggerClientEvent("AddPourcentageCl", xTarget.source)
            end
        end
    end
end)

RegisterNetEvent('WinPropertyAttack')
AddEventHandler('WinPropertyAttack', function(crewId, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    MySQL.Async.execute('UPDATE `properties_list` SET `property_owner` = @owner, `id_crew` = @crew, `jobs` = @job WHERE id_property = @property', {
        ['@owner'] = xPlayer.identifier,
        ['@crew'] = crewId,
        ['@property'] = id,
        ['@job'] = nil
    })
    MySQL.Async.execute('DELETE FROM properties_access WHERE id_property='..id..'')
    local xPlayers 	= ESX.GetPlayers()
    for i = 1, #xPlayers, 1 do
        local xTarget = ESX.GetPlayerFromId(xPlayers[i])
        local crewplayer = Table[xTarget.identifier].id_crew

        if crewplayer == crewId then
            xTarget.showNotification('~g~Les accès de la propriété vous ont été attribués')
            TriggerClientEvent('StopAttack', xTarget.source)
        end
    end
    Wait(500)
    TriggerEvent("Property:Actualizes")
end)