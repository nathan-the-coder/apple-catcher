const rl = @import("raylib");
const std = @import("std");

const allocator = std.heap.page_allocator;

const StringMap = std.StringHashMap(rl.Sound);

pub const SoundManager = struct {
    storage: StringMap,

    pub const Error = error{
        SoundNotFound,
        DuplicateSoundError,
    };

    pub fn init() SoundManager {
        const map = StringMap.init(allocator);

        return SoundManager{
            .storage = map,
        };
    }

    pub fn add(self: *@This(), name: [:0]const u8, path: []const u8) !void {
        if (self.storage.contains(name)) return Error.DuplicateSoundError;
        try self.storage.put(name, try rl.loadSound(try std.mem.Allocator.dupeZ(allocator, u8, path)));
    }

    pub fn play(self: *@This(), name: []const u8) !void {
        const sound = self.storage.get(name) orelse return Error.SoundNotFound;
        rl.playSound(sound);
    }

    pub fn stop(self: *@This(), name: []const u8) !void {
        const sound = self.storage.get(name) orelse return Error.SoundNotFound;
        rl.stopSound(sound);
    }

    pub fn deinit(self: *@This()) void {
        var it = self.storage.iterator();
        while (it.next()) |entry| {
            rl.unloadSound(entry.value_ptr.*);
        }
        self.storage.deinit();
    }
};
