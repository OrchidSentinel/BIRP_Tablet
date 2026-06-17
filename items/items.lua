-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablet – ox_inventory Item-Definitionen (REFERENZ)
--
--  Diese Datei wird NICHT von FiveM geladen. Sie ist die dauerhafte Referenz-
--  Kopie der Items. Eintragen in: ox_inventory/data/items/testing.lua
--  (bzw. eure Item-Datei). Jedes Item ruft den passenden Client-Export auf.
-- ══════════════════════════════════════════════════════════════════════════════

['sentinel_tablet'] = {
    label       = 'Sentinel Tablet',
    weight      = 300,
    stack       = false,
    close       = true,
    consume     = 0,
    description = 'Ein gesichertes Tablet der Sentinel Initiative.',
    client = {
        export = 'BIRP_Tablet.openSentinelTablet',
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
        export = 'BIRP_Tablet.openSmileTablet',
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
        export = 'BIRP_Tablet.openBlackboxTablet',
    },
},
