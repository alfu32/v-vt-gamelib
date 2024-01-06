module libgamev


type ShapeTransform = fn (&Entity, int, &i8) Shape

enum EntityType {
	background=0x10
	ship=0x11
	foe=0x12
	bullet=0x13
	rocket=0x14
}
struct Entity {
	pub mut:
	etype EntityType
	// Flag flags;
	shape Shape
	birth_frame u128
	life u64
	color u8
	background u8
	next ShapeTransform
}

fn entity_new(birthframe int, x0 int, y0 int, content &i8, transformfunc ShapeTransform, color i8, background i8) &Entity {
	mut entity := &Entity{}
	entity.type_ = ship
	entity.shape = shape_new(x0, y0, content)
	entity.birth_frame = birthframe
	entity.life = 1
	entity.color = color
	entity.background = background
	entity.next = transformfunc
	return entity
}
