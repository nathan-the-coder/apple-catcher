const rl = @import("raylib");

pub const AppleColor = enum {
    White,
    Gold,
    Gray,
};

pub fn toRlColor(color: AppleColor) rl.Color {
    return switch (color) {
        .White => rl.Color.white,
        .Gold => rl.Color.gold,
        .Gray => rl.Color.gray,
    };
}
