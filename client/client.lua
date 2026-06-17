-- ══════════════════════════════════════════════════════════════════════════════
--  BIRP_Tablet – Client
--
--  Öffnet je nach benutztem Item das passende Tablet. Alle Tablets teilen sich
--  EINE NUI-Page (nui.html) und EINEN Tablet-Rahmen; der Inhalt wird aus dem
--  jeweiligen Unterordner in einen iframe geladen.
-- ══════════════════════════════════════════════════════════════════════════════

local isOpen   = false
local current  = nil  -- aktuell geöffnetes Tablet (Config.Tablets key)

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
    end
end)
