module libgamev


const colors = ['\\033[0m', '\\033[31m', '\\033[32m', '\\033[33m', '\\033[34m', '\\033[35m',
'\\033[36m', '\\033[37m', '\\033[90m', '\\033[91m', '\\033[92m', '\\033[93m', '\\033[94m',
'\\033[95m', '\\033[96m', '\\033[97m']

const backgrounds = ['\\033[40m', '\\033[41m', '\\033[42m', '\\033[43m', '\\033[44m', '\\033[45m',
'\\033[46m', '\\033[47m', '\\033[100m', '\\033[101m', '\\033[102m', '\\033[103m', '\\033[104m',
'\\033[105m', '\\033[106m', '\\033[107m']

struct Viewport {
	pub mut:
	width       int
	height      int
	buffer      []string
	colors      []u8
	backgrounds []u8
}

fn viewport_new(width int, height int) &Viewport {
	mut vp := &Viewport(C.malloc(sizeof(Viewport)))
	vp.width = 80
	vp.height = 24
	vp.clear()
	return vp
}

fn (vp &Viewport) clear() {
	for i := 0; i < vp.height; i++ {
		vp.buffer[i]=" ".repeat(vp.width)
		vp.colors[i]=[]u8{7;vp.width}
		vp.backgrounds[i]=[]u8{0;vp.width}
	}
}

fn (vp &Viewport) draw_char(x int, y int, character string, fg u8, bg u8) {
	if x >= 0 && x < vp.width && y >= 0 && y < vp.height {
		vp.buffer[y][x] = character
		vp.colors[y][x] = fg
		vp.backgrounds[y][x] = fg
	}
}

fn (vp &Viewport) render() {
	println("+${"-".repeat(vp.width)}}+")
	for y := 0; y < vp.height; y++ {
		print(`|`)
		last_color := 0
		for x := 0; x < vp.width; x++ {
			colored := 0
			if vp.colors[y][x] {
				print(colors[vp.colors[y][x]])
			}
			putchar(vp.buffer[y][x])
			if vp.colors[y][x] && vp.colors[y][x] != vp.colors[y][x + 1] {
				printf("\\033[0m")
			}
		}
		println('\\033[0m|')
	}
	println("+${"-".repeat(vp.width)}}+")
}
