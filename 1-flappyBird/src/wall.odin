package flappy_bird

import rl "vendor:raylib"

PIPE_MOVEMENT_SPEED :: 200.0
PIPE_SPAWN_X :: SCREEN_WIDTH + 50.0
PIPE_DESPAWN_X :: -150.0
PIPE_INTERVAL :: 300

GAP_HEIGHT :: 200.0
GAP_HALF_HEIGHT :: GAP_HEIGHT / 2

@(rodata)
COLLIDER_PIPE_TOP: Vec2 = {70, 70}
@(rodata)
COLLIDER_PIPE_SIDE: Vec2 = {70, 100}

PIPE_WIDTH :: 70

Wall :: struct {
	x_position: f32,
	center_y:   f32,
}

spawn_new_walls :: proc(game: ^Game) {
	last_wall := game.walls[len(game.walls) - 1]
	distance := PIPE_SPAWN_X - last_wall.x_position

	if distance >= PIPE_INTERVAL {
		spawn_pipe(game)
	}
}

spawn_pipe :: proc(game: ^Game) {
	random_offset := rl.GetRandomValue(-100, 100)
	wall := Wall {
		center_y   = 200 + f32(random_offset),
		x_position = f32(PIPE_SPAWN_X),
	}
	append(&game.walls, wall)
}

move_walls :: proc(game: ^Game, delta_time: f32) {
	for &wall in game.walls {
		wall.x_position -= PIPE_MOVEMENT_SPEED * delta_time
	}
}

despawn_old_walls :: proc(game: ^Game) {
	first_wall := game.walls[0]

	if first_wall.x_position <= PIPE_DESPAWN_X {
		pop_front(&game.walls)
	}
}

draw_pipes :: proc(game: ^Game) {
	for wall in game.walls {
		center := wall.center_y

		bottom_pipe_start_y := center + GAP_HALF_HEIGHT
		top_pipe_start_y := center - GAP_HALF_HEIGHT

		draw_pipe(wall.x_position, bottom_pipe_start_y, true, game.assets)
		draw_pipe(wall.x_position, top_pipe_start_y, false, game.assets)
	}
}

draw_pipe :: proc(x, y: f32, going_down: bool, assets: Assets) {
	y := y
	direction: f32 = going_down ? 1 : -1

	left_top: Vec2 = {
		x - (PIPE_WIDTH / 2),
		y - (COLLIDER_PIPE_TOP.y / 2 * direction),
	}
	right_bottom: Vec2 = {
		left_top.x + PIPE_WIDTH,
		left_top.y + (1_000 * direction),
	}

	rect := create_rect(left_top, right_bottom)

	draw_texture(assets.pipe_tip, {x, y}, !going_down)
	// draw_collider_rect({x, y}, COLLIDER_PIPE_TOP)

	for i := 1; i < 5; i += 1 {
		y += 100.0 * direction

		draw_texture(assets.pipe_mid, {x, y}, !going_down)
		// draw_collider_rect({x, y}, COLLIDER_PIPE_SIDE)
	}
	draw_collider_rect({rect.x, rect.y}, {rect.width, rect.height})
}
