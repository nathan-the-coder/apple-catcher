package basket

import rl "vendor:raylib"

Basket :: struct {
  // base entity struct fields
  texture: rl.Texture2D,
  pos: rl.Vector2,

  vel: rl.Vector2,
  move_spd: f32,
  
  apple_caught: i32
}

init :: proc(self: ^Basket, x: f32, y: f32) {
  self.apple_caught = 0

}
