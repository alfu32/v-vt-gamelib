module libgamev

fn terminal_clear()  {
	print('\\033[1;1H\\033[2J')
}

fn viewport_shape_draw(screen &Viewport, shape &Shape, fg i8, bg i8)  {
	y := shape.y
	mut x := shape.x
	mut offset_y := 0
	content := shape.content
	for chr in content.runes() {
		if chr != " " {
			if chr == "\n" {
				offset_y += 1
				x = shape.x - 1
			}
			else {
				screen.draw_char(x, y + offset_y, *content, fg, bg)
			}
		}
		x++
	}
}

