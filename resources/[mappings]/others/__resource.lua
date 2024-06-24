fx_version 'cerulean'
game 'gta5'

version '1.4'

ui_page "speedometer/ui/index.html"

client_scripts {
	"speedometer/client.lua",
}

files {
	"handling/casino/**/*.meta",
	'handling/handling/handling.meta',
	'handling/handling/vehicles.meta',
	'handling/handling/carcols.meta',
	'handling/handling/carvariations.meta',
	'handling/handling/vehiclelayouts.meta',

	"speedometer/ui/index.html",
	"speedometer/ui/assets/clignotant-droite.svg",
	"speedometer/ui/assets/clignotant-gauche.svg",
	"speedometer/ui/assets/feu-position.svg",
	"speedometer/ui/assets/feu-route.svg",
	"speedometer/ui/assets/fuel.svg",
	"speedometer/ui/fonts/fonts/Roboto-Bold.ttf",
	"speedometer/ui/fonts/fonts/Roboto-Regular.ttf",
	"speedometer/ui/script.js",
	"speedometer/ui/style.css",
	"speedometer/ui/debounce.min.js",

    'loadingscreen/index.html',
    'loadingscreen/music/load.mp3',
    'loadingscreen/img/*.png',
	'loadingscreen/css/bootstrap.css',
    'loadingscreen/css/owl.carousel.css',
	'loadingscreen/css/style.css',
    'loadingscreen/js/jquery.ajaxchimp.js',
	'loadingscreen/js/jquery.backstretch.min.js',
    'loadingscreen/js/jquery-1.11.0.min.js',
	'loadingscreen/js/lj-safety-first.js',
    'loadingscreen/js/owl.carousel.min.js',

	'weapons/weapons.meta',
	'weapons/loadouts.meta',
	'weapons/explosion.ymt',
	'weapons/recul/weaponautoshotgun.meta',
	'weapons/recul/weaponbullpuprifle.meta',
	'weapons/recul/weaponcombatpdw.meta',
	'weapons/recul/weaponcompactrifle.meta',
	'weapons/recul/weapondbshotgun.meta',
	'weapons/recul/weaponfirework.meta',
	'weapons/recul/weapongusenberg.meta',
	'weapons/recul/weaponheavypistol.meta',
	'weapons/recul/weaponheavyshotgun.meta',
	'weapons/recul/weaponmachinepistol.meta',
	'weapons/recul/weaponmarksmanpistol.meta',
	'weapons/recul/weaponmarksmanrifle.meta',
	'weapons/recul/weaponminismg.meta',
	'weapons/recul/weaponmusket.meta',
	'weapons/recul/weaponrevolver.meta',
	'weapons/recul/weapons_assaultrifle_mk2.meta',
	'weapons/recul/weapons_bullpuprifle_mk2.meta',
	'weapons/recul/weapons_carbinerifle_mk2.meta',
	'weapons/recul/weapons_combatmg_mk2.meta',
	'weapons/recul/weapons_heavysniper_mk2.meta',
	'weapons/recul/weapons_marksmanrifle_mk2.meta',
	'weapons/recul/weapons_pumpshotgun_mk2.meta',
	'weapons/recul/weapons_revolver_mk2.meta',
	'weapons/recul/weapons_smg_mk2.meta',
	'weapons/recul/weapons_snspistol_mk2.meta',
	'weapons/recul/weapons_specialcarbine_mk2.meta',
	'weapons/recul/weaponsnspistol.meta',
	'weapons/recul/weaponspecialcarbine.meta',
	'weapons/recul/weaponvintagepistol.meta',
	'weapons/recul/weapon_combatshotgun.meta',
	'weapons/recul/weapon_militaryrifle.meta',
	'weapons/melee/weaponknuckle.meta',
	'weapons/melee/weaponswitchblade.meta',
	'weapons/melee/weaponbottle.meta',
	'weapons/melee/weaponpoolcue.meta',
	'weapons/vehicles/*.meta',
}

--- Loading Screen ---

loadscreen 'loadingscreen/index.html'

--- Vehicles ---

data_file 'HANDLING_FILE' 'casino/**/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'casino/**/vehicles.meta'
data_file 'HANDLING_FILE' 'handling/handling/handling.meta'
data_file 'VEHICLE_METADATA_FILE' 'handling/handling/vehicles.meta'
data_file 'CARCOLS_FILE' 'handling/handling/carcols.meta'
data_file 'VEHICLE_VARIATION_FILE' 'handling/handling/carvariations.meta'
data_file 'VEHICLE_LAYOUTS_FILE' 'handling/handling/vehiclelayouts.meta'

--- Weapons ---

data_file 'WEAPONINFO_FILE_PATCH' 'weapons/weapons.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponautoshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponbullpuprifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponcombatpdw.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponcompactrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapondbshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponfirework.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapongusenberg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponheavypistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponheavyshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmachinepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmarksmanpistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmarksmanrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponminismg.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponmusket.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponrevolver.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_assaultrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_bullpuprifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_carbinerifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_combatmg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_heavysniper_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_marksmanrifle_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_pumpshotgun_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_revolver_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_smg_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_snspistol_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapons_specialcarbine_mk2.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponsnspistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponspecialcarbine.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weaponvintagepistol.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapon_combatshotgun.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/recul/weapon_militaryrifle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponknuckle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponswitchblade.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponbottle.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/melee/weaponpoolcue.meta'
data_file 'WEAPONINFO_FILE_PATCH' 'weapons/vehicles/*.meta'