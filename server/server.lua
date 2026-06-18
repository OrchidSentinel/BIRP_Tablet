-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablet – Server
--
--  Keine Serverlogik nötig. Platzhalter als Erweiterungspunkt (z.B. Logging,
--  Zugriffsgating). Items werden in ox_inventory definiert (siehe items/).
-- ══════════════════════════════════════════════════════════════════════════════

AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        print('^5[BIRP_Tablet]^7 Tablet-Bundle gestartet (sentinel / smile / blackbox).')
    end
end)

-- ── Audio (xSound, raeumlich) ─────────────────────────────────────────────────
--  Der Client meldet Audio-Aktionen (siehe client/client.lua). Der Ton wird hier
--  ueber xSound an ALLE Clients gesendet und an der Position des abspielenden
--  Spielers ausgegeben (3D). Dadurch hoeren Umstehende im Hoerradius mit.
local activeTapes = {}  -- [src] = true, solange ein Audiofragment laeuft

local function xsoundReady()
    return Config.Audio and Config.Audio.resource
        and GetResourceState(Config.Audio.resource) == 'started'
end

RegisterNetEvent('BIRP_Tablet:tapeAudio', function(data)
    local src = source
    data = data or {}

    if not xsoundReady() then
        if data.action == 'play' then
            print(('^3[BIRP_Tablet]^7 xSound (%s) nicht gestartet – Audiofragment bleibt stumm.')
                :format(tostring(Config.Audio and Config.Audio.resource)))
        end
        return
    end

    local x   = exports[Config.Audio.resource]
    local id  = 'birp_tablet_tape_' .. src
    local act = data.action
    local vol = tonumber(data.volume) or Config.Audio.defaultVolume or 0.4

    if act == 'play' then
        if activeTapes[src] then
            -- Fortsetzen (nach Pause): Lautstaerke/Zeit angleichen.
            x:setVolume(-1, id, vol)
            if data.time then x:setTimeStamp(-1, id, math.floor(data.time)) end
            x:Resume(-1, id)
        elseif data.url then
            local ped = GetPlayerPed(src)
            local pos = (ped and ped ~= 0) and GetEntityCoords(ped) or vector3(0.0, 0.0, 0.0)
            x:PlayUrlPos(-1, id, data.url, vol, pos, false)
            x:Distance(-1, id, Config.Audio.distance or 12.0)
            if data.time and data.time > 0.5 then x:setTimeStamp(-1, id, math.floor(data.time)) end
            activeTapes[src] = true
        end
    elseif act == 'pause' then
        if activeTapes[src] then x:Pause(-1, id) end
    elseif act == 'seek' then
        if activeTapes[src] and data.time then x:setTimeStamp(-1, id, math.floor(data.time)) end
    elseif act == 'volume' then
        if activeTapes[src] then x:setVolume(-1, id, vol) end
    elseif act == 'stop' then
        if activeTapes[src] then x:Destroy(-1, id); activeTapes[src] = nil end
    end
end)

-- Spieler verlaesst den Server -> evtl. laufendes Fragment beenden.
AddEventHandler('playerDropped', function()
    local src = source
    if activeTapes[src] then
        if xsoundReady() then
            exports[Config.Audio.resource]:Destroy(-1, 'birp_tablet_tape_' .. src)
        end
        activeTapes[src] = nil
    end
end)

-- Resource stoppt -> alle laufenden Fragmente beenden.
AddEventHandler('onResourceStop', function(res)
    if res ~= GetCurrentResourceName() then return end
    if xsoundReady() then
        for src in pairs(activeTapes) do
            exports[Config.Audio.resource]:Destroy(-1, 'birp_tablet_tape_' .. src)
        end
    end
    activeTapes = {}
end)
