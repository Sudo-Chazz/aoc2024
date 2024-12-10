const std = @import("std");

pub fn main() !void {
    const f_handle = std.fs.cwd().openFile("../example.txt", .{ .mode = .read_only }) catch |err| {
        std.debug.print("{!}", .{err});
        std.process.exit(1);
    };
    defer f_handle.close();

    var lineBuf: [1024]u8 = undefined;
    var reader = f_handle.reader();
    // need to explore if this is the zig way of reading a file line by line
    while (reader.readUntilDelimiterOrEof(&lineBuf, '\n') catch unreachable) |line| {
        std.debug.print("{s}\n", .{line});
    }
    partOne();
}

fn partOne() void {
    // TODO
}
