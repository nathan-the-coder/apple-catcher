const Game = @import("game.zig").Game;

pub fn main() !void {
    var g = try Game.init(600, 720);

    try g.init_gameplay();

    try g.run();
}
