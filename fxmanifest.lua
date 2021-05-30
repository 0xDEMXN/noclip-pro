fx_version 'cerulean'
game 'gta5'

author 'D3RP'
description 'No Clip Pro - Enhanced NoClip for FiveM'
version '1.0.2'

client_scripts {
  'locale.lua',
  'locales/en.lua',
  'config.lua',
  'client/cl_noclip.lua',
}

server_scripts {
  '@mysql-async/lib/MySQL.lua',

  'config.lua',
  'server/sv_noclip.lua',
}

file 'locale.js'

dependencies {
	'mysql-async'
}