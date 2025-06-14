const std = @import("std");
const rl = @import("raylib");

const State = @import("state.zig");
const GameState = State.GameState;

const Basket = @import("./basket.zig").Basket;
const AppleSpawner = @import("./spawner.zig").AppleSpawner;
const SoundManager = @import("sound_manager.zig").SoundManager;

const config = @import("config.zig");

const utils = @import("utils.zig");

pub const Game = struct {
    state: GameState,
    time_game_started: f64,
    time_game_ended: f64,

    // Player variables
    player_score: i32,
    last_milestone_player_score: i32,
    missed_apples: i32,
    level: i32,

    // sprites
    basket: Basket,
    spawner: AppleSpawner,

    // Structs instances
    sound_manager: SoundManager,

    bg_image: rl.Texture2D,

    // methods
    pub fn init() !Game {
        rl.setConfigFlags(.{ .vsync_hint = true });

        rl.initWindow(config.screen_width, config.screen_height, "Apple Catcher - Zig");
        rl.initAudioDevice();
        rl.setTargetFPS(500);

        const b = try Basket.init(@as(f32, @floatFromInt(config.screen_width)) / 2.0, @as(f32, @floatFromInt(config.screen_height - 50)));
        const spwner = try AppleSpawner.init(std.heap.page_allocator);

        const sm = SoundManager.init();
        const bg_image = try rl.loadTexture("assets/images/bg.png");

        return Game{ .state = .MAIN_MENU, .level = 1, .time_game_started = rl.getTime(), .time_game_ended = 0.0, .player_score = 0, .last_milestone_player_score = 0, .missed_apples = 0, .basket = b, .spawner = spwner, .sound_manager = sm, .bg_image = bg_image };
    }

    pub fn init_gameplay(self: *@This()) !void {
        self.time_game_started = rl.getTime();

        // Add sounds to the manager.
        // the sound for when the apple caught by the basket.
        try self.sound_manager.add("catch", "assets/sounds/coin.mp3");
        // add the bg music for the game
        try self.sound_manager.add("bgMusic", "assets/sounds/bgMusic.mp3");

        // add the sfx for missed apples
        try self.sound_manager.add("missed", "assets/sounds/missed.wav");

        // Play the bg music at the start of the game
        try self.sound_manager.play("bgMusic");
    }

    fn update(self: *@This(), dt: f32) !void {
        switch (self.state) {
            .MAIN_MENU => {
                if (rl.isKeyPressed(.enter)) {
                    self.state = State.nextState(self.state, .Start);
                    try self.init_gameplay();
                }
            },
            .PLAYING => {
                if (rl.isKeyPressed(.escape)) {
                    self.state = State.nextState(self.state, .Pause);
                    try self.init_gameplay();
                } else {
                    self.basket.update(dt);
                    try self.spawner.update(dt);

                    try self.handleCollisions();

                    // Check if the
                    if (self.player_score >= self.last_milestone_player_score + 10) {
                        self.last_milestone_player_score += 10;

                        self.spawner.incrementFallSpeed(10);
                    }

                    // Logic for removing off-screen apples and adding the value of missed_apples for lose state.
                    for (self.spawner.apples.items, 0..) |*apple, i| {
                        if (apple.rect.y >= @as(f32, @floatFromInt(config.screen_height))) {
                            _ = self.spawner.apples.swapRemove(i);
                            self.missed_apples += 1;
                            try self.sound_manager.play("missed");
                        }
                    }

                    // Check how many apples the player missed, if greater than 5, then game over.
                    if (self.missed_apples > 5) {
                        self.state = .END;
                    }
                }
            },
            .PAUSE_MENU => {
                if (rl.isKeyPressed(.escape)) {
                    self.state = State.nextState(self.state, .Resume);
                    try self.sound_manager.play("bgMusic");
                } else if (rl.isKeyPressed(.q)) {
                    self.state = State.nextState(self.state, .Quit);
                }
            },
            .END => {
                try self.sound_manager.stop_all();
                if (rl.isKeyPressed(.q)) {
                    self.state = State.nextState(self.state, .Start);
                    try self.init_gameplay();
                } else if (rl.isKeyPressed(.q)) {
                    self.state = State.nextState(self.state, .Quit);
                }
            },
        }
    }

    fn handleCollisions(self: *@This()) !void {
        var i = self.spawner.apples.items.len;
        while (i > 0) {
            i -= 1;
            if (utils.checkCollisions(self.basket.rect, self.spawner.apples.items[i].rect)) {
                _ = self.spawner.apples.swapRemove(i);

                if (self.spawner.apples.items[i].type == .Bad) {
                    self.state = .END;
                } else if (self.spawner.apples.items[i].type == .Golden) {
                    self.player_score += 10;
                } else {
                    self.player_score += 1;
                }
                try self.sound_manager.play("catch");
            }
        }

        if (self.level == 1 and self.player_score >= 20) {
            self.level += 1;
            self.player_score = 0;
        }
    }

    fn draw(self: *@This()) !void {
        rl.beginDrawing();
        defer rl.endDrawing();

        rl.clearBackground(rl.Color.sky_blue);

        switch (self.state) {
            .MAIN_MENU => {
                rl.drawText("APPLE CATCHER", 100, 100, 50, rl.Color.dark_green);
                rl.drawText("Press ENTER to Start", 100, 200, 30, rl.Color.black);
            },
            .PLAYING => {
                rl.drawTexturePro(self.bg_image, .{ .x = 0, .y = 0, .width = @as(f32, @floatFromInt(self.bg_image.width)), .height = @as(f32, @floatFromInt(self.bg_image.height)) }, .{ .x = 0, .y = 0, .width = @as(f32, @floatFromInt(rl.getScreenWidth())), .height = @as(f32, @floatFromInt(rl.getScreenHeight())) }, .{ .x = 0, .y = 0 }, 0.0, rl.Color.white);

                try self.basket.draw();

                var buf: [500]u8 = undefined;
                const scoreStr = try std.fmt.bufPrintZ(&buf, "{}", .{self.player_score});
                rl.drawText(scoreStr, @divExact(rl.getScreenWidth(), 2), 20, 50, rl.Color.white);

                self.spawner.draw();
            },
            .PAUSE_MENU => {
                rl.drawText("PAUSED", 100, 100, 50, rl.Color.gray);
                rl.drawText("Press ESC to Resume", 100, 200, 30, rl.Color.black);
                rl.drawText("Press Q to Quit to  Menu", 100, 250, 30, rl.Color.black);
            },
            .END => {
                rl.drawText("GAME OVER", 100, 100, 50, rl.Color.red);
                rl.drawText("Press R to Restart", 100, 200, 30, rl.Color.black);
                rl.drawText("Press Q for Main Menu", 100, 250, 30, rl.Color.black);
            },
        }
    }

    pub fn run(self: *@This()) !void {
        while (!rl.windowShouldClose()) {
            const dt = rl.getFrameTime();
            try self.update(dt);
            try self.draw();
        }
    }

    pub fn deinit(self: *@This()) !void {
        self.state = .END;
        self.time_game_ended = rl.getTime();

        _ = try self.sound_manager.stop("bgMusic");

        self.basket.deinit();
        self.spawner.deinit();

        self.sound_manager.deinit();

        rl.closeAudioDevice();
        rl.closeWindow();
    }
};
