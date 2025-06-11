const Game = @import("game.zig").Game;

pub fn main() !void {
    var g = try Game.init();

    try g.init_gameplay();

    try g.run();
}
