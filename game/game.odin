package game

import rl "vendor:raylib"
import "core:fmt"

import "../loadr"
import "../basket"
import "../spawner"

GameState :: enum {
  PLAYING,

  PAUSE_MENU,
  MAIN_MENU,

  END
}

GameConfig :: struct {
  screenWidth: i32,
  screenHeight: i32,
}

Game :: struct {
  state: GameState,
  config: GameConfig,
  asset_manager: ^loadr.AssetManager,

  // Sprites
  basket: ^basket.Basket,

  // Spawners
  apple_spawner : ^spawner.AppleSpawner,

  // Others
  timeGameStarted: f64,
  timeGameEnded: f64,
}

init :: proc(game: ^Game) {
  rl.SetConfigFlags({.VSYNC_HINT})
  rl.InitWindow(game.config.screenWidth, game.config.screenHeight, "Apple Catcher")
  rl.InitAudioDevice()

  init_gameplay(game)

  rl.SetTargetFPS(500)
}

init_gameplay :: proc(game: ^Game) {
  game.state = .PLAYING
  game.timeGameStarted = rl.GetTime()

  game.asset_manager = new(loadr.AssetManager)
  loadr.init(game.asset_manager, "assets")

  game.basket = new(basket.Basket)
  basket.init(game.basket, game.asset_manager, cast(f32)game.config.screenWidth/2, cast(f32)game.config.screenHeight-50)

  game.apple_spawner = new(spawner.AppleSpawner)
  spawner.init_spawner(game.apple_spawner, game.asset_manager)
}

update :: proc(game: ^Game, dt: f32) {
  if game.state == .END && rl.IsKeyPressed(.R) {
    init_gameplay(game)
  }

  basket.update(game.basket, dt)
  spawner.update_objects(game.apple_spawner, game.asset_manager, dt)
}

draw :: proc(game: ^Game) {
  rl.BeginDrawing()

  rl.ClearBackground(rl.SKYBLUE)

  if (game.state == .END) {
  } else {
    spawner.draw_objects(game.apple_spawner)
    basket.draw(game.basket)  
  }

  rl.EndDrawing()
}

run :: proc(game: ^Game) {
  for !rl.WindowShouldClose() {
    dt := rl.GetFrameTime()
    update(game, dt)
    draw(game)
  }
}

close :: proc(game: ^Game) {
  game.state = .END
  game.timeGameEnded = rl.GetTime()

  loadr.unload(game.asset_manager)

  rl.CloseAudioDevice()
  rl.CloseWindow()
}
