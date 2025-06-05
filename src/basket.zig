const rl = @import("raylib");
const std = @import("std");

pub const Basket = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,

    move_spd: f32,
    score: i32,

    pub fn init(x: f32, y: f32) !Basket {
        const tex = try rl.loadTexture("assets/images/basket.png");
        return Basket{
            .move_spd = 200.0,
            .score = 0,
            .texture = tex,
            .rect = .{ .x = x, .y = y, .width = @as(f32, @floatFromInt(tex.width)), .height = @as(f32, @floatFromInt(tex.height)) },
        };
    }

    pub fn update(self: *Basket, dt: f32) void {
        if (rl.isKeyDown(.a) or rl.isKeyDown(.left)) {
            self.rect.x -= self.move_spd * dt;
        } else if (rl.isKeyDown(.d) or rl.isKeyDown(.right)) {
            self.rect.x += self.move_spd * dt;
        }

        // Clamp the basket's position to prevent it from going offscreen.
        if (self.rect.x < self.rect.width / 2) {
            self.rect.x = self.rect.width / 2;
        } else if (self.rect.x > @as(f32, @floatFromInt(rl.getScreenWidth())) - self.rect.width / 2) {
            self.rect.x = @as(f32, @floatFromInt(rl.getScreenWidth())) - self.rect.width / 2;
        }
    }

    pub fn draw(self: *Basket) !void {
        rl.drawTexturePro(self.texture, .{ .x = 0.0, .y = 0.0, .width = @as(f32, @floatFromInt(self.texture.width)), .height = @as(f32, @floatFromInt(self.texture.height)) }, self.rect, .{ .x = @as(f32, @floatFromInt(self.texture.width)) / 2, .y = @as(f32, @floatFromInt(self.texture.height)) / 2 }, 0.0, rl.Color.white);

        var buf: [500]u8 = undefined;
        const scoreStr = try std.fmt.bufPrintZ(&buf, "{}", .{self.score});
        rl.drawText(scoreStr, @divExact(rl.getScreenWidth(), 2), 20, 50, rl.Color.white);
    }

    pub fn deinit(self: *Basket) void {
        rl.unloadTexture(self.texture);
    }
};
