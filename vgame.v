[translated]
module main
import os

fn player_behaviour_next(mut e &Entity, frame int, keys &i8) Shape {
	mut sh := e.shape.shape_copy()
	if keys != (voidptr(0)) {
		if frame - last_move > 5 {
			if C.strchr(keys, `z`) != (voidptr(0)) {
				sh.x -= 1
				if sh.x < 0 {
					sh.x = 0
				}
				last_move = frame
			}
			if C.strchr(keys, `c`) != (voidptr(0)) {
				sh.x += 1
				if sh.x > 80 {
					sh.x = 80
				}
				last_move = frame
			}
			if C.strchr(keys, `s`) != (voidptr(0)) {
				sh.y -= 1
				if sh.y < 0 {
					sh.y = 0
				}
				last_move = frame
			}
			if C.strchr(keys, `x`) != (voidptr(0)) {
				sh.y += 1
				if sh.y > 20 {
					sh.y = 20
				}
				last_move = frame
			}
		}
		if C.strchr(keys, `g`) != (voidptr(0)) {
			if frame - last_cannon > 30 {
				mut bullet := entity_new(frame, sh.x + 3, sh.y, c'-==>', bullet_behaviour, 5, 0)
				bullet.life = 60
				scene_manager_add_entity(manager, bullet)
				mut bullet2 := entity_new(frame, sh.x + 3, sh.y + 4, c'-==>', bullet_behaviour, 5, 0)
				bullet2.life = 60
				scene_manager_add_entity(manager, bullet2)
				last_cannon = frame
			}
		}
		if C.strchr(keys, `h`) != (voidptr(0)) {
			if frame - last_bullet > 10 {
				mut bullet := entity_new(frame, sh.x + 5, sh.y + 2, c':', bullet_behaviour, 6, 0)
				bullet.life = 60
				scene_manager_add_entity(manager, bullet)
				last_bullet = frame
			}
		}
	}
	return sh
}

fn foe_behaviour_next(mut e &Entity, frame int, keys &i8) Shape {
	mut sh := e.shape.shape_copy()
	if sh.y + foe_direction > 23 {
		foe_direction = -1
	}
	else if sh.y + foe_direction < 1 {
		foe_direction = 1
	}
	if frame % 5 == 0 {
		sh.y = sh.y + foe_direction
	}
	return sh
}

fn bullet_behaviour(mut e &Entity, frame int, keys &i8) Shape {
	mut sh := e.shape.shape_copy()
	if frame % 5 == 0 {
		sh.x = sh.x + 1
		e.life = e.life - 1
	}
	return sh
}

fn rolling_background_behaviour(mut e &Entity, frame int, keys &i8) Shape {
	mut sh := e.shape.shape_copy()
	if frame % 5 == 0 {
		if (sh.x - 1) < -80 {
			sh.x = 80
		}
		else {
			sh.x = sh.x - 1
		}
	}
	return sh
}

[weak] __global (
	running  = int (1)
)

[export:'background']
const (
background   = c'                                                                       \n               *                                                       \n        *                                                              \n                *                                     *                \n         *           *          **                                     \n                                **                                     \n                         *      **                                     \n                               +--+                                    \n                               |  |                                    \n                               |  |                                    \n                               |  |          *                         \n             ======            |  |                          +-------+ \n         +----------+          |  |                      +---|       | \n         | ________ |        +-+--+-+                    |   |       | \n         | ________ |        |      |                    |   |       | \n         | ________ |        |      |                    |   |       | \n         | ________ |        |      |                    +---+-------+ \n         | ________ |        |      |                    |           | \n         | ________ |        |      |        ======================  | \n    +------+_______ |      +-+------+-+         _+--------------+    | \n    |      |_______ |      |          |         _| ____________ |    | \n    |      |_______ |      |          |         _|              |    | \n    |      |_______ |      |          |     _____| ____________ |    | \n    |      |        |      |          |          |              |    | \n=======================__================______========================\n'
)

[export:'ship_shape']
const (
ship_shape   = c'  \\-\n  \\\n#====>\n  /\n /-\n'
)

[export:'foe_shape']
const (
foe_shape   = c'   ##\n -####\n=#######\n -####\n  ##\n'
)
struct App{
	pub mut:
		running bool
}
pub fn (mut app App) destroy_handler(sig os.Signal) {
	println('shutting down ...')
	app.running=false
}
fn app_create() &App{
	mut app_ref:=&App{true}
	os.signal_opt(.int,app_ref.destroy_handler)!
	return app_ref
}
fn main()  {
	a := app_create()
	keyboard := keyboard_new()
	signal_opt
	vpp = viewport_new(80, 25)
	manager := scene_manager_new()
	bkg0 := entity_new(0, 80, 0, background, rolling_background_behaviour, 2, 1)
	bkg1 := entity_new(0, 0, 0, background, rolling_background_behaviour, 2, 1)
	entity1 := entity_new(0, 10, 10, ship_shape, player_behaviour_next, 4, 1)
	entity2 := entity_new(0, 70, 10, foe_shape, foe_behaviour_next, 1, 1)
	scene_manager_add_entity(manager, bkg0)
	scene_manager_add_entity(manager, bkg1)
	scene_manager_add_entity(manager, entity1)
	scene_manager_add_entity(manager, entity2)
	shape := shape_new(10, 5, c'HooHooHooo')
	status := shape_new(0, 0, c':::GAME:::.\360\237\232\200\360\237\232\200\360\237\232\200......................................')
	frame := 0
	for a.running {
		terminal_clear()
		pressed := keyboard_get_pressed(keyboard)
		shape_set_fmt(status, c':::GAME::: x:%6d y:%6d,frame:%8d, objects:%2d', shape.x, shape.y, frame, manager.entities_count)
		viewport_clear(vpp)
		scene_manager_update(manager, frame, pressed)
		viewport_shape_draw(vpp, status, 3, 0)
		scene_manager_draw_on_viewport(manager, vpp)
		viewport_renderer(vpp)
		scene_manager_do_collisions(manager)
		frame ++
		usleep(9 * 1000)
		scene_manager_remove_dead_shapes(manager)
	}
	pintlnf(c' - cleaning up \n')
	sleep(1)
	shape_dealloc(shape)
	shape_dealloc(status)
	viewport_dealloc(vpp)
	scene_manager_free(manager)
	print(' - resetting terminal \n')
	sleep(1)
	keyboard_deinit(keyboard)
	sleep(1)
	printf(' - done \n')
	sleep(1)
	return
}

