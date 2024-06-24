resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'
version '1.0.0'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua',
	'sv_needs.lua'
}

client_scripts {
	'config.lua',
	'client/classes/status.lua',
	'client/main.lua',
	'cl_needs.lua'
}

ui_page 'html/ui.html'

files {
	'html/ui.html',
	'html/css/app.css',
	'html/scripts/app.js'
}