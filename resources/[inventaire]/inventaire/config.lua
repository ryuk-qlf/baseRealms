Config = {}

Config.Locale = "fr"

Config.IncludeCash = true
Config.IncludeAccounts = true
Config.ExcludeAccountsList = {"bank", "money"}
Config.OpenControl = 289

--- HUD 

Config.AlwaysShowRadar = false -- set to true if you always want the radar to show
Config.ShowStress = true -- set to true if you want a stress indicator
Config.ShowSpeedo = true -- set to true if you want speedometer enabled
Config.ShowVoice = true -- set to false if you want to hide mic indicator
Config.UnitOfSpeed = "kmh"  -- "kmh" or "mph"
Config.UseRadio = true -- Shows headset icon instead of microphone if radio is on - REQUIRES "rp-radio"
Config.ShowFuel = true -- Show fuel indicator

Config.CloseUiItems = {
    "carteidentite",
    "permis",
    "carte",
    "phone",
    "carte"
}