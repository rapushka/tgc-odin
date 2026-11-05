package flappy_bird

import rl "vendor:raylib"

PLAYER_SPEED :: 20.0
PLAYER_WING_DOWN_DURATION_S :: 0.2

GRAVITY :: 400.0
JUMP_VELOCITY :: -180.0
VELOCITY_MIN :: -200.0 // up
VELOCITY_MAX :: 300.0 // down

COLLIDER_PLAYER_RADIUS :: 20

Player :: struct {
	position:    Vec2,
	y_velocity:  f32,
	up_duration: Maybe(f32),
	is_alive:    bool,
}

handle_player :: proc(player: ^Player, delta_time: f32) {
	if (rl.IsKeyPressed(.SPACE) || rl.IsKeyPressed(.UP)) {
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

draw_player :: proc(player: Player, assets: Assets) {
	_, is_going_up := player.up_duration.?
	player_texture := is_going_up ? assets.player_up : assets.player_down

	if !player.is_alive {
		player_texture = assets.player_dead
	}
	draw_texture(player_texture, player.position)
	draw_collider_circle(player.position, COLLIDER_PLAYER_RADIUS)
}
