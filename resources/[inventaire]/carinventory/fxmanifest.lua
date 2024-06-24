fx_version 'adamant'
game 'gta5'
version '1.2.1'

server_scripts {
  "@lmodeextended/locale.lua",
  "@mysql-async/lib/MySQL.lua",
  "locales/fr.lua",
  "locales/en.lua",
  "config.lua",
  "server/classes/c_trunk.lua",
  "server/trunk.lua",
  "server/esx_trunk-sv.lua"
}

client_scripts {
  "@lmodeextended/locale.lua",
  "locales/fr.lua",
  "locales/en.lua",
  "config.lua",
  "client/esx_trunk-cl.lua"
}

