fx_version 'adamant'
games {'gta5'}

ui_page 'html/ui.html'

client_scripts {
  "@lmodeextended/locale.lua",
  "utils.lua",
  'config.lua',
  "locales/*.lua",
  "client/*.lua"
}

server_scripts {
  "@lmodeextended/locale.lua",
  "@mysql-async/lib/MySQL.lua",
  'config.lua',
  "locales/*.lua",
  "server/*.lua"
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/locales/*.js',
    'html/img/hud/*.png',
    'html/img/*.png',
    'html/img/items/*.png',
}
