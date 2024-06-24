fx_version 'adamant'
games { 'gta5', 'rdr3' }

resource_type 'gametype' { name = 'lmodeextended' }

server_scripts {
	-- Base --
	'base/shared/*.lua',
    'base/server/*.lua',
	-- lmodeextended --
    "@mysql-async/lib/MySQL.lua",
	'locale.lua',
	'locales/*.lua',
	'config.lua',
	'config.weapons.lua',
	
	'server/common.lua',
	'server/classes/player.lua',
	'server/functions.lua',
	'server/paycheck.lua',
	'server/main.lua',
	'server/commands.lua',
	'server/dbmigrate.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua',
}

client_scripts {
	-- Base --
	'base/shared/*.lua',
    'base/client/*.lua',
	-- lmodeextended --
	'locale.lua',
	'locales/*.lua',
	'config.lua',
	'config.weapons.lua',
	'client/common.lua',
	'client/entityiter.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/main.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
	'common/modules/math.lua',
	'common/modules/table.lua',
	'common/functions.lua'
}

exports {
	'getSharedObject',
	'GetCore'
}

server_exports {
	'getSharedObject',
	'GetCore',
    "getCurrentGameType",
    "getCurrentMap",
    "changeGameType",
    "changeMap",
    "doesMapSupportGameType",
    "getMaps",
    "roundEnded"
}

provide 'lmodeextended'