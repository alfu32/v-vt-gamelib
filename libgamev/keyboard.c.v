module libgamev

import term.termios
#flag -I @VMODROOT/libgamev/
#flag @VMODROOT/libgamev/keyboard.o
#include "keyboard.h"

pub struct C.input_event{
	value int
	code int
	typ int
}
pub struct InputEvent {
	value u32
	code u8
	typ u8
}
pub struct C.Keyboard {
	num_devices i32
	oldt termios.Termios
	newt termios.Termios
	device_paths []string
	key_state []u8
	device i32
	ev C.input_event
}
pub struct Keyboard {
	num_devices i32
	oldt termios.Termios
	newt termios.Termios
	device_paths []string
	key_state []u8
	device i32
	ev InputEvent
}

pub fn C.keyboard_new() &C.Keyboard
/// pub fn keyboard_new() &Keyboard {
/// 	ckb := C.keyboard_new()
/// 	return &Keyboard{
/// 		num_devices: ckb.num_devices
/// 		oldt: ckb.oldt
/// 		newt: ckb.newt
/// 		device_paths: ckb.device_paths
/// 		key_state: ckb.key_state
/// 		device: ckb.device
/// 		ev: InputEvent{
/// 			value: u32(ckb.ev.value)
/// 			code: u8(ckb.ev.code)
/// 			typ: u8(ckb.ev.typ)
/// 		}
/// 	}
/// }
[c:'is_keyboard']
fn C.is_keyboard(&char) i32
[c:'find_keyboard_devices']
fn C.find_keyboard_devices(&&char) int
[c:'keyboard_refresh']
fn C.keyboard_refresh(&C.Keyboard) int
[c:'keyboard_contains']
fn C.keyboard_contains(&C.Keyboard, &u8) int
[c:'keyboard_get_pressed']
fn C.keyboard_get_pressed(&C.Keyboard) &u8
[c:'keyboard_deinit']
pub fn C.keyboard_deinit(&C.Keyboard)



