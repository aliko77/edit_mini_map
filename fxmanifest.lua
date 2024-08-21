fx_version 'cerulean'
game 'gta5'
lua54 'yes'
name 'edit_mini_map'
version '1.0.0'
author 'aliko.'

client_scripts {
    'client.lua',
    'test.lua'
}

shared_scripts { '@ox_lib/init.lua' }

dependencies { 'ox_lib' }

escrow_ignore { 'test.lua' }
