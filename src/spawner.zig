const std = @import("std");
const rl = @import("raylib");

const ArrayList = std.ArrayList;
const Apple = @import("apple.zig").Apple;
const config = @import("config.zig");
const colors = @import("colors.zig");

const MAX_APPLES = 30;

pub const AppleType = enum {
    Normal,
    Bad,
    Golden,
};

pub const AppleSpawner = struct {
    apples: ArrayList(Apple),
    spawn_timer: f32,
    spawn_duration: f32,
    texture: ?rl.Texture2D,
    allocator: std.mem.Allocator,

    pub fn init(allocator: std.mem.Allocator) !AppleSpawner {
        const apples = try ArrayList(Apple).initCapacity(allocator, 30);

        const tex = try rl.loadTexture("assets/images/apple.png");

        return AppleSpawner{ .spawn_duration = 1.0, .spawn_timer = 1.0, .texture = tex, .apples = apples, .allocator = allocator };
    }

    pub fn incrementFallSpeed(self: *@This(), inc_factor: f32) void {
        for (self.apples.items) |*apple| {
            apple.fall_spd += inc_factor;
        }
    }

    fn spawnRandomAppleType(self: *@This()) AppleType {
        _ = self;
        const roll = rl.getRandomValue(1, 100);

        if (roll <= 5) {
            return .Golden;
        } else if (roll <= 20) {
            return .Bad;
        } else {
            return .Normal;
        }
    }

    pub fn update(self: *@This(), dt: f32) !void {
        self.spawn_timer -= dt;

        if (self.spawn_timer <= 0) {
            self.spawn_timer = self.spawn_duration;

            // Only spawn if it haven't hit the limit
            if (self.apples.items.len < MAX_APPLES) {
                var apple = Apple.init(@as(f32, @as(f32, @floatFromInt(rl.getRandomValue(0, config.screen_width)))), 0.0);
                apple.texture = self.texture;

                const apple_type = self.spawnRandomAppleType();

                apple.color = if (apple_type == .Golden) colors.toRlColor(.Gold) else if (apple_type == .Bad)
                    colors.toRlColor(.Gray)
                else
                    colors.toRlColor(.White);

                try self.apples.append(apple);
            }
        }

        for (self.apples.items) |*apple| {
            apple.update(dt);
        }
    }

    pub fn draw(self: *@This()) void {
        for (self.apples.items) |*apple| {
            apple.draw();
        }
    }

    pub fn deinit(self: *@This()) void {
        for (self.apples.items) |*apple| {
            apple.deinit();
        }

        self.apples.deinit();
    }
};
