Config = []

Config.YoutubeAPI = 'AIzaSyAxTUVRP9stRTaUi4owwe_ykOq6rTPBP3M' // Create your API here: https://www.youtube.com/watch?v=N18czV5tj5o
Config.YoutubePlaylist = 'PLthRQzseatzv8gLzQSxuMoofoZjvqlPTJ' // Create an album and paste the end of the link here.

Config.DefaultAlbum = 'Album' // This is the prefix for Gallery Albums.

Config.JobsBlockedToContact = [ // Skip this part.
    "police",
    "ambulance",
    "mechanic",
]


// Don't touch this, it won't make any changes.
Config.HeaderDisabledApps = [
    "bank",
    "whatsapp",
    "meos",
    "garage",
    "racing",
    "houses",
    "lawyers",
    "youtube",
]

// Weather translations for your widget.
function WeatherTranslation(x) {
    if (x == "RAIN") { x = "Pluie" }
    else if (x == "THUNDER") { x = "Orages" }
    else if (x == "CLEARING") { x = "Clair" }
    else if (x == "CLEAR") { x = "Clair" }
    else if (x == "EXTRASUNNY") { x = "Soleil" }
    else if (x == "CLOUDS") { x = "Nuages" }
    else if (x == "OVERCAST") { x = "Nuageux" }
    else if (x == "SMOG") { x = "Brouillard" }
    else if (x == "FOGGY") { x = "Brouillard" }
    else if (x == "XMAS") { x = "Noel" }
    else if (x == "SNOWLIGHT") { x = "Neige" }
    else if (x == "BLIZZARD") { x = "Blizzard" }
    else if (x == "BILINMIYOR") { x = "Autre" } else { x = "Autre" }
    return x
}

// Dates of your phone.
Config.January = "Janvier"
Config.February = "Fevrier"
Config.March = "Mars"
Config.April = "Avril"
Config.May = "Mai"
Config.June = "Juin"
Config.July = "Juillet"
Config.August = "Aout"
Config.September = "Septembre"
Config.October = "Octobre"
Config.November = "Novembre"
Config.December = "Decembre"

Config.Jan = "Jan"
Config.Feb = "Fev"
Config.Mar = "Mar"
Config.Apr = "Avr"
Config.May = "Mai"
Config.Jun = "Jui"
Config.Jul = "Jui"
Config.Aug = "Aou"
Config.Sept = "Sep"
Config.Oct = "Oct"
Config.Nov = "Nov"
Config.Dec = "Dec"

Config.Sunday = "Dimanche"
Config.Monday = "Lundi"
Config.Tuesday = "Mardi"
Config.Wednesday = "Mercredi"
Config.Thursday = "Jeudi"
Config.Friday = "Vendredi"
Config.Saturday = "Samedi"

Config.Everyday = "Chaque jour"
Config.Weekend = "Weekend"
Config.Weekdays = "Semaine"

// App state, remember to edit the html too.
Config.Job1 = "police" // Default "police"
Config.Job2 = "ems" // Default "ambulance"
Config.Job3 = "lawyer" // Default "lawyer"
Config.Job4 = "taxi" // Default "taxi"

// Skip this part.
Config.HeaderColors = {
    "image-zoom": {
        "top": "black",
        "bottom": "white"
    },
    "store": {
        "top": "black",
        "bottom": "black"
    },
    "bank": {
        "top": "white",
        "bottom": "white"
    },
    "twitter": {
        "top": "black",
        "bottom": "black"
    },
    "phone": {
        "top": "black",
        "bottom": "black"
    },
    "mail": {
        "top": "black",
        "bottom": "black"
    },
    "advert": {
        "top": "black",
        "bottom": "black"
    },
    "racing": {
        "top": "white",
        "bottom": "white"
    },
    "houses": {
        "top": "white",
        "bottom": "white"
    },
    "food": {
        "top": "white",
        "bottom": "black"
    },
    "food": {
        "top": "white",
        "bottom": "black"
    },
    "clock": {
        "top": "black",
        "bottom": "black"
    },
    "calculator": {
        "top": "white",
        "bottom": "white"
    },
    "arrests": {
        "top": "white",
        "bottom": "black"
    },
    "whatsapp": {
        "top": "black",
        "bottom": "black"
    },
    "settings": {
        "top": "black",
        "bottom": "black"
    },
    "photos": {
        "top": "black",
        "bottom": "black"
    },
}