import term.ui as tui
#flag -I/usr/include/libevdev-1.0/
#flag -levdev
#include "/home/alfu64/Development/vlibgame/keyboard.c"

struct App {
	pub mut:
	tui &tui.Context = unsafe { nil }
}

fn event(e &tui.Event, mut app App) {
	modifiers :=if !e.modifiers.is_empty() {
		if e.modifiers.has(.ctrl) {
			'ctrl. '
		} else if e.modifiers.has(.shift) {
			'shift '
		} else if e.modifiers.has(.alt) {
			'alt. '
		} else {
			'${e.modifiers}'
		}
	} else {
		' no modifiers '
	}
	app.tui.clear()
	app.tui.set_cursor_position(0, 0)
	app.tui.write('V term.input event viewer (press ESC to exit)')
	app.tui.write('
		width     : ${e.width}
		ascii     : ${e.ascii}
		button    : ${e.button}
		code      : ${e.code}
		direction : ${e.direction}
		height    : ${e.height}
		modifiers : ${modifiers}
		typ       : ${e.typ}
		utf8      : ${e.utf8}
		x         : ${e.x}
		y         : ${e.y}
	'.trim_indent())
	app.tui.write('Raw event bytes: ${e.utf8.bytes().hex()} = ${e.utf8.bytes()}')
	app.tui.flush()

	if e.typ == .key_down && e.code == .escape {
		exit(0)
	}
}

fn main() {
	mut app := &App{}
	app.tui = tui.init(
		user_data: app
		event_fn: event
		window_title: 'something'
		hide_cursor: true
		capture_events: true
		frame_rate: 60
		use_alternate_buffer: false
	)
	app.tui.run()!
}
