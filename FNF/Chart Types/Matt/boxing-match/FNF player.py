import json
import time
import sys
import keyboard

# Desired control keys (left → right)
BASE_KEYS = ['a', 's', ';', "'"]

def safe_input(prompt):
    try:
        return input(prompt)
    except EOFError:
        return ''

# ===== ask chart type =====
print("Choose chart type:")
print("  1) Dustin")
print("  2) Matt")
chart_type = safe_input("Enter 1 or 2: ").strip()

if chart_type not in ('1', '2'):
    print("Invalid choice. Exiting.")
    sys.exit(1)

file_path = safe_input('Enter the path to the chart file: ').strip('" ').strip()
if not file_path:
    print("No path given. Exiting.")
    sys.exit(1)

try:
    with open(file_path, 'r', encoding='utf-8') as f:
        chart = json.load(f)
except Exception as e:
    print("Failed to open/parse file:", e)
    sys.exit(1)

notes = []
lane_ids = set()

if chart_type == '1':  # Dustin format
    strumlines = chart.get('strumLines') or []
    if not strumlines:
        print("No strumLines found in JSON. Exiting.")
        sys.exit(1)

    print("\nFound strumLines:")
    for i, sl in enumerate(strumlines):
        lanes = sorted({n.get('id') for n in sl.get('notes', []) if isinstance(n.get('id'), int)})
        print(f"  [{i}] position={sl.get('position','?')} notes={len(sl.get('notes', []))} lanes={lanes}")

    choice = safe_input("\nEnter strumLine index to use: ").strip()
    try:
        sel_index = int(choice)
        if not (0 <= sel_index < len(strumlines)):
            raise ValueError()
    except Exception:
        print("Invalid index. Exiting.")
        sys.exit(1)

    selected = strumlines[sel_index]

    for note in selected.get('notes', []):
        if note.get('type', 0) != 0:  # skip special
            continue
        lane = note.get('id')
        lane_ids.add(lane)
        notes.append({
            'time': note.get('time', 0) / 1000.0,
            'lane': lane,
            'length': note.get('sLen', 0) / 1000.0
        })

elif chart_type == '2':  # Matt format (always 0–3 for player)
    for section in chart.get('notes', []):
        for n in section.get('sectionNotes', []):
            if len(n) < 3:
                continue
            t, lane, length = n[:3]
            note_type = n[3] if len(n) >= 4 else 0
            if note_type != 0:
                continue  # skip specials
            if lane not in (0, 1, 2, 3):
                continue  # only keep 0–3
            lane_ids.add(lane)
            notes.append({
                'time': t / 1000.0,
                'lane': lane,
                'length': length / 1000.0
            })

# ===== lane mapping =====
lane_ids = sorted(lane_ids)[:4]
mapping = {lid: BASE_KEYS[i] for i, lid in enumerate(lane_ids)}

print("\nLane → key mapping:")
for lid, key in mapping.items():
    print(f"  lane {lid} -> '{key}'")

# keep only notes with valid lanes
notes = [n for n in notes if n['lane'] in mapping]
notes.sort(key=lambda n: n['time'])

print(f"\nLoaded {len(notes)} playable notes.\n")

# ===== controls =====
activated = False
stopped = False

def toggle_playback():
    global activated
    activated = not activated
    print("[RESUME]" if activated else "[PAUSE]")

def stop_script():
    global stopped
    stopped = True
    print("[STOP] Stopping script...")
    for k in set(mapping.values()):
        try:
            keyboard.release(k)
        except Exception:
            pass

keyboard.add_hotkey('t', toggle_playback)
keyboard.add_hotkey('p', stop_script)

print("Press T to start/resume, P to stop.")

# Wait for first T
while not activated:
    time.sleep(0.05)

start_time = time.time()

for note in notes:
    if stopped:
        break

    wait_time = start_time + note['time'] - time.time()
    if wait_time > 0:
        time.sleep(wait_time)

    if not activated:
        continue

    key = mapping[note['lane']]
    print(f"[{time.time() - start_time:.3f}s] Pressing: {key}")
    keyboard.press(key)
    if note['length'] > 0:
        time.sleep(note['length'])
    keyboard.release(key)

print("Song finished or stopped.")
