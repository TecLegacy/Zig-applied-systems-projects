const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const val = parseArgs(init) catch |err| {
        std.debug.print("Error: While parsing args {} \n", .{err});
        return;
    };
    std.debug.print("Val: {} \n", .{val});
}

// Reading File from CLI and printing usage
// zparse --info log-file
fn parseArgs(init: std.process.Init) !bool {
    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    // skip program name
    _ = args.skip();

    // Command and log level flags
    var show_hello = false;
    var show_help = false;
    var show_info = false;
    var show_warn = false;
    var show_error = false;

    // accepting flags --info --warn --error (-i,-w,-e)
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--hello")) {
            show_hello = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            show_help = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--info") or std.mem.eql(u8, arg, "-i")) {
            show_info = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--warn") or std.mem.eql(u8, arg, "-w")) {
            show_warn = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--error") or std.mem.eql(u8, arg, "-e")) {
            show_error = true;
            continue;
        }

        if (std.mem.startsWith(u8, arg, "-")) {
            std.debug.print("Unknown flag: {s}\n", .{arg});
            flagUsage();
            return false;
        }
    }

    if (show_help) {
        flagUsage();
        return true;
    }

    std.debug.print(
        "Flags passed:\n  hello={} help={} info={} warn={} error={}\n",
        .{ show_hello, show_help, show_info, show_warn, show_error },
    );

    return show_hello or show_help or show_info or show_warn or show_error;
}

// Print flag usage
fn flagUsage() void {
    std.debug.print(
        \\Usage: zstats [options] <file>
        \\Options:
        \\  -w, --words   Count words
        \\  -l, --lines   Count lines
        \\  -c, --bytes   Count bytes
        \\  -h, --help    Show help
        \\Examples:
        \\  zstats dummy.txt
        \\  zstats -w dummy.txt
        \\  zstats --lines --bytes dummy.txt
        \\
    , .{});
}
