package flappy_bird

import la "core:math/linalg"
import "vendor:directx/d3d12"
import rl "vendor:raylib"

draw_texture :: proc {
	draw_texture_usual,
	draw_texture_flipped,
}

@(private = "file")
draw_texture_usual :: proc(texture: rl.Texture2D, position: Vec2) {
	draw_texture_flipped(texture, position, false)
}

@(private = "file")
draw_texture_flipped :: proc(texture: rl.Texture2D, position: Vec2, flip_v: bool) {
	render_position: Vec2 = {
		position.x - f32(texture.width) / 2,
		position.y - f32(texture.height) / 2,
	}

	if !flip_v {
		rl.DrawTextureV(texture, render_position, rl.WHITE)
		return
	}

	source := as_rect(texture)
	source.height *= -1

	dest := as_rect(texture)
	dest.x = render_position.x
	dest.y = render_position.y

	rl.DrawTexturePro(texture, source, dest, {}, 0, rl.WHITE)
}

@(private = "file")
as_rect :: proc(texture: rl.Texture2D) -> rl.Rectangle {
	return rl.Rectangle {
		width  = f32(texture.width),
		height = f32(texture.height),
		x      = 0,
		y      = 0,
	}
}

draw_collider_circle :: proc(position: Vec2, radius: f32) {
	rl.DrawCircleLinesV(position, radius, rl.GREEN)
}

draw_collider_rect :: proc(position: Vec2, sizes: Vec2) {
	x := i32(position.x) - i32(sizes.x) / 2
	y := i32(position.y) - i32(sizes.y) / 2

	rl.DrawRectangleLines(x, y, i32(sizes.x), i32(sizes.y), rl.GREEN)
}
