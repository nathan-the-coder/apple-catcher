package basket

import rl "vendor:raylib"
import "../loadr"

Basket :: struct {
  // base entity struct fields
  texture: rl.Texture2D,
  pos: rl.Vector2,

  vel: rl.Vector2,
  move_spd: f32,
  
  apple_caught: i32
}

init :: proc(self: ^Basket, asset_manager: ^loadr.AssetManager, x: f32, y: f32) {
  self.apple_caught = 0
  self.move_spd = 200
  self.pos = rl.Vector2{ x, y }
  self.vel = rl.Vector2{ 0, 0 }

  self.texture = loadr.get_texture(asset_manager, "basket")
  if self.texture.id <= 0 {
    panic("Empty texture, or failed to load texture")
  }
}

update :: proc(self: ^Basket, dt: f32) {
}

draw :: proc(self: ^Basket) {
  rl.DrawTextureEx(self.texture, self.pos, 0.0, 0.0, rl.WHITE)
}
