local fov_max = 70.0
local fov_min = 5.0
local zoomspeed = 10.0

local binoculars = false
local fov = (fov_max+fov_min)*0.5

RegisterNetEvent('useJumelle')
AddEventHandler('useJumelle', function()
    local lPed = GetPlayerPed(-1)
	if not IsPedSittingInAnyVehicle(lPed) then
		binoculars = true

		TaskStartScenarioInPlace(GetPlayerPed(-1), "WORLD_HUMAN_BINOCULARS", 0, 1)
		PlayAmbientSpeech1(GetPlayerPed(-1), "GENERIC_CURSE_MED", "SPEECH_PARAMS_FORCE")

		Wait(2000)

		local scaleform = RequestScaleformMovie("BINOCULARS")

		while not HasScaleformMovieLoaded(scaleform) do
			Citizen.Wait(1)
		end

		local lPed = GetPlayerPed(-1)
		local cam = CreateCam("DEFAULT_SCRIPTED_FLY_CAMERA", true)

		AttachCamToEntity(cam, lPed, 0.0, 0.0, 1.0, true)
		SetCamRot(cam, 0.0, 0.0, GetEntityHeading(lPed))
		SetCamFov(cam, fov)
		RenderScriptCams(true, false, 0, 1, 0)
		PushScaleformMovieFunction(scaleform, "SET_CAM_LOGO")
		PushScaleformMovieFunctionParameterInt(0)
		PopScaleformMovieFunctionVoid()
			
		while binoculars and not IsEntityDead(lPed) do
			if IsControlJustPressed(0, 177) then
				PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", false)
				ClearPedTasks(GetPlayerPed(-1))
				ClearTimecycleModifier()
				fov = (fov_max+fov_min)*0.5
				RenderScriptCams(false, false, 0, 1, 0)
				SetScaleformMovieAsNoLongerNeeded(scaleform)
				DestroyCam(cam, false)
				SetNightvision(false)
				SetSeethrough(false)
				binoculars = false
			end

			local zoomvalue = (1.0/(fov_max-fov_min))*(fov-fov_min)
			CheckInputRotation(cam, zoomvalue)
			Zoom(cam)
			HideHUDThisFrame()
			DrawScaleformMovieFullscreen(scaleform, 255, 255, 255, 255)
			Citizen.Wait(1)
		end
	end
end)

function HideHUDThisFrame()
	HideHelpTextThisFrame()
	HideHudAndRadarThisFrame()
	HideHudComponentThisFrame(1) 
	HideHudComponentThisFrame(2) 
	HideHudComponentThisFrame(3) 
	HideHudComponentThisFrame(4) 
	HideHudComponentThisFrame(6)
	HideHudComponentThisFrame(7)
	HideHudComponentThisFrame(8)
	HideHudComponentThisFrame(9)
	HideHudComponentThisFrame(13)
	HideHudComponentThisFrame(11)
	HideHudComponentThisFrame(12)
	HideHudComponentThisFrame(15)
	HideHudComponentThisFrame(18)
	HideHudComponentThisFrame(19)
end

function CheckInputRotation(cam, zoomvalue)
	local rightAxisX = GetDisabledControlNormal(0, 220)
	local rightAxisY = GetDisabledControlNormal(0, 221)
	local rotation = GetCamRot(cam, 2)
	if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
		new_z = rotation.z + rightAxisX*-1.0*(8.0)*(zoomvalue+0.1)
		new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*(8.0)*(zoomvalue+0.1)), -89.5)
		SetCamRot(cam, new_x, 0.0, new_z, 2)
	end
end

function Zoom(cam)
	local lPed = GetPlayerPed(-1)
	if not IsPedSittingInAnyVehicle(lPed) then
		if IsControlJustPressed(0,241) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,242) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	else
		if IsControlJustPressed(0,17) then
			fov = math.max(fov - zoomspeed, fov_min)
		end
		if IsControlJustPressed(0,16) then
			fov = math.min(fov + zoomspeed, fov_max)
		end
		local current_fov = GetCamFov(cam)
		if math.abs(fov-current_fov) < 0.1 then
			fov = current_fov
		end
		SetCamFov(cam, current_fov + (fov - current_fov)*0.05)
	end
end