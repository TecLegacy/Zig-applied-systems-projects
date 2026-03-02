const std = @import("std");

pub fn main(init: std.process.Init) !void {
    std.debug.print("1 \n", .{});

    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    _ = args.skip(); // skip program name

    while (args.next()) |arg| {
        std.debug.print("Argument: {s}\n", .{arg});
    }

    std.debug.print("2 \n", .{});
}
