Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)  
	while true do
		Wait(500)
		if NetworkIsSessionStarted() then
			TriggerServerEvent('hardcap:playerActivated')
			return
		end
	end
end)