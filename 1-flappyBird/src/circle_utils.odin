package flappy_bird

import rl "vendor:raylib"

Circle :: struct {
	center: Vec2,
	radius: f32,
}

circle_from_center :: proc(center: Vec2, radius: f32) -> Circle {
	return Circle{center, radius}
}
