fx_version 'cerulean'
game 'gta5'
author 'Aiakos#8317'
description 'pj-craft'
ui_page {
	'html/index.html',
}
files {
	'html/*.css',
	'html/*.js',
	'html/*.html',
	'html/*.ogg',
	'html/images/*.png',
	'html/images/*.svg',
	'html/itemimages/*.png',

}

shared_script{
	'config.lua',
}

dependencies { 
	'/server:5104',
	'/gameBuild:1868',
	'/onesync',
}

client_scripts {
	'client/*.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua', -- OXMYSQL
	'server/*.lua',
}

lua54 'yes'