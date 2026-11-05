package flappy_bird

import rl "vendor:raylib"

// where is pipe's "origin", relative to pipe's tip
// i.e. top is:
// origin
//   ⬆
//  tip
Pipe_Direction :: enum {
	Up,
	Down,
}

Pipe :: struct {
	tip_position: Vec2,
	direction:    Pipe_Direction,
}

rect_pipe :: proc(pipe: Pipe) -> Rect {
	x, y := expand_values(pipe.tip_position)
	is_going_down := pipe.direction == .Down
	direction: f32 = is_going_down ? 1 : -1

	left_top: Vec2 = {
		x - (PIPE_WIDTH / 2),
		y - (COLLIDER_PIPE_TOP.y / 2 * direction),
	}
	right_bottom: Vec2 = {
		left_top.x + PIPE_WIDTH,
		left_top.y + (1_000 * direction),
	}

	return rect_from_corners(left_top, right_bottom)
}

draw_pipe :: proc(pipe: Pipe, assets: Assets) {
	x, y := expand_values(pipe.tip_position)
	is_going_down := pipe.direction == .Down
	direction: f32 = is_going_down ? 1 : -1

	draw_texture(assets.pipe_tip, {x, y}, !is_going_down)

	for i := 1; i < 5; i += 1 {
		y += 100.0 * direction

		draw_texture(assets.pipe_mid, {x, y}, !is_going_down)
	}

	rect := rect_pipe(pipe)
	draw_collider_rect(rect)
}
