fx_version 'bodacious'
games { 'gta5' }

name "INDONUSA-impound"
description "Impound Script Made By Aa Nyieng."
author "Aa Nyieng"
version "1.0."
lua54 'yes'

ui_page "html/index.html"

files {
	'html/index.html',
	'html/index.js',
    'html/jquery-3.6.3.min.js'
}

client_scripts {
	'@PolyZone/client.lua',
	'@PolyZone/BoxZone.lua',
	'client.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua',
}

shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

dependencies {
    'es_extended',
	'PolyZone',
	'qtarget',
}

