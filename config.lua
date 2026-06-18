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

-- ── Audio (xSound) ───────────────────────────────────────────────────────
--  Die Inhaltsseiten (z.B. sentinel/tape_01.html) nutzen im Browser ein
--  natives <audio>-Element. INGAME wird der Ton stattdessen über xSound
--  abgespielt (Lautstärke-Kontrolle, sauberes Stoppen beim Schließen).
--  Die Seite schaltet ihr <audio> dann stumm und steuert nur noch xSound.
Config.Audio = {
    resource      = 'xsound',       -- Name der xSound-Resource
    defaultVolume = 0.4,            -- Start-Lautstärke (0.0 - 1.0), falls die Seite keine sendet
}

-- Jede ID = ein Tablet. 'item' ist das ox_inventory-Item, das es öffnet.
--   folder  : Unterordner/Submodule mit dem Inhalt
--   entry   : Start-HTML im Ordner
--   frame   : true = Sentinel-Tablet-Rahmen, false = Vollbild
--   network : Beschriftung im DISCONNECT-Panel (optional)
--   node    : Node-Code im DISCONNECT-Panel (optional)
--   access  : ZUGANG-Zeile im DISCONNECT-Panel (nur relevant wenn panel=true)
--   panel   : true = DISCONNECT-Panel zeigen (nur Sentinel-Initiative!); sonst false
--   selfNav : true = Inhalt bringt eigene ESC/Zurueck-Logik mit (postMessage
--             'sentinel:back'); Huelle haengt dann KEIN eigenes ESC an. Default false.
Config.Tablets = {
    sentinel = {
        item    = 'sentinel_tablet',
        folder  = 'sentinel',
        entry   = 'index.html',
        frame   = true,
        network = 'SENTINEL NETWORK',
        node    = 'GSD-04',
        access  = 'ORCHID',
        panel   = true,
        selfNav = true,
    },
    smile = {
        item    = 'smile_terminal',
        folder  = 'smile',
        entry   = 'index.html',
        frame   = true,
        network = 'SMILE ARCHIVE',
        node    = 'COR-13',
        access  = 'SMILE',
        panel   = false,
    },
    blackbox = {
        item    = 'blackbox_tablet',
        folder  = 'blackbox',
        entry   = 'index.html',
        frame   = true,
        network = 'NEXUS BLACKBOX',
        node    = 'BLK-00',
        access  = 'NEXUS',
        panel   = false,
    },
}
