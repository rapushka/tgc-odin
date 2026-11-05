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

// wall is a pair of pipes
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

get_pipes_of_wall :: proc(wall: Wall) -> [2]Pipe {
	center := wall.center_y

	top_tip_y := center - GAP_HALF_HEIGHT
	bottom_tip_y := center + GAP_HALF_HEIGHT

	return {
		Pipe{tip_position = {wall.x_position, top_tip_y}, direction = .Up},
		Pipe{tip_position = {wall.x_position, bottom_tip_y}, direction = .Down},
	}
}

draw_walls :: proc(game: ^Game) {
	for wall in game.walls {
		pipes := get_pipes_of_wall(wall)

		for pipe in pipes {
			draw_pipe(pipe, game.assets)
		}
	}
}
