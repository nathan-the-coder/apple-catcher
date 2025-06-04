const rl = @import("raylib");

pub const Apple = struct {
    texture: rl.Texture2D,
    rect: rl.Rectangle,

    fallSpeed: f32,

    pub fn init(x: f32, y: f32) !Apple {
        const tex = try rl.loadTexture("assets/images/apple.png");
        return Apple{
            .fallSpeed = 200.0,
            .texture = tex,
            .rect = .{ .x = x, .y = y, .width = @as(f32, @floatFromInt(tex.width)), .height = @as(f32, @floatFromInt(tex.height)) },
        };
    }

    pub fn update(self: *Apple, dt: f32) void {
        self.rect.y += self.fallSpeed * dt;
    }

    pub fn draw(self: *Apple) void {
        rl.drawTexturePro(self.texture, .{ .x = 0.0, .y = 0.0, .width = @as(f32, @floatFromInt(self.texture.width)), .height = @as(f32, @floatFromInt(self.texture.height)) }, self.rect, .{ .x = @as(f32, @floatFromInt(self.texture.width)) / 2, .y = @as(f32, @floatFromInt(self.texture.height)) / 2 }, 0.0, rl.Color.white);
    }

    pub fn deinit(self: *Apple) void {
        rl.unloadTexture(self.texture);
    }
};
