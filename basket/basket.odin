package basket

import rl "vendor:raylib"
import "../loadr"
import "core:fmt"

Basket :: struct {
  // base entity struct fields
  texture: rl.Texture2D,
  rect: rl.Rectangle,

  vel: rl.Vector2,
  move_spd: f32,
  
  apple_caught: i32
}

init :: proc(self: ^Basket, asset_manager: ^loadr.AssetManager, x: f32, y: f32) {
  self.apple_caught = 0
  self.move_spd = 200
  self.vel = rl.Vector2{ 0, 0 }

  self.texture = loadr.get_texture(asset_manager, "basket")
  self.rect = rl.Rectangle{ x, y, cast(f32)self.texture.width, cast(f32)self.texture.height }
}

update :: proc(self: ^Basket, dt: f32) {
}

draw :: proc(self: ^Basket) {
  rl.DrawTexturePro(self.texture, 
    rl.Rectangle{ 0.0, 0.0, cast(f32)self.texture.width, cast(f32)self.texture.height },
    self.rect,
    rl.Vector2{cast(f32)self.texture.width/2, cast(f32)self.texture.height/2}, 0.0, rl.WHITE)
}
