const std = @import("std");
const rl = @import("raylib");

const Basket = @import("./basket.zig").Basket;
const AppleSpawner = @import("./spawner.zig").AppleSpawner;

const GameState = enum {
    PLAYING,

    MAIN_MENU,
    PAUSE_MENU,

    END,
};

pub const Game = struct {
    state: GameState,
    timeGameStarted: f64,
    timeGameEnded: f64,

    // sprites
    basket: Basket,
    spawner: AppleSpawner,

    // methods
    pub fn init(screenWidth: i32, screenHeight: i32) !Game {
        rl.setConfigFlags(.{ .vsync_hint = true });

        rl.initWindow(screenWidth, screenHeight, "Apple Catcher - Zig");
        rl.initAudioDevice();
        rl.setTargetFPS(500);

        const b = try Basket.init(@as(f32, @floatFromInt(screenWidth)) / 2.0, @as(f32, @floatFromInt(screenHeight - 50)));
        const spwner = try AppleSpawner.init();

        return Game{
            .state = .PLAYING,
            .timeGameStarted = rl.getTime(),
            .timeGameEnded = 0.0,
            .basket = b,
            .spawner = spwner,
        };
    }

    pub fn init_gameplay(self: *Game) void {
        self.state = .PLAYING;
        self.timeGameStarted = rl.getTime();
    }

    fn update(self: *Game, dt: f32) !void {
        if (self.state == .END and rl.isKeyPressed(.r)) {
            self.init_gameplay();
            std.debug.print("dt: {d:.3}\n", .{dt});
        }

        self.basket.update(dt);
        try self.spawner.update(dt);
    }

    fn draw(self: *Game) void {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        if (self.state == .END) {} else {
            self.basket.draw();
            self.spawner.draw();
        }
    }

    pub fn run(self: *Game) !void {
        while (!rl.windowShouldClose()) {
            const dt = rl.getFrameTime();
            try self.update(dt);
            self.draw();
        }
    }

    pub fn deinit(self: *Game) void {
        self.state = .END;
        self.timeGameEnded = rl.getTime();

        self.basket.deinit();
        self.spawner.deinit();

        rl.closeAudioDevice();
        rl.closeWindow();
    }
};
