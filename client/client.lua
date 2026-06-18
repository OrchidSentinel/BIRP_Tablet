-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablet – Client
--
--  Öffnet je nach benutztem Item das passende Tablet. Alle Tablets teilen sich
--  EINE NUI-Page (nui.html) und EINEN Tablet-Rahmen; der Inhalt wird aus dem
--  jeweiligen Unterordner in einen iframe geladen.
-- ══════════════════════════════════════════════════════════════════════════════

local isOpen   = false
local current  = nil  -- aktuell geöffnetes Tablet (Config.Tablets key)

-- ── Audio (xSound) ────────────────────────────────────────────────────────────
--  Inhaltsseiten spielen Ton im Browser nativ ab; ingame schicken sie stattdessen
--  NUI-Callbacks an diese Resource, die den Ton über xSound abspielt/stoppt.
local TAPE_ID = 'birp_tablet_tape'  -- feste xSound-ID (nur ein Audiofragment gleichzeitig)

local function xsoundReady()
    return Config.Audio and Config.Audio.resource
        and GetResourceState(Config.Audio.resource) == 'started'
end

local function stopTape()
    if not xsoundReady() then return end
    local x = exports[Config.Audio.resource]
    if x:soundExists(TAPE_ID) then x:Destroy(TAPE_ID) end
end

local function openTablet(id)
    local t = Config.Tablets[id]
    if not t then
        print(('^1[BIRP_Tablet]^7 Unbekanntes Tablet: %s'):format(tostring(id)))
        return
    end
    if isOpen then return end
    isOpen  = true
    current = id

    SetNuiFocus(true, true)
    SendNUIMessage({
        type    = 'open',
        folder  = t.folder,
        entry   = t.entry,
        frame   = t.frame ~= false,
        network = t.network,
        node    = t.node,
        access  = t.access,
        panel   = t.panel,
        selfNav = t.selfNav,
    })

    if Config.HoldAnimation and GetResourceState('bablo-animations') == 'started' then
        exports['bablo-animations']:playAnimation(PlayerPedId(), Config.HoldAnimation)
    end
end

local function closeTablet()
    if not isOpen then return end
    isOpen  = false
    current = nil

    SetNuiFocus(false, false)
    SendNUIMessage({ type = 'close' })
    stopTape()  -- evtl. laufendes Audiofragment beenden

    if Config.HoldAnimation and GetResourceState('bablo-animations') == 'started' then
        exports['bablo-animations']:cancelAnimation()
    end
end

-- ── Exports ───────────────────────────────────────────────────────────────────
-- Generisch:   exports['BIRP_Tablet']:openTablet('sentinel')
exports('openTablet', openTablet)
exports('closeTablet', closeTablet)

-- Bequem pro Tablet (für ox_inventory client.export):
exports('openSentinelTablet', function() openTablet('sentinel') end)
exports('openSmileTablet',    function() openTablet('smile') end)
exports('openSmileTerminal', function() openTablet('smile') end) -- Alias (Legacy)
exports('openBlackboxTablet', function() openTablet('blackbox') end)

-- ── NUI -> Lua ────────────────────────────────────────────────────────────────
RegisterNUICallback('close', function(_, cb)
    closeTablet()
    cb({ ok = true })
end)

-- Audio-Steuerung aus den Inhaltsseiten (z.B. sentinel/tape_01.html).
-- Erwartet { action = 'play'|'pause'|'seek'|'volume'|'stop', url, time, volume }.
RegisterNUICallback('tapeAudio', function(data, cb)
    data = data or {}
    if not xsoundReady() then
        if data.action == 'play' then
            print('^3[BIRP_Tablet]^7 xSound (\''..tostring(Config.Audio and Config.Audio.resource)..'\') nicht gestartet – Audiofragment bleibt stumm.')
        end
        cb({ ok = false, reason = 'no-xsound' })
        return
    end

    local x   = exports[Config.Audio.resource]
    local act = data.action

    if act == 'play' then
        local vol = tonumber(data.volume) or Config.Audio.defaultVolume or 0.4
        if x:soundExists(TAPE_ID) then
            x:setVolume(TAPE_ID, vol)
            if data.time then x:setTimeStamp(TAPE_ID, math.floor(data.time)) end
            x:Resume(TAPE_ID)
        elseif data.url then
            x:PlayUrl(TAPE_ID, data.url, vol, false)
            if data.time and data.time > 0.5 then x:setTimeStamp(TAPE_ID, math.floor(data.time)) end
        end
    elseif act == 'pause' then
        if x:soundExists(TAPE_ID) then x:Pause(TAPE_ID) end
    elseif act == 'seek' then
        if x:soundExists(TAPE_ID) and data.time then x:setTimeStamp(TAPE_ID, math.floor(data.time)) end
    elseif act == 'volume' then
        if x:soundExists(TAPE_ID) and data.volume then x:setVolume(TAPE_ID, tonumber(data.volume)) end
    elseif act == 'stop' then
        stopTape()
    end

    cb({ ok = true })
end)

-- ── Sicherheit / Lifecycle ────────────────────────────────────────────────────
AddEventHandler('onResourceStart', function(res)
    if res == GetCurrentResourceName() then
        isOpen = false
        current = nil
        SetNuiFocus(false, false)
        SendNUIMessage({ type = 'close' })
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        SetNuiFocus(false, false)
        stopTape()
    end
end)
