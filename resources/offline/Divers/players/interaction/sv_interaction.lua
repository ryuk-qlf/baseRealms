ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("GetPermSellVehicle", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if json.encode(result[1]) ~= "null" then
            local id_grade = result[1].id_grade

            MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_grade = @id_grade', {
                ['@id_grade'] = id_grade
            }, function(result2)

                if result2[1].sell_vehicle == 1 then
                    cb(true)
                else
                    cb(false)
                end
            end)
        end
    end)
end)

ESX.RegisterServerCallback("GetVehicleCrewPawn", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if json.encode(result[1]) ~= "null" then
            local id_crew = result[1].id_crew

            MySQL.Async.fetchAll('SELECT * FROM crew_vehicles WHERE crew = @crew', {
                ['@crew'] = id_crew
            }, function(result2)

                cb(result2)
            end)
        end
    end)
end)

ESX.RegisterServerCallback("GetVehicleJobPawn", function(source, cb, job)
    local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll("SELECT * FROM jobs_vehicles WHERE job = @job", {
            ["@job"] = job
        }, function(result)

        cb(result)
    end)
end)

ESX.RegisterServerCallback("GetVehiclePersoPawn", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll("SELECT * FROM vehicle_owner WHERE owner = @owner", {
            ["@owner"] = xPlayer.identifier
        }, function(result)

        cb(result)
    end)
end)

ESX.RegisterServerCallback("GetVehiclePret", function(source, cb, plate)
    local xPlayer = ESX.GetPlayerFromId(source)

        MySQL.Async.fetchAll("SELECT * FROM vehicle_key WHERE plate = @plate", {
            ["@plate"] = plate
        }, function(result)

        cb(result)
    end)
end)

RegisterNetEvent("givecarKey")
AddEventHandler("givecarKey", function(custom, model, plate, target, type)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xTarget.job.name == "pawnshop" or xTarget.job.name == "pawnnord" then
        if #(GetEntityCoords(GetPlayerPed(source))-GetEntityCoords(GetPlayerPed(target))) < 15 then
            if type == "crew" then
                MySQL.Async.execute("DELETE FROM crew_vehicles WHERE plate = @plate", {
                    ["@plate"] = plate
                })
            elseif type == "job" then
                MySQL.Async.execute("DELETE FROM jobs_vehicles WHERE plate = @plate", {
                    ["@plate"] = plate
                })
            elseif type == "perso" then
                MySQL.Async.execute("DELETE FROM vehicle_owner WHERE plate = @plate", {
                    ["@plate"] = plate
                })
                MySQL.Async.execute("DELETE FROM vehicle_key WHERE plate = @plate", {
                    ["@plate"] = plate
                })
            end

            MySQL.Async.execute("INSERT INTO jobs_vehicles (job, model, plate, custom, pound) VALUES (@job, @model, @plate, @custom, @pound)", {
                ["@job"] = xTarget.job.name,
                ["@model"] = model,
                ["@plate"] = plate,
                ["@custom"] = custom,
                ["@pound"] = 0,
            })
            xPlayer.showNotification("Vous avez donné les clés du véhicule immaticulé : ~o~"..plate)
            xTarget.showNotification("Vous avez reçu les clés du véhicule immaticulé : ~o~"..plate)
        else
            DropPlayer(source, "cheat GiveCarKey")
        end
    else
        xPlayer.showNotification("~r~La personne n'est pas un employé du~w~ ~y~Pawn-Shop~s~.")
    end
end)

RegisterNetEvent("giveCarSell")
AddEventHandler("giveCarSell", function(custom, model, plate, target, type)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("DELETE FROM jobs_vehicles WHERE plate = @plate", {
        ["@plate"] = plate
    })
    if type == "crew" then
        MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
            ["@identifier"] = xTarget.identifier
        }, function(result)
    
            local id_crew = result[1].id_crew

            MySQL.Async.execute("INSERT INTO crew_vehicles (crew, model, plate, custom, pound) VALUES (@crew, @model, @plate, @custom, @pound)", {
                ["@crew"] = id_crew,
                ["@model"] = model,
                ["@plate"] = plate,
                ["@custom"] = custom,
                ["@pound"] = 0
            })
        end)

        MySQL.Async.execute("INSERT INTO vehicle_key (identifier, plate) VALUES (@identifier, @plate)", {
            ["@identifier"] = xTarget.identifier,
            ["@plate"] = plate
        })
    elseif type == "job" then
        MySQL.Async.execute("INSERT INTO jobs_vehicles (job, model, plate, custom, pound) VALUES (@job, @model, @plate, @custom, @pound)", {
            ["@job"] = xPlayer.job.name,
            ["@model"] = model,
            ["@plate"] = plate,
            ["@custom"] = custom,
            ["@pound"] = 0
        })

        MySQL.Async.execute("INSERT INTO vehicle_key (identifier, plate) VALUES (@identifier, @plate)", {
            ["@identifier"] = xTarget.identifier,
            ["@plate"] = plate
        })
    elseif type == "perso" then
        MySQL.Async.execute("INSERT INTO vehicle_owner (owner, model, plate, custom, pound) VALUES (@owner, @model, @plate, @custom, @pound)", {
            ["@owner"] = xTarget.identifier,
            ["@model"] = model,
            ["@plate"] = plate,
            ["@custom"] = custom,
            ["@pound"] = 0
        })

        MySQL.Async.execute("INSERT INTO vehicle_key (identifier, plate) VALUES (@identifier, @plate)", {
            ["@identifier"] = xTarget.identifier,
            ["@plate"] = plate
        })
    end

    xPlayer.showNotification("Vous avez donné les clés du véhicule immaticulé : ~o~"..plate)
    xTarget.showNotification("Vous avez reçu les clés du véhicule immaticulé : ~o~"..plate)
end)

RegisterNetEvent("lendcarKey")
AddEventHandler("lendcarKey", function(plate, target)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM vehicle_key WHERE plate = @plate AND identifier = @identifier", {
        ["@plate"] = plate,
        ["@identifier"] = xTarget.identifier
    }, function(row)
        if not row[1] then
            MySQL.Async.execute("INSERT INTO vehicle_key (identifier, label, plate) VALUES (@identifier, @label, @plate)", {
                ["@identifier"] = xTarget.identifier,
                ["@label"] = xTarget.getIdentity(),
                ["@plate"] = plate
            })

            xPlayer.showNotification("Vous avez prêté les clés du véhicule immaticulé : ~o~"..plate)
            xTarget.showNotification("Vous avez reçu le prêt des clés du véhicule immaticulé : ~o~"..plate)
        else
            xPlayer.showNotification("~r~La personne possède déjà les clés du véhicule.")
        end
    end)
end)

RegisterNetEvent("retraitKey")
AddEventHandler("retraitKey", function(identifier, plate)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.execute("DELETE FROM vehicle_key WHERE plate = @plate AND identifier = @identifier", {
        ["@plate"] = plate,
        ["@identifier"] = identifier
    })

    xPlayer.showNotification("Vous avez retiré les clés du véhicule immaticulé : ~o~"..plate)
end)

RegisterNetEvent("annoncePawnShop")
AddEventHandler("annoncePawnShop", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "pawnshop" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "PawnShop Sud", "~b~Annonce ", input, 'CHAR_PROPERTY_BAR_TEQUILALA', 1)
    elseif xPlayer.job.name == "pawnnord" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "PawnShop Nord", "~b~Annonce ", input, 'CHAR_PROPERTY_BAR_TEQUILALA', 1)
    else
        DropPlayer(source, "cheat AnnoncePawnShop")
    end
end)

RegisterNetEvent("annonceUnicorn")
AddEventHandler("annonceUnicorn", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "unicorn" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "Vanilla Unicorn", "~b~Annonce ", input, 'CHAR_MP_STRIPCLUB_PR', 1)
    else
        DropPlayer(source, "cheat AnnoncePawnShop")
    end
end)

RegisterNetEvent("annonceBahama")
AddEventHandler("annonceBahama", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "bahama" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "Bahama Mamas", "~b~Annonce ", input, 'CHAR_STRIPPER_JULIET', 1)
    else
        DropPlayer(source, "cheat AnnoncePawnShop")
    end
end)

RegisterNetEvent("annonceThePalace")
AddEventHandler("annonceThePalace", function(input)
    local xPlayer = ESX.GetPlayerFromId(source)

    if xPlayer.job.name == "thepalace" then
        TriggerClientEvent('esx:showAdvancedNotification', -1, "The Palace", "~b~Annonce ", input, 'CHAR_PROPERTY_BAR_SINGLETONS', 1)
    else
        DropPlayer(source, "cheat AnnoncePawnShop")
    end
end)