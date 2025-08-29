import time
import pyautogui
import keyboard
def get_variant():
	while True:
		print("Select QTE variant:")
		print("1. Discord")
		print("2. Roblox")
		choice = input("Enter 1 or 2: ").strip()
		if choice == "1":
			return "Discord"
		elif choice == "2":
			return "Roblox"
		else:
			print("Invalid choice. Try again.")
def get_duration():
	while True:
		val = input("How long should the QTE be (seconds, max 30)? ").strip()
		if val.isdigit():
			num = int(val)
			if 1 <= num <= 30:
				return num
		print("Please enter a number between 1 and 30.")

def get_preview():
	msg = input("Preview message (type 'none' to skip): ").strip()
	if msg.lower() == "none":
		return None
	return msg

def wait_for_p():
	print("Press 'P' to start the QTE...")
	while True:
		if keyboard.is_pressed('p'):
			break
		time.sleep(0.05)
def type_and_enter(text):
	pyautogui.typewrite(text)
	pyautogui.press('enter')
def type_and_newline(text):
	pyautogui.typewrite(text)
	pyautogui.typewrite('\n')
def run_discord_qte(NUMBER, PREVIEW_MESSAGE):
	TIME_LEFT = NUMBER
	if PREVIEW_MESSAGE:
		type_and_enter(PREVIEW_MESSAGE)
	type_and_enter(f"[QUICK TIME EVENT: {NUMBER} SECONDS]")
	type_and_enter(f"Time Left: {TIME_LEFT}")
	while TIME_LEFT > 0:
		time.sleep(1)
		prev_digits = len(str(TIME_LEFT))
		TIME_LEFT -= 1
		pyautogui.press('up')
		for _ in range(prev_digits):
			pyautogui.press('backspace')
		pyautogui.typewrite(str(TIME_LEFT))
		pyautogui.press('enter')
def run_roblox_qte(NUMBER, PREVIEW_MESSAGE):
	TIME_LEFT = NUMBER
	if PREVIEW_MESSAGE:
		type_and_newline(PREVIEW_MESSAGE)
	type_and_newline(f"[QUICK TIME EVENT: {NUMBER} SECONDS]")
	type_and_newline(f"Time Left: {TIME_LEFT}")
	while TIME_LEFT > 0:
		time.sleep(1)
		prev_digits = len(str(TIME_LEFT))
		TIME_LEFT -= 1
		pyautogui.press('up')
		for _ in range(prev_digits):
			pyautogui.press('backspace')
		pyautogui.typewrite(str(TIME_LEFT))
		pyautogui.typewrite('\n')
def main():
	variant = get_variant()
	NUMBER = get_duration()
	PREVIEW_MESSAGE = get_preview()
	wait_for_p()
	if variant == "Discord":
		run_discord_qte(NUMBER, PREVIEW_MESSAGE)
	else:
		run_roblox_qte(NUMBER, PREVIEW_MESSAGE)
if __name__ == "__main__":
	main()
