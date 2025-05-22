// table.zig

const std = @import("std");

pub const Options = struct {
    name: []const u8
};

pub fn Table(comptime T: type) type {
    return struct {
        options: Options,
        allocator: std.mem.Allocator,
        data: std.AutoArrayHashMapUnmanaged([]const u8, *T),

        const Self = @This();

        pub fn init(allocator: std.mem.Allocator, options: Options) Self {
            return Self{
                .options = options,
                .allocator = allocator,
                .data = std.AutoArrayHashMapUnmanaged([]const u8, *T){},
            };
        }

        pub fn deinit(self: *Self) void {
            if (@typeInfo(T) != .Opaque) {
                var iter = self.data.iterator();
                while (iter.next()) |entry| {
                    self.allocator.destroy(entry.value_ptr.*);
                }
            }

            self.data.deinit(self.allocator);
        }

        pub fn get(self: *Self, key: []const u8) ?*T {
            return self.data.get(key);
        }

        pub fn put(self: *Self, key: []const u8, value: T) !void {
            const v: *T = try self.allocator.create(T);
            v.* = value;
            try self.data.put(self.allocator, key, v);
        }
    };
}