const std = @import("std");
const rl = @import("raylib");

const ArrayList = std.ArrayList;

const Apple = @import("apple.zig").Apple;

const MAX_APPLES = 30;

pub const AppleSpawner = struct {
    apples: ArrayList(Apple),
    spawn_timer: f32,
    spawn_duration: f32,

    pub fn init() !AppleSpawner {
        const allocator = std.heap.page_allocator;
        const list = try ArrayList(Apple).initCapacity(allocator, 30);

        return AppleSpawner{ .spawn_duration = 1.0, .spawn_timer = 1.0, .apples = list };
    }

    pub fn update(self: *AppleSpawner, dt: f32) !void {
        self.spawn_timer -= dt;

        if (self.spawn_timer <= 0) {
            self.spawn_timer = self.spawn_duration;

            // Only spawn if it haven't hit the limit
            if (self.apples.items.len < MAX_APPLES) {
                const apple = try Apple.init(@as(f32, @as(f32, @floatFromInt(rl.getRandomValue(0, rl.getScreenWidth())))), 0.0);
                try self.apples.append(apple);
            }
        }

        var i = self.apples.items.len;
        while (i > 0) {
            i -= 1;
            self.apples.items[i].update(dt);

            if (self.apples.items[i].rect.y >= @as(f32, @floatFromInt(rl.getScreenHeight()))) {
                _ = self.apples.swapRemove(i);
            }
        }
    }

    pub fn draw(self: *AppleSpawner) void {
        for (0..self.apples.items.len) |i| {
            self.apples.items[i].draw();
        }
    }

    pub fn deinit(self: *AppleSpawner) void {
        for (0..self.apples.items.len) |i| {
            self.apples.items[i].deinit();
        }

        self.apples.deinit();
    }
};
