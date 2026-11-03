package flappy_bird

import rl "vendor:raylib"

// accepts any two opposing corners
create_rect :: proc(corner_a, corner_b: Vec2) -> rl.Rectangle {
	center := (corner_b + corner_a) / 2
	size := corner_b - corner_a

	// TODO: `rl.Rectangle`'s x/y are actually top-left corner, not center
	return {
		x      = center.x,
		y      = center.y,
		width  = abs(size.x),
		height = abs(size.y),
	}
}
