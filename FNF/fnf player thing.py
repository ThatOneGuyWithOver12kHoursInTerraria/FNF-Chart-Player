import json
import os
import time
from datetime import datetime
try:
    import keyboard  # pip install keyboard
except ImportError:
    print("Please install the 'keyboard' module: pip install keyboard")
    exit(1)

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
        print(msg)
        self.lines.append(msg)
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
    def load_chart(self):
        with open(self.chart_path, 'r') as f:
            data = json.load(f)
        # FNF base game charts usually have: data['song']['notes']
        self.notes = []
        try:
            notes_sections = data['song']['notes']
            for section in notes_sections:
                section_notes = section.get('sectionNotes', [])
                for note in section_notes:
                    # note: [time, lane, type, sustain]
                    time_pos = note[0]
                    lane = note[1]
                    note_type = note[2] if len(note) > 2 else 0
                    sustain = note[3] if len(note) > 3 else 0
                    self.notes.append({
                        'time': time_pos,
                        'lane': lane,
                        'type': note_type,
                        'sustain': sustain
                    })
        except Exception as e:
            print(f"Error parsing FNF chart: {e}")

class MattChartReader(ChartReaderBase):
    def load_chart(self):
        with open(self.chart_path, 'r') as f:
            data = json.load(f)
        # TODO: Parse Matt chart format
        self.notes = []

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

def ask_user():
    print("Select FNF chart type:")
    for k, v in chart_types.items():
        print(f"{k}: {v[0]}")
    chart_type = input("Enter chart type number: ").strip()
    while chart_type not in chart_types:
        chart_type = input("Invalid. Enter chart type number: ").strip()
    chart_class = chart_types[chart_type][1]

    chart_file = input("Enter chart file name or path: ").strip()
    while not os.path.isfile(chart_file):
        chart_file = input("File not found. Enter chart file name or path: ").strip()

    key_count = int(input("How many keys will you use? (default 4): ").strip() or "4")
    strumline = input(f"Enter note lanes to use (comma separated, e.g. 0,1,2,3): ").strip()
    lanes = [int(x) for x in strumline.split(',') if x.strip().isdigit()]
    while len(lanes) != key_count:
        strumline = input(f"You must enter {key_count} lanes. Try again: ").strip()
        lanes = [int(x) for x in strumline.split(',') if x.strip().isdigit()]

    controls = {}
    print("Assign controls for each key:")
    for i in range(key_count):
        controls[lanes[i]] = input(f"Key for lane {lanes[i]}: ").strip()

    # Special notes
    special_notes = ['bullet', 'death', 'poison']
    special_note_settings = {}
    print("Special notes detected: bullet, death, poison")
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
        key = input(f"Key for extra mechanic '{mech}' (or 'empty' if not used): ").strip()
        extra_settings[mech] = key if key != 'empty' else None

    print_presses = input("Print out what is pressed? (y/n): ").strip().lower() == 'y'

    return {
        'chart_class': chart_class,
        'chart_file': chart_file,
        'key_count': key_count,
        'lanes': lanes,
        'controls': controls,
        'special_note_settings': special_note_settings,
        'extra_settings': extra_settings,
        'print_presses': print_presses
    }

def wait_for_t():
    print("Press 'T' to start...")
    while True:
        if keyboard.is_pressed('t'):
            print("Starting!")
            break
        time.sleep(0.1)

def main():
    log_path = get_log_file()
    logger = Logger(log_path)
    logger.log("Script started.")
    settings = ask_user()
    logger.log(f"User settings: {settings}")
    reader = settings['chart_class'](settings['chart_file'])
    logger.log(f"Loading chart: {settings['chart_file']}")
    reader.load_chart()
    notes = reader.get_notes()
    logger.log(f"Loaded {len(notes)} notes from chart.")
    if len(notes) > 0:
        logger.log("First 10 notes:")
        for n in notes[:10]:
            logger.log(str(n))
    wait_for_t()
    logger.log("Playback started.")

    # Play notes according to settings
    start_time = time.time()
    note_idx = 0
    total_notes = len(notes)
    stopped = False
    while note_idx < total_notes and not stopped:
        now = time.time() - start_time
        note = notes[note_idx]
        note_time = note['time']
        lane = note['lane']
        note_type = note.get('type', 0)
        sustain = note.get('sustain', 0)

        # Check for stop
        if keyboard.is_pressed('t'):
            logger.log("Stopped!")
            stopped = True
            break

        # Wait until it's time for the note
        if now >= note_time:
            # Special note logic
            skip_note = False
            if note_type == 'death' and not settings['special_note_settings'].get('death', False):
                skip_note = True
            if note_type == 'poison' and not settings['special_note_settings'].get('poison', False):
                skip_note = True
            # Bullet notes always hit
            if note_type == 'bullet':
                skip_note = False

            if not skip_note and lane in settings['controls']:
                key = settings['controls'][lane]
                keyboard.press_and_release(key)
                msg = f"Pressing: {key} (lane {lane}, time {note_time})"
                if settings['print_presses']:
                    logger.log(msg)
                else:
                    logger.log(f"Pressed: {key} (lane {lane}, time {note_time})")
            note_idx += 1
        else:
            time.sleep(0.001)

    logger.log("All notes played or stopped.")
    logger.save()
    print(f"Log saved to {log_path}")

if __name__ == "__main__":
    main()