package spawner

import rl "vendor:raylib"
import "core:fmt"

import "../loadr"
import "../apple"

MAX_APPLES :: 30

AppleSpawner :: struct {
  apples : [dynamic]^apple.Apple,
  spawn_timer : f32,
  spawn_duration : f32,
}

init_spawner :: proc(self: ^AppleSpawner, asset_manager: ^loadr.AssetManager) {
  self.apples = make([dynamic]^apple.Apple, 0, MAX_APPLES, context.allocator)

  self.spawn_duration = 1.0
  self.spawn_timer = 1.0
}


update_objects :: proc(self: ^AppleSpawner, asset_manager: ^loadr.AssetManager, dt: f32) {

  self.spawn_timer -= dt

  if self.spawn_timer <= 0 {
    self.spawn_timer = self.spawn_duration

    // Only spawn if it haven't hit the limit
    if len(self.apples) < MAX_APPLES {
      _apple := apple.new_apple(asset_manager, cast(f32)rl.GetRandomValue(0, rl.GetScreenWidth()), 0.0)

      append(&self.apples, _apple)
    }
  }

  for i := len(self.apples) - 1; i >= 0; i -= 1 {
    apple.update(self.apples[i], dt)

    if self.apples[i].rect.y >= cast(f32)rl.GetScreenHeight() {
      ordered_remove(&self.apples, i)
    }
  }  
}

draw_objects :: proc(self: ^AppleSpawner) {
  for i in 0..<len(self.apples) {
    apple.draw(self.apples[i])
  }
}
