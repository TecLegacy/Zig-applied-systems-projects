const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const flag = parseArgs(init) catch |err| {
        switch (err) {
            error.NoFlagsPassed, error.UnknownFlag => return,
        }
        return;
    };

    if (flag.show_help) {
        flagUsage();
        return;
    }

    std.debug.print(
        "Flags passed:\n  hello={} help={} info={} warn={} error={}\n",
        .{ flag.show_hello, flag.show_help, flag.show_info, flag.show_warn, flag.show_error },
    );
}

// Track which flag was sent
const Flags = struct {
    show_hello: bool = false,
    show_help: bool = false,
    show_info: bool = false,
    show_warn: bool = false,
    show_error: bool = false,
};

// Reading File from CLI and printing usage
// zparse --info log-file
fn parseArgs(init: std.process.Init) !Flags {
    var args = try init.minimal.args.iterateAllocator(init.gpa);
    defer args.deinit();

    // skip program name
    _ = args.skip();

    var flag = Flags{};

    // Making sure user passes a flag to work with
    var is_flag_passed = false;

    // accepting flags --info --warn --error (-i,-w,-e)
    while (args.next()) |arg| {
        if (std.mem.eql(u8, arg, "--hello")) {
            is_flag_passed = true;
            flag.show_hello = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--help") or std.mem.eql(u8, arg, "-h")) {
            is_flag_passed = true;
            flag.show_help = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--info") or std.mem.eql(u8, arg, "-i")) {
            is_flag_passed = true;
            flag.show_info = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--warn") or std.mem.eql(u8, arg, "-w")) {
            is_flag_passed = true;
            flag.show_warn = true;
            continue;
        }

        if (std.mem.eql(u8, arg, "--error") or std.mem.eql(u8, arg, "-e")) {
            is_flag_passed = true;
            flag.show_error = true;
            continue;
        }

        if (std.mem.startsWith(u8, arg, "-")) {
            std.debug.print("Unknown flag: {s}\n", .{arg});
            flagUsage();
            return error.UnknownFlag;
        }
    }

    if (!is_flag_passed) {
        flagUsage();
        return error.NoFlagsPassed;
    }

    return flag;
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

// File handling
// fn fileHandler(io: std.Io, cwd: std.Io.Dir.cwd()) void {
//     // const file_os_handle = cwd.openFile(io, file_path, {});

//     // open close file , handle error
//     // chunk read
//     // check for warning level
// }
