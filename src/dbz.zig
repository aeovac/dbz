const std = @import("std");
const t = @import("table.zig");
const Table = t.Table;
const TableOptions = t.Options;

pub const Client = struct {
    allocator: std.mem.Allocator,
    tables: std.StringArrayHashMap(*Table(anyopaque)),
    mutex: std.Thread.Mutex,

    const Self = @This();

    pub fn init(allocator: std.mem.Allocator) !*Self {
        const self = try allocator.create(Client);
        self.* = Client{
            .allocator = allocator,
            .tables = std.StringArrayHashMap(*Table(anyopaque)).init(allocator),
            .mutex = .{},
        };
        return self;
    }

    pub fn deinit(self: *Self) void {
        self.mutex.lock();

        defer {
						self.mutex.unlock();
						self.allocator.destroy(self);
				}

        var iter = self.tables.iterator();
        while (iter.next()) |entry| {
            const table = entry.value_ptr.*;
            table.deinit();
            self.allocator.destroy(table);
        }

        self.tables.deinit();
    }

    pub fn createTypedTable(self: *Self, comptime T: type, options: TableOptions) !*Table(T) {
        self.mutex.lock();
        defer self.mutex.unlock();

        const table = try self.allocator.create(Table(T));
        table.* = Table(T).init(self.allocator, options);
        try self.tables.put(options.name, @ptrCast(table));
        return table;
    }

    pub fn createTable(self: Self, options: TableOptions) Table[anyopaque] {
        return createTypedTable(anyopaque, options);
    }
};