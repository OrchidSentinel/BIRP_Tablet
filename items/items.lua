-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablets – ox_inventory Item-Definitionen (REFERENZ)
--
--  Diese Datei wird NICHT von FiveM geladen. Sie ist die dauerhafte Referenz-
--  Kopie der Items. Eintragen in: ox_inventory/data/items/testing.lua
--  (bzw. eure Item-Datei). Jedes Item ruft den passenden Client-Export auf.
--
--  WICHTIG: Der Export-Prefix unten ('BIRP_Tablets.…') IST der Resource-Name.
--  Der Resource-Ordner auf dem Server MUSS daher 'BIRP_Tablets' heissen.
--  (Das GitHub-Repo heisst 'BIRP_Tablet' – beim Klonen Zielordner mit angeben:
--   git clone --recurse-submodules <url> BIRP_Tablets)
-- ══════════════════════════════════════════════════════════════════════════════

['sentinel_tablet'] = {
    label       = 'Sentinel Tablet',
    weight      = 300,
    stack       = false,
    close       = true,
    consume     = 0,
    description = 'Ein gesichertes Tablet der Sentinel Initiative.',
    client = {
        export = 'BIRP_Tablets.openSentinelTablet',
    },
},

['smile_terminal'] = {
    label       = 'SMILE Terminal',
    weight      = 300,
    stack       = false,
    close       = true,
    consume     = 0,
    description = 'Ein korrumpiertes Archiv-Terminal. Was auch immer es enthält, es will gefunden werden.',
    client = {
        export = 'BIRP_Tablets.openSmileTablet',
    },
},

['blackbox_tablet'] = {
    label       = 'Blackbox Tablet',
    weight      = 300,
    stack       = false,
    close       = true,
    consume     = 0,
    description = 'Ein verschlossenes NEXUS-Blackbox-Terminal.',
    client = {
        export = 'BIRP_Tablets.openBlackboxTablet',
    },
},
