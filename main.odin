package main

import "game"

main :: proc() {
  game_inst := new(game.Game)
  game_inst.config = game.GameConfig{
    400, 600
  }
  game.init(game_inst)
  defer game.close(game_inst)

  game.run(game_inst)
}
