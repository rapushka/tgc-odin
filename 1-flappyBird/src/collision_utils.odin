package flappy_bird

import rl "vendor:raylib"

check_collision_circle_rect :: proc(circle: Circle, rect: Rect) -> bool {
	rl_rect := as_raylib_rect(rect)
	return rl.CheckCollisionCircleRec(circle.center, circle.radius, rl_rect)
}
