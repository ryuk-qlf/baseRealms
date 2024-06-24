ESX = nil

Citizen.CreateThread(function()

	while ESX == nil do
		TriggerEvent('LandLife:GetSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    PlayerData = ESX.GetPlayerData() 
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)  
	PlayerData.job = job
	Citizen.Wait(5000)
end)

--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
function syncRadioData(radioTable)
	radioData = radioTable
	logger.info(('[radio] Syncing radio table.'))
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	playMicClicks(enabled)
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource)
	radioData[plySource] = false
	if radioPressed then
		logger.info(('[radio] %s joined radio %s while we were talking, adding them to targets'):format(plySource, radioChannel))
		playerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info(('[radio] %s joined radio %s'):format(plySource, radioChannel))
	end
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info(('[radio] Left radio %s, cleaning up.'):format(radioChannel))
		for tgt, enabled in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false)
			end
		end
		radioData = {}
		playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
	else
		radioData[plySource] = nil
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info(('[radio] %s left radio %s while we were talking, updating targets.'):format(plySource, radioChannel))
			playerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info(('[radio] %s has left radio %s'):format(plySource, radioChannel))
		end
	end
end
RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
	if GetConvarInt('voice_enableUi', 1) == 1 then
		SendNUIMessage({
			radioChannel = channel,
			radioEnabled = radioEnabled
		})
	end
end

--- exports setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
exports('setRadioChannel', setRadioChannel)
-- mumble-voip compatability
exports('SetRadioChannel', setRadioChannel)

--- exports removePlayerFromRadio
--- sets the local players current radio channel and updates the server
exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

--- exports addPlayerToRadio
--- sets the local players current radio channel and updates the server
---@param radio number the channel to set the player to, or 0 to remove them.
exports('addPlayerToRadio', function(radio)
	local radio = tonumber(radio)
	if radio then
		setRadioChannel(radio)
	end
end)

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed.
--[[function isDead()
	if GetResourceState("pma-ambulance") ~= "missing" then
		if LocalPlayer.state.isDead then
			return true
		end
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() then return end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info(('[radio] Start broadcasting, update targets and notify server.'))
			playerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
				RequestAnimDict('random@arrests')
				while not HasAnimDictLoaded('random@arrests') do
					Citizen.Wait(10)
				end
				TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
			end
			Citizen.CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				if PlayerData.job and PlayerData.job.name == 'police' then
					RequestAnimDict("random@arrests")
					while not HasAnimDictLoaded("random@arrests") do
						Wait(1)
					end
					TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, false, false, false)
				end
				while radioPressed do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if radioChannel > 0 or radioEnabled and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(1)
		playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 0) == 1 then

		end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
		if PlayerData.job and PlayerData.job.name == 'police' then
			StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -1.8)
		end
	end
end, false)

RegisterKeyMapping('+radiotalk', 'Parler en radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))]]

local isTalkingRadio = false
local radiomute = true
local CallRadio = false

function StopCallRadio()
	isTalkingRadio = false
	radioPressed = false
	MumbleClearVoiceTargetPlayers(1)
	playerTargets(NetworkIsPlayerTalking(PlayerId()) and callData or {})
	TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	playMicClicks(false)
	TriggerEvent("pma-voice:radioActive", false)
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if CallRadio then
			if not isTalkingRadio then
				if NetworkIsPlayerTalking(PlayerId()) then
					isTalkingRadio = true
					playerTargets(radioData, NetworkIsPlayerTalking(PlayerId()) and callData or {})
					TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
					radioPressed = true
					playMicClicks(true)
					TriggerEvent("pma-voice:radioActive", true)
				end
			elseif isTalkingRadio then
				if not NetworkIsPlayerTalking(PlayerId()) then
					StopCallRadio()
				end
			end
		end
	end
end)

RegisterNetEvent("CallRadioDefault")
AddEventHandler("CallRadioDefault", function()
	CallRadio = true
	TriggerEvent('IconeMuteRadio', false)
end)

RegisterKeyMapping("-muteradio", "Mode muet Radio", "keyboard", "L")

RegisterCommand("-muteradio", function()
	if radioEnabled then
		if radiomute then
			ESX.Notification("Vous avez ~g~activé~s~ le mode muet de votre radio.")
			CallRadio = false
			TriggerEvent('IconeMuteRadio', true)

			if NetworkIsPlayerTalking(PlayerId()) then
				StopCallRadio()
			end
		else
			ESX.Notification("Vous avez ~r~désactivé~w~ le mode muet de votre radio.")
			CallRadio = true
			TriggerEvent('IconeMuteRadio', false)
		end
		radiomute = not radiomute
	end
end, false)

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info(('[radio] radio set serverside update to radio %s'):format(radioChannel))
	radioChannel = _radioChannel
end
RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)