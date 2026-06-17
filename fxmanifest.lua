fx_version 'cerulean'
game 'gta5'

author 'ElektroHeld / OrchidSentinel'
description 'BIRP Tablets – mehrere Tablet-Terminals (Sentinel / Smile / Blackbox) in einer Resource. Inhalte als Git-Submodules.'
version '1.0.0'

lua54 'yes'

ui_page 'nui.html'

-- Tablet-Hülle + alle drei Inhalts-Ordner (Submodules) servieren.
-- Pro Ordner BEIDE Patterns:
--   '<ordner>/*'     -> flache Dateien (aktueller Stand der Content-Repos)
--   '<ordner>/**/*'  -> evtl. spätere Unterordner
-- So müssen bei neuen Inhaltsdateien KEINE Manifest-Änderungen erfolgen.
files {
    'nui.html',
    'sentinel/*',
    'sentinel/**/*',
    'smile/*',
    'smile/**/*',
    'blackbox/*',
    'blackbox/**/*',
}

shared_script 'config.lua'
client_script 'client/client.lua'
server_script 'server/server.lua'

-- Optionale Halteanimation; wird nur genutzt wenn vorhanden (siehe client.lua).
-- dependency 'bablo-animations'
