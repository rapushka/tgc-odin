package flappy_bird

import "core:fmt"
import rl "vendor:raylib"

Vec2 :: [2]f32

SCREEN_WIDTH :: 800
SCREEN_HEIGHT :: 450

Game :: struct {
	player: Player,
	assets: Assets,
	walls:  [dynamic]Wall,
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

	game := Game {
		walls = make([dynamic]Wall),
		player = Player {
			position = {90, 90},
			is_alive = true,
		},
		assets = Assets {
			player_up   = rl.LoadTexture("player-up.png"),
			player_down = rl.LoadTexture("player-down.png"),
			player_dead = rl.LoadTexture("player-ded.png"),
			pipe_tip    = rl.LoadTexture("pipe-tip.png"),
			pipe_mid    = rl.LoadTexture("pipe-mid.png"),
		},
	}
	defer delete(game.walls)

	spawn_new_walls(&game.walls)

	for !rl.WindowShouldClose() {
		// # update
		delta_time := rl.GetFrameTime()

		handle_player(&game.player, delta_time)
		move_walls(game.walls[:], delta_time)
		spawn_new_walls(&game.walls)
		despawn_old_walls(&game.walls)

		check_player_collisions(&game.player, game.walls[:])

		// # draw
		rl.BeginDrawing()
		defer rl.EndDrawing()

		rl.ClearBackground({160, 200, 255, 255})

		draw_player(game.player, game.assets)
		draw_walls(game.walls[:], game.assets)
	}
}

check_player_collisions :: proc(player: ^Player, walls: []Wall) {
	player_circle := circle_from_center(player.position, COLLIDER_PLAYER_RADIUS)

	for wall in walls {
		pipes := get_pipes_of_wall(wall)
		for pipe in pipes {
			pipe_rect := rect_pipe(pipe)

			is_collided := check_collision_circle_rect(player_circle, pipe_rect)

			if is_collided {
				player.is_alive = false
			}
		}
	}
}
