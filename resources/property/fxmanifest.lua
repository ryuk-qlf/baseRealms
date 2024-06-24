fx_version 'adamant'
games { 'gta5' }

client_scripts {
  "@lmodeextended/locale.lua",
  "locales/fr.lua",
  "locales/en.lua",
  "RageUI/RMenu.lua",
  "RageUI/menu/RageUI.lua",
  "RageUI/menu/Menu.lua",
  "RageUI/menu/MenuController.lua",
  "RageUI/components/*.lua",
  "RageUI/menu/elements/*.lua",
  "RageUI/menu/items/*.lua",
  "RageUI/menu/panels/*.lua",
  "RageUI/menu/windows/*.lua",

  "client/*.lua",
}

server_scripts {
  "@lmodeextended/locale.lua",
  "@mysql-async/lib/MySQL.lua",
  "locales/fr.lua",
  "locales/en.lua",
  "server/*.lua",
}

shared_scripts{
  'config.lua'
}

exports {
  "GetIsInProperty",
  "GetIsInGarage",
}