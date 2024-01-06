@[translated]
module libgamev

struct Shape {
	x       int
	y       int
	content &i8
}

fn shape_copy(this &Shape, source Shape)

struct Lldiv_t {
	quot i64
	rem  i64
}

struct Random_data {
	fptr      &int
	rptr      &int
	state     &int
	rand_type int
	rand_deg  int
	rand_sep  int
	end_ptr   &int
}

struct Drand48_data {
	__x     [3]u16
	__old_x [3]u16
	__c     u16
	__init  u16
	__a     i64
}

fn realloc(voidptr, u32) voidptr

fn realloc(__ptr voidptr, __size usize) voidptr

type ShapeTransform = fn (&Entity, int, &i8) Shape

enum EntityType {
}

struct Viewport {
	width       int
	height      int
	buffer      &&u8
	colors      &&u8
	backgrounds &&u8
}

struct SceneManager {
	entities       &&Entity
	entities_count int
}

fn scene_manager_new() &SceneManager

fn scene_manager_add_entity(manager &SceneManager, entity &Entity)

fn scene_manager_update(manager &SceneManager, currentframe int, pressed &i8)

fn scene_manager_do_collisions(manager &SceneManager)

fn scene_manager_remove_dead_shapes(manager &SceneManager)

fn scene_manager_draw_on_viewport(manager &SceneManager, vpp &Viewport)

fn scene_manager_free(manager &SceneManager)

fn viewport_shape_draw(screen &Viewport, shape &Shape, fg i8, bg i8)

fn key_is_pressed() int

fn key_read() int

struct ClientRect {
	x      int
	y      int
	width  u32
	height u32
}

fn get_bounding_client_rect(shape &Shape) ClientRect

fn scene_manager_new() &SceneManager {
	manager := &SceneManager(C.malloc(sizeof(SceneManager)))
	manager.entities = (unsafe { nil })
	manager.entities_count = 0
	return manager
}

fn scene_manager_add_entity(manager &SceneManager, entity &Entity) {
	manager.entities_count++
	manager.entities = realloc(manager.entities, manager.entities_count * sizeof(&Entity))
	manager.entities[manager.entities_count - 1] = entity
}

fn scene_manager_update(manager &SceneManager, currentframe int, keys &i8) {
	for i := 0; i < manager.entities_count; i++ {
		entity := manager.entities[i]
		newshape := entity.next(entity, currentframe, keys)
		shape_copy(entity.shape, newshape)
	}
}

fn scene_manager_do_collisions(manager &SceneManager) {
	rects := &ClientRect(C.malloc(sizeof(ClientRect) * manager.entities_count))
	for i := 0; i < manager.entities_count; i++ {
		rects[i] = get_bounding_client_rect(manager.entities[i].shape)
	}
	C.free(rects)
}

fn scene_manager_remove_dead_shapes(manager &SceneManager) {
	alivecount := 0
	for i := 0; i < manager.entities_count; i++ {
		if manager.entities[i].life != 0 {
			alivecount++
		}
	}
	aliveshapes := &&Entity(C.malloc(alivecount * sizeof(&Entity)))
	index := 0
	for i := 0; i < manager.entities_count; i++ {
		if manager.entities[i].life != 0 {
			aliveshapes[index++] = manager.entities[i]
		} else {
			C.free(manager.entities[i].shape.content)
			C.free(manager.entities[i].shape)
			C.free(manager.entities[i])
		}
	}
	C.free(manager.entities)
	manager.entities = aliveshapes
	manager.entities_count = alivecount
}

fn scene_manager_draw_on_viewport(manager &SceneManager, vp &Viewport) {
	if manager == (unsafe { nil }) || vp == (unsafe { nil }) {
		return
	}
	for i := 0; i < manager.entities_count; i++ {
		entity := manager.entities[i]
		if entity != (unsafe { nil }) && entity.shape != (unsafe { nil }) {
			viewport_shape_draw(vp, entity.shape, entity.color, entity.background)
		}
	}
}

fn scene_manager_free(manager &SceneManager) {
	for i := 0; i < manager.entities_count; i++ {
		if manager.entities[i].shape.content {
			C.free(manager.entities[i].shape.content)
		}
		C.free(manager.entities[i].shape)
		C.free(manager.entities[i])
	}
	C.free(manager.entities)
	C.free(manager)
}
