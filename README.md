# FarmingTimer

A simple WoW addon that tracks your farming time and automatically stops once all target items have been collected in the desired quantities.

## Features

- Track multiple items at the same time.
- Set items via drag & drop from your bag or via ItemID/item link.
- Define target quantities per item.
- Start / Pause / Resume / Stop / Reset.
- Automatic stop + success sound when all targets are reached.
- Movable window + options panel in the Interface menu.
- Minimap button (toggle on/off).

## Installation

1. Copy the `FarmingTimer` folder to `World of Warcraft/_retail_/Interface/AddOns/`.
2. Enable the addon on the character selection screen.

## Quick Start

1. Open with `/ft` or via the minimap button.
2. Click **Add Item**.
3. Drag an item into the slot **or** paste an ItemID/link into the **ItemID / Link** field.
4. Enter the target quantity in the **Amount** field.
5. Press **Start** and start farming.

## Main Window Controls

- **Add Item**: adds a new row.
- **Start**: starts the timer and tracking.
- **Pause**: pauses time tracking (progress remains visible).
- **Resume**: appears instead of Start when paused.
- **Stop**: ends the run.
- **Reset**: resets the timer and progress.

## Progress / Counting Logic

- Counting is **net since start**:
  `current bag count − start count`
- If you consume or hand in items during a run, progress may decrease.
- **Only items in your bags** are counted (no bank count).

## Options (Interface → AddOns → FarmingTimer)

- **Open FarmingTimer**: opens the main window.
- **Show minimap button**: toggle minimap button on/off.
- **Reset frame position**: resets the window position.

## Slash Commands

- `/ft`
- `/farmingtimer`

## FAQ

**Why is my item shown as a question mark?**  
The item may not be cached yet. Wait a moment or open its tooltip so WoW loads it.

**Why does progress reset to 0 after Stop?**  
Stop ends the run. Pressing Start begins a new run with a new baseline.

## Feedback

Feel free to report feature requests or bugs — I’ll add/fix them.
