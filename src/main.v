module main

import libgamev

fn main() {
	kb := libgamev.C.keyboard_new()
	println('
		Hello :
			- World
			- Me
			- you
			- everybody
		!
		${kb}
	'.trim_indent())
	libgamev.C.keyboard_deinit(kb)
}
