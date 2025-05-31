package game

import rl "vendor:raylib"

import "../loadr"

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

  timeGameStarted: f64,
  timeGameEnded: f64,
}

init :: proc(game: ^Game) {
  rl.SetConfigFlags({.VSYNC_HINT})
  rl.InitWindow(game.config.screenWidth, game.config.screenHeight, "Apple Catcher")
  rl.InitAudioDevice()

  game.asset_manager = new(loadr.AssetManager)
  loadr.init(game.asset_manager, "assets")

  init_gameplay(game)

  rl.SetTargetFPS(500)
}

init_gameplay :: proc(game: ^Game) {
  game.state = .PLAYING
  game.timeGameStarted = rl.GetTime()
}

update :: proc(game: ^Game, dt: f32) {
  if game.state == .END && rl.IsKeyPressed(.R) {
    init_gameplay(game)
  }
}

draw :: proc(game: ^Game) {
  rl.BeginDrawing()

  rl.ClearBackground(rl.SKYBLUE)

  if (game.state == .END) {
  } else {
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

  rl.CloseAudioDevice()
  rl.CloseWindow()
}
