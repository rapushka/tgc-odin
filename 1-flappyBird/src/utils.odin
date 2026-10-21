package flappy_bird

import la "core:math/linalg"
import "vendor:directx/d3d12"
import rl "vendor:raylib"

draw_texture :: proc(texture: rl.Texture2D, position: Vec2, flip_v: bool) {
	if !flip_v {
		rl.DrawTextureV(texture, position, rl.WHITE)
		return
	}

	source := get_source_rect(texture)
	source.height *= -1

	dest := get_source_rect(texture)
	dest.x = position.x
	dest.y = position.y

	rl.DrawTexturePro(texture, source, dest, {}, 0, rl.WHITE)
}

get_source_rect :: proc(texture: rl.Texture2D) -> rl.Rectangle {
	return rl.Rectangle {
		width  = f32(texture.width),
		height = f32(texture.height),
		x      = 0,
		y      = 0,
	}
}
