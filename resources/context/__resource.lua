fx_version 'adamant'
game 'gta5'

ui_page "ui/index.html"

files {
	"ui/index.html",
	"ui/assets/cursor.png",
	"ui/assets/close.png",
	"ui/script.js",
	"ui/style.css",
	'ui/debounce.min.js',
}

client_scripts {
	"client.lua",
	"cl_context.lua"
}

server_scripts {
	"server.lua"
}