ESX = nil
TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

local School = {
    Right = 0,
    CurrentTest = nil,
    Start = false,
    Drivetest = nil,
    CurrentCheckPoint = 0,
    DriveErrors = 0,
    LastCheckPoint = -1,
    CurrentBlip = nil,
    CurrentZoneType = nil,
    IsAboveSpeedLimit = false,
    VehicleHealth = nil,
    Blockitcar = false,
}


local Success = false
local permisCar = false 
local permisMoto = false 
local permisTruck = false

School.openedMenu = false
School.openedMenu2 = false
School.mainMenu = RageUI.CreateMenu("AutoSchool", " ")
School.mainMenu:SetRectangleBanner(235, 134, 52, 70)
School.mainMenu2 = RageUI.CreateMenu("AutoSchool", " ")
School.mainMenu2:SetRectangleBanner(235, 134, 52, 70)

School.subMenuQuestion1 = RageUI.CreateSubMenu(School.mainMenu2, "Question 1", " ")
School.subMenuQuestion1:SetRectangleBanner(235, 134, 52, 70)
School.subMenuQuestion1.Closable = false
School.subMenuQuestion2 = RageUI.CreateSubMenu(School.mainMenu2, "Question 2", " ")
School.subMenuQuestion2.Closable = false
School.subMenuQuestion2:SetRectangleBanner(235, 134, 52, 70)
School.subMenuQuestion3 = RageUI.CreateSubMenu(School.mainMenu2, "Question 3", " ")
School.subMenuQuestion3.Closable = false
School.subMenuQuestion3:SetRectangleBanner(235, 134, 52, 70)
School.subMenuQuestion4 = RageUI.CreateSubMenu(School.mainMenu2, "Question 4", " ")
School.subMenuQuestion4.Closable = false
School.subMenuQuestion4:SetRectangleBanner(235, 134, 52, 70)
School.subMenuQuestion5 = RageUI.CreateSubMenu(School.mainMenu2, "Question 5", " ")
School.subMenuQuestion5.Closable = false
School.subMenuQuestion5:SetRectangleBanner(235, 134, 52, 70)

School.subMenuFinish = RageUI.CreateSubMenu(School.mainMenu2, "Terminé", " ")
School.subMenuFinish:SetRectangleBanner(235, 134, 52, 70)

School.mainMenu.Closed = function()
    School.openedMenu = false
end
School.mainMenu2.Closed = function()
    School.openedMenu2 = false
end

function SetCurrentZoneType(type)
    School.CurrentZoneType = type
end

function StopDriveTest(Success)
	if Success then
		local car = GetVehiclePedIsIn(PlayerPedId(), false)
		RemoveBlip(School.CurrentBlip)
		ESX.Notification("~b~Bravo~w~\nVous avez réussi ~o~l\'épreuve du permis~w~, vous l'avez dès maintenant, en votre possession.")
		if DoesEntityExist(car) then
			DeleteEntity(car)
			SetVehicleAsNoLongerNeeded(car)
		end
		if DoesEntityExist(pedss) then
			DeleteEntity(pedss)
		end
        School.Blockitcar = true
		if School.SpawnVeh == "blista" then
			permis = "car"
		elseif School.SpawnVeh == "bati" then
			permis = "motor"
		elseif School.SpawnVeh == "mule2" then
			permis = "heavycar"
		end
        TriggerServerEvent('GivePermis', permis)
	else
		if DoesEntityExist(pedss) then
			DeleteEntity(pedss)
		end
		ESX.Notification("~r~Malheureusement~w~\nVous avez raté ~o~l\'épreuve du permis~w~, ce n'est pas grave, vous pouvez le repasser quand vous voulez.")			
		if DoesEntityExist(car) then
			DeleteEntity(car)
			SetVehicleAsNoLongerNeeded(car)
		end
	end
	School.Start = false
	School.CurrentTest = nil
end

local CheckPoints = {
	{
		Pos = {x = 216.204, y = 370.29, z = 106.323},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Aller sur la route\n- Tourner à gauche, vitesse limitée à~w~ ~y~80km/h.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 236.32, y = 346.78, z = 105.57},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 403.16, y = 300.05, z = 103.00},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 548.00, y = 247.555, z = 103.09},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 658.73, y = 213.41, z = 95.93},
        Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Maintenant~w~\n- Tourner à droite, n'oubliez pas les clignotants")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 670.106, y = 194.68, z = 93.19},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~o~Zone Résidentielle~w~\nVous entrez dans une zone résidentielle, vitesse limitée: ~y~50km/h.")
			TestAuto = 0
		end
	},
	{
		Pos = {x = 625.11, y = 69.87, z = 90.11},
		Action = function(playerPed, setCurrentZoneType)
			setCurrentZoneType('town')
			ESX.Notification("~b~Maintenant~w~\n- Prenez à droite, vitesse limitée: ~y~80km/h.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 534.88, y = 75.044, z = 96.37},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Maintenant~w~\n- Tourner à gauche quand le feu sera vert.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 484.05, y = 39.68, z = 92.18},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Aller vers le prochain passage\n- Continuer tout droit.")
			TestAuto = 1
		end
	},	
	{
		Pos = {x = 401.702, y = -108.51, z = 65.19}, 
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 358.86, y = -245.34, z = 53.97},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 317.28, y = -362.89, z = 45.25},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 294.85, y = -456.19, z = 43.28},
		Action = function(playerPed, setCurrentZoneType)
			setCurrentZoneType("freeway")
			ESX.Notification("~b~Zone Autoroute~w~\n- Tourner à droite, vitesse limitée: ~y~ 120km/h.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = 68.52, y = -479.70, z = 34.06},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- S\'insérer\n- Continuer tout droit jusqu'à la sortie indiqué")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -138.31, y = -494.899, z = 29.42},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -688.59, y = -497.28, z = 25.19},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -989.10, y = -546.41, z = 18.35},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Maintenant~w~\n- Ralentir dans la voie d\'insertion.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -1157.47, y = -638.79, z = 22.72},
		Action = function(playerPed, setCurrentZoneType)
			setCurrentZoneType("town")
			ESX.Notification("~b~Maintenant~w~\n- Tourner à gauche, vitesse limitée: ~y~80km/h.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = -1142.446, y = -691.37, z = 21.63},
		Action = function(playerPed, setCurrentZoneType)
			setCurrentZoneType("freeway")
			ESX.Notification("~b~Maintenant~w~\n- Tourner à gauche, attention au feu.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -1016.85, y = -616.55, z = 18.26},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit, vitesse limitée: ~y~120km/h.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -849.54, y = -541.89, z = 22.83},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -490.50, y = -530.48, z = 25.33},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = -26.30, y = -527.42, z = 33.25},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit, se préparer à tourner à droite et ralentir.")
			TestAuto = 2
		end
	},
	{
		Pos = {x = 91.53, y = -544.01, z = 33.84},
		Action = function(playerPed, setCurrentZoneType)
			setCurrentZoneType("town")
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit, vitesse limitée: ~y~80km/h.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 252.99, y = -543.60, z = 43.21},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Maintenant~w~\n- Tourner à gauche, attention au feu.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 306.79, y = -459.09, z = 43.32},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 318.32, y = -410.10, z = 45.12},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 351.15, y = -293.01, z = 53.88},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 400.48, y = -149.67, z = 64.69},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 508.28, y = 56.62, z = 95.80},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 563.84, y = 228.76, z = 103.04},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Tourner à gauche.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 437.77, y = 293.12, z = 102.99},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 275.69, y = 337.76, z = 105.51},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Bien~w~\nAttention au feu\n- Continuer tout droit.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 223.73, y = 356.74, z = 105.85},
		Action = function(playerPed, setCurrentZoneType)
			ESX.Notification("~b~Maintenant~w~\n- Tourner à droite.")
			TestAuto = 1
		end
	},
	{
		Pos = {x = 213.72, y = 389.25, z = 106.84},
		Action = function(playerPed, setCurrentZoneType)
			School.Start = false
			if School.DriveErrors < 5 then
				StopDriveTest(true)
			else
				StopDriveTest(false)
			end
		end
	},
}

function StartConduite()
	School.Start = true
	while School.Start do
		Wait(0)
		DisableControlAction(0, 75, true)
		if School.CurrentTest == 'drive' then
			local nextCheckPoint = School.CurrentCheckPoint + 1
			if CheckPoints[nextCheckPoint] == nil then
				if DoesBlipExist(School.CurrentBlip) then
					RemoveBlip(School.CurrentBlip)
				end

				School.CurrentTest = nil

				while not IsPedheadshotReady(RegisterPedheadshot(PlayerPedId())) or not IsPedheadshotValid(RegisterPedheadshot(PlayerPedId())) do
					Wait(100)
				end
		
				BeginTextCommandThefeedPost("PS_UPDATE")
				AddTextComponentInteger(50)
				EndTextCommandThefeedPostStats("PSF_DRIVING", 14, 50, 25, false, GetPedheadshotTxdString(RegisterPedheadshot(PlayerPedId())), GetPedheadshotTxdString(RegisterPedheadshot(PlayerPedId())))
				EndTextCommandThefeedPostTicker(false, true)
				UnregisterPedheadshot(RegisterPedheadshot(PlayerPedId()))
			else
				if School.CurrentCheckPoint ~= School.LastCheckPoint then
					if DoesBlipExist(School.CurrentBlip) then
						RemoveBlip(School.CurrentBlip)
					end
					School.CurrentBlip = AddBlipForCoord(CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z)
					SetBlipRoute(School.CurrentBlip, 1)
					School.LastCheckPoint = School.CurrentCheckPoint
				end

				local distance = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, true)
				if distance <= 90.0 then
					DrawMarker(36, CheckPoints[nextCheckPoint].Pos.x, CheckPoints[nextCheckPoint].Pos.y, CheckPoints[nextCheckPoint].Pos.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 102, 204, 102, 100, false, true, 2, false, false, false, false)
				end
				if distance <= 3.0 then
					CheckPoints[nextCheckPoint].Action(PlayerPedId(), SetCurrentZoneType)
					School.CurrentCheckPoint = School.CurrentCheckPoint + 1
				end
			end

			if IsPedInAnyVehicle(GetPlayerPed(-1), false) then

				local vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
				local speed = GetEntitySpeed(vehicle) * 3.6
				local tooMuchSpeed = false
				local GetSpeed = math.floor(GetEntitySpeed(vehicle) * 3.6)
				local speed_limit_residence = 50.0
				local speed_limit_ville = 80.0
				local speed_limit_autoroute = 120.0
				local DamageControl = 0

				if TestAuto == 0 and GetSpeed >= speed_limit_residence then
					tooMuchSpeed = true
					School.DriveErrors = School.DriveErrors + 1
					School.IsAboveSpeedLimit = true
                    ESX.Notification('~r~Vous avez fait une erreur~w~\nVous roulez trop vite, vitesse limite : ' ..speed_limit_residence.. ' km/h')
					ESX.DrawMissionText("Nombre d'erreurs "..School.DriveErrors.."/5", 4000)
					Wait(2000) -- évite bug
				end

				if TestAuto == 1 and GetSpeed >= speed_limit_ville then
					tooMuchSpeed = true
					School.DriveErrors = School.DriveErrors + 1
					School.IsAboveSpeedLimit = true
					ESX.Notification('~r~Vous avez fait une erreur~w~\nVous roulez trop vite, vitesse limite : ' ..speed_limit_ville.. ' km/h')
					ESX.DrawMissionText("Nombre d'erreurs "..School.DriveErrors.."/5", 4000)
					Wait(2000)
				end

				if TestAuto == 2 and GetSpeed >= speed_limit_autoroute then
					tooMuchSpeed = true
					School.DriveErrors = School.DriveErrors + 1
					School.IsAboveSpeedLimit = true
					ESX.Notification('~r~Vous avez fait une erreur~w~\nVous roulez trop vite, vitesse limite : ' ..speed_limit_autoroute.. ' km/h')
					ESX.DrawMissionText("Nombre d'erreurs "..School.DriveErrors.."/5", 4000)
					Wait(2000)
				end

				if HasEntityCollidedWithAnything(vehicle) and DamageControl == 0 then
					School.DriveErrors = School.DriveErrors + 1
					ESX.Notification('~r~Vous avez fait une erreur~w~\nVotre vehicule s\'est prit des dégats')
					ESX.DrawMissionText("Nombre d'erreurs "..School.DriveErrors.."/5", 4000)
					Wait(2000)
				end

				if not tooMuchSpeed then
					School.IsAboveSpeedLimit = false
				end

				if GetEntityHealth(vehicle) < GetEntityHealth(vehicle) then

					School.DriveErrors = School.DriveErrors + 1

					ESX.Notification('~r~Vous avez fait une erreur~w~\nVotre vehicule s\'est prit des dégats\n~r~Nombre d\'erreurs ' ..School.DriveErrors.. '/5')
					
					School.VehicleHealth = GetEntityHealth(vehicle)
					Wait(2000)
				end
				if School.DriveErrors >= 5 then
					RemoveBlip(School.CurrentBlip)
					School.CurrentCheckPoint = 1
					ESX.Game.DeleteVehicle(GetVehiclePedIsIn(GetPlayerPed(-1), false))
					SetEntityCoords(GetPlayerPed(-1), 204.82, 377.133, 107.24)
					StopDriveTest(false)
					School.DriveErrors = 0
					School.CurrentCheckPoint = 0
				end
			end
		else
			Wait(500)
		end
	end
end

function StartDriveTest(car)
	School.SpawnVeh = car
	School.CurrentTest = 'drive'
	School.Start = true
	RequestModel(GetHashKey(car))
	while not HasModelLoaded(GetHashKey(car)) do
        Wait(100)
    end
	local veh = CreateVehicle(GetHashKey(car), 213.61, 389.34, 106.85, 171.44, 1, 0)
	TaskEnterVehicle(GetPlayerPed(-1), veh, 20000, -1, 2.0, 3, 0)
	SetEntityAsMissionEntity(veh, true, false)
    StartConduite()
end

function openSchoolMenu()
	if School.openedMenu then 
		School.openedMenu = false 
		RageUI.Visible(School.mainMenu, false)
	else
		Wait(150)
		School.openedMenu = true 
		RageUI.Visible(School.mainMenu, true)
		Citizen.CreateThread(function()
			while School.openedMenu do 
					RageUI.IsVisible(School.mainMenu, function()
						RageUI.Button("Passer le permis voiture", nil, {RightLabel = "~g~50$~s~"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('IfHasMoney', function(cb)
									if cb then
										RageUI.CloseAll()
										School.openedMenu = false 
										StartDriveTest("blista")
									else
										ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(50$)')
									end
								end, 50)
							end
						})
						RageUI.Button("Passer le permis moto", nil, {RightLabel = "~g~50$~s~"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('IfHasMoney', function(cb)
									if cb then
										RageUI.CloseAll()
										School.openedMenu = false 
										StartDriveTest("bati")
									else
										ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(50$)')
									end
								end, 50)
							end
						})
						RageUI.Button("Passer le permis camion", nil, {RightLabel = "~g~50$~s~"}, true, {
							onSelected = function()
								ESX.TriggerServerCallback('IfHasMoney', function(cb)
									if cb then
										RageUI.CloseAll()
										School.openedMenu = false 
										StartDriveTest("mule2")
									else
										ESX.ShowNotification('~r~Vous n\'avez pas assez d\'argent ~g~(50$)')
									end
								end, 50)
							end
						})
					end)            
				Wait(1)
			end
		end)
	end
end

function openSchoolMenu2()
	if School.openedMenu2 then 
		School.openedMenu2 = false 
		RageUI.Visible(School.mainMenu2, false)
	else
		School.openedMenu2 = true 
		RageUI.Visible(School.mainMenu2, true)
		Citizen.CreateThread(function()
			while School.openedMenu2 do 
					RageUI.IsVisible(School.mainMenu2, function()
						RageUI.Separator("Bienvenue à ~y~AutoSchool")
						RageUI.Button("Passer le code", nil, {RightLabel = "~g~25$"}, true, {
							onSelected = function()
								TriggerServerEvent("removeMoneyCode")
							end
						}, School.subMenuQuestion1)
					end)   

					RageUI.IsVisible(School.subMenuQuestion1, function()
						RageUI.Separator("Je peux griller un feu ~r~rouge~s~ quand :")
						RageUI.Button("Je tourne à droite et que la voie est libre", nil, {}, true, {}, School.subMenuQuestion2)
						RageUI.Button("Je tourne à gauche et que la voie est libre", nil, {}, true, {}, School.subMenuQuestion2)
						RageUI.Button("Jamais, on ne peut pas griller de feu rouge", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuQuestion2)
					end)       

					RageUI.IsVisible(School.subMenuQuestion2, function()
						RageUI.Separator("La distance entre un vélo")
						RageUI.Separator("et vous doit-être en agglomération de :")
						RageUI.Button("1,50 mètre", nil, {}, true, {}, School.subMenuQuestion3)
						RageUI.Button("1 mètre", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuQuestion3)
					end)     

					RageUI.IsVisible(School.subMenuQuestion3, function()
						RageUI.Separator("Quel est le taux d'alcool")
						RageUI.Separator("à ne pas dépasser pour conduire ?")
						RageUI.Button("0,5 g/L de sang", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuQuestion4)
						RageUI.Button("0,25 mg/L d'air expiré", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuQuestion4)
						RageUI.Button("0,12 g/L de sang", nil, {}, true, {}, School.subMenuQuestion4)
						RageUI.Button("0,32 mg/L d'air expiré", nil, {}, true, {}, School.subMenuQuestion4)
					end)    
					
					RageUI.IsVisible(School.subMenuQuestion4, function()
						RageUI.Separator("Quel est la limitation de vitesse en ville ?")
						RageUI.Button("110 ~y~km~s~/~b~h~s~", nil, {}, true, {}, School.subMenuQuestion5)
						RageUI.Button("80 ~y~km~s~/~b~h~s~", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuQuestion5)
						RageUI.Button("60 ~y~km~s~/~b~h~s~", nil, {}, true, {}, School.subMenuQuestion5)
					end)      
					
					RageUI.IsVisible(School.subMenuQuestion5, function()
						RageUI.Separator("Quel est la limitation de vitesse")
						RageUI.Separator("sur l\'autoroute ?")
						RageUI.Button("110 ~y~km~s~/~b~h~s~", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuFinish)
						RageUI.Button("130 ~y~km~s~/~b~h~s~", nil, {}, true, {
							onSelected = function()
								School.Right = School.Right + 1
								print(School.Right)
							end
						}, School.subMenuFinish)
						RageUI.Button("100 ~y~km~s~/~b~h~s~", nil, {}, true, {}, School.subMenuFinish)
					end)  
					
					RageUI.IsVisible(School.subMenuFinish, function()
						if School.Right >= 3 then 
							RageUI.Separator("~g~Félicitations~s~ à vous")
							RageUI.Separator("Examen réussi avec succès :")
							RageUI.Button("Récupérer votre code", nil, {RightLabel = "→"}, true, {
								onSelected = function()
									print("Ma license")
									ESX.Notification("~b~Bravo~w~ à vous, vous avez passé ~o~l'épreuve du code~w~\nmaintenant, à vous de jouer pour ~o~le permis~w~")
									TriggerServerEvent("GiveCode")
									School.openedMenu2 = false
								end
							})
						else 
							RageUI.Separator("Vous avez ~r~échoué~s~")
							RageUI.Separator("Ce n'est pas grave :")
							RageUI.Button("Repasser votre code", nil, {RightLabel = "→"}, true, {
								onSelected = function()
									School.openedMenu2 = false
									School.Right = 0
								end
							})
						end
					end)
				Wait(1)
			end
		end)
	end
end

CreateThread(function()
    while true do
        local time = 1000
		local plyCoords = GetEntityCoords(GetPlayerPed(-1))
        local dist = Vdist2(plyCoords.x, plyCoords.y, plyCoords.z, 232.15, 365.02, 106.07)

		if dist <= 2.0 then
			time = 5
			DisplayNotification("Appuyez sur ~INPUT_TALK~ pour intéragir avec ~b~Luc.")
			if IsControlJustPressed(0, 51) then
				ESX.TriggerServerCallback("getInfoAutoEcole", function(codeRight)
					if codeRight == 1 then
						openSchoolMenu()
					elseif codeRight == 0 then
						openSchoolMenu2()
					end
				end)
			end
		end
		Wait(time)
    end
end)