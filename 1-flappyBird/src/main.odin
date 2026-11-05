package flappy_bird

import rl "vendor:raylib"

Vec2 :: [2]f32

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

Game :: struct {
	player: Player,
	walls:  [dynamic]Wall,
	assets: Assets,
}

Assets :: struct {
	player_up:   rl.Texture2D,
	player_down: rl.Texture2D,
	player_dead: rl.Texture2D,
	pipe_tip:    rl.Texture2D,
	pipe_mid:    rl.Texture2D,
}

main :: proc() {
	rl.InitWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Flappy Bird")
	defer rl.CloseWindow()
	rl.SetTargetFPS(60)

	assets := Assets {
		player_up   = rl.LoadTexture("player-up.png"),
		player_down = rl.LoadTexture("player-down.png"),
		player_dead = rl.LoadTexture("player-ded.png"),
		pipe_tip    = rl.LoadTexture("pipe-tip.png"),
		pipe_mid    = rl.LoadTexture("pipe-mid.png"),
	}

	player := Player {
		position   = {90, 90},
		y_velocity = 0.0,
		is_alive   = true,
	}

	game := Game {
		player = player, // TODO: THIS IS COPY OF STRUCT, NEED FIX
		walls  = make([dynamic]Wall),
		assets = assets,
	}
	defer delete(game.walls)

	spawn_pipe(&game)

	for !rl.WindowShouldClose() {
		// # update
		delta_time := rl.GetFrameTime()
		handle_player(&player, delta_time)
		move_walls(&game, delta_time)
		spawn_new_walls(&game)
		despawn_old_walls(&game)

		check_player_collisions(&game)

		// # draw
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground({160, 200, 255, 255})

		draw_player(player, game.assets)
		draw_walls(&game)
	}
}

check_player_collisions :: proc(game: ^Game) {
	player := game.player
	walls := game.walls

	player_circle := circle_from_center(player.position, COLLIDER_PLAYER_RADIUS)

	for wall in walls {
		center := wall.center_y

		bottom_pipe_start_y := center + GAP_HALF_HEIGHT
		top_pipe_start_y := center - GAP_HALF_HEIGHT

		// rect_from_corners()
		// collided := check_collision_circle_rect(player_circle, )
	}
}
