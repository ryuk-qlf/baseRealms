ESX = nil
TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)

Citizen.CreateThread(function()
	while true do
		SetDiscordAppId(947227794671300618)
    	SetDiscordRichPresenceAsset('logo')
        SetDiscordRichPresenceAction(0, "Discord", "https://discord.gg/A8kktNv4Yc")
        ESX.TriggerServerCallback("GetPlayers", function(players)
            SetRichPresence(GetPlayerName(PlayerId()) .. " - ".. #players .. "/1024")
        end)
		Citizen.Wait(60000)
	end
end)