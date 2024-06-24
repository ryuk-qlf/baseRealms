Citizen.CreateThread(function()
	while true do
		local Ped = GetPlayerPed(-1)
		if IsPedInAnyVehicle(Ped) then
			local PedCar = GetVehiclePedIsIn(Ped, false)

			carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
			SendNUIMessage({
				showhud = true,
				speed = carSpeed
			})
			_,feuPosition,feuRoute = GetVehicleLightsState(PedCar)
			if(feuPosition == 1 and feuRoute == 0) then
				SendNUIMessage({
					feuPosition = true
				})
			else
				SendNUIMessage({
					feuPosition = false
				})
			end
			if(feuPosition == 1 and feuRoute == 1) then
				SendNUIMessage({
					feuRoute = true
				})
			else
				SendNUIMessage({
					feuRoute = false
				})
			end

		else
			SendNUIMessage({
				showhud = false
			})
		end

		Citizen.Wait(175)
	end
end)

Citizen.CreateThread(function()
	while true do
		local Ped = GetPlayerPed(-1)
		if(IsPedInAnyVehicle(Ped)) then
			local PedCar = GetVehiclePedIsIn(Ped, false)
			if PedCar and GetPedInVehicleSeat(PedCar, -1) == Ped then
				carSpeed = math.ceil(GetEntitySpeed(PedCar) * 3.6)
				fuel = GetVehicleFuelLevel(PedCar)

				SendNUIMessage({
					showfuel = true,
					fuel = fuel
				})
			end
		end

		Citizen.Wait(350)
	end
end)