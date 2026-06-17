-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablet – Konfiguration
--
--  Eine Resource bündelt mehrere "Tablets". Jeder Inhalt liegt in einem eigenen
--  Unterordner, der als Git-Submodule auf ein eigenes GitHub-Repo zeigt und
--  weiterhin über GitHub Pages erreichbar bleibt:
--
--    sentinel/  -> github.com/OrchidSentinel/sentinel-initiative
--    smile/     -> github.com/OrchidSentinel/Smile
--    blackbox/  -> github.com/OrchidSentinel/sentinel-blackbox
--
--  Inhalt aktualisieren (auf dem Server):
--    git -C resources/[...]/BIRP_Tablet submodule update --remote
--    danach: refresh; ensure BIRP_Tablet
--  -> Es müssen NUR die Dateien aktualisiert werden, keine Code-Änderung nötig.
-- ══════════════════════════════════════════════════════════════════════════════

Config = {}

-- Optional: Halteanimation beim Öffnen (bablo-animations). false = aus.
Config.HoldAnimation = 'tablet2'

-- Jede ID = ein Tablet. 'item' ist das ox_inventory-Item, das es öffnet.
--   folder  : Unterordner/Submodule mit dem Inhalt
--   entry   : Start-HTML im Ordner
--   frame   : true = Sentinel-Tablet-Rahmen, false = Vollbild
--   network : Beschriftung im DISCONNECT-Panel (optional)
--   node    : Node-Code im DISCONNECT-Panel (optional)
Config.Tablets = {
    sentinel = {
        item    = 'sentinel_tablet',
        folder  = 'sentinel',
        entry   = 'index.html',
        frame   = true,
        network = 'SENTINEL NETWORK',
        node    = 'GSD-04',
    },
    smile = {
        item    = 'smile_terminal',
        folder  = 'smile',
        entry   = 'index.html',
        frame   = true,
        network = 'SMILE ARCHIVE',
        node    = 'COR-13',
    },
    blackbox = {
        item    = 'blackbox_tablet',
        folder  = 'blackbox',
        entry   = 'index.html',
        frame   = true,
        network = 'NEXUS BLACKBOX',
        node    = 'BLK-00',
    },
}
