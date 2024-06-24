local ContextUI = {
    Entity = {
        ID = nil,
        Type = nil,
        Model = nil,
        ServerID = nil
    },
    ContextActive = false
}

function ContextUI.ScreenToWorld(distance, flags)
    local camRot = GetGameplayCamRot(0)
    local camPos = GetGameplayCamCoord()
    local mouse = vector2(GetControlNormal(2, 239), GetControlNormal(2, 240))
    local cam3DPos, forwardDir = ContextUI.ScreenRelToWorld(camPos, camRot, mouse)
    local direction = camPos + forwardDir * distance
    local rayHandle = StartExpensiveSynchronousShapeTestLosProbe(cam3DPos, direction, flags, 0, 0)
    local _, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(rayHandle)
    return (hit == 1 and true or false), endCoords, surfaceNormal, entityHit, (entityHit >= 1 and GetEntityType(entityHit) or 0), direction, mouse
end

function ContextUI.ScreenRelToWorld(camPos, camRot, cursor)
    local camForward = ContextUI.RotationToDirection(camRot)
    local rotUp = vector3(camRot.x + 1.0, camRot.y, camRot.z)
    local rotDown = vector3(camRot.x - 1.0, camRot.y, camRot.z)
    local rotLeft = vector3(camRot.x, camRot.y, camRot.z - 1.0)
    local rotRight = vector3(camRot.x, camRot.y, camRot.z + 1.0)
    local camRight = ContextUI.RotationToDirection(rotRight) - ContextUI.RotationToDirection(rotLeft)
    local camUp = ContextUI.RotationToDirection(rotUp) - ContextUI.RotationToDirection(rotDown)
    local rollRad = -(camRot.y * math.pi / 180.0)
    local camRightRoll = camRight * math.cos(rollRad) - camUp * math.sin(rollRad)
    local camUpRoll = camRight * math.sin(rollRad) + camUp * math.cos(rollRad)
    local point3DZero = camPos + camForward * 1.0
    local point3D = point3DZero + camRightRoll + camUpRoll
    local point2D = ContextUI.World3DToScreen2D(point3D)
    local point2DZero = ContextUI.World3DToScreen2D(point3DZero)
    local scaleX = (cursor.x - point2DZero.x) / (point2D.x - point2DZero.x)
    local scaleY = (cursor.y - point2DZero.y) / (point2D.y - point2DZero.y)
    local point3Dret = point3DZero + camRightRoll * scaleX + camUpRoll * scaleY
    local forwardDir = camForward + camRightRoll * scaleX + camUpRoll * scaleY
    return point3Dret, forwardDir
end

function ContextUI.RotationToDirection(rotation)
    local x, z = (rotation.x * math.pi / 180.0), (rotation.z * math.pi / 180.0)
    local num = math.abs(math.cos(x))
    return vector3((-math.sin(z) * num), (math.cos(z) * num), math.sin(x))
end

function ContextUI.World3DToScreen2D(pos)
    local _, sX, sY = GetScreenCoordFromWorldCoord(pos.x, pos.y, pos.z)
    return vector2(sX, sY)
end

function ContextUI.CloseContext(Entity)
    ResetEntityAlpha(Entity)
    ContextUI.ContextActive = false
end

function ContextUI.ContextMenu(status)
    ContextUI.ContextActive = status
    while ContextUI.ContextActive do
        SetMouseCursorActiveThisFrame()
        DisableControlAction(0, 1)
        DisableControlAction(0, 2)
        DisableControlAction(0, 4)
        DisableControlAction(0, 5)
        DisableControlAction(0, 24)
        DisableControlAction(0, 25)
        local isFound, entityCoords, surfaceNormal, entityHit, entityType, cameraDirection, mouse = ContextUI.ScreenToWorld(35.0, 31)
        if entityType ~= 0 then
            SetMouseCursorSprite(5)
            if ContextUI.Entity.ID ~= entityHit then
                ResetEntityAlpha(ContextUI.Entity.ID)
                ContextUI.Entity.ID = entityHit
                SetEntityAlpha(ContextUI.Entity.ID, 200, false)
            end
            if IsDisabledControlJustPressed(0, 24) then     
                ContextUI.Entity = {
                    Type = entityType,
                    Model = GetEntityModel(entityHit),
                    ServerID = GetPlayerServerId(NetworkGetPlayerIndexFromPed(entityHit)),
                    EntityID = ContextUI.Entity.ID,
                    Coords = entityCoords
                }
                ContextUI.EntityAction(ContextUI.Entity)
            end
        else
            if ContextUI.Entity.ID ~= nil then
                ResetEntityAlpha(ContextUI.Entity.ID)
                ContextUI.Entity.ID = nil
            end
            SetMouseCursorSprite(1)
        end

        Wait(1)
    end

    if not ContextUI.ContextActive then
        ResetEntityAlpha(ContextUI.Entity.ID)
        ContextUI.Entity.ID = nil
    end
end

RegisterKeyMapping('+contextmenu', 'Menu Contextuel', 'keyboard', 'GRAVE')

RegisterCommand('+contextmenu', function()
    ContextUI.ContextMenu(true)
end)

RegisterCommand('-contextmenu', function()
    ContextUI.ContextMenu(false)
end)

function ContextUI.CheckCoords(coords)
    return GetDistanceBetweenCoords(GetEntityCoords(GetPlayerPed(-1)), coords)
end

function openInfoPlayer(Menu, IdPlayer)
    SetKeepInputMode(true)
	SendNUIMessage({crosshair = true})
	showMenu = true
	SetNuiFocus(true, true)
	SendNUIMessage({menu = Menu, idEntity = IdPlayer})
end

function ContextUI.EntityAction(Entity)
    if Entity.Type == 1 then
        print(GetPlayerServerId(PlayerId()))
        print(Entity.ServerID)
        if GetPlayerServerId(PlayerId()) ~= Entity.ServerID then
            if ContextUI.CheckCoords(Entity.Coords) <= 1.5 then
                ContextUI.CloseContext(Entity.EntityID)
                openInfoPlayer("joueur", Entity.ServerID)
            else
                openInfoPlayer("infoply", Entity.ServerID)
            end
        end
    elseif Entity.Type == 2 then
        if Entity.Model == GetHashKey("bmx") or Entity.Model == GetHashKey("cruiser") or Entity.Model == GetHashKey("fixter") or Entity.Model == GetHashKey("scorcher") or Entity.Model == GetHashKey("tribike") or Entity.Model == GetHashKey("tribike2") or Entity.Model == GetHashKey("tribike3") then
            if ContextUI.CheckCoords(Entity.Coords) <= 1.5 then
                ContextUI.CloseContext(Entity.EntityID)
                TriggerEvent('OpenMenuRoue', 'bmx')
            end
        else
            if ContextUI.CheckCoords(Entity.Coords) <= 3 then
                ContextUI.CloseContext(Entity.EntityID)
                TriggerEvent('OpenMenuRoue', 'vehicule')
            end
        end
    end
end