package flappy_bird

import rl "vendor:raylib"

Rect :: struct {
	center: Vec2,
	sizes:  Vec2,
}

// accepts any two opposing corners
create_rect_from_corners :: proc(corner_a, corner_b: Vec2) -> Rect {
	center := (corner_b + corner_a) / 2
	sizes := abs_vec2(corner_b - corner_a)

	return {center, sizes}
}

abs_vec2 :: proc(value: Vec2) -> Vec2 {
	return {abs(value.x), abs(value.y)}
}
