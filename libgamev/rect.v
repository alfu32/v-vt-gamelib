module libgamev

struct ClientRect {
	x      int
	y      int
	width  u32
	height u32
}
fn find_max_len(s []string) u32 {
	mut m:=0
	for l in s {
		if l.len>m {
			m=l.len
		}
	}
	return m
}


pub fn (b Box) contains_point(p Point) bool {
	a := b.anchor
	c := b.corner()
	return a.x <= p.x && p.x <= c.x && a.y <= p.y && p.y <= c.y
}

pub fn (b Box) corners() []Point {
	a := b.anchor
	c := b.corner()
	mut r := [a.clone()]
	r << Point{a.x, c.y}
	r << c.clone()
	r << Point{c.x, a.y}
	return r
}

pub fn (b Box) contains_box(o Box) bool {
	mut a := true
	for corner in o.corners() {
		a = a && b.contains_point(corner)
	}
	return a
}

pub fn (b Box) intersects_box(o Box) bool {
	mut a := false
	for corner in o.corners() {
		a = a || b.contains_point(corner)
	}
	mut z := false
	for corner in b.corners() {
		z = z || o.contains_point(corner)
	}
	return a || z
}

fn rectanglesintersect(rect1 &ClientRect, rect2 &ClientRect) int {
	x1 := rect1.x
	y1 := rect1.y
	x2 := x1 + rect1.width
	y2 := y1 + rect1.height
	x3 := rect2.x
	y3 := rect2.y
	x4 := x3 + rect2.width
	y4 := y3 + rect2.height
	if x2 < x3 || x4 < x1 {
		return 0
	}
	if y2 < y3 || y4 < y1 {
		return 0
	}
	return 1
}
