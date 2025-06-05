const std = @import("std");
const rl = @import("raylib");
const expect = std.testing.expect;

pub fn checkCollisions(rect1: rl.Rectangle, rect2: rl.Rectangle) bool {
    return rect1.x < rect2.x + rect2.width and
        rect1.x + rect1.width > rect2.x and
        rect1.y < rect2.y + rect2.height and
        rect1.y + rect1.height > rect2.y;
}

test "retangles overlap" {
    const r1 = rl.Rectangle{ .x = 0, .y = 0, .width = 10, .height = 10 };
    const r2 = rl.Rectangle{ .x = 5, .y = 5, .width = 10, .height = 10 };

    try expect(checkCollisions(r1, r2));
}

test "rectangles do not overlap" {
    const r1 = rl.Rectangle{ .x = 0, .y = 0, .width = 10, .height = 10 };
    const r2 = rl.Rectangle{ .x = 20, .y = 20, .width = 10, .height = 10 };

    try expect(!checkCollisions(r1, r2));
}

test "rectangles just touching edges - no overlap" {
    const r1 = rl.Rectangle{ .x = 0, .y = 0, .width = 10, .height = 10 };
    const r2 = rl.Rectangle{ .x = 10, .y = 0, .width = 10, .height = 10 };

    try expect(!checkCollisions(r1, r2));
}

test "one rectangle fully inside another" {
    const r1 = rl.Rectangle{ .x = 0, .y = 0, .width = 20, .height = 20 };
    const r2 = rl.Rectangle{ .x = 5, .y = 5, .width = 5, .height = 5 };

    try expect(checkCollisions(r1, r2));
}
