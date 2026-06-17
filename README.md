# BIRP_Tablets

Eine FiveM-Resource, die **mehrere Tablet-Terminals** bündelt. Je nachdem,
welches Item benutzt wird, öffnet sich das passende Tablet – alle in derselben
Tablet-Hülle (Rahmen, Bezel, Buttons).

Die Inhalte der einzelnen Tablets bleiben **eigenständige GitHub-Repos** und
sind weiterhin über **GitHub Pages** erreichbar. Sie sind hier als
**Git-Submodules** in Unterordnern eingebunden:

| Ordner      | Repo                                                  | Item              |
|-------------|-------------------------------------------------------|-------------------|
| `sentinel/` | `OrchidSentinel/sentinel-initiative`                  | `sentinel_tablet` |
| `smile/`    | `OrchidSentinel/Smile`                                | `smile_terminal`  |
| `blackbox/` | `OrchidSentinel/sentinel-blackbox`                    | `blackbox_tablet` |

## Wie es funktioniert

- `nui.html` ist die gemeinsame Tablet-Hülle (FiveM-only). Sie lädt den Inhalt
  des aktiven Tablets in einen `<iframe>` (`<ordner>/index.html`).
- Die Inhaltsseiten nutzen nur **relative Links** → sie funktionieren identisch
  im Spiel (iframe) und auf GitHub Pages (direkt aufgerufen).
- Smile versteckt sich auf GitHub Pages bzw. wartet im Spiel auf ein
  `open`-Signal; die Hülle schickt dieses Signal automatisch an den iframe.
- `fxmanifest.lua` serviert die Inhaltsordner per Glob (`sentinel/**/*` …) →
  neue Inhaltsdateien laufen **ohne Manifest-Änderung** mit.

## Erstinstallation auf dem Server

```bash
# In den resources-Pfad klonen – MIT Submodules:
git clone --recurse-submodules <url-zu-BIRP_Tablets> BIRP_Tablets

# Falls schon ohne --recurse-submodules geklont:
git -C BIRP_Tablets submodule update --init --recursive
```

Items aus `items/items.lua` in `ox_inventory/data/items/…` eintragen und in
der `server.cfg` `ensure BIRP_Tablets` setzen.

## Inhalt aktualisieren (der eigentliche Vorteil)

Wenn ein Tablet-Maintainer etwas in **seinem** GitHub-Repo ändert, reicht auf
dem Server:

```bash
# Alle Tablets auf den neuesten Stand ihres Branches ziehen:
git -C BIRP_Tablets submodule update --remote --recursive

# (oder nur eins:)
git -C BIRP_Tablets/sentinel pull
```

Danach in der Server-Konsole:

```
refresh
restart BIRP_Tablets
```

Es müssen **nur die Dateien** aktualisiert werden – kein Code-Eingriff nötig.
Jedes Tablet bleibt sein eigenes Repo und ist getrennt pflegbar.

## Neues Tablet hinzufügen

1. Submodule einbinden:
   `git submodule add <repo-url> <ordner>`
2. In `config.lua` einen Eintrag unter `Config.Tablets` ergänzen
   (`item`, `folder`, `entry`, `frame`, …).
3. Item in `items/items.lua` + ox_inventory ergänzen
   (`export = 'BIRP_Tablets.openTablet'` generisch, oder eigenen Wrapper-Export).
4. `fxmanifest.lua`: `'<ordner>/**/*'` in `files` ergänzen.

## Konfiguration

Siehe `config.lua` – pro Tablet: Item-Name, Ordner, Startseite, Rahmen an/aus,
Beschriftung im DISCONNECT-Panel.
