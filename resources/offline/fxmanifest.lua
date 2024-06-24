fx_version 'adamant'
games { 'gta5' };

client_scripts {
	"@lmodeextended/locale.lua",
	"Utils/functions.lua",
	"utils.lua",

	"RageUI/RMenu.lua",
    "RageUI/menu/RageUI.lua",
    "RageUI/menu/Menu.lua",
    "RageUI/menu/MenuController.lua",
    "RageUI/components/*.lua",
    "RageUI/menu/elements/*.lua",
    "RageUI/menu/items/*.lua",
    "RageUI/menu/panels/*.lua",
    "RageUI/menu/windows/*.lua",

	"Divers/activities/drugs/cl_drugs.lua", --
	"Divers/activities/farm/cl_vigneron.lua",
	"Divers/activities/farm/cl_matiere.lua",
	"Divers/activities/farm/cl_conforama.lua",
	"Divers/activities/farm/marker.lua",
	"Divers/activities/peche/cl_fishing.lua",
	"Divers/activities/pelle/cl_shovel.lua",
	"Divers/activities/telescope/cl_telescope.lua",
	"Divers/activities/autoschool/cl_autoschool.lua",
	"Divers/activities/braquagesup/cl_robbery.lua",

	"Divers/builder/crew/cl_crew.lua",
	"Divers/builder/agroalimentaire/cl_agro.lua", --

	"Divers/job/ambulance/cl_ambulance.lua",
	"Divers/job/barber/cl_barber.lua",
	"Divers/job/cardealer/cl_cardealer.lua",
	"Divers/job/cardealer/cl_cardealerservice.lua",
	"Divers/job/centrejob/cl_centrejob.lua",
	"Divers/job/mecano/cl_mecano.lua",
	"Divers/job/tatoos/cl_tatoo.lua",
	"Divers/job/custom/cl_custom.lua",
	"Divers/job/police/siren/cl_siren.lua",
	"Divers/job/police/cl_police.lua",
	"Divers/job/pawnshop/cl_pawnshop.lua",
	"Divers/job/ltd/cl_ltd.lua",
	"Divers/job/lsmotors/cl_lsmotors.lua",
	"Divers/job/pharmacie/cl_pharma.lua",
	"Divers/persist-veh/cl_persist.lua",

	"Divers/players/admin/cl_admin.lua",
	"Divers/players/charcreator/cl_camera.lua",
	"Divers/players/charcreator/cl_charcreator.lua",
	"Divers/players/billing/cl_billing.lua",
	"Divers/players/banking/cl_banking.lua",
	"Divers/players/interaction/cl_interaction.lua",

	"Divers/shops/ammunation/cl_ammu.lua",
	"Divers/shops/clothshop/cl_clothshop.lua",
	"Divers/shops/market/cl_market.lua",
	"Divers/shops/market/cl_LS_BC.lua",
	"Divers/shops/location/cl_bikeloc.lua",

	"Utils/job/call_job/cl_call.lua",
	"Utils/job/society/cl_society.lua",
	"Utils/cartepermis/cl_carte.lua",

	"Utils/players/kevlar/cl_kevlar.lua",
	"Utils/players/savehealth/cl_health.lua",
	"Utils/players/ammo/cl_ammo.lua",
	"Utils/players/wipe/cl_wipe.lua",
	"Utils/players/jumelle/cl_jumelle.lua",
	"Utils/weather/config.lua",
	"Utils/weather/cl_main.lua",
	"cl_blips.lua",
	"cl_peds.lua",
	"richpresence.lua"
}

server_scripts {
	"@lmodeextended/locale.lua",
	'@mysql-async/lib/MySQL.lua',

	"Divers/activities/drugs/sv_drugs.lua",
	"Divers/activities/farm/sv_matiere.lua",
	"Divers/activities/peche/sv_fishing.lua",
	"Divers/activities/pelle/sv_shovel.lua",
	"Divers/activities/autoschool/sv_autoschool.lua",
	"Divers/activities/braquagesup/sv_robbery.lua",
	"Divers/persist-veh/sv_persist.lua",

	"Divers/builder/crew/sv_crew.lua",
	"Divers/builder/agroalimentaire/sv_agro.lua",

	"Divers/job/ambulance/sv_ambulance.lua",
	"Divers/job/barber/sv_barber.lua",
	"Divers/job/cardealer/sv_cardealer.lua",
	"Divers/job/centrejob/sv_centrejob.lua",
	"Divers/job/mecano/sv_mecano.lua",
	"Divers/job/tatoos/sv_tatoo.lua",
	"Divers/job/custom/sv_custom.lua",
	"Divers/job/police/sv_police.lua",
	"Divers/job/pawnshop/sv_pawnshop.lua",
	"Divers/job/ltd/sv_ltd.lua",
	"Divers/job/lsmotors/sv_lsmotors.lua",
	"Divers/job/pharmacie/sv_pharma.lua",

	"Divers/players/admin/sv_ban.lua",
	"Divers/players/admin/sv_admin.lua",
	"Divers/players/charcreator/sv_charcreator.lua",
	"Divers/players/billing/sv_billing.lua",
	"Divers/players/banking/sv_banking.lua",
	"Divers/players/interaction/sv_interaction.lua",

	"Divers/shops/ammunation/sv_ammu.lua",
	"Divers/shops/clothshop/sv_clothshop.lua",
	"Divers/shops/market/sv_market.lua",
	"Divers/shops/location/sv_bikeloc.lua",

	"Utils/job/call_job/sv_call.lua",
	"Utils/job/society/sv_society.lua",

	"Utils/players/kevlar/sv_kevlar.lua",
	"Utils/cartepermis/sv_carte.lua",
	"Utils/players/savehealth/sv_health.lua",
	"Utils/players/ammo/sv_ammo.lua",
	"Utils/players/wipe/sv_wipe.lua",
	"Utils/weather/config.lua",
	"Utils/weather/sv_function.lua",
	"Utils/weather/sv_main.lua",
	"sv_main.lua"
}

shared_scripts {
	"config.lua"
}

exports {
    "GetPlayerDead",
    "GetPlayerKnockout"
}

server_exports {
	"GetCountJobInService"
}