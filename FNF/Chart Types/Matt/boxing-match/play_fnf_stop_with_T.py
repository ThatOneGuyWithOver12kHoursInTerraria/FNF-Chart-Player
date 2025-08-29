# play_fnf_stop_with_T.py
# Usage:
#   pip install pynput
#   python play_fnf_stop_with_T.py /path/to/your_chart.json
#
# Press 'T' anytime to immediately stop playback and release any held keys.
# NOTE: pynput may require elevated privileges on some OSes to send global key events.

import json
import sys
import time
import threading
from pynput.keyboard import Controller, KeyCode, Listener

def load_notes_from_file(path):
    with open(path, 'r', encoding='utf-8') as f:
        data = json.load(f)
    notes_sections = data.get('song', {}).get('notes', [])
    events = []
    for section in notes_sections:
        section_notes = section.get('sectionNotes', [])
        for n in section_notes:
            if not isinstance(n, list) or len(n) < 2:
                continue
            time_ms = float(n[0])
            note_idx = int(n[1])
            length_ms = float(n[2]) if len(n) >= 3 and isinstance(n[2], (int, float)) else 0.0
            label = str(n[3]) if len(n) >= 4 else ''
            events.append((time_ms, note_idx, length_ms, label))
    events.sort(key=lambda e: e[0])
    return events

# map 0..3 to keys requested
KEY_MAP = {
    0: KeyCode.from_char('a'),
    1: KeyCode.from_char('s'),
    2: KeyCode.from_char(';'),
    3: KeyCode.from_char("'"),
}

def filter_player_notes(events):
    filtered = []
    for t, idx, length, label in events:
        if isinstance(label, str) and label.lower() == 'foul':
            continue
        if idx not in KEY_MAP:
            continue
        filtered.append((t / 1000.0, idx, length / 1000.0))  # convert ms -> seconds
    return filtered

def start_stop_listener(stop_event):
    # Listener that sets stop_event when 't' or 'T' is pressed
    def on_press(key):
        try:
            ch = key.char
        except AttributeError:
            ch = None
        if ch and ch.lower() == 't':
            print("\n'T' detected — stopping playback...")
            stop_event.set()
            # returning False stops the listener thread
            return False

    listener = Listener(on_press=on_press)
    listener.daemon = True
    listener.start()
    return listener

def play_events(events, pre_delay=3.0):
    keyboard = Controller()
    stop_event = threading.Event()
    listener = start_stop_listener(stop_event)

    print(f"Starting in {pre_delay} seconds... focus the FNF window now. Press 'T' to abort.")
    # allow abort during pre-delay
    start_time = time.perf_counter() + pre_delay
    while True:
        if stop_event.is_set():
            print("Aborted before start.")
            return
        now = time.perf_counter()
        if now >= start_time:
            break
        time.sleep(0.01)

    start = time.perf_counter()
    currently_held_key = None

    try:
        for t_sec, idx, length_sec in events:
            if stop_event.is_set():
                break
            target = start + t_sec
            now = time.perf_counter()
            wait = target - now
            # sleep in small increments so we can check stop_event frequently
            if wait > 0:
                end_wait = now + wait
                while time.perf_counter() < end_wait:
                    if stop_event.is_set():
                        break
                    # sleep short chunk
                    time.sleep(0.002)
                if stop_event.is_set():
                    break

            # Press the mapped key
            key = KEY_MAP[idx]
            keyboard.press(key)
            currently_held_key = key

            # Hold for length_sec, but allow early abort
            if length_sec and length_sec > 0:
                end_hold = time.perf_counter() + length_sec
                while time.perf_counter() < end_hold:
                    if stop_event.is_set():
                        break
                    time.sleep(0.002)
            else:
                # short tap
                time.sleep(0.02)

            # Release key if still held
            try:
                keyboard.release(key)
            except Exception:
                pass
            currently_held_key = None

        if stop_event.is_set():
            print("Playback stopped by user.")
        else:
            print("Playback finished.")
    finally:
        # ensure any held key is released
        if currently_held_key is not None:
            try:
                keyboard.release(currently_held_key)
            except Exception:
                pass
        # ensure listener is stopped
        try:
            listener.stop()
        except Exception:
            pass

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: python play_fnf_stop_with_T.py /path/to/chart.json")
        sys.exit(1)
    path = sys.argv[1]
    events_raw = load_notes_from_file(path)
    events = filter_player_notes(events_raw)
    if not events:
        print("No playable notes (0..3) found after filtering. Check file or mapping.")
        sys.exit(1)

    print("First 10 playable events (time_sec, note_index, hold_sec):")
    for e in events[:10]:
        print(e)
    play_events(events)
