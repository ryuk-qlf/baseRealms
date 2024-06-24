function GetAllPlayers()
	local players = {}

	for _,player in ipairs(GetActivePlayers()) do
		local ped = GetPlayerPed(player)

		if DoesEntityExist(ped) then
			table.insert(players, player)
		end
	end

	return players
end

function GetNearbyPlayers(distance)
	local ped = GetPlayerPed(-1)
	local playerPos = GetEntityCoords(ped)
	local nearbyPlayers = {}

	for _,v in pairs(GetAllPlayers()) do
		local otherPed = GetPlayerPed(v)
		local otherPedPos = otherPed ~= ped and IsEntityVisible(otherPed) and GetEntityCoords(otherPed)

		if otherPedPos and GetDistanceBetweenCoords(otherPedPos, playerPos) <= (distance or max) then
			nearbyPlayers[#nearbyPlayers + 1] = v
		end
	end
	return nearbyPlayers
end

function GetNearbyPlayer(distance)
    local Timer = GetGameTimer() + 10000
    local oPlayer = GetNearbyPlayers(distance)

    if #oPlayer == 0 then
        ESX.ShowNotification("~r~Il n'y a aucune personne aux alentours de vous.")
        return false
    end

    if #oPlayer == 1 then
        return oPlayer[1]
    end

    ESX.ShowNotification("Appuyer sur ~g~E~s~ pour valider~n~Appuyer sur ~b~A~s~ pour changer de cible~n~Appuyer sur ~r~X~s~ pour annuler")
    Citizen.Wait(100)
    local aBase = 1
    while GetGameTimer() <= Timer do
        Citizen.Wait(0)
        DisableControlAction(0, 38, true)
        DisableControlAction(0, 73, true)
        DisableControlAction(0, 44, true)
        if IsDisabledControlJustPressed(0, 38) then
            return oPlayer[aBase]
        elseif IsDisabledControlJustPressed(0, 73) then
            ESX.ShowNotification("Vous avez ~r~annulé~s~ cette ~r~action~s~")
            break
        elseif IsDisabledControlJustPressed(0, 44) then
            aBase = (aBase == #oPlayer) and 1 or (aBase + 1)
        end
        local cPed = GetPlayerPed(oPlayer[aBase])
        local cCoords = GetEntityCoords(cPed)
        DrawMarker(0, cCoords.x, cCoords.y, cCoords.z + 1.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.1, 0.1, 0.1, 0, 180, 10, 30, 1, 1, 0, 0, 0, 0, 0)
    end
    return false
end

--- ProgressBar ---

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

--- Timer Bar ---

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

function LongText(text)
	local max = 100
	for i = 0, string.len(text), max do
		local sub = string.sub(text, i, math.min(i + max, string.len(text)))
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

-------

function LowNotification(key, msg)
	DrawScaleformMovieFullscreen(LowSetupScaleform(key, msg), 255, 255, 255, 255, 0)
end

function LowButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function LowSetupScaleform(key, msg)
    local scaleform = RequestScaleformMovie("instructional_buttons")

    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(1)
    N_0xe83a3e3557a56640(GetControlInstructionalButton(2, key, true))
    LowButtonMessage(msg)
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()

    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()

    return scaleform
end

showText = function(args)
    args.font = args.font or 6;
    args.size = args.size or 0.50;
    args.posx = args.posx or 0.5;
    args.posy = args.posy or 0.4;

    SetTextFont(args.font) 
    SetTextProportional(0) 
    SetTextScale(args.size, args.size)
    SetTextColour(255, 255, 255, 255)
    SetTextEntry("STRING") 
    AddTextComponentString(args.msg or "null") 
    DrawText(args.posx, args.posy) 
end