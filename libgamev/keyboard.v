module libgamev

#include "/home/alfu64/Development/vlibgame/libgamev/keyboard.h"
#include "/home/alfu64/Development/vlibgame/libgamev/keyboard.c"

pub struct C.Keyboard {
	//// num_devices i32
	//// oldt C.termios
	//// newt C.termios
	//// device_paths []string
	//// key_state []u8
	//// device i32
	//// ev C.input_event
}

pub fn C.keyboard_new() &C.Keyboard
pub fn C.is_keyboard(&char) C.int
pub fn find_keyboard_devices(&&char) C.int
pub fn keyboard_refresh(&C.Keyboard) C.int
pub fn keyboard_contains(&C.Keyboard, &C.char) C.int
pub fn keyboard_get_pressed(&C.Keyboard) &C.char
pub fn keyboard_deinit(&C.Keyboard)


