# FNF Player Script
**THIS PAGE WAS MADE BY COPILOT BECAUSE I WAS LAZY, MANY THINGS HERE WILL CHANGE IN THE FUTURE**
**IF YOU WOULD LIKE TO REQUEST A MOD OR FEATURE SUPPORT, OR FILE A BUG REPORT, YOU CAN VIA GITHUB, EMAIL ME AT tsolr.savior@gmail.com, OR DM ME ON DISCORD johnnyjj45**
**(yeah, I don't know how to code :sob:)**

**The "Chart Types" folder is only there to give examples of each chart .json for each mod to copilot**

Automated (macro) chart playback helper for Friday Night Funkin' style JSON charts.

It can:
* Load multiple chart formats (Base FNF JSON, Matt format; Dustin & Doors stubs ready)
* Simulate hitting notes with the Python `keyboard` library
* Dynamically swap which lanes you control in Matt charts using `mustHitSection`
* Detect & optionally skip special note types (string identifiers, e.g. `death`, `poison`, `bullet`)
* Log every press / release / classification with timestamps to a file
* Save & load presets (all your answers) for quick reuse

> NOTE: This is for local experimentation & tooling. Respect game / mod rules. Automating gameplay on live servers or public competition contexts may violate terms.

---

## 1. Requirements

* Python 3.8+
* `keyboard` module (`pip install keyboard`)
	* On Linux this library usually needs to run as root (e.g. `sudo python fnf player thing.py`) to emit key events globally.
* Chart JSON files accessible via path you enter.

Directory structure expectation (simplified):
```
FNF/
	fnf player thing.py
	Chart Types/
		FNF/ ... (base game style)
		Matt/ ... (sections with sectionNotes[] & mustHitSection)
		Dustin/ (TODO)
		Doors/  (TODO)
	Presets/ (auto-created)
	Logs/    (auto-created)
```

## 2. Supported Chart Formats

| Type Key | Name              | Loader Class          | Status |
|----------|-------------------|-----------------------|--------|
| 1        | FNF (Base Game)   | `FNFChartReader`      | Working |
| 2        | Matt              | `MattChartReader`     | Working (with lane swap) |
| 3        | Dustin            | `DustinChartReader`   | Stub (parse TBD) |
| 4        | Doors             | `DoorsChartReader`    | Stub (parse TBD) |

### 2.1 Base FNF
Uses nested `notes` object keyed by difficulty. Each note object: `{ "t": ms, "d": lane, "l": sustain, "p": [] }`.

### 2.2 Matt Charts
JSON root has `song.notes` array of section objects. Each section has:
```
{
	"sectionNotes": [ [timeMs, lane, sustainMs, optionalStringType], ... ],
	"mustHitSection": true|false,
	...
}
```
The script attaches `must_hit_section` per note and sorts all notes chronologically.

#### mustHitSection Lane Swapping Logic
When playing a Matt chart:
* You specify two sets of lanes: your base lanes (e.g. `0,1,2,3`) and opponent lanes (e.g. `4,5,6,7`).
* If a note's section has `mustHitSection == true` then you control your base lanes (`0,1,2,3`) and opponent lanes are logged only.
* If `mustHitSection == false` the roles swap: you now press notes that appear on the opponent lane numbers (`4,5,6,7`) and the base lanes become opponent lanes (only logged).
* Because of this, during setup for a Matt chart you are also prompted for key bindings for opponent lanes (so they can be pressed during swapped sections).
 - Note from creator: Just set this as the ones you have for the player lanes, I'll change it to do that as default later.

This behavior matches your request: When `mustHitSection` is false the script hits the opponent-labeled lanes.

## 3. Running

From inside the `FNF` directory:
```
python fnf player thing.py
```
Or (Linux global key emit):
```
sudo python fnf player thing.py
```

### Interactive Prompts (Fresh Run)
1. Select chart type (1–4).
2. Enter chart file path (relative or absolute).
3. (Base FNF only) Pick difficulty shown.
4. Enter how many keys you will use (e.g. 4).
5. Enter your key lanes (e.g. `0,1,2,3`).
6. Enter opponent key lanes (defaults to `4,5,6,7`).
7. Assign physical keys for each of your lanes.
8. (Matt) Assign keys for opponent lanes (needed for swaps).
9. Choose handling for each detected special note type (hit or skip) except `bullet` which defaults to hit.
10. Provide keys for extra mechanics (currently just `space`, or type `empty`).
 - Note from creator: I'm unsure how most mods do this and where they put this extra mechanic (which is usually dodging), so once i figure that out I'm going to set this up as I don't think it works right now.
11. Decide whether to print every press immediately.
12. Optionally save as a preset for reuse.
13. Press `T` when prompted to start playback.
 - Not from creator: If you are wondering when you press the start playback key, just press it when the song starts, or when the "3 2 1 go" or "ready start" popup enters the last one. But I recommend to enter the chart editor (usually accessibly in-game via the 7 key during a song) and putting a note on the very first section/line, then go over to the "song" tab and press download, use that for your chart directory instead so you can time when to press the key. (May need to add multiple notes to determine your avarage accuracy using the ratings, and starting playback may actually be delayed)

Playback continues until all notes consumed or you press `T` again (stop toggle). Each note is pressed at its scheduled time; sustains are held for a minimal duration based on sustain length (basic approximation).

## 4. Presets

When you opt to save, a JSON file is created in `Presets/` with:
```
{
	chart_file, difficulty, key_count,
	lanes, opponent_lanes, controls,
	special_note_settings, extra_settings,
	print_presses, chart_class, swap_by_must_hit
}
```
On next launch you can pick a preset number and skip re-entering details.

## 5. Special Notes

Any string found in the 4th element of a Matt section note (or `type` field of a base FNF note if present) is treated as a special note type.

Default always-hit: `bullet`.
Prompted (you decide): `death`, `poison`, plus any newly discovered names.

If you choose not to hit (e.g. `death`), the script logs skipping it. Opponent notes are always logged but never pressed.

## 6. Logging

Log file: `Logs/fnf_run_<timestamp>.txt`
Includes:
* Startup configuration & first 10 parsed notes
* DEBUG lines (first 30 Matt notes) showing classification & lane sets
* Press / release events (or just pressed summary) with timestamps
* Opponent note sightings
* Stop / completion notice

Use logs to compare with video playback if needed.

## 7. Key Press Simulation Details

* Uses `keyboard.press` and `keyboard.release`.
* Sustains: hold duration = `max(0.01, sustainMs/1000)` (very approximate; refine later for precise rhythm windows).
* Minimal 1 ms loop tick (sleep 0.001) plus OS scheduling; real timing jitter expected.

## 8. Common Issues / FAQ

| Issue | Cause / Fix |
|-------|-------------|
| PermissionError / no key presses (Linux) | Run with sudo. |
| Wrong lanes being hit in Matt charts | Check lane sets (player vs opponent) & that chart actually uses expected numbering. |
| Special notes not detected | Ensure they have a string 4th element; otherwise they're treated as normal. |
| High CPU usage | Tight loop; acceptable for short sessions. Increase sleep slightly if needed. |

## 9. Extending

Add parsing logic in `DustinChartReader` / `DoorsChartReader.load_chart()` following patterns in `MattChartReader`.

## 10. TODO / Roadmap
* Implement Dustin & Doors chart parsers
* More accurate sustain handling (early/late release scheduling)
* BPM-aware future improvements (e.g. predictive drift correction)
* Option to export CSV of presses
* Dry run mode (no key emission) for analysis

## 11. Disclaimer

This tool automates key presses. Use responsibly and only where permitted. Author(s) assume no liability for misuse.

---
