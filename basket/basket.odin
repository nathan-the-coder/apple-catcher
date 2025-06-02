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
  self.move_spd = 220
  self.vel = rl.Vector2{ 0, 0 }

  self.texture = loadr.get_texture(asset_manager, "basket")
  self.rect = rl.Rectangle{ x, y, cast(f32)self.texture.width, cast(f32)self.texture.height }
}

update :: proc(self: ^Basket, dt: f32) {
  // To avoid the sliding effect on the basket, Its velocity needs to be zeroed out first.
  self.vel = rl.Vector2{ 0, 0 }

  // Update basket position with keypress
  // Update basket's velocity by its speed in left and right direction with keydown
  // Supports common WASD key and the less common Arrow Keys.
  if rl.IsKeyDown(.A) || rl.IsKeyDown(.LEFT) {
    // move the basket left by negating its speed and setting it to velocity x
    self.vel.x = -self.move_spd
  } else if rl.IsKeyDown(.D) || rl.IsKeyDown(.RIGHT) {
    // move the basket right by using its speed and setting it to velocity x
    self.vel.x = self.move_spd
  }

  // Update the basket's position by velocity multiplied by dt
  self.rect.x += self.vel.x * dt

  // Clamp the basket's position to prevent it from going offscreen.
  if self.rect.x < self.rect.width/2 { self.rect.x = self.rect.width/2}
  else if self.rect.x > cast(f32)rl.GetScreenWidth() - self.rect.width/2 { self.rect.x = cast(f32)rl.GetScreenWidth() - self.rect.width/2}

  fmt.println("Apples caught count: ", self.apple_caught)
}

check_collision :: proc(self: ^Basket, other_rect: rl.Rectangle) -> bool {
  if self.rect.x < other_rect.x + other_rect.width &&
     self.rect.x + self.rect.width > other_rect.x &&
     self.rect.y < other_rect.y + other_rect.height &&
     self.rect.y + self.rect.height > other_rect.y {
       return true
   } else {
     return false
   }
}

draw :: proc(self: ^Basket) {
  rl.DrawTexturePro(self.texture, 
    rl.Rectangle{ 0.0, 0.0, cast(f32)self.texture.width, cast(f32)self.texture.height },
    self.rect,
    rl.Vector2{cast(f32)self.texture.width/2, cast(f32)self.texture.height/2}, 0.0, rl.WHITE)
}
