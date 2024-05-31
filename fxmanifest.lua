fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'Cadburry'
description 'Mining job integrated with snappy-phone party system'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_script 'client.lua'
server_script 'server.lua'

dependencies {
    '/onesync',
    'ox_lib'
}