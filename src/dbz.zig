const std = @import("std");

pub const dbz = struct {
    allocator: *std.mem.Allocator,

    pub fn init(allocator: *std.mem.Allocator) dbz {
        return dbz{
            .allocator = allocator,
        };
    }

    pub fn deinit(self: dbz) !void {
        self.* = undefined;
    }


    pub fn createTable(self: dbz) void {
        _ = self;
        std.debug.print("Creating table",);
    }
};