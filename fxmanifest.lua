fx_version 'cerulean'
game 'gta5'

name "INDONUSA-impound"
description "Impound Script Made By Aa Nyieng."
author "Aa Nyieng"
version "1.0."

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'client/main.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server/main.lua',
}

shared_scripts {
    '@ox_lib/init.lua'
}

dependencies {
	'PolyZone',
	'qtarget',
}
