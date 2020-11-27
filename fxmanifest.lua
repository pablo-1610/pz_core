fx_version 'adamant'
game 'gta5'
description 'Pablo Z. Core'
version '1.0'

--[[

	   PZ_Core par Pablo Z

	Tous droits réservés © 2020

]]

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"server_main.lua",

	"jobs/police/server.lua",
	"jobs/fbi/server.lua",
	"jobs/unicorn/server.lua",
	"jobs/bahamas/server.lua",
	"jobs/taxi/server.lua",
	"jobs/vigneron/server.lua",
	"soundSys/server/main.lua",

	"modules/staffmode/staff.lua",
	"modules/staffmode/server.lua",

	"modules/shops/config.lua",
	"modules/shops/server.lua",

	"modules/armory/server.lua",

	"jobs/server_jobs.lua"
}

client_scripts {
	-- RageUI Version 1
	"src/client/RMenu.lua",
    "src/client/menu/RageUI.lua",
    "src/client/menu/Menu.lua",
    "src/client/menu/MenuController.lua",
    "src/client/components/*.lua",
    "src/client/menu/elements/*.lua",
    "src/client/menu/items/*.lua",
    "src/client/menu/panels/*.lua",
	"src/client/menu/windows/*.lua",
	
	-- 
	"client_main.lua",
	"jobs/client_jobs.lua",

	"modules/commands/client.lua",

	"modules/utils/utils.lua",
	"modules/interactions/markers.lua",
	"modules/interactions/jobs.lua",

	"modules/staffmode/staff.lua",
	"modules/staffmode/client.lua",

	"modules/shops/config.lua",
	"modules/shops/client.lua",

	"jobs/police/config.lua",
	"jobs/police/client.lua",

	"jobs/fbi/config.lua",
	"jobs/fbi/client.lua",

	"jobs/unicorn/config.lua",
	"jobs/unicorn/client.lua",

	"jobs/bahamas/config.lua",
	"jobs/bahamas/client.lua",

	"jobs/taxi/config.lua",
	"jobs/taxi/client.lua",

	"jobs/vigneron/config.lua",
	"jobs/vigneron/client.lua",

	"modules/menu/menus.lua",

	"modules/armory/config.lua",
	"modules/armory/client.lua",

	"soundSys/client/main.lua",

	"jobs/client_inventory.lua"

}

ui_page('soundSys/html/index.html')

files({
    'soundSys/html/index.html',
	'soundSys/html/sounds/callback.ogg',
	'soundSys/html/sounds/code2.ogg',
	'soundSys/html/sounds/code3.ogg',
	'soundSys/html/sounds/code99.ogg'
})

dependencies {
	'mysql-async'
}
