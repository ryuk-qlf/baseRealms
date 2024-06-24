SharedWeather = {}

SharedWeather.lang = "fr"

SharedWeather.weather = {
    "EXTRASUNNY", "CLEAR", "CLOUDS", "NEUTRAL", "CLEARING", "RAIN", "THUNDER"
}

SharedWeather.isWinter = false

SharedWeather.notWinterBlacklist = {
    ["EXTRASUNNY"] = true,
    ["CLEAR"] = true,
    ["CLOUDS"] = true,
    ["NEUTRAL"] = true,
    ["CLEARING"] = true,
    ["RAIN"] = true,
    ["THUNDER"] = true
}

SharedWeather.maxRandom = 4

SharedWeather.default = {
    ["weather"] = "EXTRASUNNY",
    ["nextWeather"] = {
        [1] = "CLEAR",
        [2] = "CLOUDS",
        [3] = "NEUTRAL",
        [1] = "CLEARING",
        [2] = "RAIN",
        [3] = "THUNDER"
    }
}

SharedWeather.text = {
    ["fr"] = {
        ["error_weather"] = "~r~Méteo inconnu",
        ["error_time"] = "~r~Heure / Minute inconnu",
        ["error_bool"] = "~r~Veuillez saisir ~y~true ~r~ou ~y~false",
    },
    ["en"] = {
        ["error_weather"] = "~r~Weather not exist",
        ["error_time"] = "~r~Hours/Minute not exist",
        ["error_bool"] = "~r~Please enter ~y~true ~r~or ~y~false",
    },
}