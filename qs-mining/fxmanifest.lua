
fx_version 'cerulean'
game 'gta5'

description 'FiveM Mining Script'
author 'qs-scripts.com | Luca'
version '1.0.0'
lua54 'yes'

shared_script '@es_extended/imports.lua' 
shared_script 'config.lua'

client_scripts {
    'client/client.lua',
    '@ox_lib/init.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/server.lua'
}

dependencies {
    'ox_lib',
    'ox_target', 
    'mysql-async',
    'es_extended'
}

