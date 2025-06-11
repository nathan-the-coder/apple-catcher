const rl = @import("raylib");

pub const Apple = struct {
    texture: ?rl.Texture2D,
    rect: rl.Rectangle,
    fall_spd: f32,
    color: rl.Color,

    pub fn init(x: f32, y: f32) Apple {
        return Apple{
            .fall_spd = 200.0,
            .texture = null,
            .color = rl.Color.white,
            .rect = .{ .x = x, .y = y, .width = 32, .height = 32 },
        };
    }

    pub fn update(self: *Apple, dt: f32) void {
        self.rect.y += self.fall_spd * dt;
    }

    pub fn draw(self: *Apple) void {
        if (self.texture) |tex| {
            rl.drawTexturePro(tex, .{ .x = 0.0, .y = 0.0, .width = @as(f32, @floatFromInt(tex.width)), .height = @as(f32, @floatFromInt(tex.height)) }, self.rect, .{ .x = @as(f32, @floatFromInt(tex.width)) / 2, .y = @as(f32, @floatFromInt(tex.height)) / 2 }, 0.0, self.color);
        }
    }

    pub fn deinit(self: *Apple) void {
        rl.unloadTexture(self.texture);
    }
};
