fx_version 'bodacious'

game 'gta5'

lua54 'yes'

version '1.1.1'

this_is_a_map 'yes'

files {
    'k4qphone.ytyp'
}

data_file 'DLC_ITYP_REQUEST' 'k4qphone.ytyp'

ui_page "html/index.html"

client_scripts {
    'config/config.lua',
    'client/main.lua',
    'client/uber.lua',
    'client/photo.lua',
    'client/rentel.lua',
    'client/valet.lua',
    'client/pincode.lua',
    'client/gui.lua',
    'config/config_pincode.lua',
    'config/config_animations.lua',
    'config/config_rentel.lua',
    'config/config_uber.lua',
    'config/config_client.lua',
    'config/config_radio.lua',
    'config/config_calls_client.lua',
    'config/translations.lua',

    --[[ '@cs-video-call/client/hooks/core.lua', ]]
    --[[ '@cs-stories/client/hooks/core.lua' ]]
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'config/config.lua',
    'config/config_webhook.lua',
    'server/main.lua',
    'config/translations.lua',
    'config/config_pincode.lua',
    'config/config_server.lua',
	'config/config_valet.lua',
    'config/config_rentel.lua',
    'config/config_uber.lua',
    'config/config_banking.lua',
    'config/config_calls_server.lua',
    'config/config_commands.lua',
    'server/version_check.lua',

    --[[ '@cs-video-call/server/hooks/core.lua', ]]
    --[[ '@cs-stories/server/hooks/core.lua' ]]
}

files {
    'html/index.html',
    'html/js/*.js',
    'config/config_javascript.js',
    'html/img/*.png',
    'html/css/*.css',
    'html/fonts/*.ttf',
    'html/fonts/*.otf',
    'html/fonts/*.woff',
    'html/img/backgrounds/*.png',
    'html/img/apps/*.png',
	'html/img/app_details/*.png',
    'html/img/darkweb_items/*.png',
    'html/sound/*.ogg',
}

escrow_ignore {
    'server/version_check.lua',
	'config/config.lua',
    'config/translations.lua',
    'config/config_valet.lua',
    'config/config_client.lua',
    'config/config_animations.lua',
    'config/config_commands.lua',
    'config/config_server.lua',
    'config/config_webhook.lua',
    'config/config_uber.lua',
    'config/config_rentel.lua',
    'config/config_pincode.lua',
    'config/config_radio.lua',
    'config/config_banking.lua',
    'config/config_calls_server.lua',
    'config/config_calls_client.lua',
}

dependencies {
	'mysql-async', -- Required.
	'qs-base', -- Required.
	'screenshot-basic', -- Required.
	'/server:4752', -- ⚠️PLEASE READ⚠️ This requires at least server build 4700 or higher
}
dependency '/assetpacks'