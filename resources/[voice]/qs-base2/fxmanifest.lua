fx_version 'bodacious'

game 'gta5'

lua54 'yes'

version '1.1.1'

client_scripts {
    'client/main.lua',
    'client/sound.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config.lua',
    'server/main.lua',
    'server/sound.lua',
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/sounds/*.ogg'
}

escrow_ignore {
	'config.lua'
}

dependencies {
	'mysql-async', -- Required.
	'/server:4752', -- ⚠️PLEASE READ⚠️ This requires at least server build 4700 or higher
}
dependency '/assetpacks'