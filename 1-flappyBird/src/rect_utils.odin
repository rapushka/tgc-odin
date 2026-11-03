package flappy_bird

import rl "vendor:raylib"

create_rect :: proc(top_left, bottom_right: Vec2) -> rl.Rectangle {
	center := (bottom_right + top_left) / 2
	size := bottom_right - top_left

	return {
		x      = center.x,
		y      = center.y,
		width  = size.x,
		height = size.y,
	}
}
