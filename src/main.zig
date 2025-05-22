
const std = @import("std");
const dbz = @import("dbz.zig");

const User = struct {
    name: []const u8,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const client = try dbz.Client.init(allocator);
    defer client.deinit();

    const users = try client.createTypedTable(User, .{ .name = "users" });
    try users.put("user1", User{ .name = "Alice" });

    if (users.get("user1")) |user| {
        std.debug.print("User name: {s}\n", .{user.name});
    } else {
        std.debug.print("User not found\n", .{});
    }
}