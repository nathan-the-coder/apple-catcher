package apple

import rl "vendor:raylib"
import "../loadr"
import "core:fmt"

Apple :: struct {
  // base entity struct fields
  texture: rl.Texture2D,
  rect: rl.Rectangle,

  vel: rl.Vector2,
  fall_spd: f32,
}

init :: proc(self: ^Apple, asset_manager: ^loadr.AssetManager, x: f32, y: f32) {
  self.fall_spd = 100.0 + cast(f32)rl.GetRandomValue(-30, 50)  // 50-200 pixels per second
  self.vel = rl.Vector2{ 0, 0 }

  self.texture = loadr.get_texture(asset_manager, "apple")
  self.rect = rl.Rectangle{ x, y, cast(f32)self.texture.width, cast(f32)self.texture.height }
  
}

new_apple :: proc(asset_manager: ^loadr.AssetManager, x: f32, y: f32) -> ^Apple {
  apple := new(Apple)
  init(apple, asset_manager, x, y)
  
  return apple
}

update :: proc(self: ^Apple, dt: f32) {
  self.vel.y = self.fall_spd
  self.rect.y += self.vel.y * dt
}

draw :: proc(self: ^Apple) {
  rl.DrawTexturePro(self.texture, 
    rl.Rectangle{ 0.0, 0.0, cast(f32)self.texture.width, cast(f32)self.texture.height },
    self.rect,
    rl.Vector2{cast(f32)self.texture.width/2, cast(f32)self.texture.height/2}, 0.0, rl.WHITE)
}
