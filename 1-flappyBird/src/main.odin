package flappy_bird

import "core:fmt"
import "core:slice"
import rl "vendor:raylib"

Vec2 :: [2]f32

PLAYER_SPEED :: 20.0
PLAYER_WING_DOWN_DURATION_S :: 0.1

GRAVITY :: 400.0
JUMP_VELOCITY :: -180.0
VELOCITY_MIN :: -200.0 // up
VELOCITY_MAX :: 300.0 // down

PIPE_MOVEMENT_SPEED :: 200.0
PIPE_SPAWN_X :: SCREEN_WIDTH + 50.0
PIPE_DESPAWN_X :: -150.0
PIPE_INTERVAL :: 300

GAP_HEIGHT :: 200.0
GAP_HALF_HEIGHT :: GAP_HEIGHT / 2

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

Game :: struct {
	player: Player,
	walls:  [dynamic]Wall,
	assets: Assets,
}

Wall :: struct {
	x_position: f32,
	center_y:   f32,
}

Player :: struct {
	position:    Vec2,
	y_velocity:  f32,
	up_duration: Maybe(f32),
}

Assets :: struct {
	player_up:   rl.Texture2D,
	player_down: rl.Texture2D,
	pipe_tip:    rl.Texture2D,
	pipe_mid:    rl.Texture2D,
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Flappy Bird")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	pipe_tip := rl.LoadTexture("pipe-tip.png")
	pipe_mid := rl.LoadTexture("pipe-mid.png")

	assets := Assets {
		player_up   = rl.LoadTexture("player-up.png"),
		player_down = rl.LoadTexture("player-down.png"),
		pipe_tip    = rl.LoadTexture("pipe-tip.png"),
		pipe_mid    = rl.LoadTexture("pipe-mid.png"),
	}

	player := Player {
		position   = {60, 40},
		y_velocity = 0.0,
		// rect = {width = f32(assets.player_down.width), height = f32(assets.player_down.height)},
	}

	game := Game {
		player = player,
		walls  = make([dynamic]Wall),
		assets = assets,
	}
	defer delete(game.walls)

	x := PIPE_SPAWN_X
	spawn_pipe(&game)

	for !rl.WindowShouldClose() {
		delta_time := rl.GetFrameTime()
		handle_player(&player, delta_time)
		move_walls(&game, delta_time)
		spawn_new_walls(&game)
		despawn_old_walls(&game)

		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground({160, 200, 255, 255})

		// draw
		draw_player(player, game.assets)

		for wall in game.walls {
			center := wall.center_y

			bottom_pipe_start_y := center + GAP_HALF_HEIGHT
			top_pipe_start_y := center - GAP_HALF_HEIGHT

			draw_pipe(wall.x_position, bottom_pipe_start_y, true, game.assets)
			draw_pipe(wall.x_position, top_pipe_start_y, false, game.assets)
		}
	}
}

handle_player :: proc(player: ^Player, delta_time: f32) {
	if (rl.IsKeyDown(.SPACE) || rl.IsKeyDown(.UP)) {
		player.y_velocity = JUMP_VELOCITY

		player.up_duration = PLAYER_WING_DOWN_DURATION_S
	}

	player.y_velocity += GRAVITY * delta_time

	player.y_velocity = clamp(player.y_velocity, VELOCITY_MIN, VELOCITY_MAX)
	player.position.y += player.y_velocity * delta_time

	if duration_left, ok := player.up_duration.?; ok {
		duration_left -= delta_time

		if duration_left < 0.0 {
			player.up_duration = nil
		} else {
			player.up_duration = duration_left
		}
	}
}

move_walls :: proc(game: ^Game, delta_time: f32) {
	for &wall in game.walls {
		wall.x_position -= PIPE_MOVEMENT_SPEED * delta_time
	}
}


draw_pipe :: proc(x, y: f32, going_down: bool, assets: Assets) {
	y := y
	direction: f32 = going_down ? 1 : -1

	draw_texture(assets.pipe_tip, {x, y}, !going_down)

	for i := 1; i < 5; i += 1 {
		y += 100.0 * direction

		draw_texture(assets.pipe_mid, {x, y}, !going_down)
	}
}

draw_player :: proc(player: Player, assets: Assets) {
	_, is_going_up := player.up_duration.?
	player_texture := is_going_up ? assets.player_up : assets.player_down

	draw_collider(player.position, 20)
	// rl.DrawTextureV(player_texture, player.position, rl.WHITE)
	draw_texture(player_texture, player.position)
}

spawn_pipe :: proc(game: ^Game) {
	random_offset := rl.GetRandomValue(-100, 100)
	test_wall := Wall {
		center_y   = 150 + f32(random_offset),
		x_position = f32(PIPE_SPAWN_X),
	}
	append(&game.walls, test_wall)
}

spawn_new_walls :: proc(game: ^Game) {
	last_wall := game.walls[len(game.walls) - 1]
	distance := PIPE_SPAWN_X - last_wall.x_position

	if distance >= PIPE_INTERVAL {
		spawn_pipe(game)
	}
}

despawn_old_walls :: proc(game: ^Game) {
	first_wall := game.walls[0]

	if first_wall.x_position <= PIPE_DESPAWN_X {
		pop_front(&game.walls)
	}
}
