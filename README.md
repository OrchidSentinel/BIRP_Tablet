# BIRP_Tablet

Eine **einzige FiveM-Resource**, die **mehrere Tablet-Terminals** bündelt. Je
nachdem, welches ox_inventory-Item benutzt wird, öffnet sich das passende
Tablet — alle in derselben Tablet-Hülle (Rahmen, Bezel, Buttons).

Die Inhalte der einzelnen Tablets sind **eigenständige GitHub-Repos** und
laufen unverändert auch als **GitHub-Pages-Website**. Hier sind sie als
**Git-Submodules** in Unterordnern eingebunden.

> **TL;DR für Entwickler & KI:** Diese Resource liefert die NUI-Hülle + Lua-Glue.
> Die drei Unterordner (`sentinel/`, `smile/`, `blackbox/`) sind **reiner
> Content** (HTML/CSS/JS) aus separaten Repos. Inhalt ändern = im jeweiligen
> Content-Repo arbeiten, dann hier das Submodule aktualisieren. **Niemals**
> FiveM-Glue (fxmanifest/NUI-Focus/`cfx-nui-…`) in die Content-Repos packen.

## Die 4 Repos

| Rolle              | Repo                                              | Hier als   |
|--------------------|---------------------------------------------------|------------|
| Sammel-Resource    | `OrchidSentinel/BIRP_Tablet`                      | dieses Repo|
| Tablet „Sentinel"  | `OrchidSentinel/sentinel-initiative`              | `sentinel/`|
| Tablet „Smile"     | `OrchidSentinel/Smile`                            | `smile/`   |
| Tablet „Blackbox"  | `OrchidSentinel/sentinel-blackbox`                | `blackbox/`|

## Architektur

```
  ox_inventory-Item                BIRP_Tablet  (FiveM-Resource)
  ───────────────►  client/client.lua ──SendNUIMessage(open)──►  nui.html
                         │  exports.openTablet(id)                 (Hülle/Rahmen)
                         │                                            │
                         │  ◄──── fetch https://<res>/close ──────────┤
                         ▼                                       <iframe src>
                    SetNuiFocus                       ┌──────────────┼──────────────┐
                                                      ▼              ▼              ▼
                                              sentinel/index   smile/index   blackbox/index
                                              (Submodule)      (Submodule)   (Submodule)
                                                      │              │              │
   getrennte GitHub-Repos + je eine GitHub-Pages-Website ◄──────────┴──────────────┘
```

- **`nui.html`** = gemeinsame Tablet-Hülle (FiveM-only). Sie lädt den Inhalt des
  aktiven Tablets in einen `<iframe>` (`<ordner>/index.html`), zeichnet den
  Rahmen und besitzt die gesamte NUI-Logik (Öffnen/Schließen/ESC).
- **Content-Seiten** nutzen nur **relative Links** → identisches Verhalten im
  Spiel (iframe) und auf GitHub Pages (direkt aufgerufen).
- **`fxmanifest.lua`** serviert die Inhaltsordner per Glob → neue Inhaltsdateien
  laufen **ohne Manifest-Änderung** mit.

## Message-Protokoll (Lua ⇄ NUI)

| Richtung   | Nachricht / Call                                             | Bedeutung                       |
|------------|--------------------------------------------------------------|---------------------------------|
| Lua → NUI  | `SendNUIMessage({ type='open', folder, entry, frame, network, node })` | Tablet öffnen, Inhalt laden     |
| Lua → NUI  | `SendNUIMessage({ type='close' })`                           | Tablet schließen                |
| NUI → Lua  | `fetch('https://'..GetParentResourceName()..'/close')`       | NUI bittet ums Schließen (ESC/Button) |

Die Hülle schickt dem geladenen iframe nach dem Load zusätzlich
`postMessage({action:'open'})` (No-Op für reinen Content; Altlast-Kompatibilität).

> **Wichtig:** NUI-Callbacks **immer** über `GetParentResourceName()` adressieren,
> **nie** `cfx-nui-<name>` hartkodieren.

## Erstinstallation (Server)

```bash
# MIT Submodules klonen:
git clone --recurse-submodules https://github.com/OrchidSentinel/BIRP_Tablet.git

# Falls schon ohne --recurse-submodules geklont:
git -C BIRP_Tablet submodule update --init --recursive
```

1. Items aus `items/items.lua` in `ox_inventory/data/items/…` eintragen.
2. `ensure BIRP_Tablet` in die `server.cfg`.
3. Alte Einzel-Resourcen (`BIRP_Sentinel_Tablet`, `BIRP_Smile_Tablet`) **aus der
   server.cfg nehmen** — sonst Item-/Export-Kollisionen.

## Inhalt aktualisieren (der Kernvorteil)

Ein Tablet-Maintainer ändert **sein** Content-Repo auf GitHub. Auf dem Server:

```bash
git -C BIRP_Tablet submodule update --remote --recursive   # alle Tablets
# oder gezielt eins:
git -C BIRP_Tablet/sentinel pull
```

Dann in der Server-Konsole:

```
refresh
restart BIRP_Tablet
```

**Nur Dateien aktualisieren — kein Code-Eingriff.** Jedes Tablet bleibt sein
eigenes Repo und ist getrennt pflegbar.

## Neues Tablet hinzufügen

1. `git submodule add <repo-url> <ordner>`
2. In `config.lua` einen Eintrag unter `Config.Tablets` ergänzen.
3. Item in `items/items.lua` + ox_inventory ergänzen.
4. In `fxmanifest.lua` `'<ordner>/*'` und `'<ordner>/**/*'` zu `files` hinzufügen.

## Dateien in diesem Repo

| Datei              | Zweck                                                        |
|--------------------|--------------------------------------------------------------|
| `nui.html`         | Gemeinsame Tablet-Hülle + komplette NUI-Logik (iframe, ESC, close) |
| `config.lua`       | Item→Tablet-Mapping, Rahmen an/aus, Panel-Beschriftung       |
| `client/client.lua`| `openTablet(id)` + Exports, NUI-Focus, `close`-Callback      |
| `server/server.lua`| Platzhalter / Erweiterungspunkt (z. B. Logging)              |
| `items/items.lua`  | ox_inventory-Item-Definitionen (Referenz zum Eintragen)      |
| `sentinel/` `smile/` `blackbox/` | Content-Submodules (eigene Repos)              |

## Vertrag für die Content-Repos (Entwickler & KI)

Damit ein Tablet sowohl im Spiel-iframe **als auch** auf GitHub Pages
funktioniert, muss jedes Content-Repo diese Regeln einhalten:

1. **Nur reiner Content**: HTML/CSS/JS/Assets. **Kein** `fxmanifest.lua`,
   `client.lua`, `server.lua` oder NUI-Glue im Content-Repo.
2. **Einstieg = `index.html`** im Repo-Root.
3. **Nur relative Links** zwischen Seiten (`seite.html`, nicht `/seite.html`,
   nicht absolute URLs auf eigene Seiten). Assets ebenso relativ.
4. **Muss standalone im Browser laufen** — nicht davon abhängen, dass die Hülle
   da ist.
5. **Kein `cfx-nui-<name>`** hartkodieren. Falls je der Resource-Name in JS
   gebraucht wird: `GetParentResourceName()`.
6. **Keine eigene Schließen-/Focus-Logik** nötig — die Hülle besitzt sie. Im
   Spiel schließen **ESC** und der **DISCONNECT-Button**.
7. Neue Dateien werden durch den Manifest-Glob automatisch mitserviert.
