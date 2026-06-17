fx_version 'cerulean'
game 'gta5'

author 'ElektroHeld / OrchidSentinel'
description 'BIRP Tablets – mehrere Tablet-Terminals (Sentinel / Smile / Blackbox) in einer Resource. Inhalte als Git-Submodules.'
version '1.0.0'

lua54 'yes'

ui_page 'nui.html'

-- Tablet-Hülle + alle drei Inhalts-Ordner (Submodules) per Glob servieren.
-- Dadurch müssen bei neuen Inhaltsdateien KEINE Manifest-Änderungen erfolgen.
files {
    'nui.html',
    'config.lua',
    'sentinel/**/*',
    'smile/**/*',
    'blackbox/**/*',
}

shared_script 'config.lua'
client_script 'client/client.lua'
server_script 'server/server.lua'

-- Optionale Halteanimation; wird nur genutzt wenn vorhanden (siehe client.lua).
-- dependency 'bablo-animations'

provide 'birp_sentinel_tablet'
provide 'birp_smile_tablet'
