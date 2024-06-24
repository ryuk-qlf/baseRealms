RegisterNetEvent('DisplayMic')
AddEventHandler('DisplayMic', function(Icon, Status)
	SendNUIMessage({
		type = Icon,
		toggle = Status
	})
end)