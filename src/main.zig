const Game = @import("game.zig").Game;

pub fn main() !void {
    var g = try Game.init(480, 720);
    defer g.deinit();

    try g.init_gameplay();

    try g.run();
}
