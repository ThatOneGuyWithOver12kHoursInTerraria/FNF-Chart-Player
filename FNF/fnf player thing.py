import json
import os
import time
from datetime import datetime
try:
    import keyboard  # pip install keyboard
except ImportError:
    print("Please install the 'keyboard' module: pip install keyboard")
    exit(1)

PRESETS_DIR = os.path.join(os.path.dirname(__file__), 'Presets')
if not os.path.exists(PRESETS_DIR):
    os.makedirs(PRESETS_DIR)

def list_presets():
    return [f[:-5] for f in os.listdir(PRESETS_DIR) if f.endswith('.json')]

def load_preset(name):
    path = os.path.join(PRESETS_DIR, name + '.json')
    if os.path.isfile(path):
        with open(path, 'r', encoding='utf-8') as f:
            return json.load(f)
    return None

def save_preset(name, data):
    path = os.path.join(PRESETS_DIR, name + '.json')
    with open(path, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=2)

def normalize_key(raw):
    """Normalize a user-entered key name.
    Accepts:
      - literal word 'space' (any case)
      - a single space character
    Returns canonical 'space' for those, else the raw text.
    """
    if raw is None:
        return ''
    if raw.lower() == 'space' or raw == ' ':
        return 'space'
    return raw

LOGS_DIR = os.path.join(os.path.dirname(__file__), 'Logs')
if not os.path.exists(LOGS_DIR):
    os.makedirs(LOGS_DIR)

def get_log_file():
    timestamp = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')
    return os.path.join(LOGS_DIR, f'fnf_run_{timestamp}.txt')

class Logger:
    def __init__(self, log_path):
        self.log_path = log_path
        self.lines = []
    def log(self, msg):
        ts = datetime.now().strftime('%Y-%m-%d %H:%M:%S.%f')[:-3]
        log_entry = f'[{ts}] {msg}'
        print(log_entry)
        self.lines.append(log_entry)
    def save(self):
        with open(self.log_path, 'w', encoding='utf-8') as f:
            for line in self.lines:
                f.write(line + '\n')
# Chart reader stubs
class ChartReaderBase:
    def __init__(self, chart_path):
        self.chart_path = chart_path
        self.notes = []
    def load_chart(self):
        pass
    def get_notes(self):
        return self.notes

class FNFChartReader(ChartReaderBase):
    def load_chart(self, difficulty=None, logger=None):
        try:
            with open(self.chart_path, 'r') as f:
                data = json.load(f)
            self.notes = []
            if difficulty is None:
                difficulty = 'easy'
            notes_list = data.get('notes', {}).get(difficulty, [])
            for note in notes_list:
                # note: {"t": time, "d": lane, "l": sustain, "p": []}
                time_pos = note.get('t', 0) / 1000.0  # convert ms to seconds
                lane = note.get('d', 0)
                sustain = note.get('l', 0)
                note_type = 0  # type not present in this format
                self.notes.append({
                    'time': time_pos,
                    'lane': lane,
                    'type': note_type,
                    'sustain': sustain
                })
        except Exception as e:
            if logger:
                logger.log(f"Error parsing FNF chart: {e}")
            else:
                print(f"Error parsing FNF chart: {e}")

class MattChartReader(ChartReaderBase):
    def load_chart(self):
        with open(self.chart_path, 'r') as f:
            data = json.load(f)
        self.notes = []
        song_data = data.get('song', {})
        sections = song_data.get('notes', [])
        # Extract sectionNotes; also capture section index and mustHitSection for downstream logic
        for s_idx, section in enumerate(sections):
            if isinstance(section, dict) and 'sectionNotes' in section:
                must_hit = section.get('mustHitSection', False)
                for raw in section.get('sectionNotes', []):
                    # raw: [time, lane, sustain] or [time, lane, sustain, special]
                    time_pos = raw[0] / 1000.0 if len(raw) > 0 else 0.0
                    lane = raw[1] if len(raw) > 1 else 0
                    sustain = raw[2] if len(raw) > 2 and isinstance(raw[2], (int, float)) else 0
                    note_type = raw[3] if len(raw) > 3 and isinstance(raw[3], str) else 0
                    self.notes.append({
                        'time': time_pos,
                        'lane': lane,
                        'type': note_type,
                        'sustain': sustain,
                        'section_index': s_idx,
                        'must_hit_section': must_hit
                    })
    # Ensure chronological order; some charts list later sections early
        self.notes.sort(key=lambda n: n['time'])

class DustinChartReader(ChartReaderBase):
    def load_chart(self):
        with open(self.chart_path, 'r') as f:
            data = json.load(f)
        # TODO: Parse Dustin chart format
        self.notes = []

class DoorsChartReader(ChartReaderBase):
    def load_chart(self):
        with open(self.chart_path, 'r') as f:
            data = json.load(f)
        # TODO: Parse Doors chart format
        self.notes = []

chart_types = {
    '1': ('FNF (Base Game)', FNFChartReader),
    '2': ('Matt', MattChartReader),
    '3': ('Dustin', DustinChartReader),
    '4': ('Doors', DoorsChartReader)
}

def ask_user(logger):
    # Preset selection
    presets = list_presets()
    if presets:
        print("Available presets:")
        for i, p in enumerate(presets):
            print(f"{i+1}: {p}")
        print("0: Don't use a preset")
        sel = input("Select a preset by number, or 0 to skip: ").strip()
        if sel.isdigit() and int(sel) > 0 and int(sel) <= len(presets):
            preset_data = load_preset(presets[int(sel)-1])
            logger.log(f"Loaded preset: {preset_data}")
            # Convert chart_class string to actual class object
            chart_class_name = preset_data.get('chart_class')
            for k, v in chart_types.items():
                if v[1].__name__ == chart_class_name:
                    preset_data['chart_class'] = v[1]
                    break
            # Convert controls keys to int (they may be str if loaded from JSON)
            preset_data['controls'] = {int(k): v for k, v in preset_data['controls'].items()}
            return preset_data

    print("Select FNF chart type:")
    for k, v in chart_types.items():
        print(f"{k}: {v[0]}")
    chart_type = input("Enter chart type number: ").strip()
    while chart_type not in chart_types:
        logger.log(f"Invalid chart type entered: {chart_type}")
        chart_type = input("Invalid. Enter chart type number: ").strip()
    chart_class = chart_types[chart_type][1]

    chart_file = input("Enter chart file name or path: ").strip()
    while not os.path.isfile(chart_file):
        logger.log(f"Chart file not found: {chart_file}")
        chart_file = input("File not found. Enter chart file name or path: ").strip()
    difficulty = None
    if chart_class == FNFChartReader:
        with open(chart_file, 'r') as f:
            data = json.load(f)
        available_difficulties = list(data.get('notes', {}).keys())
        print(f"Available difficulties: {', '.join(available_difficulties)}")
        difficulty = input("Enter difficulty: ").strip().lower()
        while difficulty not in available_difficulties:
            logger.log(f"Invalid difficulty entered: {difficulty}")
            difficulty = input(f"Invalid. Enter difficulty from {', '.join(available_difficulties)}: ").strip().lower()

    key_count = int(input("How many keys will you use? (default 4): ").strip() or "4")

    print("Lane mapping: Lanes on the right side of the screen start from 0 up to your key count minus 1. Any lane numbers after that are for the opponent (usually left side). Example: 0,1,2,3 for you; 4,5,6,7 for opponent.")
    strumline = input(f"Enter your key lanes (comma separated, e.g. 0,1,2,3): ").strip()
    lanes = [int(x) for x in strumline.split(',') if x.strip().isdigit()]
    while len(lanes) != key_count:
        strumline = input(f"You must enter {key_count} lanes. Try again: ").strip()
        lanes = [int(x) for x in strumline.split(',') if x.strip().isdigit()]

    opp_strumline = input(f"Enter opponent key lanes (comma separated, default 4,5,6,7): ").strip() or "4,5,6,7"
    opponent_lanes = [int(x) for x in opp_strumline.split(',') if x.strip().isdigit()]

    controls = {}
    print("Assign controls for each key:")
    for i in range(key_count):
        while True:
            raw = input(f"Key for lane {lanes[i]} (press space for Space): ")
            k = normalize_key(raw)
            if k:
                controls[lanes[i]] = k
                break
            print("Key cannot be empty. Try again.")

    # If we're in a Matt chart (swap_by_must_hit logic) we also need key bindings for opponent lanes
    # because when mustHitSection is false those lanes become the player's lanes temporarily.
    # Only ask for lanes not already assigned above.
    if chart_class.__name__ == 'MattChartReader':
        missing_opp_controls = [l for l in opponent_lanes if l not in controls]
        if missing_opp_controls:
            print("Because mustHitSection swapping is active, provide keys for opponent lanes (used when mustHitSection is false):")
            for l in missing_opp_controls:
                while True:
                    raw = input(f"Key for opponent lane {l} (press space for Space): ")
                    k = normalize_key(raw)
                    if k:
                        controls[l] = k
                        break
                    print("Key cannot be empty. Try again.")

    # Detect all special note types in the chart
    detected_special_notes = set(['bullet', 'death', 'poison'])
    try:
        with open(chart_file, 'r') as f:
            chart_data = json.load(f)
        chart_class_name = chart_class.__name__
        note_types_found = set()
        if chart_class_name == 'FNFChartReader':
            for diff in chart_data.get('notes', {}).values():
                for note in diff:
                    t = note.get('type', None)
                    if isinstance(t, str):
                        note_types_found.add(t)
        elif chart_class_name == 'MattChartReader':
            song_data = chart_data.get('song', {})
            sections = song_data.get('notes', [])
            # Check for special notes in sectionNotes arrays
            for section in sections:
                if isinstance(section, dict) and 'sectionNotes' in section:
                    for note in section['sectionNotes']:
                        # If note has a 4th element and it's a string, treat as special note
                        if len(note) > 3 and isinstance(note[3], str):
                            note_types_found.add(note[3])
        # Add any new string types to detected_special_notes
        for t in note_types_found:
            if t not in detected_special_notes:
                detected_special_notes.add(t)
    except Exception as e:
        logger.log(f"Error detecting special notes: {e}")

    special_notes = list(detected_special_notes)
    special_note_settings = {}
    print(f"Special notes detected: {', '.join(special_notes)}")
    for note in special_notes:
        if note == 'bullet':
            special_note_settings[note] = True
        else:
            ans = input(f"Should {note} notes be hit? (y/n): ").strip().lower()
            special_note_settings[note] = (ans == 'y')

    # Extra mechanics
    extra_mechanics = ['space']
    extra_settings = {}
    for mech in extra_mechanics:
        raw = input(f"Key for extra mechanic '{mech}' (or 'empty' if not used, press space for Space): ")
        if raw.lower().strip() == 'empty':
            extra_settings[mech] = None
        else:
            extra_settings[mech] = normalize_key(raw)

    print_presses = input("Print out what is pressed? (y/n): ").strip().lower() == 'y'

    # Matt-specific option: whether to swap lanes based on mustHitSection semantics
    # For Matt charts we ALWAYS apply swapping semantics (mustHitSection True => base player lanes)
    swap_by_must_hit = (chart_class.__name__ == 'MattChartReader')

    # Ask to save all settings as a preset at the end
    if input("Save all these answers as a preset? (y/n): ").strip().lower() == 'y':
        preset_name = input("Enter preset name: ").strip()
        save_preset(preset_name, {
            'chart_file': chart_file,
            'difficulty': difficulty,
            'key_count': key_count,
            'lanes': lanes,
            'opponent_lanes': opponent_lanes,
            'controls': controls,
            'special_note_settings': special_note_settings,
            'extra_settings': extra_settings,
            'print_presses': print_presses,
            'chart_class': chart_class.__name__,
            'swap_by_must_hit': swap_by_must_hit
        })

    return {
        'chart_class': chart_class,
        'chart_file': chart_file,
        'difficulty': difficulty,
        'key_count': key_count,
        'lanes': lanes,
        'opponent_lanes': opponent_lanes,
        'controls': controls,
        'special_note_settings': special_note_settings,
        'extra_settings': extra_settings,
    'print_presses': print_presses,
    'swap_by_must_hit': swap_by_must_hit
    }

def wait_for_t():
    print("Press 'T' to start...")
    while True:
        if keyboard.is_pressed('t'):
            print("Starting!")
            # Wait for 'T' to be released before continuing
            while keyboard.is_pressed('t'):
                time.sleep(0.05)
            break
        time.sleep(0.1)

def main():
    log_path = get_log_file()
    logger = Logger(log_path)
    logger.log("Script started.")
    settings = ask_user(logger)
    # If loaded from preset, chart_class will be a string, so convert to class
    chart_class_obj = settings['chart_class']
    if isinstance(chart_class_obj, str):
        # Find the class from chart_types
        for k, v in chart_types.items():
            if v[1].__name__ == chart_class_obj:
                chart_class_obj = v[1]
                break

    reader = chart_class_obj(settings['chart_file'])
    if chart_class_obj == FNFChartReader:
        reader.load_chart(settings.get('difficulty'), logger=logger)
    else:
        reader.load_chart()
    notes = reader.get_notes()
    logger.log(f"Loaded {len(notes)} notes from chart.")
    if len(notes) > 0:
        logger.log("First 10 notes:")
        for n in notes[:10]:
            logger.log(str(n))
    wait_for_t()
    logger.log("Playback started.")

    start_time = time.time()
    note_idx = 0
    total_notes = len(notes)
    stopped = False
    while keyboard.is_pressed('t'):
        time.sleep(0.05)

    held_notes = {}
    base_player_lanes = settings['lanes']
    base_opponent_lanes = settings.get('opponent_lanes', [])
    # Default to True for Matt even if missing in preset
    swap_by_must_hit = settings.get('swap_by_must_hit', chart_class_obj == MattChartReader)
    if chart_class_obj == MattChartReader:
        logger.log(f"Matt chart lane strategy: mustHitSection swap enforced (swap_by_must_hit={swap_by_must_hit})")

    while note_idx < total_notes and not stopped:
        now = time.time() - start_time

        lanes_to_release = [lane for lane, (release_time, key) in held_notes.items() if now >= release_time]
        for lane in lanes_to_release:
            key = held_notes[lane][1]
            keyboard.release(key)
            if settings['print_presses']:
                logger.log(f"Released: {key} (lane {lane}, time {now:.3f})")
            del held_notes[lane]

        if keyboard.is_pressed('t'):
            logger.log("Stopped!")
            stopped = True
            break

        while note_idx < total_notes and now >= notes[note_idx]['time']:
            note = notes[note_idx]
            note_time = note['time']
            lane = note['lane']
            note_type = note.get('type', 0)
            sustain = note.get('sustain', 0)

            skip_note = False
            if note_type == 'death' and not settings['special_note_settings'].get('death', False):
                skip_note = True
            if note_type == 'poison' and not settings['special_note_settings'].get('poison', False):
                skip_note = True
            if note_type == 'bullet':
                skip_note = False

            # For MattChartReader optionally swap lanes based on mustHitSection
            if chart_class_obj == MattChartReader and 'must_hit_section' in note and swap_by_must_hit:
                must_hit = note['must_hit_section']
                player_lanes = set(base_player_lanes) if must_hit else set(base_opponent_lanes)
                opponent_lanes = set(base_opponent_lanes) if must_hit else set(base_player_lanes)
            else:
                must_hit = None
                player_lanes = set(base_player_lanes)
                opponent_lanes = set(base_opponent_lanes)

            # Debug classification (first few notes) to help diagnose issues
            if note_idx < 30 and chart_class_obj == MattChartReader:
                logger.log(
                    f"DEBUG note_idx={note_idx} t={note_time:.3f} lane={lane} mustHit={must_hit} player_lanes={sorted(player_lanes)} opp_lanes={sorted(opponent_lanes)} class={'PLAYER' if lane in player_lanes else ('OPP' if lane in opponent_lanes else 'UNKNOWN')}"
                )

            if lane in player_lanes:
                if not skip_note and lane in settings['controls']:
                    key = settings['controls'][lane]
                    if not key:
                        logger.log(f"WARNING: Empty key binding for lane {lane}; skipping press.")
                        note_idx += 1
                        continue
                    hold_time = max(0.01, sustain / 1000.0) if sustain > 0 else 0.01
                    keyboard.press(key)
                    held_notes[lane] = (now + hold_time, key)
                    msg = f"Pressing: {key} (lane {lane}, time {note_time}, hold {hold_time:.3f}s)"
                    if settings['print_presses']:
                        logger.log(msg)
                    else:
                        logger.log(f"Pressed: {key} (lane {lane}, time {note_time}, hold {hold_time:.3f}s)")
            elif lane in opponent_lanes:
                logger.log(f"Opponent note: lane {lane}, time {note_time}, sustain {sustain}")
            note_idx += 1

        time.sleep(0.001)

    for lane, (release_time, key) in held_notes.items():
        keyboard.release(key)
        if settings['print_presses']:
            logger.log(f"Released: {key} (lane {lane}, time {time.time() - start_time:.3f})")

    logger.log("All notes played or stopped.")
    logger.save()
    print(f"Log saved to {log_path}")

if __name__ == "__main__":
    main()