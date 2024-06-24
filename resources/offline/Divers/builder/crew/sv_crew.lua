ESX = nil

TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("GetPermGestion", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if json.encode(result[1]) ~= "null" then
            local id_grade = result[1].id_grade

            MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_grade = @id_grade', {
                ['@id_grade'] = id_grade
            }, function(result2)

                if result2[1].gestion == 1 then
                    cb(true)
                else
                    cb(false)
                end
            end)
        end
    end)
end)

ESX.RegisterServerCallback("GetCrewPly", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll('SELECT * FROM crew_membres WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
	}, function(result)

		if result[1] == nil then
			cb(true)
        end
    end)
end)

ESX.RegisterServerCallback("ListeMembres", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result2)

        local id_crew = result2[1].id_crew

        MySQL.Async.fetchAll('SELECT * FROM crew_membres WHERE id_crew = @id_crew', {
            ['@id_crew'] = id_crew
        }, function(result)
            cb(result)
        end)
    end)
end)

ESX.RegisterServerCallback("GetAllRang", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        local id_crew = result[1].id_crew

        MySQL.Async.fetchAll('SELECT * FROM crew_grades WHERE id_crew = @id_crew', {
            ['@id_crew'] = id_crew
        }, function(result2)
            cb(result2)
        end)
    end)
end)

ESX.RegisterServerCallback("InfosCrew", function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        local id_crew = result[1].id_crew

        MySQL.Async.fetchAll('SELECT * FROM crew_liste WHERE id_crew = @id_crew', {
            ['@id_crew'] = id_crew
        }, function(result2)
            cb(result2)
        end)
    end)
end)

------
------

RegisterNetEvent("CreateCrew")
AddEventHandler("CreateCrew", function(name, devise, namechef, tableGrades)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT name FROM crew_liste WHERE name = @name", {
        ["@name"] = name
    }, function(result1)

        if not result1[1] then

            MySQL.Async.execute("INSERT INTO crew_liste (name, devise) VALUES(@name, @devise)", {
                ["@name"] = name,
                ["@devise"] = devise
            })

            Wait(1500)

            MySQL.Async.fetchAll("SELECT * FROM crew_liste WHERE name = @name", {
                ["@name"] = name
            }, function(result2)

                local id_crew = result2[1].id_crew

                Wait(1500)

                MySQL.Async.execute("INSERT INTO crew_grades (name, rang, id_crew, gestion, sell_vehicle) VALUES (@name, @rang, @id_crew, @gestion, @sell_vehicle)", {
                    ["@name"] = namechef,
                    ["@rang"] = 1,
                    ["@gestion"] = 1,
                    ["@sell_vehicle"] = 1,
                    ["@id_crew"] = tonumber(id_crew)
                })

                for k, v in pairs(tableGrades) do
                    MySQL.Async.execute("INSERT INTO crew_grades (name, rang, id_crew) VALUES (@name, @rang, @id_crew)", {
                        ["@name"] = v.name,
                        ["@rang"] = tonumber(v.rang),
                        ["@id_crew"] = tonumber(id_crew)
                    })
                end
      
                MySQL.Async.fetchAll("SELECT * FROM crew_grades WHERE id_crew = @id_crew AND rang = @rang", {
                    ["@id_crew"] = tonumber(id_crew),
                    ["@rang"] = 1
                }, function(result4)

                    local id_gradechef = result4[1].id_grade

                    Wait(1050)

                    MySQL.Async.execute("INSERT INTO crew_membres (identifier, label, id_grade, label_grade, rang_grade, id_crew) VALUES (@identifier, @label, @id_grade, @label_grade, @rang_grade, @id_crew)", {
                        ["@identifier"] = xPlayer.identifier,
                        ["@label"] =  xPlayer.getIdentity(),
                        ["@id_grade"] = id_gradechef,
                        ["label_grade"] = namechef,
                        ["rang_grade"] = 1,
                        ["@id_crew"] = tonumber(id_crew)
                    })
                end)
                xPlayer.showNotification("Vous avez créer le crew ~b~"..name.."~s~ avec la devise ~b~"..devise.."~s~ avec ~b~"..(#tableGrades+1).."~s~ grades.")
            end)
        end
    end)
end)

RegisterNetEvent("FireThePlayer")
AddEventHandler("FireThePlayer", function(identifier)
    MySQL.Async.execute("DELETE FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = identifier
    })
end)

RegisterNetEvent("LeaveCrew")
AddEventHandler("LeaveCrew", function()
    local xPlayer = ESX.GetPlayerFromId(source)
    
    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        if result[1] then

            MySQL.Async.execute("DELETE FROM crew_membres WHERE identifier = @identifier", {
                ["@identifier"] = xPlayer.identifier
            })
            xPlayer.showNotification("Vous avez pris la décision de ~r~quitter~s~ votre crew.")
        else
            xPlayer.showNotification("~r~Vous faite partie de aucun crew.")
        end
    end)
end)

local TableJoinSource = {}
local TableJoinTargetName = {}
local TableJoinLastGrade = {}
local TableJoinGradeName = {}
local TableJoinGradeRang = {}
local TableJoinid_crew = {}

RegisterServerEvent("RecrutThePlayer")
AddEventHandler("RecrutThePlayer", function(target)
    local xTarget = ESX.GetPlayerFromId(target)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xTarget.identifier
    }, function(result)
        if not result[1] then

            MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
                ["@identifier"] = xPlayer.identifier
            }, function(result1)

                local id_crew = result1[1].id_crew

                Wait(150)
                MySQL.Async.fetchAll("SELECT * FROM crew_grades WHERE id_crew = @id_crew ORDER BY rang DESC", {
                    ["@id_crew"] = id_crew
                }, function(result2)
                    if result2[1] then
                        local LastGrade = result2[1].id_grade
                        local GradeName = result2[1].name
                        local GradeRang = result2[1].rang
                        
                        MySQL.Async.fetchAll("SELECT * FROM crew_liste WHERE id_crew = @id_crew", {
                            ["@id_crew"] = id_crew
                        }, function(result3)

                            local CrewName = result3[1].name
                            local TargetName = xTarget.getIdentity()

                            xPlayer.showNotification("Vous avez proposé à ~b~"..TargetName.."~s~ de rejoindre votre crew.")
                            TriggerClientEvent("SolutionJoinCrew", xTarget.source, CrewName)
                            TableJoinSource[xTarget.source] = xPlayer.source
                            TableJoinTargetName[xTarget.source] = TargetName
                            TableJoinLastGrade[xTarget.source] = LastGrade
                            TableJoinGradeName[xTarget.source] = GradeName
                            TableJoinGradeRang[xTarget.source] = GradeRang
                            TableJoinid_crew[xTarget.source] = id_crew
                        end)
                    end
                end)
            end)
        else
            xPlayer.showNotification("~r~La personne est déjà dans un crew.")
        end
    end)
end)

RegisterNetEvent("JoinCrew")
AddEventHandler("JoinCrew", function()
    local xPlayer = ESX.GetPlayerFromId(source)

    if TableJoinSource[xPlayer.source] then
        local TargetName = TableJoinTargetName[xPlayer.source]
        local LastGrade = TableJoinLastGrade[xPlayer.source]
        local GradeName = TableJoinGradeName[xPlayer.source]
        local GradeRang = TableJoinGradeRang[xPlayer.source]
        local id_crew = TableJoinid_crew[xPlayer.source]

        MySQL.Async.execute("INSERT INTO crew_membres (identifier, label, id_grade, label_grade, rang_grade, id_crew) VALUES (@identifier, @label, @id_grade, @label_grade, @rang_grade, @id_crew)", {
            ["@identifier"] = xPlayer.identifier,
            ["@label"] = TargetName,
            ["@id_grade"] = LastGrade,
            ["@label_grade"] = GradeName,
            ["@rang_grade"] = GradeRang,
            ["@id_crew"] = id_crew
        })
    end
end)

RegisterNetEvent("AlertJoinCrew")
AddEventHandler("AlertJoinCrew", function(type)
    local xPlayer = ESX.GetPlayerFromId(source)
    local aSrc = TableJoinSource[xPlayer.source]
    local aPlayer = ESX.GetPlayerFromId(aSrc)

    if TableJoinSource[xPlayer.source] then
        if type == 1 then
            aPlayer.showNotification("~r~La personne à mis trop de temps à choisir.")
            TableJoinSource[xPlayer.source] = nil
        elseif type == 2 then
            aPlayer.showNotification("~r~La personne à refusé de rejoindre votre crew.")
            TableJoinSource[xPlayer.source] = nil
        elseif type == 3 then
            aPlayer.showNotification("~b~La personne a accepté de rejoindre votre crew.")
            TableJoinSource[xPlayer.source] = nil
        end
    end
end)

RegisterNetEvent("FireTarget")
AddEventHandler("FireTarget", function(target)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(target)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)

        if result[1] then
            local CrewSource = result[1].id_crew

            MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
                ["@identifier"] = xTarget.identifier
            }, function(result1)

                if result1[1] then
                    local CrewTarget = result1[1].id_crew

                    if result1[1].rang_grade ~= 1 then
                        if CrewSource == CrewTarget then
                            MySQL.Async.execute("DELETE FROM crew_membres WHERE identifier = @identifier", {
                                ["@identifier"] = xTarget.identifier
                            })
                            xPlayer.showNotification("Vous avez ~b~expulsé~s~ la personne de votre crew.")
                            xTarget.showNotification("Vous avez été ~b~expulsé~s~ de votre crew.")
                        end
                    else
                        xPlayer.showNotification("Vous ne pouvez pas ~b~expulsé~s~ le créateur du crew.")
                    end
                end
            end)
        end
    end)
end)

RegisterNetEvent("EditRang")
AddEventHandler("EditRang", function(identifier, id_grade, label_grade, rang_grade)
    MySQL.Async.execute("UPDATE crew_membres SET id_grade = @id_grade, label_grade = @label_grade, rang_grade = @rang_grade WHERE identifier = @identifier", {
        ["@identifier"] = identifier,
        ["@id_grade"] = id_grade,
        ["@label_grade"] = label_grade,
        ["@rang_grade"] = rang_grade
    })
end)

RegisterNetEvent("AddNewRang")
AddEventHandler("AddNewRang", function(name)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE identifier = @identifier", {
        ["@identifier"] = xPlayer.identifier
    }, function(result)
        local id_crew = result[1].id_crew

        MySQL.Async.fetchAll("SELECT * FROM crew_grades WHERE id_crew = @id_crew ORDER BY rang DESC", {
            ["@id_crew"] = id_crew,
            ["@rang"] = rang
        }, function(result2)
            if result2[1] then
                local lastID = result2[1].rang

                MySQL.Async.execute("INSERT INTO crew_grades (name, rang, id_crew) VALUES (@name, @rang, @id_crew)", {
                    ["@name"] = name,
                    ["@rang"] = (lastID+1),
                    ["@id_crew"] = tonumber(id_crew)
                })
            end
        end)
    end)
end)

RegisterNetEvent("UpdateAccesGestionCrew")
AddEventHandler("UpdateAccesGestionCrew", function(status, id_grade)
    MySQL.Async.execute("UPDATE crew_grades SET gestion = @gestion WHERE id_grade = @id_grade", {
        ["@id_grade"] = id_grade,
        ["@gestion"] = status
    })
end)

RegisterNetEvent("UpdateAccesPropertyCrew")
AddEventHandler("UpdateAccesPropertyCrew", function(status, id_grade)
    MySQL.Async.execute("UPDATE crew_grades SET acces_property = @acces_property WHERE id_grade = @id_grade", {
        ["@id_grade"] = id_grade,
        ["@acces_property"] = status
    })
end)

RegisterNetEvent("UpdateAccesChestPropertyCrew")
AddEventHandler("UpdateAccesChestPropertyCrew", function(status, id_grade)
    MySQL.Async.execute("UPDATE crew_grades SET acces_chest = @acces_chest WHERE id_grade = @id_grade", {
        ["@id_grade"] = id_grade,
        ["@acces_chest"] = status
    })
end)

RegisterNetEvent("UpdateAccesKeyVehicleCrew")
AddEventHandler("UpdateAccesKeyVehicleCrew", function(status, id_grade)
    MySQL.Async.execute("UPDATE crew_grades SET key_vehicle = @key_vehicle WHERE id_grade = @id_grade", {
        ["@id_grade"] = id_grade,
        ["@key_vehicle"] = status
    })
end)

RegisterNetEvent("UpdateAccesSellVehicleCrew")
AddEventHandler("UpdateAccesSellVehicleCrew", function(status, id_grade)
    MySQL.Async.execute("UPDATE crew_grades SET sell_vehicle = @sell_vehicle WHERE id_grade = @id_grade", {
        ["@id_grade"] = id_grade,
        ["@sell_vehicle"] = status
    })
end)

RegisterNetEvent("DeleteGrade")
AddEventHandler("DeleteGrade", function(idgrade)

    MySQL.Async.execute("DELETE FROM crew_grades WHERE id_grade = @id_grade", {
        ["@id_grade"] = idgrade
    })

    Wait(150)

    MySQL.Async.fetchAll("SELECT * FROM crew_membres WHERE id_grade = @id_grade", {
        ["@id_grade"] = idgrade
    }, function(result)
        if result then

            for k, v in pairs(result) do
                Identifier = v.identifier

                MySQL.Async.execute("DELETE FROM crew_membres WHERE identifier = @identifier", {
                    ["@identifier"] = Identifier
                })
            end
        end
    end)
end)