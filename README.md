# FarmingTimer

Ein einfaches WoW-Addon, das deine Farmzeit misst und automatisch stoppt, sobald alle gewuenschten Items in der Zielmenge gesammelt wurden.

## Funktionen
- Mehrere Items gleichzeitig tracken.
- Item per Drag and Drop aus der Tasche oder per ItemID/Item-Link setzen.
- Ziele (Anzahl) pro Item definieren.
- Start / Pause / Resume / Stop / Reset.
- Automatischer Stopp plus Erfolgssound, wenn alle Ziele erreicht sind.
- Bewegliches Fenster plus Options-Panel im Interface-Menue.
- Minimap-Button (ein/aus).
- Presets speichern, laden und loeschen.

## Installation
1. Ordner `FarmingTimer` nach `World of Warcraft/_retail_/Interface/AddOns/` kopieren.
2. Im Charakter-Auswahlbildschirm das Addon aktivieren.

## Schnellstart
1. Oeffnen mit `/ft` oder ueber den Minimap-Button.
2. Klicke **Add Item**.
3. Item in den Slot ziehen oder ItemID/Link im Feld **ItemID / Link** einfuegen.
4. Zielmenge im Feld **Anzahl** eintragen.
5. **Start** druecken und losfarmen.

## Bedienung im Hauptfenster
- **Add Item**: fuegt eine neue Zeile hinzu.
- **Start**: startet den Timer und die Messung.
- **Pause**: pausiert die Zeitmessung (Fortschritt bleibt sichtbar).
- **Resume**: erscheint statt Start, wenn pausiert.
- **Stop**: beendet den Run.
- **Reset**: setzt den Timer und Fortschritt zurueck.
- **Preset**: Dropdown zum Auswaehlen gespeicherter Presets.
- **Preset-Name**: Name eingeben und mit **Save** speichern.
- **Load**: laedt das ausgewaehlte Preset.
- **Delete**: loescht das ausgewaehlte Preset.

## Fortschritt / Zaehleweise
- Es wird netto seit Start gezaehlt:
  `aktueller Bag-Count - Start-Count`
- Wenn du waehrend des Runs Items verbrauchst/abgibst, kann der Fortschritt sinken.
- Gezaehlt werden nur Items im Bag (kein Bank-Count).

## Optionen (Interface -> AddOns -> FarmingTimer)
- **Open FarmingTimer**: oeffnet das Hauptfenster.
- **Show minimap button**: Minimap-Button ein/aus.
- **Reset frame position**: setzt die Fenster-Position zurueck.

## Slash-Commands
- `/ft`
- `/farmingtimer`

## Haeufige Fragen
**Warum wird mein Item als Fragezeichen angezeigt?**
Das Item ist evtl. noch nicht im Cache. Warte kurz oder oeffne die Tooltip-Info, dann laedt WoW das Item nach.

**Warum steht der Fortschritt auf 0 nach Stop?**
Nach Stop wird der Run beendet. Mit Start beginnt ein neuer Run mit neuer Baseline.

## Feedback
Wuensche oder Fehler gern melden, ich baue es ein.
