# play_fnf_start_on_Y_strict.py
# Usage:
#   pip install pynput
#   python play_fnf_start_on_Y_strict.py /path/to/chart.json
#
# Strict start-on-Y behavior:
# - Script will NOT start until you explicitly perform the required Y release + Y press.
# - This avoids accidental auto-starts caused by buffered/held keys.
# - Press 'T' anytime to stop playback.

import json
import sys
import time
import threading
from pynput.keyboard import Controller, KeyCode, Listener

KEY_MAP = {
    0: KeyCode.from_char('a'),
    1: KeyCode.from_char('s'),
    2: KeyCode.from_char(';'),
    3: KeyCode.from_char("'"),
}

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

def filter_player_notes(events):
    filtered = []
    for t, idx, length, label in events:
        if isinstance(label, str) and label.lower() == 'foul':
            continue
        if idx not in KEY_MAP:
            continue
        filtered.append((t / 1000.0, idx, length / 1000.0))  # convert ms -> seconds
    return filtered

def start_stop_strict_listener(start_event, stop_event):
    """
    Strict start logic:
    - Initially requires seeing a 'y' release event to clear any held/buffered key state.
    - After we see a release, the next 'y' press will start playback.
    - 't' press will set stop_event anytime.
    """
    # state machine flags
    seen_y_release = threading.Event()

    def on_press(key):
        try:
            ch = key.char
        except AttributeError:
            ch = None
        if not ch:
            return

        c = ch.lower()

        # 't' always stops immediately
        if c == 't':
            print("\n'T' detected — stopping playback...")
            stop_event.set()
            return

        # Only start on Y press *after* we've observed a Y release
        if c == 'y' and seen_y_release.is_set() and not start_event.is_set():
            # mark start and record reference time
            start_time = time.perf_counter()
            start_event.start_time = start_time  # attach start time to event object
            start_event.set()
            print("\n'Y' detected (after release) — starting playback...")
            return

    def on_release(key):
        try:
            ch = key.char
        except AttributeError:
            ch = None
        if not ch:
            return
        if ch.lower() == 'y':
            # seeing a release clears prior state; now we're ready to accept a deliberate Y press
            if not seen_y_release.is_set():
                print("(Detected Y release — now waiting for a Y press to start.)")
            seen_y_release.set()

    listener = Listener(on_press=on_press, on_release=on_release)
    listener.daemon = True
    listener.start()
    return listener

def play_events(events):
    keyboard = Controller()
    start_event = threading.Event()
    stop_event = threading.Event()
    listener = start_stop_strict_listener(start_event, stop_event)

    try:
        print("Ready. To start playback:")
        print("  1) If Y might be held/buffered: press-and-release Y once to clear.")
        print("  2) Then press Y again to start playback.")
        print("Press 'T' anytime to abort.")
        # wait for start_event or stop_event
        while not start_event.is_set() and not stop_event.is_set():
            time.sleep(0.01)

        if stop_event.is_set():
            print("Playback aborted before start.")
            return

        # start_event.start_time was set when Y press occurred
        start_time_reference = getattr(start_event, 'start_time', time.perf_counter())
        currently_held_key = None

        for t_sec, idx, length_sec in events:
            if stop_event.is_set():
                break
            target = start_time_reference + t_sec
            # wait until target time, but check stop_event frequently
            while True:
                now = time.perf_counter()
                wait = target - now
                if wait <= 0 or stop_event.is_set():
                    break
                time.sleep(0.002)

            if stop_event.is_set():
                break

            key = KEY_MAP[idx]
            try:
                keyboard.press(key)
                currently_held_key = key

                if length_sec and length_sec > 0:
                    end_hold = time.perf_counter() + length_sec
                    while time.perf_counter() < end_hold:
                        if stop_event.is_set():
                            break
                        time.sleep(0.002)
                else:
                    time.sleep(0.02)
            finally:
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
