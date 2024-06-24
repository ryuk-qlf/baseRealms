function LookProgressBar()
    return ActiveProgressBar
end

function DrawTextProgress(Text, Text3, Taille, Text2, Font, Justi, havetext)
    SetTextFont(Font)
    SetTextScale(Taille, Taille)
    SetTextColour(255, 255, 255, 255)
    SetTextJustification(Justi or 1)
    SetTextEntry("STRING")
    if havetext then SetTextWrap(Text, Text + .1) end
    AddTextComponentString(Text2)
    DrawText(Text, Text3)
end

local LoadPoint = {".", "..", "...", ""}

function AddProgressBar(Text, r, g, b, a, Timing)
    if Timing then
        DeleteProgressBar()
        ActiveProgressBar = true
        Citizen.CreateThread(function()
            local Timing1, Timing2 = 0.0, GetGameTimer() + Timing
            local Point, AddLoadPoint = ""
            while ActiveProgressBar and (Timing1 < 1) do
                Citizen.Wait(0)
                if Timing1 < 1 then
                    Timing1 = 1 - ((Timing2 - GetGameTimer()) / Timing)
                end
                if not AddLoadPoint or GetGameTimer() >= AddLoadPoint then
                    AddLoadPoint = GetGameTimer() + 500
                    Point = LoadPoint[string.len(Point) + 1] or ""
                end
                DrawRect(0.5, 0.940, 0.15, 0.03, 0, 0, 0, 100)
                local y, endroit = 0.15 - 0.0025, 0.03 - 0.005
                local chance = math.max(0, math.min(y, y * Timing1))
                DrawRect((0.5 - y / 2) + chance / 2, 0.940, chance, endroit, r, g, b, a) -- 0,155,255,125
                DrawTextProgress(0.5, 0.940 - 0.0125, 0.3, (Text or "Action en cours") .. Point, 0, 0, false)
            end
            DeleteProgressBar()
        end)
    end
end

function DeleteProgressBar() 
    ActiveProgressBar = nil
end

local BarsActivate = {}

function AddTimerBar(title, data)
	if data then
        RequestStreamedTextureDict("timerbars", true)

        local BarInfo = #BarsActivate + 1
        BarsActivate[BarInfo] = {
            title = title,
            text = data.text,
            textColor = data.color or { 255, 255, 255, 255 },
            percentage = data.percentage,
            endTime = data.endTime,
            pbarBgColor = data.bg or { 155, 155, 155, 255 },
            pbarFgColor = data.fg or { 255, 255, 255, 255 }
        }
        return BarInfo
    end
end

function RemoveTimerBar()
	BarsActivate = {}
	SetStreamedTextureDictAsNoLongerNeeded("timerbars")
end

function UpdateTimerBar(BarInfo, data)
    if BarsActivate[BarInfo] or data then
        for k,v in pairs(data) do
            BarsActivate[BarInfo][k] = v
        end
    end
end

local textColor = { 200, 100, 100 }

function MinuteurAuto(second)
	second = tonumber(second)

	if second <= 0 then
		return "00:00"
	else
		min = string.format("%02.f", math.floor(second / 60))
		sec = string.format("%02.f", math.floor(second - min * 60))
		return string.format("%s:%s", min, sec)
	end
end

function DisplayNotification(text, init)
	SetTextComponentFormat("jamyfafi")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, init, -1)
end

function DrawTestTimeBar(Text, floatScale, intPosX, intPosY, color, intAlign, addWarp)
	SetTextFont(0)
	SetTextScale(floatScale, floatScale)

	SetTextColour(color[1], color[2], color[3], 255)
    SetTextJustification(intAlign or 1)
    SetTextWrap(0.0, addWarp or intPosX)

	SetTextEntry("jamyfafi")
	LongText(Text)

	DrawText(intPosX, intPosY)
end

function LongText(txt)
	local maxLen = 100
	for i = 0, string.len(txt), maxLen do
		local sub = string.sub(txt, i, math.min(i + maxLen, string.len(txt)))
		AddTextComponentString(sub)
	end
end

Citizen.CreateThread(function()
	while true do
		local xtime = 250

		local safeZone = GetSafeZoneSize()
		local safeZoneX = (1.0 - safeZone) * 0.5
		local safeZoneY = (1.0 - safeZone) * 0.5

		if #BarsActivate > 0 then
			xtime = 1
			HideHudComponentThisFrame(6)
			HideHudComponentThisFrame(7)
			HideHudComponentThisFrame(8)
			HideHudComponentThisFrame(9)

			for i,v in pairs(BarsActivate) do
				local drawY = (0.984 - safeZoneY) - (i * 0.038)
				DrawSprite("timerbars", "all_black_bg", 0.918 - safeZoneX, drawY, 0.165, 0.035, 0.0, 255, 255, 255, 160)
				DrawTestTimeBar(v.title, 0.3, (0.918 - safeZoneX) + 0.012, drawY + -0.012, v.textColor, 2)

				if v.percentage then
					local pbarX = (0.918 - safeZoneX) + 0.047
					local pbarY = drawY + 0.0015
					local width = 0.0616 * v.percentage

					DrawRect(pbarX, pbarY, 0.0616, 0.0105, v.pbarBgColor[1], v.pbarBgColor[2], v.pbarBgColor[3], v.pbarBgColor[4])

					DrawRect((pbarX - 0.0616 / 2) + width / 2, pbarY, width, 0.0105, v.pbarFgColor[1], v.pbarFgColor[2], v.pbarFgColor[3], v.pbarFgColor[4])
				elseif v.text then
					DrawTestTimeBar(v.text, 0.425, (0.918 - safeZoneX) + 0.0785, drawY + -0.0165, v.textColor, 2)
				elseif v.endTime then
					local remainingTime = math.floor(v.endTime - GetGameTimer())
					DrawTestTimeBar(MinuteurAuto(remainingTime / 1000), 0.425, (0.918 - safeZoneX) + 0.0785, drawY + -0.0165, remainingTime <= 0 and textColor or v.textColor, 2)
				end
			end
		end
		Wait(xtime)
	end
end)

------

Burglary = {}
Burglary.SoundID = nil
Burglary.TimeAnim = 12000
Burglary.TimeAnimSearch = 10000

function Burglary:Enter(idProp)
    local player = PlayerPedId()
    local pPos = GetEntityCoords(player)

    DoScreenFadeOut(1000)
    Wait(1000)
    Burglary.LastPos = pPos
    Burglary.Current.Enter = Property:GetEnterFromType(Burglary.Current.Interior)
    Burglary.Current.Chest = Property:GetChestFromType(Burglary.Current.Interior)

    Burglary.Current.Ipl = GetInteriorAtCoords(Burglary.Current.Enter)
    if Burglary.Current.Ipl then
        LoadInterior(Burglary.Current.Ipl)
    end

    DeleteProgressBar()

    Property:TeleportCoords(Burglary.Current.Enter, player)
    Property:StartInstance()

    Wait(1000)
    DoScreenFadeIn(1000)
    Burglary.IsInProperty = true
end

function Burglary:Exit()
    local player = PlayerPedId()
    local pPos = GetEntityCoords(player)

    DoScreenFadeOut(1000)
    Wait(1000)
    Property:TeleportCoords(Burglary.LastPos, player)
    Property:StopInstance()

    if Burglary.SoundID then
        StopSound(Burglary.SoundID)
        Burglary.SoundID = nil
    end
    if Burglary.Dog then 
        SetEntityAsNoLongerNeeded(Burglary.Dog)
        DeleteEntity(Burglary.Dog)
        Burglary.Dog = nil 
    end

    Wait(1000)
    DoScreenFadeIn(1000)
    RemoveTimerBar()
    Burglary.IsInProperty = false
end

function Burglary:SpawnDog()
    if not Burglary.Dog then
        local hash = GetHashKey(Burglary.Current.HashDog)

        if not HasModelLoaded(hash) then
            RequestModel(hash)
            while not HasModelLoaded(hash) do
                Citizen.Wait(100)
            end
        end

        Burglary.Dog = CreatePed(28, hash, Burglary.Current.DogSpawn.x, Burglary.Current.DogSpawn.y, Burglary.Current.DogSpawn.z, 0.0, true, false)
    
        TaskCombatPed(Burglary.Dog, GetPlayerPed(-1) ,0, 16)
    end
end

RegisterNetEvent("useTournevis")
AddEventHandler("useTournevis", function()
    local player = PlayerPedId()
    local pPos = GetEntityCoords(player)
    local Pourcent = 0

    if not LookProgressBar() and not IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then 

        for k, v in pairs(Properties.List) do
            if v.property_pos ~= "null" then
                local propPos = json.decode(v.property_pos)
                local dist = Vdist(pPos, vector3(propPos.x, propPos.y, propPos.z))
                if dist <= 5.0 then
                    Burglary.Call = false
                    Burglary.Current = v
                    Burglary.Current.Id = v.id_property
                    Burglary.Current.Pos = json.decode(v.property_pos)
                    Burglary.Current.Enter = Property:GetEnterFromType(Burglary.Current.Interior)
                    Burglary.Current.Chest = Property:GetChestFromType(Burglary.Current.Interior)            
                    Burglary.Current.Name = v.property_name
                    Burglary.Current.Interior = v.property_type 
                    Burglary.Current.Owner = v.property_owner
                    Burglary.Current.Cambriolage = v.cambriolage

                    for _,y in pairs(Properties.Interiors) do 
                        if Burglary.Current.Interior == y.name then 
                            Burglary.Current.HashDog = y.HashDog
                            Burglary.Current.DogSpawn = y.SpawnDog
                            Burglary.Current.SpawnObject = y.SpawnObject
                        end
                    end
                    Burglary.Current.HasFind = {}

                    if GetClockHours() >= 21 or GetClockHours() <= 5 then
                        if Burglary.Current.Interior ~= nil then
                            if Burglary.Current.Cambriolage == 0 then
                                if ESX.PlayerData.identifier ~= Burglary.Current.Owner and Burglary.Current.Interior ~= "Labo1" and Burglary.Current.Interior ~= "Labo2" and Burglary.Current.Interior ~= "Labo3" then
                                    TriggerServerEvent("removeDiversInventoryItem", "tournevis")

                                    AddProgressBar("Crochetage en cours", 0, 151, 255, 200, Burglary.TimeAnim)
                                    ESX.Streaming.RequestAnimDict("mini@safe_cracking", function()
                                        TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "idle_base", 8.0, -8.0, -1, 35, 0.0, false, false, false)
                                    end)
                                    Wait(Burglary.TimeAnim / 2.2)
                                    ClearPedTasksImmediately(player)
                                    Wait(100)
                                    ESX.Streaming.RequestAnimDict("mini@safe_cracking", function()
                                        TaskPlayAnim(PlayerPedId(), "mini@safe_cracking", "idle_base", 8.0, -8.0, -1, 35, 0.0, false, false, false)
                                    end)
                                    Wait(Burglary.TimeAnim / 2)
                                    ClearPedTasksImmediately(player)

                                    local chanceEnter = math.random(1, 100)
                                    if chanceEnter >= 60 and chanceEnter <= 100 then 
                                        TriggerServerEvent("call:makeCallSpecial", "police", GetEntityCoords(PlayerPedId()), "Cambriolage en cours")
                                        ESX.ShowNotification("~r~Vous n'avez pas réussi à crocheter la porte.")
                                        PlaySoundFrontend(-1, "Drill_Pin_Break","DLC_HEIST_FLEECA_SOUNDSET", 0)
                                        return
                                    end

                                    PlaySoundFrontend(-1,"MP_RANK_UP","HUD_FRONTEND_DEFAULT_SOUNDSET", 0)
                                    ESX.ShowNotification("Vous avez ~g~réussi~s~ le crochetage.")

                                    Wait(1000)

                                    Burglary:Enter(Burglary.Current.Id)
                                    TriggerServerEvent("AddTableCambriolage", Burglary.Current.Id)

                                    local ChanceDog = math.random(1, 100)
                                    if ChanceDog >= 70 and ChanceDog <= 100 then 
                                        Burglary:SpawnDog()
                                    end

                                    TimerBar = AddTimerBar("Visible", { percentage = 0.0, bg = {100, 100, 100, 255}, fg = {200, 200, 200, 255}})

                                    Citizen.CreateThread(function()
                                        Wait(500)
                                        while Burglary.IsInProperty do

                                            if Burglary.Current.Enter ~= nil then
                                                if Vdist(GetEntityCoords(player), vector3(Burglary.Current.Enter.x, Burglary.Current.Enter.y, Burglary.Current.Enter.z)) <= 5 then
                                                    DrawMarker(25, Burglary.Current.Enter.x, Burglary.Current.Enter.y, Burglary.Current.Enter.z-0.98, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.7, 0.7, 0.7, 46, 134, 193, 178, false, false, false, false)
                                                end

                                                if Vdist(GetEntityCoords(player), vector3(Burglary.Current.Enter.x, Burglary.Current.Enter.y, Burglary.Current.Enter.z)) <= 1.2 then
                                                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~sortir de la propriété")
                                                    if IsControlJustReleased(0, 51) then       
                                                        Burglary:Exit()
                                                    end
                                                end
                                            end
                                            
                                            if GetEntityHealth(PlayerPedId()) <= 115 then
                                                if Burglary.Dog then 
                                                    ESX.ShowNotification("~r~Vous vous êtes fait croquer par le chien.")
                                                    Burglary:Exit()
                                                end
                                            end

                                            if Pourcent >= 1 then
                                                if not Burglary.Call then
                                                    ESX.ShowNotification("~r~Vous vous êtes fait repérer vous avez fait trop de bruit.")
                                                    TriggerServerEvent("call:makeCallSpecial", "police", Burglary.LastPos, "Cambriolage en cours")
                                                    Burglary.Call = true 
                                                end
                                            end

                                            if Pourcent <= 1 then
                                                if GetEntitySpeed(PlayerPedId()) <= 1.0 then
                                                    Pourcent = Pourcent + 0.0002
                                                    UpdateTimerBar(TimerBar, { percentage = Pourcent })
                                                end

                                                if GetEntitySpeed(PlayerPedId()) <= 2.5 then
                                                    Pourcent = Pourcent + 0.0005
                                                    UpdateTimerBar(TimerBar, { percentage = Pourcent })
                                                end

                                                if GetEntitySpeed(player) > 3.0 then 
                                                    Pourcent = Pourcent + 0.0010
                                                    UpdateTimerBar(TimerBar, { percentage = Pourcent })
                                                end
                                            end

                                            for _,s in pairs(Burglary.Current.SpawnObject) do
                                                local DistObject = Vdist(GetEntityCoords(player), s)

                                                if DistObject <= 1.2 and not Burglary.Current.HasFind[_] then 
                                                    DisplayNotification("Appuyez sur ~INPUT_CONTEXT~ pour ~b~fouiller le meuble.")
                                                    if IsControlJustReleased(0, 51) then
                                                        Burglary.Current.HasFind[_] = true
                                                        AddProgressBar("Fouille en cours", 0, 151, 255, 200, Burglary.TimeAnimSearch)
                                                        ESX.Streaming.RequestAnimDict('anim@amb@clubhouse@tutorial@bkr_tut_ig3@', function()
                                                            TaskPlayAnim(PlayerPedId(), "anim@amb@clubhouse@tutorial@bkr_tut_ig3@", "machinic_loop_mechandplayer", 8.0, -8.0, -1, 35, 0.0, false, false, false)
                                                        end)
                                                        Wait(Burglary.TimeAnimSearch)
                                                        ClearPedTasks(player)
                                                        TriggerServerEvent("AddItemCambriolage")
                                                    end
                                                end
                                            end
                                            Wait(5)
                                        end
                                    end)
                                else
                                    ESX.ShowNotification("~r~Vous ne pouvez pas cambrioler cette propriété.")
                                end
                            else
                                ESX.ShowNotification("~r~Vous ne pouvez pas cambrioler cette propriété.")
                            end
                        end
                    else
                        ESX.ShowNotification("~r~Vous pouvez cambrioler uniquement de nuit.")
                    end
                end
            end
        end
    end
end)