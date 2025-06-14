pub const GameState = enum {
    MAIN_MENU,
    PLAYING,
    PAUSE_MENU,
    END,
};

pub fn nextState(current: GameState, input: enum { Start, Pause, Resume, GameOver, Quit }) GameState {
    return switch (current) {
        .MAIN_MENU => switch (input) {
            .Start => .PLAYING,
            else => .MAIN_MENU,
        },
        .PLAYING => switch (input) {
            .Pause => .PAUSE_MENU,
            .GameOver => .END,
            else => .PLAYING,
        },
        .PAUSE_MENU => switch (input) {
            .Resume => .PLAYING,
            .Quit => .MAIN_MENU,
            else => .PAUSE_MENU,
        },
        .END => switch (input) {
            .Quit => .MAIN_MENU,
            .Start => .PLAYING,
            else => .END,
        },
    };
}
