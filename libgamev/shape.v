module libgamev

struct Shape {
	pub mut:
	x       int
	y       int
	content string
}

fn shape_new(x int, y int, content string) &Shape {
	shape := &Shape{x,y,content}
	return shape
}

fn (sh Shape) shape_copy(source Shape) &Shape {
	return shape_new(source.x,source.y,source.content)
}

fn (mut sh &Shape) shape_move_to(x int, y int) {
	sh.x=x
	sh.y=y
}

fn  (mut sh &Shape) shape_set(newcontent string) {
	sh.content=content
}

fn (shape &Shape) get_bounding_client_rect() ClientRect {
	lines := shape.content.trim_indent().split("\n")
	shapewidth := find_max_len(lines)
	shapeheight := lines.len
	rect := ClientRect{
		x: shape.x
		y: shape.y
		width: shapewidth
		height: shapeheight
	}

	return rect
}


