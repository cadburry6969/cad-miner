fx_version "cerulean"
game "gta5"
lua54 'yes'

author 'Cadburry'
description 'Mining job integrated with snappy-phone party system'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/*.lua',
}

client_scripts {
    'bridge/client.lua',
    'client.lua'
}

server_scripts {
    'bridge/server.lua',
    'server.lua'
}

dependencies {
    '/onesync',
    'ox_lib',
    'scully_emotemenu',
    'snappy-phone',
    'cad-pedspawner' -- https://github.com/cadburry6969/cad-pedspawner
}