const std = @import("std");

pub fn main() !void {
    const f_handle = std.fs.cwd().openFile("../input.txt", .{ .mode = .read_only }) catch |err| {
        std.debug.print("{!}", .{err});
        std.process.exit(1);
    };
    defer f_handle.close();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const alloc = gpa.allocator();

    var reader = f_handle.reader();
    const distance = try partOne(alloc, &reader);
    std.debug.print("{d}\n", .{distance});
}

fn partOne(allocator: std.mem.Allocator, reader: anytype) !u32 {
    var left_arr = std.ArrayList([]const u8).init(allocator);
    var right_arr = std.ArrayList([]const u8).init(allocator);
    defer {
        left_arr.deinit();
        right_arr.deinit();
    }

    var lineBuf: [1024]u8 = undefined;
    while (reader.readUntilDelimiterOrEof(&lineBuf, '\n') catch unreachable) |line| {
        var nums = std.mem.splitSequence(u8, line, "   ");

        const left = try allocator.dupe(u8, nums.next().?);
        const right = try allocator.dupe(u8, nums.next().?);

        try left_arr.append(left);
        try right_arr.append(right);
    }

    // sort arrays
    std.mem.sort([]const u8, left_arr.items, {}, lessThan);
    std.mem.sort([]const u8, right_arr.items, {}, lessThan);

    // calc distance and sum
    var dist: u32 = 0;
    for (left_arr.items, right_arr.items) |l, r| {
        dist += @abs(try std.fmt.parseInt(i32, l, 10) - try std.fmt.parseInt(i32, r, 10));
    }

    // free and empty array
    for (left_arr.items, right_arr.items) |l, r| {
        allocator.free(l);
        allocator.free(r);
    }
    return dist;
}

fn lessThan(_: void, a: []const u8, b: []const u8) bool {
    return std.mem.lessThan(u8, a, b);
}
