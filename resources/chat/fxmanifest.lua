version '1.0.0'
author 'Cfx.re <root@cfx.re>'

fx_version 'adamant'
games { 'rdr3', 'gta5' }

ui_page 'dist/ui.html'

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
  'dist/ui.html',
  'dist/index.css',
  'html/vendor/*.css',
  'html/vendor/fonts/*.woff2',
}

rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

webpack_config 'webpack.config.js'
