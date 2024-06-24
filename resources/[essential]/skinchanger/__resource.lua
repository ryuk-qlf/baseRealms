resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

version '1.0.2'

client_scripts {
	'shared.lua',
	'cl_skin.lua'
}

server_scripts {
	"@mysql-async/lib/MySQL.lua",
	'shared.lua',
	'sv_skin.lua'
}