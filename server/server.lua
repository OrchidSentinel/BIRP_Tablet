-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablets – Server
--
--  Keine Serverlogik nötig. Platzhalter als Erweiterungspunkt (z.B. Logging,
--  Zugriffsgating). Items werden in ox_inventory definiert (siehe items/).
-- ══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        print('^5[BIRP_Tablets]^7 Tablet-Bundle gestartet (sentinel / smile / blackbox).')
    end
end)
