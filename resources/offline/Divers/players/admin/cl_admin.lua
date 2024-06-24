ESX = nil

local Perm = {}
Perm.PlyGroup = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
    end

    while Perm.PlyGroup == nil do
        Wait(1000)
        ESX.TriggerServerCallback('GetGroup', function(group) 
            Perm.PlyGroup = group 
        end)
		Citizen.Wait(10)
	end
end)

RegisterNetEvent('addPermMenuAdmin')
AddEventHandler('addPermMenuAdmin', function(group)
    Perm.PlyGroup = group
end)

local Animal = {
    ListAnimal = {
        {name = "Sanglier", model = "a_c_boar"},
        {name = "Chat", model = "a_c_cat_01"},
        {name = "Rottweiler 1", model = "a_c_chop"},
        {name = "Rottweiler 2", model = "a_c_rottweiler"},
        {name = "Vache", model = "a_c_cow"},
        {name = "Coyote", model = "a_c_coyote"},
        {name = "Biche", model = "a_c_deer"},
        {name = "Poule", model = "a_c_hen"},
        {name = "Husky", model = "a_c_husky"},
        {name = "Lion", model = "a_c_mtlion"},
        {name = "Cochon", model = "a_c_pig"},
        {name = "Poodle", model = "a_c_poodle"},
        {name = "Bulldog", model = "a_c_pug"},
        {name = "Lapin", model = "a_c_rabbit_01"},
        {name = "Rat", model = "a_c_rat"},
        {name = "Labrador", model = "a_c_retriever"},
        {name = "Chien", model = "a_c_shepherd"},
        {name = "Caniche", model = "a_c_westy"}
    }
}

Animal.openedMenu = false
Animal.mainMenu = RageUI.CreateMenu("Animal", "Animal")
Animal.mainMenu.Closed = function()
    Animal.openedMenu = false
end

RegisterCommand("animal", function()
    ESX.TriggerServerCallback("GetDimandPlayer", function(result)
        if result then
            openAnimal()  
        end
    end)
end)

function openAnimal()
    if Animal.openedMenu then
        Animal.openedMenu = false
        RageUI.Visible(Animal.mainMenu, false)
    else
        Animal.openedMenu = true
        RageUI.Visible(Animal.mainMenu, true)
            CreateThread(function()
                while Animal.openedMenu do
                    RageUI.IsVisible(Animal.mainMenu, function()
                        RageUI.Button("Reprendre son personnage", nil, {}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                    TriggerEvent('skinchanger:loadDefaultModel', skin.sex, function()
                                        ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                                            TriggerEvent('skinchanger:loadSkin', skin)
                                        end)
                                    end)
                                end)
                            end
                        })
                        if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then
                            RageUI.Button("Choisir le ped", nil, {}, true, {
                                onSelected = function()
                                    local index = ESX.KeyboardInput("Model", 30)

                                    if index ~= nil then
                                        local model = GetHashKey(index)
                                        if IsModelInCdimage(model) and IsModelValid(model) then
                                            ESX.ShowNotification("Vous avez sélectionné le model : ~b~"..index)
                                            ESX.ShowNotification("En tant qu'animal vous ne devez pas :~r~\n- Parler\n~r~- Tuer\n~r~- Voler")
                                            RequestModel(model)
                                            while not HasModelLoaded(model) do
                                                Citizen.Wait(0)
                                            end
                                    
                                            SetPlayerModel(PlayerId(), model)
                                            SetPedDefaultComponentVariation(PlayerPedId())
                                            SetModelAsNoLongerNeeded(model)
                                        end
                                    end
                                end
                            })
                        end
                        for k,v in pairs(Animal.ListAnimal) do 
                            RageUI.Button(""..v.name, nil, {}, true, {
                                onSelected = function()
                                    ESX.ShowNotification("Vous avez sélectionné le model : ~b~"..v.name)
                                    ESX.ShowNotification("En tant qu'animal vous ne devez pas :~r~\n- Parler\n~r~- Tuer\n~r~- Voler")
                                    local model = GetHashKey(v.model)
                                    if IsModelInCdimage(model) and IsModelValid(model) then
                                        RequestModel(model)
                                        while not HasModelLoaded(model) do
                                            Citizen.Wait(0)
                                        end
                                
                                        SetPlayerModel(PlayerId(), model)
                                        SetPedDefaultComponentVariation(PlayerPedId())
                                        SetModelAsNoLongerNeeded(model)
                                    end
                                end
                            })
                        end
                    end)            
                Wait(1)
            end
        end)
    end
end

local blips = {}

local Administration = {
    ListInfos = 1,
    ListVeh = 1,
    CheckboxVisible = true,
    CheckboxBlips = false,
    CheckboxGamerTags = false,
    CheckboxGameMod = false,
    CheckboxFreezePlayer = false,
    ConfirmeCrew = false,

    AllPlayers = {},
    GetSanction = {},
    ListeJobs = {},
    ListeGrades = {},
    GetCrewList = {},
    GetCrewGrade = {},
    MpGamerTags = {},
    Table = {},
}

Administration.Cam = nil 
Administration.InSpec = false
Administration.SpeedNoclip = 1
Administration.CamCalculate = nil
Administration.CamTarget = {}
Administration.Scalform = nil 

Administration.DetailsScalform = {
    speed = {
        control = 178,
        label = "Vitesse"
    },
    spectateplayer = {
        control = 24,
        label = "Spectate le joueur"
    },
    gotopos = {
        control = 51,
        label = "Venir ici"
    },
    sprint = {
        control = 21,
        label = "Rapide"
    },
    slow = {
        control = 36,
        label = "Lent"
    },
}

Administration.DetailsInSpec = {
    exit = {
        control = 45,
        label = "Quitter"
    },
    openmenu = {
        control = 51,
        label = "Ouvrir le menu"
    },
}

function DrawTextAdmin(msg, font, size, posx, posy)
    SetTextFont(font) 
    SetTextProportional(0) 
    SetTextScale(size, size) 
    SetTextDropShadow(0, 0, 0, 0,255) 
    SetTextEdge(1, 0, 0, 0, 255) 
    SetTextEntry("STRING") 
    AddTextComponentString(msg or "null") 
    DrawText(posx, posy) 
end

function Administration:TeleportCoords(vector, peds)
	if not vector or not peds then return end
	local x, y, z = vector.x, vector.y, vector.z + 0.98
	peds = peds or PlayerPedId()

	RequestCollisionAtCoord(x, y, z)
	NewLoadSceneStart(x, y, z, x, y, z, 50.0, 0)

	local TimerToGetGround = GetGameTimer()
	while not IsNewLoadSceneLoaded() do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	SetEntityCoordsNoOffset(peds, x, y, z)

	TimerToGetGround = GetGameTimer()
	while not HasCollisionLoadedAroundEntity(peds) do
		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
		Citizen.Wait(0)
	end

	local retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
	TimerToGetGround = GetGameTimer()
	while not retval do
		z = z + 5.0
		retval, GroundPosZ = GetGroundZCoordWithOffsets(x, y, z)
		Wait(0)

		if GetGameTimer() - TimerToGetGround > 3500 then
			break
		end
	end

	SetEntityCoordsNoOffset(peds, x, y, retval and GroundPosZ or z)
	NewLoadSceneStop()
	return true
end

function SetScaleformParams(scaleform, data)
	data = data or {}
	for k,v in pairs(data) do
		PushScaleformMovieFunction(scaleform, v.name)
		if v.param then
			for _,par in pairs(v.param) do
				if math.type(par) == "integer" then
					PushScaleformMovieFunctionParameterInt(par)
				elseif type(par) == "boolean" then
					PushScaleformMovieFunctionParameterBool(par)
				elseif math.type(par) == "float" then
					PushScaleformMovieFunctionParameterFloat(par)
				elseif type(par) == "string" then
					PushScaleformMovieFunctionParameterString(par)
				end
			end
		end
		if v.func then v.func() end
		PopScaleformMovieFunctionVoid()
	end
end
function CreateScaleform(name, data) -- Créer un scalform
	if not name or string.len(name) <= 0 then return end
	local scaleform = RequestScaleformMovie(name)

	while not HasScaleformMovieLoaded(scaleform) do
		Citizen.Wait(0)
	end

	SetScaleformParams(scaleform, data)
	return scaleform
end

function Administration:TeleporteToPoint(ped)
    local pPed = ped or PlayerPedId()
    local bInfo = GetFirstBlipInfoId(8)
    if not bInfo or bInfo == 0 then
        return
    end
    local entity = IsPedInAnyVehicle(pPed, false) and GetVehiclePedIsIn(pPed, false) or pPed
    local bCoords = GetBlipInfoIdCoord(bInfo)
    Administration:TeleportCoords(bCoords, entity)
end

function Administration:ActiveScalform(bool)
    local dataSlots = {
        {
            name = "CLEAR_ALL",
            param = {}
        }, 
        {
            name = "TOGGLE_MOUSE_BUTTONS",
            param = { 0 }
        },
        {
            name = "CREATE_CONTAINER",
            param = {}
        } 
    }
    local dataId = 0
    for k, v in pairs(bool and Administration.DetailsInSpec or Administration.DetailsScalform) do
        dataSlots[#dataSlots + 1] = {
            name = "SET_DATA_SLOT",
            param = {dataId, GetControlInstructionalButton(2, v.control, 0), v.label}
        }
        dataId = dataId + 1
    end
    dataSlots[#dataSlots + 1] = {
        name = "DRAW_INSTRUCTIONAL_BUTTONS",
        param = { -1 }
    }
    return dataSlots
end

function Administration:ControlInCam()
    local p10, p11 = IsControlPressed(1, 10), IsControlPressed(1, 11)
    local pSprint, pSlow = IsControlPressed(1, Administration.DetailsScalform.sprint.control), IsControlPressed(1, Administration.DetailsScalform.slow.control)
    if p10 or p11 then
        Administration.SpeedNoclip = math.max(0, math.min(100, Administration.SpeedNoclip + (p10 and 0.01 or -0.01), 2))
    end
    if Administration.CamCalculate == nil then
        if pSprint then
            Administration.CamCalculate = Administration.SpeedNoclip * 2.0
        elseif pSlow then
            Administration.CamCalculate = Administration.SpeedNoclip * 0.1
        end
    elseif not pSprint and not pSlow then
        if Administration.CamCalculate ~= nil then
            Administration.CamCalculate = nil
        end
    end
    if IsControlJustPressed(0, Administration.DetailsScalform.speed.control) then
        DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", Administration.SpeedNoclip, "", "", "", 5)
        while UpdateOnscreenKeyboard() == 0 do
            Citizen.Wait(10)
            if UpdateOnscreenKeyboard() == 1 and GetOnscreenKeyboardResult() and string.len(GetOnscreenKeyboardResult()) >= 1 then
                Administration.SpeedNoclip = tonumber(GetOnscreenKeyboardResult()) or 1.0
                break
            end
        end
    end
end

function Administration:ManageCam()
    local p32, p33, p35, p34 = IsControlPressed(1, 32), IsControlPressed(1, 33), IsControlPressed(1, 35), IsControlPressed(1, 34)
    local g220, g221 = GetDisabledControlNormal(0, 220), GetDisabledControlNormal(0, 221)
    if g220 ~= 0.0 or g221 ~= 0.0 then
        local cRot = GetCamRot(Administration.Cam, 2)
        new_z = cRot.z + g220 * -1.0 * 10.0;
        new_x = cRot.x + g221 * -1.0 * 10.0
        SetCamRot(Administration.Cam, new_x, 0.0, new_z, 2)
        SetEntityHeading(PlayerPedId(), new_z)
    end
    if p32 or p33 or p35 or p34 then
        local rightVector, forwardVector, upVector = GetCamMatrix(Administration.Cam)
        local cPos = (GetCamCoord(Administration.Cam)) + ((p32 and forwardVector or p33 and -forwardVector or vector3(0.0, 0.0, 0.0)) + (p35 and rightVector or p34 and -rightVector or vector3(0.0, 0.0, 0.0))) * (Administration.CamCalculate ~= nil and Administration.CamCalculate or Administration.SpeedNoclip)
        SetCamCoord(Administration.Cam, cPos)
        SetFocusPosAndVel(cPos)
    end
end

function Administration:StartSpectate(player)
    Administration.CamTarget = player
    Administration.CamTarget.PedHandle = GetPlayerPed(player.id)
    if not DoesEntityExist(Administration.CamTarget.PedHandle) then
        ESX.ShowNotification("~r~Vous etes trop loin de la cible.")
        return
    end
    NetworkSetInSpectatorMode(1, Administration.CamTarget.PedHandle)
    SetCamActive(Administration.Cam, false)
    RenderScriptCams(false, false, 0, false, false)
    SetScaleformParams(Administration.Scalform, Administration:ActiveScalform(true))
    ClearFocus()
end

function Administration:StartSpectateList(player)
    Administration.CamTarget.PedHandle = player

    NetworkSetInSpectatorMode(1, Administration.CamTarget.PedHandle)
    SetCamActive(Administration.Cam, false)
    RenderScriptCams(false, false, 0, false, false)
    SetScaleformParams(Administration.Scalform, Administration:ActiveScalform(true))
    ClearFocus()
end

function Administration:ExitSpectate()
    local pPed = PlayerPedId()
    if DoesEntityExist(Administration.CamTarget.PedHandle) then
        SetCamCoord(Administration.Cam, GetEntityCoords(Administration.CamTarget.PedHandle))
    end
    NetworkSetInSpectatorMode(0, pPed)
    SetCamActive(Administration.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Administration.CamTarget = {}
    SetScaleformParams(Administration.Scalform, Administration:ActiveScalform(true))
end

function Administration:ScalformSpectate()
    if IsControlJustPressed(0, Administration.DetailsInSpec.exit.control) then
        Administration:ExitSpectate()
    end
    if IsControlJustPressed(0, Administration.DetailsInSpec.openmenu.control) then
        Administration.tId = GetPlayerServerId(Administration.CamTarget.id)
        if Administration.tId and Administration.tId > 0 then
            MenuAdministration()
        end
    end
    SetFocusPosAndVel(GetEntityCoords(GetPlayerPed(Administration.CamTarget.id)))
end

function Administration:SpecAndPos()
    if not Administration.CamTarget.id and IsControlJustPressed(0, Administration.DetailsScalform.spectateplayer.control) then
        local qTable = {}
        local CamCoords = GetCamCoord(Administration.Cam)
        local pId = PlayerId()
        for k, v in pairs(GetActivePlayers()) do
            local vPed = GetPlayerPed(v)
            local vPos = GetEntityCoords(vPed)
            local vDist = GetDistanceBetweenCoords(vPos, CamCoords)
            if v ~= pId and vPed and vDist <= 20 and (not qTable.pos or GetDistanceBetweenCoords(qTable.pos, CamCoords) > vDist) then
                qTable = {
                    id = v,
                    pos = vPos
                }
            end
        end
        if qTable and qTable.id then
            Administration:StartSpectate(qTable)
        end
    end
    local camActive = GetCamCoord(Administration.Cam)
    SetEntityCoords(GetPlayerPed(-1), camActive)
    if IsControlJustPressed(1, Administration.DetailsScalform.gotopos.control) then
        Administration:Spectate(camActive)
    end
end

function Administration:RenderCam()
    if not NetworkIsInSpectatorMode() then
        Administration:ControlInCam()
        Administration:ManageCam()
        Administration:SpecAndPos()
    else
        Administration:ScalformSpectate()
    end
    if Administration.Scalform then
        DrawScaleformMovieFullscreen(Administration.Scalform, 255, 255, 255, 255, 0)
    end
end

function Administration:CreateCam()
    Administration.Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(Administration.Cam, true)
    RenderScriptCams(true, false, 0, true, true)
    Administration.Scalform = CreateScaleform("INSTRUCTIONAL_BUTTONS", Administration:ActiveScalform())
end

function Administration:DestroyCam()
    DestroyCam(Administration.Cam)
    RenderScriptCams(false, false, 0, false, false)
    ClearFocus()
    SetScaleformMovieAsNoLongerNeeded(Administration.Scalform)
    if NetworkIsInSpectatorMode() then
        NetworkSetInSpectatorMode(false, Administration.CamTarget.id and GetPlayerPed(Administration.CamTarget.id) or 0)
    end
    Administration.Scalform = nil
    Administration.Cam = nil
    lockEntity = nil
    Administration.CamTarget = {}
end

function Administration:Spectate(pPos)
    local player = PlayerPedId()
    local pPed = player
    Administration.InSpec = not Administration.InSpec
    Wait(0)
    if not Administration.InSpec then
        Administration:DestroyCam()
        SetEntityVisible(pPed, true, true)
        SetEntityInvincible(pPed, false)
        SetEntityCollision(pPed, true, true)
        FreezeEntityPosition(pPed, false)
        if pPos then
            SetEntityCoords(pPed, pPos)
        end
    else
        Administration:CreateCam()

        SetEntityVisible(pPed, false, false)
        SetEntityInvincible(pPed, true)
        SetEntityCollision(pPed, false, false)
        FreezeEntityPosition(pPed, true)
        SetCamCoord(Administration.Cam, GetEntityCoords(player))
        CreateThread(function()
            while Administration.InSpec do
                Wait(0)
                Administration:RenderCam()
            end
        end)
    end
end

RegisterKeyMapping("spectate", "Mode Spectate", "keyboard", "O")

RegisterCommand("spectate", function()
    if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then
        Administration:Spectate()
    end
end)

RegisterCommand("addplylist", function()
    if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then
        TriggerServerEvent("addListAdminMenu")
    end
end)

RegisterCommand("tpm", function()
    if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then

        local entity = PlayerPedId()
        if IsPedInAnyVehicle(entity, false) then
            entity = GetVehiclePedIsUsing(entity)
        end
        local success = false
        local blipFound = false
        local blipIterator = GetBlipInfoIdIterator()
        local blip = GetFirstBlipInfoId(8)
        
        while DoesBlipExist(blip) do
            if GetBlipInfoIdType(blip) == 4 then
                cx, cy, cz = table.unpack(Citizen.InvokeNative(0xFA7C7F0AADF25D09, blip, Citizen.ReturnResultAnyway(), Citizen.ResultAsVector()))
                blipFound = true
                break
            end
            blip = GetNextBlipInfoId(blipIterator)
            Wait(0)
        end
        
        if blipFound then
            local groundFound = false
            local yaw = GetEntityHeading(entity)
            
            for i = 0, 1000, 1 do
                SetEntityCoordsNoOffset(entity, cx, cy, ToFloat(i), false, false, false)
                SetEntityRotation(entity, 0, 0, 0, 0, 0)
                SetEntityHeading(entity, yaw)
                SetGameplayCamRelativeHeading(0)
                Wait(0)
                if GetGroundZFor_3dCoord(cx, cy, ToFloat(i), cz, false) then
                    cz = ToFloat(i)
                    groundFound = true
                    break
                end
            end
            if not groundFound then
                cz = -300.0
            end
            success = true
            ESX.ShowNotification("Téléporté sur le ~g~marqueur~s~.")
        else
            ESX.ShowNotification('~r~Aucun marker trouvé sur la map.')
        end
        
        if success then
            SetEntityCoordsNoOffset(entity, cx, cy, cz, false, false, true)
            SetGameplayCamRelativeHeading(0)
            if IsPedSittingInAnyVehicle(PlayerPedId()) then
                if GetPedInVehicleSeat(GetVehiclePedIsUsing(PlayerPedId()), -1) == PlayerPedId() then
                    SetVehicleOnGroundProperly(GetVehiclePedIsUsing(PlayerPedId()))
                end
            end
        end
    end
end)

RegisterNetEvent("freezePlys")
AddEventHandler("freezePlys", function(state)
    local plyPed = PlayerPedId()
    IsPlayerFreeze = state
    FreezeEntityPosition(plyPed, state)

    while IsPlayerFreeze do
        GiveWeaponToPed(plyPed, "weapon_unarmed", 0, false, true)
        DisableControlAction(0, 24, true) -- Attack
        DisableControlAction(0, 69, true) -- Attack
        DisableControlAction(0, 70, true) -- Attack
        DisableControlAction(0, 92, true) -- Attack
        DisableControlAction(0, 114, true) -- Attack
        DisableControlAction(0, 121, true) -- Attack
        DisableControlAction(0, 140, true) -- Attack
        DisableControlAction(0, 141, true) -- Attack
        DisableControlAction(0, 142, true) -- Attack
        DisableControlAction(0, 257, true) -- Attack
        DisableControlAction(0, 263, true) -- Attack
        DisableControlAction(0, 264, true) -- Attack
        DisableControlAction(0, 331, true) -- Attack
        DisableControlAction(0, 157, true) -- Weapon 1
        DisableControlAction(0, 158, true) -- Weapon 2
        DisableControlAction(0, 160, true) -- Weapon 3
        Wait(1)
    end
end)

RegisterNetEvent('ScreenshotAdmin')
AddEventHandler('ScreenshotAdmin', function(webhookscreen)
	    exports['screenshot-basic']:requestScreenshotUpload(webhookscreen, 'files[]')
end)

RegisterNetEvent('GotoPlayers')
AddEventHandler('GotoPlayers', function(coord)
    SetEntityCoords(PlayerPedId(), coord.x, coord.y, coord.z, 0, 0, 0, 0)

    if Administration.InSpec then
        SetCamCoord(Administration.Cam, coord.x, coord.y, coord.z)
    end
end)

function getplayers()
    ESX.TriggerServerCallback("GetAllPlayers", function(cb)
        Administration.AllPlayers = cb
    end)
end

function ActiveGamerTags()
    CreateThread(function()
        local table = {}
        Administration.HasGamerTag = true
        getplayers()
        Wait(450)
        for k,v in pairs(Administration.AllPlayers) do
            table[v.id] = {
                id = v.id,
                group = v.group,
                diamond = v.diamond,
                ata = ConvertToBool(v.ata),
                name = v.name
            }
        end
        Administration.table = table
        local PLAYERID = GetPlayerServerId(PlayerId())
        while Administration.HasGamerTag do
            for k, v in pairs(GetActivePlayers()) do
                if PLAYERID ~= GetPlayerServerId(v) then
                    local color = nil
                    local PlyId = GetPlayerServerId(v)
                    local player = Administration.table[PlyId]
                    if player ~= nil then
                        if player.group == 'moderator' then
                            color = 21
                        elseif player.group == 'admin' then
                            color = 25
                        elseif player.group == 'superadmin' then
                            color = 6
                        else                                          
                            if player.ata then
                                color = 12
                            elseif player.diamond then
                                color = 26
                            end
                        end
                        if not Administration.MpGamerTags[PlyId] then
                            local mpGamerTag = CreateFakeMpGamerTag(GetPlayerPed(v), "["..PlyId.."] "..player.name, false, false, "", 0)

                            SetMpGamerTagVisibility(mpGamerTag, 0, true)
                            SetMpGamerTagVisibility(mpGamerTag, 2, true)
                            SetMpGamerTagAlpha(mpGamerTag, 2, GetEntityHealth(GetPlayerPed(v)))
                            if color ~= nil then
                                SetMpGamerTagColour(mpGamerTag, 0, color)
                            end
                            Administration.MpGamerTags[PlyId] = { tag = mpGamerTag, ped = GetPlayerPed(v) }
                        else
                            local xBase = Administration.MpGamerTags[PlyId].tag
                            SetMpGamerTagVisibility(xBase, 4, NetworkIsPlayerTalking(v))
                            SetMpGamerTagAlpha(xBase, 4, 255)
            
                            SetMpGamerTagVisibility(xBase, 14, not IsPedInAnyVehicle(GetPlayerPed(v), false))
                            SetMpGamerTagAlpha(xBase, 14, 255)
            
                            SetMpGamerTagVisibility(xBase, 8, GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(v), false), -1) == GetPlayerPed(v))
                            SetMpGamerTagAlpha(xBase, 8, 255)
            
                            SetMpGamerTagVisibility(xBase, 9, GetPedInVehicleSeat(GetVehiclePedIsIn(GetPlayerPed(v), false), 0) == GetPlayerPed(v))
                            SetMpGamerTagAlpha(xBase, 9, 255)
                        end
                    end
                end
            end
            Wait(1)
        end
    end)
end

function DeleteGamerTags()
    Administration.HasGamerTag = false
    for k, v in pairs(Administration.MpGamerTags) do
        RemoveMpGamerTag(v.tag)
    end
    Administration.MpGamerTags = {}
end

function DisplayPlayersBlips()
	if displayBlips then
		displayBlips = false
		for k,v in pairs(blips) do
			RemoveBlip(v)
		end
		blips = {}
	else
		displayBlips = true

		Citizen.CreateThread(function()
			while displayBlips do
				for k,v in pairs(GetActivePlayers()) do
					local pPed = GetPlayerPed(v)

					if blips[v] == nil then
						local blip = AddBlipForEntity(pPed)
						SetBlipScale(blip, 0.75)
						SetBlipCategory(blip, 2)
						blips[v] = blip
					else
						local blip = GetBlipFromEntity(pPed)
						RemoveBlip(blip)
						RemoveBlip(blips[v])
						local blip = AddBlipForEntity(pPed)
						SetBlipScale(blip, 0.75)
						SetBlipCategory(blip, 2)
						blips[v] = blip
					end
					SetBlipNameToPlayerName(blips[v], v)
					SetBlipSprite(blips[v], 1)
					SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pPed)))
					

					if IsPedInAnyVehicle(pPed, false) then
						ShowHeadingIndicatorOnBlip(blips[v], false)
						local pVeh = GetVehiclePedIsIn(pPed, false)
						SetBlipRotation(blips[v], math.ceil(GetEntityHeading(pVeh)))

						
						if DecorExistOn(pVeh, "esc_siren_enabled") or IsPedInAnyPoliceVehicle(pPed) then
							SetBlipSprite(blips[v], 56)
							SetBlipColour(blips[v], 68)
						else
							SetBlipSprite(blips[v], 227)
							SetBlipColour(blips[v], 0)
						end
					else
						ShowHeadingIndicatorOnBlip(blips[v], true)
						HideNumberOnBlip(blips[v])
					end

				end
				Wait(500)
			end
		end)
	end
end

Administration.OpenedMenu = false
Administration.menu = RageUI.CreateMenu("Administration", "Administration")
Administration.subMenu = RageUI.CreateSubMenu(Administration.menu, "Liste des Joueurs", "Joueur")
Administration.subMenu2 = RageUI.CreateSubMenu(Administration.subMenu, "Joueur", "Joueur")
Administration.subMenu3 = RageUI.CreateSubMenu(Administration.subMenu2, "Avertissement", "Avertissement")
Administration.subMenu4 = RageUI.CreateSubMenu(Administration.subMenu3, "Avertissement", "Avertissement")
Administration.subMenu5 = RageUI.CreateSubMenu(Administration.subMenu2, "Liste des Métiers", "Liste des Métiers")
Administration.subMenu6 = RageUI.CreateSubMenu(Administration.subMenu5, "Liste des Grades", "Liste des Grades")
Administration.subMenu9 = RageUI.CreateSubMenu(Administration.menu, "Véhicules", "Véhicules")
Administration.subMenu10 = RageUI.CreateSubMenu(Administration.menu, "Monde", "Monde")
Administration.subMenu11 = RageUI.CreateSubMenu(Administration.menu, "Autres options", "Autres options")
Administration.subMenu12 = RageUI.CreateSubMenu(Administration.menu, "Crew", "Crew")
Administration.subMenu13 = RageUI.CreateSubMenu(Administration.menu, "Crew", "Crew")
Administration.subMenu14 = RageUI.CreateSubMenu(Administration.menu, "Crew", "Crew")
Administration.subMenu15 = RageUI.CreateSubMenu(Administration.menu, "Crew", "Crew")
Administration.GiveItem = RageUI.CreateSubMenu(Administration.menu, "Objet", "Objet")

Administration.menu:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu2:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu3:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu4:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu5:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu6:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu9:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu10:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu11:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu12:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu13:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu14:SetRectangleBanner(198, 42, 7, 125)
Administration.subMenu15:SetRectangleBanner(198, 42, 7, 125)
Administration.GiveItem:SetRectangleBanner(198, 42, 7, 125)

Administration.menu.Closed = function()
    Administration.OpenedMenu = false
    RageUI.Visible(Administration.menu, false)
end

Administration.GiveItem.Closed = function()
    RageUI.ResetFiltre()
end

Administration.subMenu13.Closed = function()
    Administration.ConfirmeCrew = false
end

Administration.subMenu:AcceptFilter(true)
Administration.GiveItem:AcceptFilter(true)
Administration.subMenu12:AcceptFilter(true)

function MenuAdministration()
    if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then
        if not RageUI.GetInMenu() then
            return
        end
        if Administration.OpenedMenu then
            Administration.OpenedMenu = false
            RageUI.Visible(Administration.menu, false)
        else
            Administration.OpenedMenu = true
            getplayers()
            RageUI.Visible(Administration.menu, true)
                CreateThread(function()
                    while Administration.OpenedMenu do
                    RageUI.IsVisible(Administration.menu, function()
                        RageUI.Button("Liste des joueurs", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                getplayers()
                                Wait(350)
                                RageUI.CloseAll()
                                RageUI.Visible(Administration.subMenu, true)
                            end
                        })
                        RageUI.Button("Véhicules", nil, {RightLabel = "→"}, true, {}, Administration.subMenu9)
                        RageUI.Button("Monde", nil, {RightLabel = "→"}, true, {}, Administration.subMenu10)
                        if Perm.PlyGroup == 'superadmin' then
                            RageUI.Button("Gestion Crew", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback('GetCrewList', function(cb)
                                        Administration.GetCrewList = cb
                                    end)
                                    Wait(350)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Administration.subMenu12, true)
                                end
                            })
                        end
                        RageUI.Button("Autres options", nil, {RightLabel = "→"}, true, {}, Administration.subMenu11)
                    end)

                    RageUI.IsVisible(Administration.subMenu12, function()
                        for k, v in pairs(Administration.GetCrewList) do
                            RageUI.Button(v.name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    IdCrew = v.id_crew
                                    NameCrew = v.name
                                    RageUI.ResetFiltre()
                                end
                            }, Administration.subMenu13)
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu13, function()
                        RageUI.Button("Changer le owner", nil, {}, true, {}, Administration.subMenu14)
                        if not Administration.ConfirmeCrew then
                            RageUI.Button("Supprimer le crew", nil, {}, true, {
                                onSelected = function()
                                    Administration.ConfirmeCrew = true
                                end
                            })
                        elseif Administration.ConfirmeCrew then
                            RageUI.Button("~g~Confirmer", nil, {}, true, {
                                onSelected = function()
                                    RageUI.GoBack()
                                    ESX.ShowNotification("Vous avez supprimé le crew ~b~"..NameCrew.."~s~.")
                                    TriggerServerEvent("DeleteCrew", IdCrew, NameCrew)
                                    Administration.ConfirmeCrew = false
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu14, function()
                        for k,v in pairs(Administration.AllPlayers) do
                            RageUI.Button(v.name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    IdJoueur = v.id
                                    NameJoueur = v.name
                                    ESX.TriggerServerCallback('GetCrewGrade', function(cb)
                                        Administration.GetCrewGrade = cb
                                    end, IdCrew)
                                    Wait(350)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Administration.subMenu15, true)
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu15, function()
                        for k, v in pairs(Administration.GetCrewGrade) do
                            RageUI.Button(v.name, nil, {RightLabel = v.rang}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("pour confirmer ecrit ~b~"..v.name, 30)
                                    if input == v.name then
                                        TriggerServerEvent("EditOwnerCrew", v.id_grade, IdCrew, IdJoueur, NameJoueur)
                                    else
                                        ESX.ShowNotification("~r~Vous devez écrire "..v.name..".")
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu9, function()
                        if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' then
                            RageUI.Button("Faire apparaître un véhicule", nil, {}, true, {
                                onSelected = function()
                                    local result = ESX.KeyboardInput('Model du véhicule', 30)  
                                    if result ~= nil then
                                        local playerPed = PlayerPedId()
                                        local coords    = GetEntityCoords(playerPed)

                                        ESX.Game.SpawnVehicle(result, coords, 90.0, function(vehicle)
                                            TaskWarpPedIntoVehicle(playerPed,  vehicle, -1)
                                        end)
                                    end
                                end
                            })
                        end
                        RageUI.Button("Réparer le moteur", nil, {}, true, {
                            onSelected = function()
                                SetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)), 1000.0)
                            end
                        })
                        RageUI.Button("Réparer la carrosserie", nil, {}, true, {
                            onSelected = function()
                                local levelmoteur = GetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1)))
                                SetVehicleEngineHealth(GetVehiclePedIsIn(GetPlayerPed(-1)), levelmoteur)
                            end
                        })
                        RageUI.Button("Nettoyer le véhicule", nil, {}, true, {
                            onSelected = function()
                                SetVehicleDirtLevel(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            end
                        })
                        RageUI.Button("Réparer entièrement le véhicule", nil, {}, true, {
                            onSelected = function()
                                SetVehicleFixed(GetVehiclePedIsIn(GetPlayerPed(-1)))
                            end
                        })
                        RageUI.List("Supprimer un véhicule", {{Name = "5m"}, {Name = "10m"}, {Name = "15m"}, {Name = "20m"}, {Name = "25m"}, {Name = "30m"}}, Administration.ListVeh, nil, {}, true, {
                            onListChange = function(Index)
                                Administration.ListVeh = Index;
                            end,
                            onSelected = function(Index)
                                if Index == 1 then 
                                    TriggerEvent('esx:deleteVehicle', 5)
                                elseif Index == 2 then 
                                    TriggerEvent('esx:deleteVehicle', 10)
                                elseif Index == 3 then 
                                    TriggerEvent('esx:deleteVehicle', 15)
                                elseif Index == 4 then 
                                    TriggerEvent('esx:deleteVehicle', 20)
                                elseif Index == 5 then 
                                    TriggerEvent('esx:deleteVehicle', 25)
                                elseif Index == 6 then 
                                    TriggerEvent('esx:deleteVehicle', 30)
                                end
                            end
                        })
                    end)

                    RageUI.IsVisible(Administration.subMenu10, function()
                        RageUI.Checkbox("Afficher les gamertags", false, Administration.CheckboxGamerTags, {}, {
                            onChecked = function()
                                ActiveGamerTags()
                                Citizen.CreateThread(function()
                                    while Administration.CheckboxGamerTags do
                                        Citizen.Wait(60000)
                                        if Administration.HasGamerTag then
                                            ActiveGamerTags()
                                            DeleteGamerTags()
                                        end
                                    end
                                end)
                            end,
                            onUnChecked = function()
                                DeleteGamerTags()
                            end,
                            onSelected = function(Index)
                                Administration.CheckboxGamerTags = Index
                            end
                        })
                        RageUI.Checkbox("Visible", false, Administration.CheckboxVisible, {}, {
                            onChecked = function()
                                SetEntityVisible(PlayerPedId(), true, false)
                                SetEntityInvincible(PlayerPedId(), false)
                            end,
                            onUnChecked = function()
                                SetEntityVisible(PlayerPedId(), false, false)
                                SetEntityInvincible(PlayerPedId(), true)
                            end,
                            onSelected = function(Index)
                                Administration.CheckboxVisible = Index
                            end
                        })
                        RageUI.Checkbox("Afficher les Blips des joueurs", false, Administration.CheckboxBlips, {}, {
                            onChecked = function()
                                DisplayPlayersBlips()
                            end,
                            onUnChecked = function()
                                displayBlips = false
                                for k,v in pairs(blips) do
                                    RemoveBlip(v)
                                end
                            end,
                            onSelected = function(Index)
                                Administration.CheckboxBlips = Index
                            end
                        })
                    end)
                    RageUI.IsVisible(Administration.subMenu11, function()
                        if Perm.PlyGroup == 'superadmin' then
                            RageUI.Button("Faire une annonces", nil, {}, true, {
                                onSelected = function()
                                    local input = ESX.KeyboardInput("Message", 150)

                                    if input ~= nil and #input > 4 then
                                        TriggerServerEvent("AnnonceAdmin", input)
                                    end
                                end
                            })
                        end
                        if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' then
                            RageUI.Button("Wipe un joueur", nil, {}, true, {
                                onSelected = function()
                                    local wipe = ESX.KeyboardInput("ID du Personnage", 30)
                                    if wipe ~= nil then
                                        TriggerServerEvent("WipePersoAdmin", wipe)
                                    end
                                end
                            })
                        end
                        RageUI.Button("Clear la zone", nil, {}, true, {
                            onSelected = function()
                                local x, y, z = table.unpack(GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 0.0, 0.0))
                                ClearAreaOfPeds(x, y, z, 100.0, 1)
                                ClearAreaOfEverything(x, y, z, 100.0, false, false, false, false)
                                ClearAreaOfVehicles(x, y, z, 100.0, false, false, false, false, false)
                                ClearAreaOfObjects(x, y, z, 100.0, true)
                                ClearAreaOfProjectiles(x, y, z, 100.0, 0)
                                ClearAreaOfCops(x, y, z, 100., 0)
                            end
                        })
                        RageUI.Button("Print vos coordonnées", nil, {}, true, {
                            onSelected = function()
                                print(GetEntityCoords(PlayerPedId()))
                                print(GetEntityHeading(PlayerPedId()))
                            end
                        })
                        RageUI.Button("Téléporter sur le point", nil, {}, true, {
                            onSelected = function()
                                ExecuteCommand("tpm")
                            end
                        })
                        RageUI.Button("Création de personnage", nil, {}, true, {
                            onSelected = function()
                                RageUI.CloseAll()
                                Administration.OpenedMenu = false
                                TriggerEvent("CreatePerso")
                            end
                        })
                        if Perm.PlyGroup == 'superadmin' then
                            RageUI.Checkbox("Invincible", false, Administration.CheckboxGameMod, {}, {
                                onChecked = function()
                                    SetPedCanRagdoll(GetPlayerPed(-1), false)
                                    ClearPedBloodDamage(GetPlayerPed(-1))
                                    ResetPedVisibleDamage(GetPlayerPed(-1))
                                    ClearPedLastWeaponDamage(GetPlayerPed(-1))
                                    SetEntityProofs(GetPlayerPed(-1), true, true, true, true, true, true, true, true)
                                    SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), false)
                                    SetEntityCanBeDamaged(GetPlayerPed(-1), false)
                                    ESX.Notification("Vous avez ~g~activé~s~ le mode Invincible")
                                end,
                                onUnChecked = function()
                                    SetPedCanRagdoll(GetPlayerPed(-1), true)
                                    ClearPedLastWeaponDamage(GetPlayerPed(-1))
                                    SetEntityProofs(GetPlayerPed(-1), false, false, false, false, false, false, false, false)
                                    SetEntityOnlyDamagedByPlayer(GetPlayerPed(-1), true)
                                    SetEntityCanBeDamaged(GetPlayerPed(-1), true)
                                    ESX.Notification("Vous avez ~r~désactivé~s~ le mode Invincible")
                                end,
                                onSelected = function(Index)
                                    Administration.CheckboxGameMod = Index
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu, function()
                        for k,v in pairs(Administration.AllPlayers) do
                            RageUI.Button("("..v.id..") - "..v.name, nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    IdSelected = v.id
                                    IdPersonnage = v.idperso
                                    discordName = v.discordname
                                    NameSelected = v.name
                                    DiamondSelected = v.diamond
                                    LieuNaissance = v.ldn
                                    DateDeNaissance = v.dateofbirth
                                    RageUI.ResetFiltre()
                                end
                            }, Administration.subMenu2)
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu2, function()
                        if IdSelected and NameSelected then
                            RageUI.Button("~r~(" .. IdSelected .. ") - " .. NameSelected, nil, {}, true, {})
                        end
                        RageUI.Button("Envoyer un message privé", nil, {}, true, {
                            onSelected = function()
                                local msg = ESX.KeyboardInput('Message', 120)
                                if msg ~= nil then
                                    TriggerServerEvent('MessageAdmin', IdSelected, "~r~Modération~s~\n"..msg)
                                end
                            end
                        })
                        RageUI.Button("Voir l'inventaire du joueur", nil, {}, true, {
                            onSelected = function()
                                TriggerEvent("esx_inventoryhud:openPlayerInventory", IdSelected)
                            end
                        })
                        RageUI.Button("Se téléporter sur le joueur", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent('GotoPlayers', IdSelected)
                            end
                        })
                        RageUI.Button("Téléporter le joueur sur vous", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent('BringPlayers', IdSelected)
                            end
                        })

                        RageUI.List("Informations", {{Name = "Discord"}, {Name = "ID Perso"}, {Name = "Diamond"}, {Name = "Lieu de naissance"}, {Name = "Date de naissance"}, {Name = "Steam(hex)"}, {Name = "ID Discord"}, {Name = "Tout"}}, Administration.ListInfos, nil, {}, true, {
                            onListChange = function(Index)
                                Administration.ListInfos = Index;
                            end,
                            onSelected = function(Index)
                                if Index == 1 then 
                                    ESX.Notification("~g~Discord~s~\n"..discordName)
                                end
                                if Index == 2 then 
                                    ESX.Notification("~b~ID Personnage~s~\n"..IdPersonnage)
                                end
                                if Index == 3 then 
                                    if DiamondSelected then
                                        ESX.Notification("~b~Diamond~s~\n"..NameSelected.." possède le ~g~diamond~s~.")
                                    else
                                        ESX.Notification("~o~Diamond~s~\n"..NameSelected.." possède pas le ~r~diamond~s~.")
                                    end
                                end
                                if Index == 4 then 
                                    ESX.Notification("Lieu de naissance~b~\n"..LieuNaissance..".")
                                end
                                if Index == 5 then 
                                    ESX.Notification("Date de naissance~p~\n"..DateDeNaissance..".")
                                end
                                if Index == 6 then
                                    TriggerServerEvent("GetInfosPlayers", IdSelected, 'Steamhex')
                                end
                                if Index == 7 then 
                                    TriggerServerEvent("GetInfosPlayers", IdSelected, 'Discord')
                                end
                                if Index == 8 then 
                                    if Perm.PlyGroup == 'superadmin' then
                                        TriggerServerEvent("GetInfosPlayers", IdSelected, 'Tout')
                                    else
                                        ESX.ShowNotification('~r~Vous devez être superadmin pour avoir cette information.')
                                    end
                                end
                            end
                        })
                        RageUI.Button("Réanimer", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, {
                            onSelected = function()
                                ExecuteCommand('revive '..IdSelected)
                            end
                        })
                        RageUI.Button("Heal le joueur", nil, {RightBadge = RageUI.BadgeStyle.Heart}, true, {
                            onSelected = function()
                                ExecuteCommand('heal '..IdSelected)
                            end
                        })
                        if Perm.PlyGroup == 'superadmin' then
                            RageUI.Button("Création de personnage", nil, {}, true, {
                                onSelected = function()
                                    TriggerServerEvent("CreatePersoUser", IdSelected)
                                end
                            })
                        end
                        RageUI.Checkbox("Freeze le joueur", false, Administration.CheckboxFreezePlayer, {}, {
                            onChecked = function()
                                TriggerServerEvent("freezePly", IdSelected, true)
                            end,
                            onUnChecked = function()
                                TriggerServerEvent("freezePly", IdSelected, false)
                            end,
                            onSelected = function(Index)
                                Administration.CheckboxFreezePlayer = Index
                            end
                        })
                        if Perm.PlyGroup == 'superadmin' then
                            RageUI.Button("Donner un objet", nil, {RightLabel = "→"}, true, {
                                onSelected = function()
                                    ESX.TriggerServerCallback('GetListeItem', function(cb)
                                        Administration.GetListeItem = cb
                                    end)
                                    Wait(550)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Administration.GiveItem, true)
                                end
                            })
                        end
                        RageUI.Button("Mettre un Avertissement", nil, {}, true, {
                            onSelected = function()
                                local result = ESX.KeyboardInput('Raison', 250)
                                if result ~= nil then 
                                    TriggerServerEvent('SetSanction', IdSelected, result)
                                    ESX.ShowNotification("~b~Vous venez de mettre un avertissement à "..NameSelected)
                                end
                            end
                        })
                        RageUI.Button("Liste des Avertissements", nil, {RightLabel = "→"}, true, {
                            onSelected = function()
                                ESX.TriggerServerCallback("GetSanction", function(cb)
                                    Administration.GetSanction = cb
                                end, IdSelected)
                                Wait(550)
                                RageUI.CloseAll()
                                RageUI.Visible(Administration.subMenu3, true)
                            end
                        })
                        RageUI.Button("Prendre un screen", nil, {}, true, {
                            onSelected = function()
                                TriggerServerEvent("ScreenshotAdmin", IdSelected)
                            end
                        })
                        if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' then
                            RageUI.Button("Modifier le métier", nil, {RightLabel = "→"}, true, {}, Administration.subMenu5)
                        end
                        RageUI.Button("~r~Kick le joueur", nil, {}, true, {
                            onSelected = function()
                                local raison = ESX.KeyboardInput('Raison du kick', 120)
                                if raison ~= nil then
                                    TriggerServerEvent('KickPlayer', IdSelected, raison)
                                    RageUI.CloseAll()
                                    RageUI.Visible(Administration.menu, true)
                                end
                            end
                        })
                        RageUI.Button("~r~Bannir le joueur", nil, {}, true, {
                            onSelected = function()
                                local raison = ESX.KeyboardInput("Raison", 30)
                                if raison ~= nil and #raison > 3 then
                                    TriggerServerEvent('admin:Ban', IdSelected, raison, GetPlayerName(PlayerId()))
                                end
                            end
                        })
                    end)

                    RageUI.IsVisible(Administration.GiveItem, function()
                        for k,v in pairs(Administration.GetListeItem) do
                            RageUI.Button(v.label, nil, {}, true, {
                                onSelected = function()
                                    local nombre = ESX.KeyboardInput('Nombre', 10)
                                    if nombre ~= nil then 
                                        ExecuteCommand('giveitem '..IdSelected..' '..v.name..' '..nombre)
                                    end
                                end
                            })
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu3, function()                            
                        RageUI.Separator("↓ Liste des avertissements ↓")
                        for k,v in pairs(Administration.GetSanction) do
                            RageUI.Button(v.date.." - "..v.raison, nil, {}, true, {
                                onSelected = function()
                                    Raison = v.raison
                                    Id = v.id
                                    Admin = v.give
                                    Date = v.date
                                end
                            }, Administration.subMenu4)
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu4, function()
                        if Raison and Admin and Id and Date then
                            RageUI.Button("Raison - "..Raison, nil, {}, true, {})
                            RageUI.Button("Auteur - "..Admin, nil, {}, true, {})
                            RageUI.Button("Date - "..Date, nil, {}, true, {})
                            RageUI.Button("ID Avertissement - "..Id, nil, {}, true, {})
                            if Perm.PlyGroup == 'superadmin' then
                                RageUI.Button("~r~Supprimer l'avertissement", nil, {RightLabel = "→"}, true, {
                                    onSelected = function()
                                        RageUI.CloseAll()
                                        Administration.OpenedMenu = false
                                        TriggerServerEvent('DeleteSanction', Id, Raison, IdSelected)
                                        ESX.ShowNotification("~b~Vous venez de supprimer l'avertissement N°"..Id)
                                    end
                                })
                            end
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu5, function()
                        ESX.TriggerServerCallback('GetJobs', function(cb)
                            Administration.ListeJobs = cb
                        end)
                        for k,v in pairs(Administration.ListeJobs) do
                            RageUI.Button(""..v.label, nil, {}, true, {
                                onSelected = function()
                                    JobLabel = v.label
                                    JobName = v.name
                                end
                            }, Administration.subMenu6)
                        end
                    end)

                    RageUI.IsVisible(Administration.subMenu6, function()
                        if JobName then
                            ESX.TriggerServerCallback('GetJobsGrades', function(cb)
                                Administration.ListeGrades = cb
                            end, JobName)
                            for k,v in pairs(Administration.ListeGrades) do
                                RageUI.Button(""..v.label, nil, {}, true, {
                                    onSelected = function()
                                        ExecuteCommand('setjob '..IdSelected..' '..JobName..' '..v.grade)
                                        ESX.Notification("Métier : ~o~"..JobLabel.."~s~~n~Grade : ~b~"..v.label.."~s~~n~Joueur : ~g~"..NameSelected)
                                    end
                                })
                            end
                        end
                    end)
                    Wait(1)
                end
            end)
        end
    end
end

Keys.Register("F2", "-admin", "Ouvrir le menu Admin", function()
    if Perm.PlyGroup == 'superadmin' or Perm.PlyGroup == 'admin' or Perm.PlyGroup == 'moderator' then
        MenuAdministration()
    end
end)

Citizen.CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/report', "demander de l'aide au adminstrateur", {{ name="raison", help="Veuillez écrire une raison détaillée"}})
end)