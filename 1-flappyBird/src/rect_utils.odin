package flappy_bird

import rl "vendor:raylib"

Rect :: struct {
	center: Vec2,
	sizes:  Vec2,
}

// accepts any two opposing corners
rect_from_corners :: proc(corner_a, corner_b: Vec2) -> Rect {
	center := (corner_b + corner_a) / 2
	sizes := abs_vec2(corner_b - corner_a)

	return {center, sizes}
}

as_raylib_rect :: proc(rect: Rect) -> rl.Rectangle {
	top_left := rect.center - (rect.sizes / 2)

	return rl.Rectangle {
		x      = top_left.x,
		y      = top_left.y,
		width  = rect.sizes.x,
		height = rect.sizes.y,
	}
}

@(private = "file")
abs_vec2 :: proc(value: Vec2) -> Vec2 {
	return {abs(value.x), abs(value.y)}
}
