const std = @import("std");

pub fn main(init: std.process.Init) !void {
    parseArgs(init) catch |err| {
        std.debug.print("Error: While parsing args {} \n", .{err});
        return;
    };
}

// Reading File from CLI and printing usage
// zparse --info log-file
fn parseArgs(init: std.process.Init) !void {
    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    // skip program name
    _ = args.skip();

    // const show_hello = false;
    var show_hello = false;

    // accepting flags --info --warn --error (-i,-w,-e)
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--hello") or std.mem.eql(u8, arg, "-h")) {
            show_hello = true;
        }
        if (std.mem.eql(u8, arg, "--info") or std.mem.eql(u8, arg, "-i")) {
            show_hello = true;
        }
        if (std.mem.eql(u8, arg, "--warn") or std.mem.eql(u8, arg, "-w")) {
            show_hello = true;
        }
        if (std.mem.eql(u8, arg, "--error") or std.mem.eql(u8, arg, "-e")) {
            show_hello = true;
        }
    }

    std.debug.print(" HELLO is {}", .{show_hello});
}
