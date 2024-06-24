ESX = nil

local PlayerData = {}

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

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

local radioOpen = false
local currentVolume = 75
local radioFreq = 0
local radioActif = false
local RadioActived = false
local RadioMute = false

local FrequenceJob = {
    {job = "police", freq = 1},
    {job = "police", freq = 2},
    {job = "police", freq = 3},
    {job = "police", freq = 4},
    {job = "police", freq = 5},
    {job = "ems", freq = 6},
    {job = "ems", freq = 7},
    {job = "ems", freq = 8},
    {job = "ems", freq = 9},
    {job = "ems", freq = 10}
}

RegisterNetEvent('esx:removeInventoryItem')
AddEventHandler('esx:removeInventoryItem', function(item, count)
	if item == "radio" then
        for k,v in pairs(ESX.GetPlayerData().inventory) do
            if v.name == item then
                if v.count < 1 then
                    exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
                    exports["pma-voice"]:SetRadioChannel(0)
                    radioFreq = 0
                    radioActif = false
                    RadioActived = false
                    RadioMute = false
                    IconeRadioMute()
                    closeRadio()
                    SetKeepInputMode(false)
                end
            end
        end
	end
end)

function toggleRadio()
    if radioActif then
        radioOpen = not radioOpen
        SendNUIMessage({
            type = 'showradio',
            toggle = radioOpen
        })
        SetNuiFocus(radioOpen, radioOpen)
        SetKeepInputMode(radioOpen)
    end
end

function closeRadio()
    radioOpen = false
    SendNUIMessage({
        type = 'showradio',
        toggle = false
    })
    SetNuiFocus(false, false)
    SetNuiFocusKeepInput(false)
    SetKeepInputMode(false)
end

RegisterNetEvent('setActiveRadio')
AddEventHandler('setActiveRadio', function()
    radioActif = not radioActif
    if radioActif then
        ESX.Notification("Vous avez ~g~allumé~s~ votre radio")
    else
        ESX.Notification("Vous avez ~r~éteint~s~ votre radio")
        exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
        exports["pma-voice"]:SetRadioChannel(0)
        radioFreq = 0
        radioActif = false
        RadioActived = false
        RadioMute = false
        IconeRadioMute()
        closeRadio()
        SetKeepInputMode(false)
    end
end)

RegisterKeyMapping("+volumeUp", "Augmenter le volume de la radio de 10%", "keyboard", "PAGEUP")
RegisterCommand("+volumeUp", function()
    if radioFreq == 1 and radioActif and currentVolume >= 0 and currentVolume < 100 then
        currentVolume = currentVolume + 5
        exports['pma-voice']:setRadioVolume(currentVolume)
        ESX.DrawMissionText("Volume de la radio à "..math.floor(currentVolume).."%", 2000)
    end
end)

RegisterKeyMapping("+volumeDown", "Réduire le volume de la radio de 10%", "keyboard", "PAGEDOWN")
RegisterCommand("+volumeDown", function()
    if radioFreq == 1 and radioActif and currentVolume > 0 then
        currentVolume = currentVolume - 5
        exports['pma-voice']:setRadioVolume(currentVolume)
        ESX.DrawMissionText("Volume de la radio à "..math.floor(currentVolume).."%", 2000)
    end
end)

RegisterKeyMapping("+radio", "Ouvrir votre radio", "keyboard", "P")
RegisterCommand("+radio", function()
    toggleRadio()
end)

RegisterNetEvent('IconeMuteRadio')
AddEventHandler('IconeMuteRadio', function(status)
    SendNUIMessage({
        type = 'showMuteIcon',
        toggle = status
    })
    SendNUIMessage({
        type = 'IconRadio',
        toggle = status
    })
    SendNUIMessage({
        type = 'IconMicro',
        toggle = status
    })
end)

function IconeRadioMute()
    SendNUIMessage({
        type = 'showMuteIcon',
        toggle = true
    })
    SendNUIMessage({
        type = 'IconRadio',
        toggle = true
    })
    SendNUIMessage({
        type = 'IconMicro',
        toggle = true
    })
    SendNUIMessage({
        type = 'setFrequence',
        data = ""
    })
end
 
RegisterNUICallback('requestFreq', function(data, cb)
    if RadioActived then
        SetNuiFocus(false, false)
        local frequence = ESX.KeyboardInput("Fréquence", 5)

        for k, v in pairs(FrequenceJob) do           
            if tonumber(frequence) == v.freq and PlayerData.job.name ~= v.job then
                SetNuiFocus(true, true)
                ESX.ShowNotification("~r~Impossible de se connecter à une fréquence privée.")
                return
            end
        end

        print('ok')

        if frequence ~= '' and tonumber(frequence) and frequence ~= nil then
            SendNUIMessage({
                type = 'setFrequence',
                data = frequence
            })
            ESX.ShowNotification("Vous avez ~g~connecté~s~ votre ~g~radio~s~ à la fréquence ~g~"..frequence.."Hz")
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
            exports["pma-voice"]:SetRadioChannel(frequence)
            ESX.SetFieldValueFromNameEncode("OfflineFreqRadio", frequence)
            radioFreq = 1
            RadioMute = true
            SetNuiFocus(true, true)
            TriggerEvent("CallRadioDefault")
        else
            SetNuiFocus(true, true)
        end
    end
    cb('ok')
end)

RegisterNUICallback('closeRadio', function()
    closeRadio()
end)

RegisterNUICallback('muteRadio', function()
    if RadioActived and RadioMute then
        ExecuteCommand("-muteradio")
    end
end)

RegisterNUICallback('offRadio', function()
    if RadioActived then
        exports["pma-voice"]:setVoiceProperty("radioEnabled", false)
        exports["pma-voice"]:SetRadioChannel(0)
        ESX.Notification("Vous avez ~r~désactivé~s~ la radio.")
        radioFreq = 0
        RadioActived = false
        RadioMute = false
        SendNUIMessage({
            type = 'IconRadio',
            toggle = true
        })
    else
        ESX.Notification("Vous avez ~g~activé~s~ la radio.")
        RadioActived = true
        SendNUIMessage({
            type = "showIconsRadioOn"
        })
        if json.encode(ESX.GetFieldValueFromName("OfflineFreqRadio")) ~= "[]" then
            local freq = ESX.GetFieldValueFromName("OfflineFreqRadio")

            for k, v in pairs(FrequenceJob) do           
                if tonumber(freq) == v.freq and PlayerData.job.name ~= v.job then
                    SetNuiFocus(true, true)
                    return
                end
            end

            SendNUIMessage({
                type = 'setFrequence',
                data = freq
            })
            ESX.ShowNotification("Vous avez ~g~connecté~s~ votre ~g~radio~s~ à la fréquence ~g~"..freq.."Hz")
            exports["pma-voice"]:setVoiceProperty("radioEnabled", true)
            exports["pma-voice"]:SetRadioChannel(freq)
            ESX.SetFieldValueFromNameEncode("OfflineFreqRadio", freq)
            radioFreq = 1
            RadioMute = true
            SetNuiFocus(true, true)
            TriggerEvent("CallRadioDefault")
        end
    end
end)

RegisterNUICallback('volumeUp', function()
    if radioFreq and RadioActived and currentVolume >= 0 and currentVolume < 100 then
        currentVolume = currentVolume + 5
        exports['pma-voice']:setRadioVolume(currentVolume)
        ESX.DrawMissionText("Volume de la radio à "..math.floor(currentVolume).."%", 2000)
    end
end)

RegisterNUICallback('volumeDown', function()
    if radioFreq and RadioActived and currentVolume > 0 then
        currentVolume = currentVolume - 5
        exports['pma-voice']:setRadioVolume(currentVolume)
        ESX.DrawMissionText("Volume de la radio à "..math.floor(currentVolume).."%", 2000)
    end
end)

local controlDisabled = {1, 2, 3, 4, 5, 6, 18, 24, 25, 37, 68, 69, 70, 91, 92, 182, 199, 200, 257}

function SetKeepInputMode(bool)
    if SetNuiFocusKeepInput then
        SetNuiFocusKeepInput(bool)
    end

    KEEP_FOCUS = bool

    if not threadCreated and bool then
        threadCreated = true

        Citizen.CreateThread(function()
            while KEEP_FOCUS do
                Wait(0)

                for _,v in pairs(controlDisabled) do
                    DisableControlAction(0, v, true)
                end
            end

            threadCreated = false
        end)
    end
end