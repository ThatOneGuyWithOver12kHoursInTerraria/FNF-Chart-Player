import time
import sys
import termios
import tty

def get_key():
    """Wait for a single key press and return it."""
    fd = sys.stdin.fileno()
    old_settings = termios.tcgetattr(fd)
    try:
        tty.setraw(fd)
        ch = sys.stdin.read(1)
    finally:
        termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
    return ch

def ask_variant():
    print("Select QTE variant:")
    print("1. Discord")
    print("2. Roblox")
    while True:
        choice = input("Enter 1 or 2: ").strip()
        if choice == "1":
            return "Discord"
        elif choice == "2":
            return "Roblox"
        else:
            print("Invalid choice. Please enter 1 or 2.")

def ask_number():
    while True:
        try:
            num = int(input("How long should the QTE be (seconds, max 30)? ").strip())
            if 1 <= num <= 30:
                return num
            else:
                print("Please enter a number between 1 and 30.")
        except ValueError:
            print("Invalid input. Enter a number.")

def ask_preview():
    msg = input("Preview message (type 'none' to skip): ").strip()
    return None if msg.lower() == "none" else msg

def wait_for_p():
    print("Press 'P' to start the QTE...")
    while True:
        key = get_key()
        if key.lower() == 'p':
            break

def discord_qte(number, preview_message):
    if preview_message:
        print(preview_message)
        input()  # Simulate pressing enter
    print(f"[QUICK TIME EVENT: {number} SECONDS]")
    input()
    print(f"Time Left: {number}")
    input()
    time_left = number
    while time_left > 0:
        time.sleep(1)
        prev_digits = len(str(time_left))
        time_left -= 1
        # Simulate up arrow (move cursor up)
        sys.stdout.write('\033[F')
        # Simulate backspace for previous digits
        sys.stdout.write('\rTime Left: ' + ' ' * prev_digits)
        sys.stdout.flush()
        # Type new number
        print(f"\rTime Left: {time_left}", end='')
        input()  # Simulate pressing enter

def roblox_qte(number, preview_message):
    if preview_message:
        print(preview_message)
        print()  # New line instead of enter
    print(f"[QUICK TIME EVENT: {number} SECONDS]")
    print()
    print(f"Time Left: {number}")
    print()
    time_left = number
    while time_left > 0:
        time.sleep(1)
        prev_digits = len(str(time_left))
        time_left -= 1
        # Simulate up arrow (move cursor up)
        sys.stdout.write('\033[F')
        # Simulate backspace for previous digits
        sys.stdout.write('\rTime Left: ' + ' ' * prev_digits)
        sys.stdout.flush()
        # Type new number
        print(f"\rTime Left: {time_left}")
        print()  # New line instead of enter

def main():
    VARIANT = ask_variant()
    NUMBER = ask_number()
    PREVIEW_MESSAGE = ask_preview()
    TIME_LEFT = NUMBER
    wait_for_p()
    if VARIANT == "Discord":
        discord_qte(NUMBER, PREVIEW_MESSAGE)
    elif VARIANT == "Roblox":
        roblox_qte(NUMBER, PREVIEW_MESSAGE)

if __name__ == "__main__":
    main()